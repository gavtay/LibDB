-- 1. Display all contents of the Clients table
SELECT * FROM Client;
-- Selecting all records from the Clients table with "*".

-- 2. First names, last names, ages and occupations of all clients
SELECT ClientFirstName, ClientLastName, Occupation, 2023 - ClientDoB AS Age
FROM LibDB.Client;
-- Selecting the fields: ClientFirstName, ClientLastName, Occupation and calculating the age of each of teh clients using a subtraction formula, all of this occurs inside of the table Client.

-- 3. First and last names of clients that borrowed books in March 2018
SELECT ClientFirstName, ClientLastName, BorrowDate
FROM LibDB.Client JOIN LibDB.Borrower ON Client.ClientId = Borrower.ClientID
WHERE (MONTH(Borrower.BorrowDate) = 3) AND (YEAR(Borrower.BorrowDate) =   2018)
ORDER BY BorrowDate;
-- Joining the Borrower and Client table together so that records from both can be used. Then I created a condition that requires the month and date to be March, 2018. 
-- The selected results are then ordered by the date they were borrowed in Ascending order for March of 2018.

-- 4. First and last names of the top 5 authors clients borrowed in 2017
SELECT COUNT(Author.AuthorID) AS AuthCount, AuthorFirstName, AuthorLastName
FROM LibDB.Author JOIN LibDB.Book ON Author.AuthorID = Book.AuthorID 
JOIN LibDB.Borrower ON Book.BookID = Borrower.BookID
WHERE YEAR(Borrower.BorrowDate) = 2017
GROUP BY AuthorFirstName, AuthorLastName
ORDER BY AuthCount DESC
LIMIT 5;
-- Selecting count of each instance that an author ID is used to borrow, Joining Author to book with the AuthorID key, and then joining book to borrower using BookID key. 
-- Created a condidition that requires the year of the BorrowDate to be 2017. Then Group by the remaining selects,
-- order by the count of AuthorIDs selected at the beginning in descending order to make sure the records are displayed from highest to lowest, and then set the limit to show only the top 5 records.

-- 5. Nationalities of the least 5 authors that clients borrowed during the years 2015-2017
SELECT COUNT(AuthorNationality) AS NationalityNumber, AuthorFirstName, AuthorLastName, AuthorNationality
FROM LibDB.Borrower JOIN LibDB.Book ON Borrower.BookID = Book.BookID
JOIN LibDB.Author ON Book.AuthorID = Author.AuthorID
WHERE YEAR(BorrowDate) BETWEEN 2015 AND 2017
GROUP BY AuthorFirstName, AuthorLastName, AuthorNationality
ORDER BY NationalityNumber
LIMIT 5;
-- Created another count of AuthorNationality to know the amount of times each nationality was borrowed. Joined Borrower to Book with the BookID key,
-- then joined Book to Author with the AuthorID key. Created a condition that requires the year of the borrowdate to be between the years 2015 to 2017 per the requirements of the problem. 
-- Grouped by all selects except for the count select, then ordered by the count of AuthorNationality. 
-- Finally limited the records to 5 so it returns the 5 least authors clients borrowed between the years 2015 to 2017.

-- 6. The book that was most borrowed during the years 2015-2017
SELECT COUNT(Borrower.BookID) AS BookCount, Book.BookTitle
FROM LibDB.Borrower JOIN LibDB.Book ON Borrower.BookID = Book.BookID 
WHERE YEAR(Borrower.BorrowDate) BETWEEN 2015 AND 2017
GROUP BY Book.BookTitle
ORDER BY BookCount DESC
LIMIT 1;
-- Once again, a count was created for each book ID that was borrowed. Borrower and Book were joined using the BookID key. 
-- This was based on a condition that required the borrowdate to be between the years 2015-2017. 
-- BookTitle was the grouping performed and the count was used to order the records in descending order to show the highest results on top. 
-- The records were then limited to 1 to show only the top book.

-- 7. Top borrowed genres for client born in years 1970-1980
SELECT COUNT(Book.Genre) AS TopGenre, Genre
FROM LibDB.Borrower JOIN LibDB.Client ON Borrower.ClientID = Client.ClientID 
JOIN LibDB.Book ON Borrower.BookID = Book.BookID
WHERE ClientDOB BETWEEN 1970 AND 1980
GROUP BY Genre
ORDER BY TopGenre DESC
LIMIT 10;
-- Surprise, a count was created for the genres. Borrower was joined to client using ClientID key, then Borrower to Book using the BookID key. 
-- A conditional was made that requires the clients date of birth to be between 1970 and 1980. Genre was the grouping and the order was the count of genre in descending order 
-- so that the highest amounts of genres recorded would be at the top of the records returned. 

-- 8. Top 5 occupations that borrowed the most in 2016
SELECT COUNT(Borrower.BookID) AS Occupations, Occupation
FROM LibDB.Borrower JOIN LibDB.Client ON Borrower.ClientID = Client.ClientID 
WHERE YEAR(Borrower.BorrowDate) = 2017
GROUP BY Occupation
ORDER BY Occupations DESC
LIMIT 5;
-- As you may already assume, a count was created for Book IDs. The table borrower was joined with client using the ClientID key. 
-- We specifically looked for records that the borrowdate year was 2017, then grouped by Occupation, and ordered by the bookID count in Desceding order.
-- Finally limited the query results to 5 to only show the top 5 occupations.

-- 9. Average number of borrowed books by job title
SELECT AVG(b.counter) average_count, Occupation C
FROM LibDB.Client C JOIN 
  (SELECT ClientId, COUNT(*) counter FROM LibDb.Borrower
  GROUP BY ClientId) b ON b.ClientId = c.ClientId
GROUP BY Occupation;
-- First selected an average on the inner select, and the occupation because the contraint for this problem is the clients occupation
-- I then joined the client table to the borrower table which held a count, linking them by the ClientID key located in both the Client and borrower tables
-- Finally grouped by occupation

-- 10. Create a VIEW and display the titles that were borrowed by at least 20% of clients 
CREATE VIEW LibDB.TitleView AS
SELECT COUNT(Book.BookId), BookTitle
FROM LibDB.Book JOIN LibDB.Borrower ON Book.BookId = Borrower.BookId
JOIN LibDB.Client ON Borrower.ClientId = Client.ClientId 
GROUP BY BookTitle
HAVING COUNT(Book.BookId) > 
(SELECT COUNT(Client.ClientId) FROM LibDB.Client)*0.2
ORDER BY COUNT(Book.BookTitle) DESC;
-- First a view called TitleView was created, inside of the view a count was selected. I joined the Book and Borrower table using the key "BookID" and then joined the Client table on
-- the Borrower table using the "ClientID" key. Due to this query containing an aggregate function, I was not able to use a WHERE clause, thus a HAVING clause was used. The condition was
-- set as long as more than 20% of clients borrowed the specific BookID in the Book Table, they would be counted and ordered to display in descending order to see the highest first.

-- 11. The top month of borrows in 2017
SELECT COUNT(*) AS BorrowCount, MONTH(BorrowDate) AS BorrowMonth, YEAR(BorrowDate) AS BorrowYear
FROM LibDB.Borrower WHERE YEAR(BorrowDate) = 2017
GROUP BY BorrowMonth, BorrowYear
ORDER BY BorrowCount DESC
LIMIT 1;
-- A count was selected as well as each of the months and years located in the BorrowDate field of the Borrower table. A conditional was created requiring the year to be 2017, and then 
-- The results were ordered in descending order to show the results in highest to lowest, which were then limited to 1 to only show the top result, which in this case was
-- the top month of borrows in 2017

-- 12. Average number of borrows by age
SELECT AVG(b.counter) AS AverageBorrowByAge, ClientDoB BirthYear
FROM LibDB.Client C JOIN 
  (SELECT ClientId, COUNT(*) counter FROM LibDB.Borrower
  GROUP BY ClientId) b ON b.ClientId = c.ClientId
GROUP BY ClientDoB;
-- An average is selected that gets the count from an inner select. The client table is joined on the borrower table in this case on the clientID key and is then grouped by Client DoB.
-- This allowed me to grab the average of the counts found in the inner select

-- 13. The oldest and the youngest clients of the library
SELECT COUNT(*) MaxMin, ClientDoB AS ClientAge, ClientFirstName, ClientLastName, Client.ClientID 
FROM LibDB.Client WHERE 2023 - ClientDoB = (select max(2023 - ClientDoB) from LibDB.Client)
OR 2023 - ClientDoB = (select min(2023 - ClientDoB) from LibDB.Client)
GROUP BY ClientFirstName, ClientLastName, Client.ClientID
ORDER BY ClientAge 
LIMIT 10;
-- Several fields are selected then an inner select is created using the client table and ClientDoB field, which selects the max (highest number) of all the results from the ClientDoB after
-- the Clients dob are subtracted from 2023 inside of the client table. Then the same is done but with the minimum condition which finds the lowest number of 2023 - ClientDoB.
-- The results are grouped and then ordered by an alias of the dob.

-- 14. First and last names of authors that wrote books in more than one genre
SELECT AuthorFirstName, AuthorLastName, Genre
FROM LibDB.Book JOIN LibDB.Author WHERE Book.AuthorID = Author.AuthorID;
(SELECT Book.AuthorID FROM LibDB.Book JOIN 
  LibDB.Author ON Book.AuthorID = Author.AuthorID
  WHERE Genre > 1);

SELECT AuthorFirstName, AuthorLastName, Genre
FROM LibDB.Book JOIN LibDB.Author WHERE Book.AuthorID = Author.AuthorID;

-- I changed Book ID 14 With author ID 1 to A genre of Fiction, Need to change the Genre back to Science Later
-- 
