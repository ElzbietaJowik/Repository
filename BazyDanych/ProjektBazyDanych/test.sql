use Library
go

-- test 1.
select r.ID, FirstName, LastName, BookID, BookCopyID, BorrowDate
from Readers r 
join Borrows br on br.ReaderID = r.ID
join BookCopies bc on bc.ID = br.BookCopyID
order by r.ID, BookID, BorrowDate

-- test 2.

SELECT bc.BookID, b.Title, br.BorrowDate
FROM BookCopies bc
JOIN Borrows br ON bc.ID = br.BookCopyID
JOIN Books b ON bc.BookID = b.ID
ORDER BY TiTle, br.BorrowDate

-- test 3.
select ID, BookID, Available
from BookCopies
order by ID, Available

-- test 4.
SELECT b.ID, b.Title, Rating, SignOutDate
FROM Books b
JOIN BookRatings br ON br.BookID = b.ID
JOIN Readers r ON br.ReaderID = r.ID
ORDER BY ID

-- test 5.
SELECT b.ID, b.EmployeeID, e.FirstName, e.LastName
FROM Borrows b
JOIN Employees e on b.EmployeeID = e.ID
ORDER BY EmployeeID
