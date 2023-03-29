ALTER TABLE LibDB.Client
ADD PRIMARY KEY (ClientID);

ALTER TABLE LibDB.Borrower
ADD PRIMARY KEY (BorrowID);

ALTER TABLE LibDB.Book
ADD PRIMARY KEY (BookID);

ALTER TABLE LibDB.Author
ADD PRIMARY KEY (AuthorID);

ALTER TABLE LibDB.Borrower
ADD FOREIGN KEY (ClientID) REFERENCES LibDB.Client(ClientID),
ADD FOREIGN KEY (BookID) REFERENCES LibDB.Book(BookID);

ALTER TABLE LibDB.Book
ADD FOREIGN KEY (AuthorID) REFERENCES LibDB.Author(AuthorID);