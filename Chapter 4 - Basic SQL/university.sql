-- 4.12

-- a)
-- Retrieve the names of all senior students majoring in ‘CS’.

SELECT Name
FROM STUDENT
WHERE Major='CS' AND Class=4

-- b)
--  Retrieve the names of all courses taught by Professor King
-- in 2007 and 2008.

SELECT Course_name
FROM COURSE C, SECTION S
WHERE C.Course_number = S.Course_number AND S.Instructor='King'
      AND (S.Year='07' OR S.Year='08')

-- c)
-- For each section taught by Professor King, retrieve the course number,
-- semester, year, and number of students who took the section.

SELECT S.Course_number, S.Semester, S.Year, COUNT(GR.Student_number)
FROM SECTION AS S, GRADE_REPORT AS GR
WHERE S.Instructor='King'AND S.Section_identifier=GR.Section_identifier

-- d)  Retrieve the name and transcript of each senior student
-- (Class = 4) majoring in CS. A transcript includes course name,
-- course number, credit hours, semester, year, and grade for each
-- course completed by the student.

SELECT STUDENT.Name, C.Course_name, S.Course_number, C.Credit_hours,
      S.Semester, S.Year, GR.Grade
FROM STUDENT, COURSE AS C, SECTION AS S, GRADE_REPORT AS GR
WHERE STUDENT.Class=4 AND STUDENT.Major='CS'
      AND STUDENT.Student_number=GR.Student_number
      AND GR.Section_identifier=S.Section_identifier
      AND S.Course_number=C.Course_number;


-- 4.13

-- a)
INSERT INTO STUDENT
VALUES ('Johnson', 12, 1, 'Math');

-- b)
UPDATE STUDENT
SET Class=2
WHERE Name='Smith'

-- c)
INSERT INTO COURSE
VALUES ('Knowledge Engineering', 'CS4390', 3, 'CS');

-- d)
DELETE FROM STUDENT
WHERE Name='Smith' AND Student_number=17;
