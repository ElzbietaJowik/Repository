
-- KREATOR BAZY LIBRARY --

SET NOCOUNT ON
GO

USE master
GO

IF EXISTS (SELECT * FROM sysdatabases WHERE name='Library')
		DROP DATABASE Library
go

DECLARE @device_directory NVARCHAR(520)
SELECT @device_directory = SUBSTRING(filename, 1, CHARINDEX(N'master.mdf', LOWER(filename)) - 1)
FROM master.dbo.sysaltfiles WHERE dbid = 1 AND fileid = 1

SET quoted_identifier ON
GO

CHECKPOINT
GO

CREATE DATABASE Library
GO

CHECKPOINT
GO

USE "Library"
GO


-- TWORZENIE TABEL


-- Tabela przechowująca informacje nt. czytelników
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.Readers') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."Readers"
GO

CREATE TABLE [dbo].[Readers] 
(
  [ID] [int] IDENTITY (1, 1) NOT NULL, 
  [CardNumber] [int] NOT NULL, 
  [FirstName] [varchar](15) NOT NULL,
  [LastName] [varchar](20) NOT NULL,
  [Gender] [char](1) NOT NULL,
  [Street] [varchar](40) NOT NULL,
  [Number] [varchar](6) NOT NULL,
  [City] [varchar](30) NOT NULL,
  [BirthDate] [date] NOT NULL,
  [SignInDate] [date] NOT NULL,
  [SignOutDate] [date] NULL
 
  CONSTRAINT [PK_Readers] PRIMARY KEY NONCLUSTERED ([ID]), -- NONCLUSTERED - na potrzeby późniejszego indeksowania
  CONSTRAINT [Gender_Assert] CHECK ([Gender] LIKE '[FM]'),
  CONSTRAINT [UC_Reader] UNIQUE ([CardNumber]),
  CONSTRAINT [BirthDate_Assert] CHECK ([BirthDate] < GETDATE() AND [BirthDate] > '1900-01-01'),
  CONSTRAINT [SignInDate_Assert] CHECK ([SignInDate] <= GETDATE()),
  CONSTRAINT [SignOutDate_Assert] CHECK ([SignOutDate] <= GETDATE()),
  CONSTRAINT [SignInDate_SignOutDate_Assert] CHECK ([SignOutDate] >= [SignInDate]),
  CONSTRAINT [All_Dates_Assert] CHECK ([SignOutDate] > [BirthDate] AND [SignInDate] > [BirthDate])

)
GO


-- Tabela przechowująca informacje nt. gatunków
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.Genres') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."Genres"
GO

CREATE TABLE [dbo].[Genres] 
(
  [ID] [int] IDENTITY (1, 1) NOT NULL, 
  [Name] [varchar](15) NOT NULL,

  CONSTRAINT [PK_Genres] PRIMARY KEY ([ID]),
  CONSTRAINT [UC_Genre] UNIQUE ([Name])
)
GO


-- Tabela przechowująca informacje nt. książek
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.Books') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."Books"
GO

CREATE TABLE [dbo].[Books] 
(
  [ID] [int] IDENTITY (1, 1) NOT NULL, 
  [Title] [varchar](50) NOT NULL,
  [GenreID] [int] NOT NULL

  CONSTRAINT [PK_Books] PRIMARY KEY ([ID]),

  CONSTRAINT [FK_Books_Genres] FOREIGN KEY ([GenreID])
  REFERENCES [dbo].[Genres]([ID]),
)
GO


-- Tabela przechowująca informacje nt. ocen
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.BookRatings') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."BookRatings"
GO

CREATE TABLE [dbo].[BookRatings] 
(
  [ID] [int] IDENTITY (1, 1) NOT NULL, 
  [BookID] [int] NOT NULL,
  [ReaderID] [int] NOT NULL,
  [Rating] [int] NOT NULL,
  [RatingDate] [date] NOT NULL,

  CONSTRAINT [PK_Patients] PRIMARY KEY ([ID]),
  CONSTRAINT [Rating_Assert] CHECK ([Rating] BETWEEN 0 AND 5),
  CONSTRAINT [RatingDate_Assert] CHECK ([RatingDate] <= GETDATE()),


  CONSTRAINT [FK_BookRatings_Books] FOREIGN KEY ([BookID])
  REFERENCES [dbo].[Books]([ID]),

  CONSTRAINT [FK_BookRatings_Readers] FOREIGN KEY ([ReaderID])
  REFERENCES [dbo].[Readers]([ID])


)
GO


-- Tabela przechowująca informacje nt. pracowników
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.Employees') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."Employees"
GO

CREATE TABLE [dbo].[Employees] 
(
  [ID] [int] IDENTITY (1, 1) NOT NULL,
  [FirstName] [varchar](15) NOT NULL,
  [LastName] [varchar](20) NOT NULL,
  [ManagerID] [int] NULL

  CONSTRAINT [PK_Employees] PRIMARY KEY ([ID]),

  CONSTRAINT [FK_Employees_Employees] FOREIGN KEY([ManagerID])
  REFERENCES [dbo].[Employees] ([ID])

)
GO


-- Tabela przechowująca informacje nt. egzemplarzy
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.BookCopies') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."BookCopies"
GO

CREATE TABLE [dbo].[BookCopies] 
(
  [ID] [int] IDENTITY (1, 1) NOT NULL, 
  [BookID] [int] NOT NULL,
  [Number] [int] NOT NULL,
  [PurchaseDate] [date] NOT NULL,
  [PurchasePrice] [money] NOT NULL,
  [Available] [bit] NOT NULL DEFAULT 1
 
  CONSTRAINT [PK_BookCopies] PRIMARY KEY ([ID]),
  CONSTRAINT [UC_BookCopy] UNIQUE ([Number]),
  CONSTRAINT [PurchaseDate_Assert] CHECK ([PurchaseDate] <= GETDATE()),


  CONSTRAINT [FK_BookCopies_Books] FOREIGN KEY ([BookID])
  REFERENCES [dbo].[Books]([ID])

)
GO


-- Tabela przechowująca informacje nt. wypożyczeń
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.Borrows') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."Borrows"
GO

CREATE TABLE [dbo].[Borrows] 
(
  [ID] [int] IDENTITY (1, 1) NOT NULL, 
  [BookCopyID] [int] NOT NULL,
  [ReaderID] [int] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  [BorrowDate] [date] NOT NULL,
  [ExpectedReturnDate] [date] NOT NULL,
  [ActualReturnDate] [date] NULL

  CONSTRAINT [PK_Borrows] PRIMARY KEY ([ID]),
  CONSTRAINT [BorrowDate_Assert] CHECK ([BorrowDate] <= GETDATE()),
  CONSTRAINT [ReturnDate_Assert] CHECK ([ExpectedReturnDate] >= [BorrowDate] AND [ActualReturnDate] >= [BorrowDate]),

  CONSTRAINT [FK_Borrows_Readers] FOREIGN KEY ([ReaderID])
  REFERENCES [dbo].[Readers]([ID]),

  CONSTRAINT [FK_Borrows_BookCopies] FOREIGN KEY ([BookCopyID])
  REFERENCES [dbo].[BookCopies]([ID]),

  CONSTRAINT [FK_Borrows_Employees] FOREIGN KEY ([EmployeeID])
  REFERENCES [dbo].[Employees]([ID])


)
GO


-- Tabela przechowująca informacje nt. autorów
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.Authors') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."Authors"
GO

CREATE TABLE [dbo].[Authors] 
(
  [ID] [int] IDENTITY (1, 1) NOT NULL,
  [FirstName] [varchar](15) NOT NULL,
  [LastName] [varchar](20) NOT NULL,

  CONSTRAINT [PK_Authors] PRIMARY KEY ([ID])
)
GO


-- Tabela pomocnicza 
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.AuthorsBooks') AND sysstat & 0xf = 3)
	DROP TABLE "dbo"."AuthorsBooks"
GO

CREATE TABLE [dbo].[AuthorsBooks] 
(
  [BookID] [int] NOT NULL,
  [AuthorID] [int] NOT NULL

  CONSTRAINT [PK_AuthorsBooks] PRIMARY KEY ([BookID], [AuthorID]),

  CONSTRAINT [FK_AuthorsBooks_Authors] FOREIGN KEY ([AuthorID])
  REFERENCES [dbo].[Authors]([ID]),

  CONSTRAINT [FK_AuthorsBooks_Books] FOREIGN KEY ([BookID])
  REFERENCES [dbo].[Books]([ID])
)
GO


-- UZUPEŁNIENIE BAZY DANYMI

-- READERS


INSERT INTO [Readers]([CardNumber], [FirstName], [LastName], [Gender], [Street], [Number], [City], [BirthDate], [SignInDate], [SignOutDate]) 
VALUES
(432, 'Harry', 'Adams', 'M', 'Artizan Street', '253', 'London', '1968-01-02', '2018-12-17', NULL),
(313, 'Olivier', 'Allen', 'M', 'Baltic Street West', '90210', 'Croydon', '1992-10-12', '2018-09-08', NULL),
(126, 'Noah', 'Baker', 'M', 'Bouverie Street', '9', 'Bexley', '1976-03-03', '2017-05-27', NULL),
(517, 'Cole', 'Baker', 'M', 'Bouverie Street', '9', 'Bexley', '1980-07-02', '2019-02-08', NULL),
(652, 'Leo', 'Cooper', 'M', 'Camomile Street', '32', 'Ilford', '1976-11-14', '2017-05-26', NULL),
(100, 'Jacob', 'Sprouse', 'M', 'Fort Street', '82', 'Sutton', '1999-03-03', '2020-05-27', NULL),
(412, 'Charlie', 'Carter', 'M', 'Carmelite Street', '87', 'Wembley', '1976-03-03', '2017-05-27', '2019-05-06'),
(653, 'Bradley', 'Clarke', 'M', 'Eldon Street', '54381', 'Wallington', '2007-01-09', '2017-08-22', '2019-09-26'),
(201, 'Cole', 'Collins', 'M', 'Hart Street', '18', 'Westerham', '1976-03-03', '2017-05-27', '2018-05-06'),
(409, 'Adam', 'Collins', 'M', 'Oark Street', '98', 'Westerham', '1994-07-07', '2017-09-02', '2020-03-01'),
(410, 'Eve', 'Collins', 'F', 'Oark Street', '98', 'Westerham', '1995-05-17', '2018-04-25', NULL),
(217, 'Ella', 'Evans', 'F', 'Godliman Street', '98', 'Sutton', '1963-08-17', '2017-05-27', NULL),
(810, 'Ava', 'Fisher', 'F', 'Jewry Street', '98', 'Sutton', '1987-08-17', '2020-03-27', NULL),
(700, 'Lily', 'Ford', 'F', 'King William Street', '90876', 'Enfield', '1956-01-09', '2018-08-22', NULL),
(701, 'Emily', 'Hamilton', 'F', 'King William Street', '90877', 'Enfield', '2001-01-09', '2020-02-22', NULL),
(290, 'Ana', 'Holmes', 'F', 'Liverpool Square', '98', 'Bromley', '1994-07-07', '2019-09-02', '2020-03-01'),
(121, 'Jenny', 'Knight', 'F', 'London Bridge', '764', 'London', '2002-01-01', '2020-02-02', '2020-05-02'),
(324, 'Brooke', 'Lawrence', 'F', 'Times Square', '64902', 'London', '2009-01-01', '2018-02-02', NULL),
(624, 'Demi', 'Moore', 'F', 'Washington Square', '759035', 'London', '2008-01-03', '2018-02-02', NULL),
(370, 'Ana', 'Holmes', 'F', 'Washington Square', '759035', 'London', '2007-01-03', '2018-02-02', NULL)



-- GENRES

INSERT INTO [Genres]([Name]) 
VALUES
('Mystery'),
('Thriller'),
('Horror'),
('Historical'),
('Romance'),
('Fantasy'),
('Biography'),
('Children'),
('Poetry'),
('Science Fiction')


-- BOOKS

INSERT INTO [Books]([Title], [GenreID]) 
VALUES
('The Adventures of Sherlock Holmes', 1),
('The Hound of the Baskervilles', 1),
('The Devil in the White City', 1),
('Gone Girl', 1),
('In the Woods', 1),
('Still Life', 1),
('The Silent Patient', 2),
('And Then There Were None', 2),
('A Simple Favor', 2),
('Before I Go to Sleep ', 2),
('Bird Box', 2),
('The Couple Next Door', 2),
('The Da Vinci Code', 2),
('It', 3),
('The Outsider', 3),
('Misery', 3),
('Carrie', 3),
('If It Bleeds', 3),
('In the Tall Grass', 3),
('Elevation', 3),
('Insomnia', 3),
('Guns, Germs, and Steel', 4),
('War and Peace', 4),
('Pride and Prejudice', 5),
('Perfect Chemistry', 5),
('The Notebook', 5),
('A Walk to Remember', 5),
('The Fault in Our Stars', 5),
('Five Feet Apart', 5),
('Harry Potter and the Philosophers Stone', 6),
('Harry Potter and the Chamber of Secrets', 6),
('Harry Potter and the Prisoner of Azkaban', 6),
('Harry Potter and the Goblet of Fire', 6),
('Harry Potter and the Order of Phoenix', 6),
('Harry Potter and the Half-Blood Prince', 6),
('Harry Potter and the Deathly Hallows', 6),
('A Game of Thrones', 6),
('A Clash of Kings', 6),
('A Storm of Swords', 6),
('A Feast for Crows', 6),
('A Dance with Dragons', 6),
('The Lord of the Rings', 6),
('The Hobbit', 6),
('Alices Adventures in Wonderland', 8),
('Sylvie and Bruno', 8),
('The Hunting of the Snark', 8),
('The Hunger Games', 10),
('Catching Fire', 10),
('Mockingjay', 10),
('The Ballad of Songbirds and Snakes', 10)


-- AUTHORS

INSERT INTO [Authors]([FirstName], [LastName]) 
VALUES
('Arthur', 'Conan Doyle'),
('Eric', 'Larson'),
('Gillian', 'Flynn'),
('Tana', 'French'),
('Louise', 'Penny'),
('Alex', 'Michaelides'),
('Agatha', 'Christie'),
('Darcey', 'Bell'),
('Steven', 'Watson'),
('Josh', 'Malerman'),
('Shari', 'Lapena'),
('Dan', 'Brown'),
('Stephen', 'King'),
('Jared', 'Diamond'),
('Leo', 'Tolstoy'),
('Jane', 'Austen'),
('Simone', 'Elkeles'),
('Nicholas', 'Sparks'),
('John', 'Green'),
('Rachael', 'Lippincott'),
('Joanne', 'Rowling'),
('George', 'Martin'),
('John', 'Tolkien'),
('Suzanne', 'Collins'),
('Lewis',  'Carroll')


-- AUTHORS_BOOKS

INSERT INTO [AuthorsBooks]([AuthorID], [BookID]) 
VALUES
(1, 1),
(1, 2), 
(2, 3),
(3, 4),
(4, 5), 
(5, 6), 
(6, 7),
(7, 8),
(8, 9),
(9, 10),
(10, 11),
(11, 12),
(12, 13),
(13, 14),
(13, 15),
(13, 16),
(13, 17),
(13, 18),
(13, 19),
(13, 20),
(13, 21),
(14, 22),
(15, 23),
(16, 24),
(17, 25),
(18, 26),
(18, 27),
(19, 28),
(20, 29),
(21, 30),
(21, 31),
(21, 32),
(21, 33),
(21, 34),
(21, 35),
(21, 36),
(22, 37),
(22, 38),
(22, 39),
(22, 40),
(22, 41),
(23, 42),
(23, 43),
(24, 47),
(24, 48),
(24, 49),
(24, 50),
(25, 44),
(25, 45),
(25, 46)



-- EMPLOYEES

INSERT INTO [Employees]([FirstName], [LastName], [ManagerID]) 
VALUES

('Gabriella', 'Green', 5),
('Tom', 'Bolton', 5),
('Benedict', 'Montez', 6),
('Anastasia', 'Montez', 2),
('Mark', 'Adams', NULL),
('Alice', 'Evans', NULL)


-- BOOKRATINGS

INSERT INTO [BookRatings]([BookID], [ReaderID], [Rating], [RatingDate]) 
VALUES
(46, 1, 3, '2020-01-03'),
(1, 1, 4, '2020-01-23'),
(15, 1, 5, '2020-02-28'),
(21, 1, 5, '2020-03-17'),
(4, 1, 1, '2020-04-21'),
(47, 1, 0, '2020-05-14'),
(3, 2, 0, '2020-01-11'),
(1, 2, 4, '2020-01-25'),
(5, 2, 5, '2020-02-24'),
(21, 2, 3, '2020-03-25'),
(4, 2, 1, '2020-04-21'),
(47, 2, 0, '2020-05-14'),
(50, 3, 4, '2020-02-02'),
(34, 3, 2, '2020-02-02'),
(21, 3, 4, '2020-02-02'),
(13, 3, 1, '2020-02-02'),
(36, 3, 2, '2020-02-02'),
(21, 4, 5, '2020-03-17'),
(4, 4, 1, '2020-04-21'),
(47, 4, 0, '2020-05-14'),
(11, 10, 2, '2020-01-11'),
(32, 10, 3, '2020-02-02'),
(13, 10, 4, '2020-02-04'),
(17, 10, 4, '2020-02-17'),
(44, 10, 5, '2020-03-01'),
(11, 16, 5, '2020-01-11'),
(32, 16, 1, '2020-02-11'),
(13, 16, 0, '2020-02-11'),
(17, 16, 2, '2020-02-17'),
(44, 16, 3, '2020-03-17'),
(1, 17, 5, '2020-01-11'),
(3, 17, 1, '2020-02-11'),
(13, 17, 0, '2020-02-11'),
(17, 17, 2, '2020-02-17'),
(46, 17, 3, '2020-03-17'),
(2, 5, 5, '2020-03-21'),
(6, 5, 4, '2020-03-21'),
(8, 5, 4, '2020-03-21'),
(9, 5, 4, '2020-03-21'),
(9, 11, 4, '2020-04-05'),
(6, 11, 4, '2020-04-05'),
(18, 11, 4, '2020-04-05'),
(6, 12, 4, '2020-04-07'),
(8, 12, 4, '2020-04-07'),
(22, 14, 2, '2020-04-17'),
(23, 14, 3, '2020-04-17'),
(23, 18, 4, '2020-04-21'),
(33, 19, 2, '2020-04-25'),
(35, 19, 3, '2020-04-25'),
(41, 20, 2, '2020-04-30'),
(42, 20, 3, '2020-04-30'),
(43, 20, 4, '2020-04-30'),
(43, 19, 4, '2020-05-02'),
(43, 18, 5, '2020-05-05'),
(45, 20, 5, '2020-05-05'),
(48, 11, 1, '2020-05-11'),
(48, 12, 0, '2020-05-11'),
(48, 13, 1, '2020-05-14'),
(49, 14, 1, '2020-05-14'),
(49, 15, 1, '2020-05-17'),
(49, 18, 1, '2020-05-19'),
(50, 11, 1, '2020-05-20'),
(50, 12, 1, '2020-05-22'),
(50, 13, 1, '2020-05-25'),
(50, 14, 1, '2020-05-30'),
(50, 15, 1, '2020-05-30'),
(50, 20, 1, '2020-05-30')





-- BOOKCOPIES

INSERT INTO [BookCopies]([BookID], [Number], [PurchaseDate], [PurchasePrice], [Available]) 
VALUES
(1, 110, '2017-01-01', 19.99, 1),
(1, 111, '2017-01-01', 19.99, 1),
(1, 112, '2017-01-01', 19.99, 1),
(1, 113, '2017-01-01', 19.99, 1),
(1, 114, '2017-01-01', 19.99, 1),
(2, 210, '2017-01-01', 119.99, 1),
(3, 310, '2017-01-01', 12.99, 1),
(3, 311, '2017-01-01', 12.99, 1),
(3, 312, '2017-01-01', 12.99, 1),
(3, 313, '2017-02-01', 12.99, 1),
(4, 410, '2017-02-01', 5.99, 1),
(4, 411, '2017-02-01', 5.99, 1),
(4, 412, '2017-02-01', 5.99, 1),
(5, 510, '2017-02-01', 119.99, 1),
(6, 610, '2017-03-01', 159.99, 1),
(7, 710, '2017-02-01', 119.99, 1),
(8, 810, '2017-02-01', 32.99, 1),
(8, 811, '2017-03-01', 32.99, 0),
(8, 812, '2017-03-01', 32.99, 1),
(9, 910, '2017-03-01', 19.99, 1),
(10, 1010, '2017-04-01', 49.99, 1),
(11, 1110,'2017-04-01', 29.99, 1),
(12, 1210, '2017-04-01', 9.99, 1),
(13, 1310, '2017-04-01', 14.99, 1),
(13, 1311, '2017-04-01', 5.99, 1),
(14, 1410, '2017-04-01', 4.99, 1),
(14, 1411, '2017-04-01', 4.99, 1),
(15, 1510, '2017-05-01', 49.99, 1),
(16, 1610, '2017-05-01', 9.99, 1),
(17, 1710, '2017-05-01', 14.99, 1),
(18, 1810, '2017-05-01', 5.99, 1),
(19, 1910, '2017-05-01', 4.99, 1),
(20, 2010, '2017-05-01', 19.99, 1),
(20, 2011, '2017-05-01', 19.99, 1),
(21, 2110, '2017-05-01', 29.99, 1),
(22, 2210, '2017-12-06', 9.99, 1),
(23, 2310, '2017-12-06', 14.99, 1),
(24, 2410, '2017-12-06', 5.99, 1),
(25, 2510, '2017-12-06', 19.99, 1),
(26, 2610, '2017-12-06', 19.99, 1),
(27, 2710, '2017-12-06', 5.20, 1),
(28, 2810, '2017-12-06', 4.10, 1),
(29, 2910, '2017-12-06', 20.00, 1),
(30, 3010, '2017-06-27', 32.99, 1),
(30, 3011, '2017-06-27', 32.99, 1),
(30, 3012, '2017-06-27', 32.99, 1),
(30, 3013, '2017-06-27', 32.99, 1),
(30, 3014, '2017-06-27', 32.99, 1),
(30, 3015, '2017-06-27', 32.99, 1),
(31, 3110, '2017-09-07', 19.99, 0),
(32, 3210, '2017-09-07', 49.99, 1),
(33, 3310, '2017-09-07', 29.99, 1),
(34, 3410, '2017-09-07', 9.99, 1),
(35, 3510, '2017-09-07', 14.99, 1),
(36, 3610, '2017-10-07', 4.99, 0),
(36, 3611, '2017-10-07', 4.99, 0),
(37, 3711, '2017-10-16', 5.99, 1),
(37, 3710, '2017-10-16', 5.99, 1),
(38, 3810, '2018-05-01', 19.99, 0),
(38, 3811, '2018-05-01', 19.99, 0),
(39, 3910, '2018-05-01', 119.99, 1),
(40, 4010, '2018-05-01', 19.99, 1),
(41, 4110, '2018-07-04', 19.99, 1),
(42, 4210, '2018-07-04', 119.99, 1),
(43, 4310, '2018-07-04', 2.99, 1),
(44, 4410, '2018-07-04', 62.99, 0),
(45, 4510, '2018-08-11', 81.99, 1),
(46, 4610, '2019-06-11', 4.99, 1),
(47, 4710, '2019-06-11', 12.99, 1),
(48, 4810, '2019-06-11', 3.99, 1),
(48, 4811, '2019-06-11', 3.99, 1),
(49, 4910, '2019-06-11', 12.99, 0),
(50, 5010, '2019-06-11', 12.99, 1)



INSERT INTO [Borrows]([BookCopyID], [ReaderID], [EmployeeID], [BorrowDate], [ExpectedReturnDate], [ActualReturnDate]) 
VALUES
(1, 1, 2, '2020-01-01', '2020-02-01', NULL),
(2, 1, 2, '2020-01-01', '2020-02-01', '2020-01-03'),
(2, 2, 3, '2020-02-28', '2020-07-28', NULL), 
(5, 3, 4, '2020-03-17', '2020-06-30', NULL), 
(8, 3, 4, '2020-03-17', '2020-06-30', NULL), 
(11, 3, 4, '2020-03-17', '2020-06-30', NULL), 
(12, 5, 1, '2020-04-04', '2020-04-13', NULL),
(13, 5, 1, '2020-04-04', '2020-05-13', NULL), 
(14, 5, 1, '2020-04-04', '2020-04-13', NULL),
(15, 5, 1, '2020-04-04', '2020-05-13', NULL), 
(27, 9, 1, '2020-04-09', '2020-04-13', NULL),
(28, 7, 1, '2020-04-09', '2020-05-13', NULL), 
(29, 13, 1, '2020-05-11', '2020-06-13', NULL),
(33, 14, 1, '2020-05-13', '2020-07-13', NULL), 
(34, 15, 1, '2020-04-13', '2020-07-13', NULL),
(43, 15, 1, '2020-04-16', '2020-05-13', NULL), 
(57, 20, 1, '2020-05-13', '2020-06-22', NULL),
(58, 20, 1, '2020-05-27', '2020-06-28', NULL), 
(71, 4, 2, '2020-04-11', '2020-05-13', '2020-05-15'),
(50, 18, 3, '2019-01-01', '2019-02-01', '2019-01-03'),
(49, 18, 3, '2019-01-01', '2019-02-01', '2019-01-03'),
(49, 19, 3, '2019-01-17', '2019-02-01', '2019-01-23'),
(1, 19, 2, '2019-02-17', '2019-02-26', '2019-02-24'),
(2, 19, 2, '2019-02-17', '2019-03-01', '2019-03-01'),
(20, 20, 3, '2018-03-01', '2018-03-01', '2018-03-03'),
(22, 20, 3, '2018-03-01', '2018-04-01', '2018-03-03'),
(14, 20, 3, '2018-03-01', '2018-04-05', '2018-06-03'),
(50, 18, 1, '2018-03-01', '2018-03-01', '2018-03-03'),
(21, 20, 1, '2018-03-01', '2018-04-01', '2018-04-03'),
(14, 20, 3, '2018-04-12', '2018-05-05', '2018-05-03'),
(44, 19, 3, '2018-04-01', '2018-05-01', '2018-05-21'),
(45, 19, 3, '2018-03-01', '2018-03-01', '2018-03-03'),
(46, 18, 3, '2018-04-01', '2018-06-01', '2018-06-03')




