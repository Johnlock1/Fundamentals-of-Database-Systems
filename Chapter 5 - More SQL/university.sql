-- Schema design

CREATE TABLE STUDENT (
  Name            VARCHAR(15) NOT NULL,
  Student_number  INT         PRIMARY KEY,
  Class           INT,
  Major           VARCHAR(4),
  CHECK (Class >=1 AND Class <=5)
)

CREATE TABLE COURSE (
  Course_name   VARCHAR(30) NOT NULL,
  Course_number VARCHAR(8)  PRIMARY KEY,
  Credit_hours  INT,
  Department    VARCHAR(4)
)

CREATE TABLE SECTION (
  Section_identifier  INT        PRIMARY KEY,
  Course_number       VARCHAR(8) NOT NULL REFERENCES COURSE(Course_number),
  Semester            VARCHAR(6),
  Year                CHAR(2),
  Instructor          VARCHAR(15)
)

CREATE TABLE GRADE_REPORT (
  Student_number      INT   NOT NULL  REFERENCES STUDENT(Student_number),
  Section_identifier  INT   NOT NULL  REFERENCES SECTION(Section_identifier),
  Grade               CHAR  NOT NULL,
  PRIMARY KEY (Student_number, Section_identifier)
)

CREATE TABLE PREREQUISITE (
  Course_number       VARCHAR(8) REFERENCES COURSE(Course_number),
  Prerequisite_number VARCHAR(8) REFERENCES COURSE(Course_number),
  PRIMARY KEY(Course_number, Prerequisite_number)
)


-- 5.6. Specify the following queries in SQL on the database schema in Figure 1.2.

-- a. Retrieve the names and major departments of all straight-A students
-- (students who have a grade of A in all their courses).

-- b. Retrieve the names and major departments of all students who do not have a
-- grade of A in any of their courses.

-- a.
SELECT name, major
FROM student AS S
WHERE NOT EXISTS (SELECT *
                  FROM grade_report
                  WHERE Student_number = S.Student_number
                  AND NOT (Grade='A'))

-- b.
SELECT name, major
FROM student AS S
WHERE NOT EXISTS (SELECT *
                  FROM grade_report
                  WHERE Student_number = S.Student_number
                  AND (Grade='A'))
