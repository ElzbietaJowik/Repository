USE Library
GO

-- #1. 
-- ID, imiona i nazwiska osób, które wypo¿yczy³y wiêcej ni¿ 1 egzemplarz tej samej ksi¹¿ki
-- Przyjmujê, ¿e szukamy powielonych egzemplarzy w pojedynczych wypo¿yczeniach, a nie w ca³ej historii.


SELECT ID, FirstName AS Imie, LastName AS Nazwisko
FROM Readers
WHERE ID IN
(
	SELECT DISTINCT ReaderID
	FROM Borrows b
	JOIN BookCopies bc ON b.BookCopyID = bc.ID
	GROUP BY b.ReaderID, bc.BookID, b.BorrowDate
	HAVING COUNT(*) > 1
)

-- #2.
-- Zliczenie iloœci wypo¿yczeñ ka¿dej ksi¹¿ki. 
-- Zapytanie zwraca: ID, tytu³, iloœæ wypo¿yczeñ i datê pierwszego wypo¿yczenia któregokolwiek egzemplarza
-- Tabela pomocnicza Tmp przechowuje informacje nt. pracowników wypo¿yczaj¹cych ksi¹¿ki 

-- Metoda 1.
SELECT bc.BookID AS ID, b.Title AS Tytul, COUNT(*) AS IleRazy, MIN(BorrowDate) AS PierwszeWypozyczenie
FROM BookCopies bc
JOIN Borrows br ON bc.ID = br.BookCopyID
JOIN Books b ON bc.BookID = b.ID
GROUP BY bc.BookID, b.Title

-- Metoda 2.
SELECT b.ID, b.Title AS Tytul, IleRazy, PierwszeWypozyczenie
FROM Books b
RIGHT JOIN
(
SELECT bc.BookID, COUNT(*) AS IleRazy, MIN(BorrowDate) AS PierwszeWypozyczenie
FROM BookCopies bc
JOIN Borrows br ON bc.ID = br.BookCopyID
GROUP BY bc.BookID) Tmp
ON b.ID = Tmp.BookID


-- #3.
-- ID i tytu³y ksi¹¿ek, których wszystkie egzemplarze uleg³y zniszczeniu

SELECT b.ID, b.Title as Tytul
FROM Books b
WHERE EXISTS (
	SELECT bc.BookID
	FROM BookCopies bc
	GROUP BY bc.BookID
	HAVING SUM(CAST(Available AS INT)) = 0 AND bc.BookID = b.ID
)


-- #4.
-- Analiza ocen wystawionych przez aktywnych u¿ytkowników.
-- Na wynik sk³adaj¹ siê: tytu³ ksi¹¿ki, najwy¿sza, najni¿sza i œrednia ocena.

SELECT b.ID, b.Title AS Tytul, MAX(br.Rating) AS NajwyzszaOcena, MIN(br.Rating) AS NajnizszaOcena, ROUND(AVG(CAST(br.Rating AS float)), 2) AS SredniaOcena
FROM Books b
JOIN BookRatings br ON br.BookID = b.ID
JOIN Readers r ON br.ReaderID = r.ID
WHERE r.SignOutDate IS NULL
GROUP BY b.ID, b.Title


-- #5.
-- Lista pracowników, którzy wypo¿yczali ksi¹¿ki. 
-- Zapytanie zwraca ID, imiê, nazwisko, iloœæ wypo¿yczeñ

SELECT e.ID, e.FirstName AS Imie, e.LastName AS Nazwisko, IleWypozyczen
FROM Employees e
RIGHT JOIN 
( 
SELECT b.EmployeeID, COUNT(*) AS IleWypozyczen
FROM Borrows b
GROUP BY b.EmployeeID
) Tmp
ON e.ID = Tmp.EmployeeID



