
-- KREATOR Library Datawarehouse (library_dwh) --

SET NOCOUNT ON
GO

USE master
GO

IF EXISTS (SELECT * FROM sysdatabases WHERE name='library_dwh')
		DROP DATABASE library_dwh
GO

DECLARE @device_directory NVARCHAR(520)
SELECT @device_directory = SUBSTRING(filename, 1, CHARINDEX(N'master.mdf', LOWER(filename)) - 1)
FROM master.dbo.sysaltfiles WHERE dbid = 1 AND fileid = 1

SET quoted_identifier ON
GO

CHECKPOINT
GO

CREATE DATABASE library_dwh
GO

CHECKPOINT
GO

USE "library_dwh"
GO

-- TWORZENIE TABEL --

-- Tabela przechowuj�ca informacje nt. ksi��ek
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.BooksDetails') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."BooksDetails"
GO

CREATE TABLE [dbo].[BooksDetails] 
(
  [BookID] [int] NOT NULL, 
  [Title] [varchar](50) NOT NULL,
  [GenreName] [varchar](15) NOT NULL,  --zamiast ID gatunk�w umieszczamy w tabeli ich nazwy

  CONSTRAINT [PK_Books] PRIMARY KEY ([BookID])

)
GO

-- Tabela przechowuj�ca informacje nt. czasu
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.TimeDetails') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."TimeDetails"
GO

CREATE TABLE [dbo].[TimeDetails] 
(
  [DateID] INT IDENTITY(1, 1) NOT NULL,
  [BorrowDate] [date] NOT NULL,

  CONSTRAINT [PK_TimeDetails] PRIMARY KEY([DateID])
)
GO

-- Tabela przechowuj�ca informacje nt. czytelnik�w
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.ReadersDetails') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."ReadersDetails"
GO

CREATE TABLE [dbo].[ReadersDetails] 
(
  [ReaderID] [int] NOT NULL, 
  [CardNumber] [int] NOT NULL, 
  [FirstName] [varchar](15) NOT NULL,
  [LastName] [varchar](20) NOT NULL,
  [Gender] [char](1) NOT NULL,
  [BirthDate] [date] NOT NULL
 
  CONSTRAINT [PK_ReadersDetails] PRIMARY KEY NONCLUSTERED ([ReaderID]), -- NONCLUSTERED - na potrzeby p�niejszego indeksowania
  CONSTRAINT [Gender_Assert] CHECK ([Gender] LIKE '[FM]'),
  CONSTRAINT [UC_Reader] UNIQUE ([CardNumber]),
  CONSTRAINT [BirthDate_Assert] CHECK ([BirthDate] < GETDATE() AND [BirthDate] > '1900-01-01'),
)
GO

-- Tabela centralna przechowuj�ca informacje nt. wypo�ycze�
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.BorrowsDetails') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."BorrowsDetails"
GO

CREATE TABLE [dbo].[BorrowsDetails] 
(
  [BookID] [int] NOT NULL,
  [ReaderID] [int] NOT NULL,
  [NoOfCopies] [int] NOT NULL,
  [BorrowDate] [date] NOT NULL,

  CONSTRAINT [BorrowDate_Assert] CHECK ([BorrowDate] <= GETDATE()),

  CONSTRAINT [FK_BorrowsDetails_BooksDetails] FOREIGN KEY ([BookID])
  REFERENCES [dbo].[BooksDetails]([BookID]),
  CONSTRAINT [FK_BorrowsDetails_ReadersDetails] FOREIGN KEY ([ReaderID])
  REFERENCES [dbo].[ReadersDetails]([ReaderID])
)
GO


-- MIGRACJA DANYCH DO TABEL I ICH NIEZB�DNE MODYFIKACJE

-- BooksDetails

-- Migracja oryginanych danych z bazy Library
INSERT INTO [library_dwh].[dbo].[BooksDetails]
SELECT b.ID, Title, g.Name FROM [Library].[dbo].[Books] b JOIN [Library].[dbo].[Genres] g ON b.GenreID = g.ID

-- Dodanie pola to�samego ze �redni� ocen� ksi��ki
ALTER TABLE [library_dwh].[dbo].[BooksDetails]
ADD AverageRating float DEFAULT NULL WITH VALUES
GO

UPDATE [library_dwh].[dbo].[BooksDetails] SET [library_dwh].[dbo].[BooksDetails].AverageRating = Tmp.AvgRating
FROM [library_dwh].[dbo].[BooksDetails]
JOIN (
	SELECT BookID, ROUND(AVG(CAST(Rating AS FLOAT)), 1) AS AvgRating
	FROM [Library].[dbo].[BookRatings]
	GROUP BY BookID 
) Tmp
ON Tmp.BookID = BooksDetails.BookID


-- ReadersDetails
-- Migracja oryginanych danych z bazy Library
INSERT INTO [library_dwh].[dbo].[ReadersDetails]
SELECT ID, CardNumber, FirstName, LastName, Gender, BirthDate FROM [Library].[dbo].[Readers] 

-- Dodanie pola to�samego z grup� wiekow�, do kt�rej nale�y czytelnik, obliczon� na podstawie jego daty urodzenia
ALTER TABLE [library_dwh].[dbo].[ReadersDetails]
ADD AgeGroup nvarchar(90) DEFAULT NULL WITH VALUES
GO

UPDATE [library_dwh].[dbo].[ReadersDetails]
SET AgeGroup = CASE
					WHEN DATEDIFF(YEAR, BirthDate, GETDATE()) BETWEEN 0 AND 17 THEN '<18'
					WHEN DATEDIFF(YEAR, BirthDate, GETDATE()) BETWEEN 18 AND 30 THEN '18-30'
					WHEN DATEDIFF(YEAR, BirthDate, GETDATE()) BETWEEN 31 AND 60 THEN '31-60'
					ELSE '>60'
					END
WHERE AgeGroup is NULL

-- Usuni�cie pola Birthdate, kt�re wobec nowoutworzonego pola AgeGroup jest zb�dne z punktu widzenia dalszej analizy
ALTER TABLE [library_dwh].[dbo].[ReadersDetails]
DROP CONSTRAINT BirthDate_Assert;
ALTER TABLE [library_dwh].[dbo].[ReadersDetails]
DROP COLUMN BirthDate;

-- TimeDetails
-- Nowa tabela, przechowuj�ca daty wypo�ycze�
-- Migracja oryginanych danych z bazy Library
INSERT INTO [library_dwh].[dbo].[TimeDetails]
SELECT DISTINCT BorrowDate FROM [Library].[dbo].[Borrows]

-- Ograniczenie oryginalnej daty do miesi�ca i roku.
-- B�dzie to jeden z wymiar�w kostki.
ALTER TABLE [library_dwh].[dbo].[TimeDetails]
ADD BorrowYear INT
ALTER TABLE [library_dwh].[dbo].[TimeDetails]
ADD BorrowMonth INT
GO

UPDATE [library_dwh].[dbo].[TimeDetails] 
SET BorrowYear = YEAR(BorrowDate), BorrowMonth = MONTH(BorrowDate)


-- Borrows
-- Migracja oryginanych danych z bazy Library
-- W celu unikni�cia duplikuj�cych si� kombinacji kluczy g��wnych agregujemy rekordy g��wnej tabeli, w taki spos�b, aby
-- jednorazowe wypo�yczenie kilku egzemplarzy tej samej ksi��ki reprezentowane by�o w tabeli fakt�w przez pojedyncz� obserwacj� 
-- o odpowiedniej warto�ci pola NoOfCopies
INSERT INTO [library_dwh].[dbo].[BorrowsDetails] SELECT BookID, ReaderID, COUNT(*) AS NoOfCopies, BorrowDate
											FROM [Library].[dbo].[Borrows] bor
											JOIN [Library].[dbo].[BookCopies] bc 
											ON bor.BookCopyID = bc.ID 
											GROUP BY bc.BookID, bor.ReaderID, bor.BorrowDate

-- Stworzenie powi�zania pomi�dzy tabelami Borrows i TimeDetails
ALTER TABLE [library_dwh].[dbo].[BorrowsDetails]
ADD DateID INT NOT NULL DEFAULT 0 WITH VALUES;
GO
-- Zamiast daty w tabeli wypo�ycze� umieszczamy jej identyfikator
UPDATE [library_dwh].[dbo].[BorrowsDetails] 
SET DateID = (SELECT DateID FROM TimeDetails td WHERE [library_dwh].[dbo].[BorrowsDetails].[BorrowDate]=td.BorrowDate);

-- Usuwamy z tabeli pe�n� dat� wypo�yczenia
ALTER TABLE [library_dwh].[dbo].[BorrowsDetails]
DROP CONSTRAINT BorrowDate_Assert
GO

ALTER TABLE [library_dwh].[dbo].[BorrowsDetails]
DROP COLUMN BorrowDate
GO 
-- Nak�adamy na identyfikator daty ograniczenie klucza obcego
ALTER TABLE [library_dwh].[dbo].[BorrowsDetails] 
ADD CONSTRAINT [FK_BorrowsDetails_TimeDetails] FOREIGN KEY ([DateID])
	REFERENCES [dbo].[TimeDetails]([DateID])
GO

-- Dodanie do tabeli fakt�w wieloatrybutowego klucza g��wnego, z�o�onego z kluczy obcych odwo�uj�cych si� do wymiar�w
ALTER TABLE [library_dwh].[dbo].[BorrowsDetails] 
ADD  CONSTRAINT [PK_BorrowsDetails] PRIMARY KEY CLUSTERED 
(
	[BookID], [ReaderID], [DateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

GO
