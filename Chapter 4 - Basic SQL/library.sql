-- Definition of LIBRARY relational database schema as shown in Figure 4.6 of
-- Fundamentals of Database Systems (Sixth Edition)
-- by Ramez Elmasri and Samakant B. Navathe


-- Exersice 4.7
-- Consider the LIBRARY relational database schema shown in
-- Figure 4.6. Choose the appropriate action (reject, cascade,
-- set to NULL, set to default) for each referential integrity
-- constraint, both for the deletion of a referenced tuple and
-- for the update of a primary key attribute value in a referenced
-- tuple. Justify your choices.


-- ANSWER:
-- If an attribute is part of PK, it can't be set to NULL.
-- So it will restrict the deletion (default or cascade are not
-- appropriate actions-meaby default branch_id).


CREATE TABLE BOOK (
  Book_id        VARCHAR(10) NOT NULL PRIMARY KEY,
  Title          VARCHAR(50) NOT NULL,
  Publisher_name VARCHAR(20),
  FOREIGN KEY(Publisher_name) REFERENCES PUBLISHER(Name)
              ON DELETE SET NULL    ON UPDATE CASCADE,
);

CREATE TABLE BOOK_AUTHORS (
  Book_id        VARCHAR(10) NOT NULL,
  Author_name    VARCHAR(30),
  PRIMARY KEY(Book_id, Author_name),
  FOREIGN KEY(Book_id) REFERENCES BOOK(Book_id)
               ON DELETE RESTRICT    ON UPDATE CASCADE
);

CREATE TABLE PUBLISHER (
  Name    VARCHAR(20) NOT NULL PRIMARY KEY,
  Address VARCHAR(50),
  Phone   CHAR(10)
);

CREATE TABLE BOOK_COPIES(
  Book_id        VARCHAR(10) NOT NULL,
  Branch_id      INT         NOT NULL,
  No_of_copies   INT,
  PRIMARY KEY(Book_id, Branch_id),
  FOREIGN KEY(Book_id) REFERENCES BOOK(Book_id)
                ON DELETE RESTRICT   ON UPDATE CASCADE,
  FOREIGN KEY(Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id)
                ON DELETE RESTRICT   ON UPDATE CASCADE
);

CREATE TABLE BOOK_LOANS (
  Book_id    VARCHAR(10) NOT NULL,
  Branch_id  INT         NOT NULL,
  Card_no    VARCHAR(10) NOT NULL,
  Date_out   DATE        NOT NULL,
  Due_date   DATE,
  PRIMARY KEY(Book_id, Branch_id, Card_no),
  FOREIGN KEY(Book_id) REFERENCES BOOK(Book_id)
                ON DELETE RESTRICT   ON UPDATE CASCADE,
  FOREIGN KEY(Branch_id) REFERENCES LIBRARY_BRANCH(Branch_id)
                  ON DELETE RESTRICT   ON UPDATE CASCADE,
  FOREIGN KEY(Card_no) REFERENCES BORROWER(Card_no)
                  ON DELETE RESTRICT   ON UPDATE CASCADE
);

CREATE TABLE LIBRARY_BRANCH (
  Branch_id   INT         NOT NULL PRIMARY KEY,
  Branch_name VARCHAR(15),
  Address     VARCHAR(50)
);

CREATE TABLE BORROWER (
  Card_no VARCHAR(10) NOT NULL PRIMARY KEY,
  Name    VARCHAR(30) NOT NULL,
  Address VARCHAR(50) NOT NULL,
  Phone   CHAR(10)
);
