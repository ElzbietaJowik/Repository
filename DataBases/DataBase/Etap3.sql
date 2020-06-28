USE Library
GO


-- INDEKS 1.

-- Kwerenda przed indeksowaniem
SELECT DISTINCT Title 
FROM Books 
WHERE Title LIKE 'The%'
ORDER BY Title

-- Indeks
CREATE NONCLUSTERED INDEX UC_Ix_Books_Title ON [dbo].[Books]
(
	[Title] ASC
)

SELECT DISTINCT Title 
FROM Books 
WHERE Title LIKE 'The%'
ORDER BY Title


DROP INDEX UC_Ix_Books_Title ON [dbo].[Books]

-- INDEKS 2.

-- Kwerenda przed indeksowaniem

SELECT CardNumber, LastName, FirstName
FROM Readers
WHERE LastName = 'Collins' AND FirstName = 'Adam'


CREATE NONCLUSTERED INDEX Ix_Readers_FullName ON [dbo].[Readers]
(
	LastName,
	FirstName
);
CREATE UNIQUE CLUSTERED INDEX Ix_Readers_CardNumber ON [dbo].[Readers]
(
	CardNumber
);

-- Kwerenda po indeksowaniu

SELECT CardNumber, LastName, FirstName
FROM Readers
WHERE LastName = 'Collins' AND FirstName = 'Adam'


DROP INDEX Ix_Readers_FullName ON [dbo].[Readers]
GO
DROP INDEX Ix_Readers_CardNumber ON [dbo].[Readers]
GO






