USE Library
GO

-- PROCEDURA

-- MODYFIKACJA TABELI Books 
-- Dodanie nowej kolumny, w której dla ka¿dej ksi¹¿ki naliczana bedzie nota, bêd¹ca sum¹ n najlepszych ocen Rating dla danej ksi¹¿ki. 
-- Na pocz¹tku wszystkie wartoœci ustawiam na 0.

ALTER TABLE Books
ADD Note int DEFAULT 0 WITH VALUES

GO

-- DEFINICJA PROCEDURY
CREATE OR ALTER PROCEDURE NoteProcedure (@n INT)

AS
BEGIN
	
	DECLARE @bookID INT
	DECLARE @note INT

	-- Deklarujê kursor dla instrukcji SELECT zwracaj¹cej ID wszystkich ksi¹¿ek znajdujacych sie w bazie.
	-- Umo¿liwi on przejrzenie wiersz po wierszu wyniku zapytania i dla ka¿dego sprowadzonego wiersza wykonanie zadanej operacji.
	DECLARE kursor CURSOR LOCAL FOR (SELECT ID, Note FROM Books)

	-- Otwieram kursor
	OPEN kursor;

	-- Instrukcja FETCH pozwala na pobranie kolejnego wiersza i zapisanie go w zmiennej
	FETCH NEXT FROM kursor INTO @bookID, @note;

	-- Aby móc przejœæ po wszystkich rekordach wyniku powy¿szego zapytania SELECT, nale¿y zastosowaæ pêtlê
	-- Do sprawdzenia, czy ostatnie wywo³anie FETCH zwróci³o wiersz, s³u¿y zmienna systemowa @@FETCH_STATUS. 
	-- Jeœli zwraca wartoœæ 0 oznacza to, ¿e pobranie wiersza odby³o siê z powodzeniem. 
	-- Inna wartoœæ oznacza osi¹gniêcie koñca zbioru rekordów lub wyst¹pienie b³êdu.

	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Sprawdzam, czy ksi¹¿ka o bie¿¹cym ID w ogóle zosta³a oceniona.
	IF @bookID IN (SELECT DISTINCT br.BookID FROM BookRatings br)
	-- Jeœli tak, zliczam sumê co najwy¿ej n wyrazów
		SET @note = (SELECT SUM(Rating)
					FROM (
						SELECT Rating, ROW_NUMBER() OVER (ORDER BY Rating DESC) AS RowNum
						FROM BookRatings br
						WHERE br.BookID = @bookID
					) T		
					WHERE RowNum <= @n);
	ELSE 
	-- Jeœli nie z góry ustawiam tê wartoœæ na NULL
		SET @note = NULL;

	-- Modyfikacja tabeli Books
	UPDATE Books set Books.Note = @note
	WHERE Books.ID=@bookID;

	-- Wczytanie kolejnego wiersza
	fetch next from kursor into @bookID, @note;

	END
	-- Zamkniêcie i zwolnienie kursora
	CLOSE kursor;
	DEALLOCATE kursor;

END --proc
GO

-- PRZYK£AD WYWO£ANIA PROCEDURY
-- BEGIN TRANSACTION
EXEC NoteProcedure 3;
SELECT * FROM Books
-- ROLLBACK TRANSACTION

