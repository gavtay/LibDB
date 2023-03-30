-- Display all contents of the Clients table
SELECT * FROM Client;

-- First names, last names, ages and occupations of all clients
SELECT ClientFirstName, ClientLastName, Occupation, 2023 - ClientDoB AS Age
FROM LibDB.Client;

-- First and last names of clients that borrowed books in March 2018
SELECT ClientFirstName, ClientLastName, BorrowDate
FROM LibDB.Client JOIN LibDB.Borrower ON Client.ClientId = Borrower.ClientID
WHERE (MONTH(Borrower.BorrowDate) = 3) AND (YEAR(Borrower.BorrowDate) =   2018)
ORDER BY BorrowDate;

-- First and last names of the top 5 authors clients borrowed in 2017
SELECT COUNT(Author.AuthorID) AS AuthCount, AuthorFirstName, AuthorLastName
FROM LibDB.Author JOIN LibDB.Book ON Author.AuthorID = Book.AuthorID 
JOIN LibDB.Borrower ON Book.BookID = Borrower.BookID
WHERE YEAR(Borrower.BorrowDate) = 2017
GROUP BY AuthorFirstName, AuthorLastName
ORDER BY AuthCount DESC
LIMIT 5;

-- Nationalities of the least 5 authors that clients borrowed during the years 2015-2017
SELECT COUNT(AuthorNationality) AS NationalityNumber, AuthorFirstName, AuthorLastName, AuthorNationality
FROM LibDB.Borrower JOIN LibDB.Book ON Borrower.BookID = Book.BookID
JOIN LibDB.Author ON Book.AuthorID = Author.AuthorID
WHERE YEAR(BorrowDate) BETWEEN 2015 AND 2017
GROUP BY AuthorFirstName, AuthorLastName, AuthorNationality
ORDER BY NationalityNumber
LIMIT 5;

-- The book that was most borrowed during the years 2015-2017
SELECT COUNT(Borrower.BookID) AS BookCount, Book.BookTitle
FROM LibDB.Borrower JOIN LibDB.Book ON Borrower.BookID = Book.BookID 
WHERE YEAR(Borrower.BorrowDate) BETWEEN 2015 AND 2017
GROUP BY Book.BookTitle
ORDER BY BookCount DESC
LIMIT 1;

-- Top borrowed genres for client born in years 1970-1980
SELECT COUNT(Book.Genre) AS TopGenre, Genre
FROM LibDB.Borrower JOIN LibDB.Client ON Borrower.ClientID = Client.ClientID 
JOIN LibDB.Book ON Borrower.BookID = Book.BookID
WHERE ClientDOB BETWEEN 1970 AND 1980
GROUP BY Genre
ORDER BY TopGenre DESC
LIMIT 10;

-- Top 5 occupations that borrowed the most in 2016
SELECT COUNT(Borrower.BookID) AS Occupations, Occupation
FROM LibDB.Borrower JOIN LibDB.Client ON Borrower.ClientID = Client.ClientID 
WHERE YEAR(Borrower.BorrowDate) = 2017
GROUP BY Occupation
ORDER BY Occupations DESC
LIMIT 5;

-- Average number of borrowed books by job title
SELECT AVG(b.counter) average_count, Occupation C
FROM LibDB.Client C JOIN 
  (SELECT ClientId, COUNT(*) counter FROM LibDb.Borrower
  GROUP BY ClientId) b ON b.ClientId = c.ClientId
GROUP BY Occupation;

-- Create a VIEW and display the titles that were borrowed by at least 20% of clients 
CREATE VIEW LibDB.TitleView AS
SELECT COUNT(Book.BookId), BookTitle
FROM LibDB.Book JOIN LibDB.Borrower ON Book.BookId = Borrower.BookId
JOIN LibDB.Client ON Borrower.ClientId = Client.ClientId 
GROUP BY BookTitle
HAVING COUNT(Book.BookId) > 
(SELECT COUNT(Client.ClientId) FROM LibDB.Client)*0.2
ORDER BY COUNT(Book.BookTitle) DESC;

-- The top month of borrows in 2017
SELECT COUNT(*) AS BorrowCount, MONTH(BorrowDate) AS BorrowMonth, YEAR(BorrowDate) AS BorrowYear
FROM LibDB.Borrower WHERE YEAR(BorrowDate) = 2017
GROUP BY BorrowMonth, BorrowYear
ORDER BY BorrowCount DESC
LIMIT 1;

-- Average number of borrows by age
SELECT AVG(b.counter) AS AverageBorrowByAge, ClientDoB BirthYear
FROM LibDB.Client C JOIN 
  (SELECT ClientId, COUNT(*) counter FROM LibDB.Borrower
  GROUP BY ClientId) b ON b.ClientId = c.ClientId
GROUP BY ClientDoB;

-- The oldest and the youngest clients of the library
SELECT COUNT(*) MaxMin, ClientDoB AS ClientAge, ClientFirstName, ClientLastName, Client.ClientID 
FROM LibDB.Client WHERE 2023 - ClientDoB = (select max(2023 - ClientDoB) from LibDB.Client)
OR 2023 - ClientDoB = (select min(2023 - ClientDoB) from LibDB.Client)
GROUP BY ClientFirstName, ClientLastName, Client.ClientID
ORDER BY ClientAge 
LIMIT 10;

-- First and last names of authors that wrote books in more than one genre
SELECT AuthorFirstName, AuthorLastName
FROM LibDB.Author JOIN LibDB.Book ON Author.AuthorID = Book.AuthorID
WHERE Genre IN ('Science', 'Fiction', 'Law', 'Society', 'Humor', 'Literature', 'Children', 'Well being')
GROUP BY AuthorFirstName, AuthorLastName
HAVING COUNT(DISTINCT Genre) > 1;
