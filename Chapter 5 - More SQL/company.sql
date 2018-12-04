-- I'm using the same schema I created for Chapter's 4 exercises.

-- 5.5. Specify the following queries on the database in Figure 3.5 in SQL.
-- Show the query results if each query is applied to the database in Figure 3.6.

-- a. For each department whose average employee salary is more than $30,000,
-- retrieve the department name and the number of employees working for that
-- department.

SELECT Dname, COUNT(*) AS No_employees
FROM department, employee
WHERE Dnumber=Dno
GROUP BY Dname,
HAVING AVG(Salary)>30000

-- b. Suppose that we want the number of male employees in each department
-- making more than $30,000, rather than all employees (as in Exercise 5.4a).
-- Can we specify this query in SQL? Why or why not?

-- We can get the number of male employees by adding the condition to the where clause.
SELECT Dname, COUNT(*) AS No_employees
FROM department, employee
WHERE Dnumber=Dno AND Sex='M'
GROUP BY Dname,
HAVING AVG(Salary)>30000


-- 5.7. In SQL, specify the following queries on the database in Figure 3.5 using
-- the concept of nested queries and concepts described in this chapter.

-- a. Retrieve the names of all employees who work in the department that has the
-- employee with the highest salary among all employees.

SELECT Fname, Lname
FROM employee
WHERE Dno IN (SELECT Dno
              FROM employee)
              WHERE Salary >= ALL (SELECT Salary FROM employee)


-- b. Retrieve the names of all employees whose supervisor’s supervisor has
-- ‘888665555’ for Ssn.

SELECT Fname, Lname
FROM employee
WHERE super_ssn IN (SELECT SSN
              FROM Employee
              WHERE super_ssn='888665555')


-- c. Retrieve the names of employees who make at least $10,000 more than
-- the employee who is paid the least in the company.
SELECT Fname, Lname
FROM employee
WHERE Salary > (SELECT DISTINCT(salary) + 10000
                FROM employee
                WHERE Salary <= ALL(SELECT salary FROM employee))




-- 5.8. Specify the following views in SQL on the COMPANY database schema shown in
-- Figure 3.5.

-- a. A view that has the department name, manager name, and manager salary for
-- every department.

CREATE VIEW Manager
AS SELECT Dname, Fname, Lname, Salary
FROM employee, department
WHERE Dno=Dnumber and Mgr_ssn=Ssn

-- b. A view that has the employee name, supervisor name, and employee salary for
-- each employee who works in the ‘Research’ department.

CREATE VIEW Employee_Research_Dept(Employee_Fname,Employee_Lname, Supervisor_Fname, Supervisor_Lname, Employee_salary)
AS SELECT E.FName, E.Lname, S.Fname, S.Lname, E.Salary
FROM employee AS E, employee as S, department
WHERE E.super_ssn=S.ssn AND E.Dno=Dnumber AND Dname='Research'

-- c. A view that has the project name, controlling department name, number of
-- employees, and total hours worked per week on the project for each project.

CREATE VIEW Project_Details(Project, Department, No_employees, Total_hours)
AS SELECT P.Pname, D.Dname, COUNT(W.Essn),SUM(W.Hours)
FROM project AS P, department AS D, works_on AS W
WHERE P.Dnum=D.Dnumber AND P.Pnumber=W.Pno
GROUP BY P.Pname, D.Dname

-- d. A view that has the project name, controlling department name, number of
-- employees, and total hours worked per week on the project for each project
-- with more than one employee working on it.

CREATE VIEW Project_Details_2(Project, Department, No_employees, Total_hours)
AS SELECT P.Pname, D.Dname, COUNT(W.Essn),SUM(W.Hours)
FROM project AS P, department AS D, works_on AS W
WHERE P.Dnum=D.Dnumber AND P.Pnumber=W.Pno
GROUP BY P.Pname, D.Dname
HAVING COUNT(W.Essn) > 1



-- 5.9. Consider the following view, DEPT_SUMMARY, defined on the COMPANY database
-- in Figure 3.6:
-- CREATE VIEW DEPT_SUMMARY (D, C, Total_s, Average_s)
-- AS SELECT Dno, COUNT (*), SUM (Salary), AVG (Salary)
-- FROM EMPLOYEE
-- GROUP BY Dno
-- State which of the following queries and updates would be allowed on the view.
-- If a query or update would be allowed, show what the corresponding query or
-- update on the base relations would look like, and give its result when applied
-- to the database in Figure 3.6.


-- a.
-- SELECT *
-- FROM DEPT_SUMMARY;

-- It's allowed. The query on the base relation it's just everything after
-- "SELECT" in the create view command.

-- b.
-- SELECT D,C
-- FROM DEPT_SUMMARY
-- WHERE TOTAL_S > 100000;

-- It's allowed. The query on base relations would look like the following:
SELECT Dno, COUNT(*)
FROM employee
GROUP BY Dno
HAVING SUM(Salary)>100000

-- c.
-- SELECT D, AVERAGE_S
-- FROM DEPT_SUMMARY
-- WHERE C> (SELECT C FROM DEPT_SUMMARY WHERE D=4);

-- It's allowed. The query on base relations would look like the following:
SELECT Dno, AVG(Salary)
FROM employee
GROUP BY Dno
HAVING COUNT(*) > (SELECT COUNT(*) FROM Employee WHERE Dno=4)

-- d.
-- UPDATE DEPT_SUMMARY
-- SET D=3
-- WHERE D=4;

-- It's not allowed, cause it in the current db state it violates the referential
-- integrity of Dno column, since there is no two/tuple with Dnumber of 3 in
-- the department table.

-- e.
-- DELETE FROM DEPT_SUMMARY
-- WHERE C > 4;

-- It's not allowed, cause it violates schema's contrains. There are multiple
-- tables that references the Ssn column of employee table.
