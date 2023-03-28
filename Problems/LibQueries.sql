-- 1. 
SELECT * FROM Clients;

-- 2. First names, last names, ages and occupations of all clients
  SELECT ClientFirstName, ClientLastName, Occupation
  FROM Client (SELECT DATEDIFF(Age) FROM Client);

-- 3. First and last names of clients that borrowed books in March 2018
  SELECT ClientFirstName, ClientLastName FROM Client INNER JOIN Borrower     ON Client.ClientId = Borrower.ClientID
  WHERE (MONTH(Borrower.BorrowDate) = 3) AND (YEAR(Borrower.BorrowDate) =   2018);

-- 3. First and last names of clients that borrowed books in March 2018

  SELECT ClientFirstName, ClientLastName FROM Client 
  IF Client.ClientID = Borrower.ClientID AND (MONTH(Borrower.BorrowDate) =   3) AND (YEAR(Borrower.BorrowDate) = 2018);

-- 4. First and last names of the top 5 authors clients borrowed in 2017

  SELECT AuthorFirstName, AuthorLastName FROM Author 
    JOIN Book ON Author.AuthorID = Book.AuthorID 
    JOIN Borrower ON Book.BookID = Borrower.BookID
    WHERE YEAR(Borrower.BorrowDate) = 2017 
  ORDER BY Author.AuthorID
  LIMIT 5;

