-- Definition of COMPANY relational database schema as shown in Figure 3.7 of
-- Fundamentals of Database Systems (Sixth Edition)
-- by Ramez Elmasri and Samakant B. Navathe



-- ============== --
-- CREATE TABLES  --
-- ============== --


CREATE DOMAIN SSN_TYPE AS CHAR(9)

CREATE TABLE EMPLOYEE (
  Fname     VARCHAR(15)   NOT NULL,
  Minit     CHAR,
  Lname     VARCHAR(15)   NOT NULL,
  Ssn       SSN_TYPE      PRIMARY KEY,
  Bdate     DATE,
  Address   VARCHAR(35),
  Sex       CHAR,
  Salary    DECIMAL(10,2),
  Super_ssn SSN_TYPE      REFERENCES EMPLOYEE(Ssn)
                          ON DELETE SET NULL  ON UPDATE CASCADE,
  Dno       INT           DEFAULT 1   REFERENCES DEPARTMENT(Dnumber)
                          ON DELETE SET DEFAULT   ON UPDATE CASCADE
);

-- ALTER TABLE employee
-- ADD FOREIGN KEY(Dno) REFERENCES DEPARTMENT(Dnumber)
--                     ON DELETE SET DEFAULT   ON UPDATE CASCADE

-- ALER TABLE employee
-- ADD COLUMN Dno INT   DEFAULT 1   REFERENCES DEPARTMENT(Dnumber)
--                                ON DELETE SET DEFAULT   ON UPDATE CASCADE

CREATE TABLE DEPARTMENT (
  Dname           VARCHAR(15) NOT NULL   UNIQUE,
  Dnumber         INT         NOT NULL   CHECK (Dnumber > 0 AND Dnumber <21),
  Mgr_ssn         SSN_TYPE    DEFAULT '888665555'  REFERENCES EMPLOYEE(Ssn)
                              ON DELETE SET DEFAULT   ON UPDATE CASCADE,
  Mgr_start_date  DATE,
  PRIMARY KEY(Dnumber)
);

CREATE TABLE DEPT_LOCATIONS (
  Dnumber   INT         NOT NULL  REFERENCES DEPARTMENT(Dnumber)
                                  ON DELETE CASCADE   ON UPDATE CASCADE,
  Dlocation VARCHAR(15) NOT NULL,
  PRIMARY KEY(Dnumber, Dlocation)
);

CREATE TABLE PROJECT (
  Pname      VARCHAR(15) NOT NULL     UNIQUE,
  Pnumber    INT         PRIMARY KEY,
  Plocation  VARCHAR(15),
  Dnum       INT         NOT NULL     REFERENCES DEPARTMENT(Dnumber)
);

CREATE TABLE WORKS_ON (
  Essn  SSN_TYPE    NOT NULL  REFERENCES EMPLOYEE(Ssn),
  Pno   INT         NOT NULL  REFERENCES PROJECT(Pnumber),
  Hours DECIMAL(3,1),
  PRIMARY KEY(Essn, Pno)
);

CREATE TABLE DEPENDENT (
  Essn            SSN_TYPE    NOT NULL  REFERENCES EMPLOYEE(Ssn),
  Dependent_name  VARCHAR(15) NOT NULL,
  Sex             CHAR,
  Bdate           DATE,
  Relationship    VARCHAR(8),
  PRIMARY KEY(Essn, Dependent_name)
);



-- =================== --
-- INSERT INTO TABLES  --
-- =================== --


INSERT INTO employee
VALUES
('James', 'E', 'Borg', '888665555', '1937-11-10', '450 Stone, Houston, TX ', 'M ', 55000, NULL , 1),
('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638 Voss, Houston, TX ', 'M ', 40000, '888665555', 5),
('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291 Berry, Bellaire, TX ', 'F ', 43000, '888665555', 4),
('John', 'B', 'Smith', '123456789', '1965-01-09', '731 Fondren, Houston, TX ', 'M ', 30000, '333445555', 5),
('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321 Castle, Spring, TX ', 'F ', 25000, '987654321', 4),
('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975 Fire Oak, Humble, TX ', 'M ', 38000, '333445555', 5),
('Ahmad', 'V', 'Jabbar', '987987987', '1969-03-29', '980 Dallas, Houston, TX ', 'M ', 25000, '987654321', 4),
('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631 Rice, Houston, TX ', 'F ', 25000, '333445555', 5);


INSERT INTO department
VALUES
('Headquarters', 1, '888665555', '1981-06-19'),
('Administration', 4, '987654321', '1995-01-01'),
('Research', 5, '333445555', '1988-05-22');


INSERT INTO dept_locations
VALUES (1, 'Houston '),
(4, 'Stafford '),
(5, 'Bellaire '),
(5, 'Sugarland '),
(5, 'Houston ');

INSERT INTO project
VALUES ('ProductX ', 1, 'Bellaire ', 5),
('ProductY ', 2, 'Sugarland ', 5),
('ProductZ ', 3, 'Houston ', 5),
('Computerization ', 10, 'Stafford ', 4),
('Reorganization ', 20, 'Houston ', 1),
('Newbenefits ', 30, 'Stafford ', 4);


INSERT INTO WORKS_ON
VALUES
('123456789', 1, 32.5),
('123456789', 2, 7.5),
('666884444', 3, 40.0),
('453453453', 1, 20.0),
('453453453', 2, 20.0),
('333445555', 2, 10.0),
('333445555', 3, 10.0),
('333445555', 10, 10.0),
('333445555', 20, 10.0),
('999887777', 30, 30.0),
('999887777', 10, 10.0),
('987987987', 10, 35.0),
('987987987', 30, 5.0),
('987654321', 30, 20.0),
('987654321', 20, 15.0),
('888665555', 20, NULL);


INSERT INTO dependent
VALUES
('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse'),
('123456789', 'Michael', 'M', '1988-12-30', 'Son'),
('123456789', 'Alice', 'F', '1988-12-30', 'Daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse');



-- ============================================= --
-- Exercises with retrival, deletion, and update
-- ============================================= --


-- Exercice 4.10

-- a)
-- Retrieve the names of all employees in department 5 who work more than
-- 10 hours per week on the ProductX project.

SELECT Fname, Lname
FROM EMPLOYEE AS E, PROJECT AS P, WORKS_ON AS W
WHERE E.Dno=5 AND E.Ssn=W.Essn AND W.Hours>10 AND W.Pno=P.Pnumber AND P.Pname='ProductX';

-- b)
-- List the names of all employees who have a dependent with the same
-- first name as themselves.

SELECT Fname, Lname
FROM EMPLOYEE E, DEPENDENT D
WHERE E.Ssn=D.Essn AND E.Fname=D.Dependent_name;

-- c)
-- Find the names of all employees who are directly supervised
-- by 'Franklin Wong'.

SELECT E.Fname, E.Lname
FROM EMPLOYEE AS E, EMPLOYEE AS S
WHERE S.Fname='Franklin' AND S.Lname='Wong' AND S.Ssn=E.Super_ssn;

-- 4.11

-- a)
INSERT INTO EMPLOYEE
VALUES ('Robert', 'F', 'Scott', '943775543', '1972-06-21',
    '2365 Newcastle Rd, Bellaire, TX', 'M', 58000, '888665555', 1);

-- b)
INSERT INTO PROJECT
VALUES ('ProductA', 4, 'Bellaire', 2);
-- Doesn't work. Violates foreign key constrain (no DEPARTMENT.Dnumber=2)

-- c)
INSERT INTO DEPARTMENT
VALUES ('Production', 4, '943775543', '2007-10-01');
-- Doesn't work. Violates unique constrain (Dnumber=4 already exists)

-- d)
INSERT INTO WORKS_ON
VALUES ('677678989', NULL, '40.0');
-- Doesn't work. Violates not-null constrain

-- e)
INSERT INTO DEPENDENT
VALUES ('453453453','John','M','1990-12-12','Spouse');

-- f)
DELETE FROM WORKS_ON
WHERE Essn='333445555';

-- g)
DELETE FROM EMPLOYEE
WHERE Ssn='987654321';
-- Doesn't work. Violates foreign key constrain (DEPENDENT.Essn)

-- h)
DELETE FROM PROJECT
WHERE Pname='ProductX';
-- Doesn't work. Violates foreign key constrain (WORKS_ON.Pno)

-- i)
UPDATE DEPARTMENT
SET Mgr_ssn='123456789', Mgr_start_date='2007-10-01'
WHERE Dnumber=5;

-- j)
UPDATE EMPLOYEE
SET Super_ssn='943775543'
WHERE Ssn='999887777';

-- k)
UPDATE WORKS_ON
SET Hours='5.0'
WHERE Essn='999887777' AND Pno=10;


-- 4.16 backup employee table
CREATE TABLE employee_backup
AS (SELECT * FROM employee)
