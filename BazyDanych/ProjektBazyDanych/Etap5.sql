USE Library
GO

-- PROCEDURA

-- MODYFIKACJA TABELI Books 
-- Dodanie nowej kolumny, w kt�rej dla ka�dej ksi��ki naliczana bedzie nota, b�d�ca sum� n najlepszych ocen Rating dla danej ksi��ki. 
-- Na pocz�tku wszystkie warto�ci ustawiam na 0.

ALTER TABLE Books
ADD Note int DEFAULT 0 WITH VALUES

GO

-- DEFINICJA PROCEDURY
CREATE OR ALTER PROCEDURE NoteProcedure (@n INT)

AS
BEGIN
	
	DECLARE @bookID INT
	DECLARE @note INT

	-- Deklaruj� kursor dla instrukcji SELECT zwracaj�cej ID wszystkich ksi��ek znajdujacych sie w bazie.
	-- Umo�liwi on przejrzenie wiersz po wierszu wyniku zapytania i dla ka�dego sprowadzonego wiersza wykonanie zadanej operacji.
	DECLARE kursor CURSOR LOCAL FOR (SELECT ID, Note FROM Books)

	-- Otwieram kursor
	OPEN kursor;

	-- Instrukcja FETCH pozwala na pobranie kolejnego wiersza i zapisanie go w zmiennej
	FETCH NEXT FROM kursor INTO @bookID, @note;

	-- Aby m�c przej�� po wszystkich rekordach wyniku powy�szego zapytania SELECT, nale�y zastosowa� p�tl�
	-- Do sprawdzenia, czy ostatnie wywo�anie FETCH zwr�ci�o wiersz, s�u�y zmienna systemowa @@FETCH_STATUS. 
	-- Je�li zwraca warto�� 0 oznacza to, �e pobranie wiersza odby�o si� z powodzeniem. 
	-- Inna warto�� oznacza osi�gni�cie ko�ca zbioru rekord�w lub wyst�pienie b��du.

	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Sprawdzam, czy ksi��ka o bie��cym ID w og�le zosta�a oceniona.
	IF @bookID IN (SELECT DISTINCT br.BookID FROM BookRatings br)
	-- Je�li tak, zliczam sum� co najwy�ej n wyraz�w
		SET @note = (SELECT SUM(Rating)
					FROM (
						SELECT Rating, ROW_NUMBER() OVER (ORDER BY Rating DESC) AS RowNum
						FROM BookRatings br
						WHERE br.BookID = @bookID
					) T		
					WHERE RowNum <= @n);
	ELSE 
	-- Je�li nie z g�ry ustawiam t� warto�� na NULL
		SET @note = NULL;

	-- Modyfikacja tabeli Books
	UPDATE Books set Books.Note = @note
	WHERE Books.ID=@bookID;

	-- Wczytanie kolejnego wiersza
	fetch next from kursor into @bookID, @note;

	END
	-- Zamkni�cie i zwolnienie kursora
	CLOSE kursor;
	DEALLOCATE kursor;

END --proc
GO

-- PRZYK�AD WYWO�ANIA PROCEDURY
-- BEGIN TRANSACTION
EXEC NoteProcedure 3;
SELECT * FROM Books
-- ROLLBACK TRANSACTION

