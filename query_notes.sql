-- SQL basic 

-- SELECT only Sports or Tools
SELECT * FROM employees 
WHERE department = 'Sports' OR department = 'Tools'

--Retrieve only the employees with salary over 100K
SELECT *
FROM employees
WHERE salary > 100000

-- Retrieve employees who work in department clothing and salary greater than 90K
SELECT * FROM employees
WHERE department = 'Clothing' AND salary > 90000

-- Retrieve those employees that have a salary less than 40K and are in department clothing or pharamcy 
SELECT *
FROM employees
WHERE salary < 40000
AND (department = 'Clothing' OR department = 'Pharmacy')

-----------_Filtering Operators 

--Find all employees and records but do not include any of the sports deparment
SELECT *
FROM employees
WHERE department != 'Sports' 

-- I have noticed there are some nulls in the email column find all the emails that are not null
SELECT * FROM employees
WHERE email IS NOT NULL

-- Find all records in email that are NULL
SELECT * FROM employees
WHERE email IS NULL

--- Filter for Multiple values 
SELECT * 
FROM employees 
WHERE department IN ('Clothing', 'First Aid', 'Toys', 'Garden')
--Use the IN operator 

-- Filter a range of salary 
SELECT * FROM employees
WHERE salary BETWEEN 80000 AND 100000

-- Between clause is inclusive of the range and can be used for Dates. 


----Return the first_name and email of females that work in the tools department having a salary greater than 110K
SELECT first_name, email 
FROM employees
WHERE gender = 'F'
AND department = 'Tools'
AND salary > 110000 

---Return the first_name and hire_date of those employees who earn more than 165K as well as those employees that work in the sports department and happen to be men. 
SELECT first_name, hire_date
FROM employees
WHERE salary > 165000
OR (department = 'Sports' AND gender = 'M')

--Retunr the first_name and hire_dates of those employees who were hired during Jan 1, 2002 and Jan 1, 2004
SELECT first_name, hire_date
FROM employees
WHERE hire_date BETWEEN '2002-01-01' AND '2004-01-01'


-- Return the male employees who work in the automotive department and earn more than 40K and less than 100K as well as females that work in the Toys department
SELECT * 
FROM employees
WHERE salary BETWEEN 40000 AND 100000
AND (gender = 'M' AND department = 'Automotive')
OR (gender = 'F' AND department = 'Toys')

------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------- String Functions

-- Use Substring to pull out information from a string 

SELECT SUBSTRING('This is test data' FROM 1 FOR 4) test_data_extracted


SELECT department FROM departments
-- We noticed there are multiple locations of clothing 
-- lets change clothing into Attire 
--REPLACE(column, 'item to replace', 'New Character')

SELECT department, REPLACE(department, 'Clothing', 'Attire')
FROM departments

-- Concatentate two columns using pipes ||
SELECT department, 
REPLACE(department, 'Clothing', 'Attire') AS modified_data,
department ||' '||'department' AS "Complete Department"
FROM departments

-- Find the position of a character 
SELECT * FROM employees

--I am now tasked to extract the domain name of the emails to find out which domain name the employees are using. 
SELECT POSITION('@' IN email)
FROM employees
-- this gives back the position of the @ sign 

SELECT SUBSTRING(email, POSITION('@' IN EMAIL))
FROM employees

-- Lets ignore the @ sign 
SELECT SUBSTRING(email, POSITION('@' IN EMAIL)+1) as domain_name
FROM employees

-- We have now extracted the domain name from employees

-- We noticed there are NUlls for Email. Lets add in a text into NULL using COALES
SELECT email FROM employees

-- COALSCE works by (column_name, 'Name besides NULL')
SELECT COALESCE(email, 'NONE') as email 
FROM employees


------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------- Grouping Function 

SELECT UPPER(first_name), LOWER(last_name)
FROM employees

SELECT MAX(salary) As max_sal, MIN(salary) As min_sal, COUNT(email)
FROM employees

SELECT SUM(salary) AS total_wages
FROM employees

--- Find the Total salary for Sports department 
SELECT SUM(salary)
FROM employees
WHERE department = 'Sports'

------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------- GROUPING DATA AND COMPUTING AGGREGATES 

-- UNDERSTANDING GROUPING 

--Create a list of employees by department 
SELECT * 
FROM employees
ORDER BY department

-- create a list of total salary for each department 
SELECT department, SUM(salary)
FROM employees
GROUP BY department

--Count the number of employees per department 
SELECT department, COUNT(employee_id)
FROM employees
GROUP BY department


SELECT department, COUNT(*), ROUND(AVG(salary)), MIN(salary), MAX(salary)
FROM employees
GROUP BY department

-------IF the column you are listed is a feature as a column in the select statement you have to include them in the GROUP BY clause 
SELECT department, gender, count(*)
FROM employees
GROUP BY department, gender

--To filter aggregated Data you can use the HAVING 
SELECT department, count(*)
FROM employees
GROUP BY department
HAVING count(*) > 35  -- used to filter grouped data
ORDER BY department 


---How many people have the same first name in company and the count
SELECT first_name, COUNT(*)
FROM employees
GROUP BY first_name
HAVING COUNT(*) > 1
ORDER BY COUNT(*) Desc

--Retrieve the Unique departments in the employees table 
SELECT department
FROM employees
GROUP BY department 
						
						
-- Present the domain names and total number of employees with that domain name. 
SELECT SUBSTRING(email, POSITION('@' IN EMAIL)+1) AS domain_name, COUNT(*)
FROM employees
WHERE email IS NOT NULL
GROUP BY domain_name
ORDER BY COUNT(*) DESC

-- Show table that shows gender, region_id, min, max, avg salary. 
-- sorted by gender 
SELECT gender, region_id, 
MIN(salary) AS min_salary,
MAX(salary) AS max_salary,
AVG(salary) AS avg_salary
FROM employees
GROUP BY gender, region_id 
ORDER BY gender, region_id 


------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------- SUB QUERIES 

SELECT * FROM employees 

--Selecting first_name, last_name at the begining and then the rest of the columns
SELECT first_name, last_name, * 
FROM employees

--SELECTING different table 
SELECT emp.department 
FROM employees as emp, departments

--Sub query is a select statement within a select 
SELECT * FROM employees 
WHERE department NOT IN (SELECT department FROM departments)
-- this query is looking for departments not in department table 

SELECT * 
FROM (SELECT * FROM employees WHERE salary > 150000) a --it surves as a source of where the data is coming from and you have to give it a Name 'A'



SELECT emp_name, yearly_salary
-- the data base uses the inner query first so the change in name of the column needs to be displayed on the outer layer. 
FROM (SELECT first_name emp_name, salary yearly_salary FROM employees WHERE salary > 150000) a


--two subqueries, they need to have references on where they are calling from one another 

SELECT * 
FROM employees
WHERE department in (SELECT department FROM departments) -- this is getting the department from table of departments 

SELECT * 
FROM (SELECT department FROM departments) as sub, -- give it an alias if its in the FROM section 

-- FROM qeury can be used in the select clause 

-- SELECT all the employees that work in the deparment division of electronics 
SELECT * FROM employees
WHERE department IN (SELECT department FROM departments WHERE division = 'Electronics')

--- Write a query for employees that work in asia or canada that make over 130K 

SELECT * FROM employees
SELECT * FROM regions

SELECT * FROM employees
WHERE salary > 130000    --find the salary from employees that is above 130K 
AND region_id IN (SELECT region_id FROM regions WHERE country IN ('Asia','Canada'))
				-- pick region id from regions where country = asia or canada 
				

-- use subquery in the select clause to show the first name and department to find out how much less they make from the highest paid in the company.
-- for asia and canada 

SELECT first_name, department, 
((SELECT MAX(salary) FROM employees)- salary) pay_diff
FROM employees
WHERE region_id IN (SELECT region_id FROM regions WHERE country IN ('Asia','Canada'))


-- Subquery with ANY AND ALL 
SELECT * FROM regions

-- there are 3 region id that are associated with USA
SELECT * FROM employees
WHERE region_id IN (SELECT region_id FROM regions WHERE country= 'United States') 
-- use the where to look up region id (use IN because we are selecting multiple) select from regions table where country is united states. 

-- filter for regions greater regions that are greater than the region id that belong to the US
-- there are multiple values so we need to introduce ALL/ANY 
-- 
SELECT * FROM employees
WHERE region_id > ANY(SELECT region_id FROM regions WHERE country= 'United States') 

-- this query picks all region_id greater than region_id from the US 
-- returning employees from other countries. 
SELECT * FROM employees
WHERE region_id > ALL(SELECT region_id FROM regions WHERE country= 'United States') 


--Write a query that returns all those employees that work in the Kids Division 
-- AND the dates at which those employees were hired is greater than all of the hire_dates of 
-- employees who work in the maintenance department. 

SELECT * FROM departments --division is in department

SELECT * FROM employees 
WHERE department = ANY (SELECT department -- use ANY to select the multiple values from division that match for kids
						FROM departments 
						WHERE division = 'Kids') 
AND hire_date > ALL (select hire_date  -- Use ALL keyboard to find the all the differences, because it brings back multiple values so we use ALL
					 from employees 
					 WHERE department = 'Maintenance')

-- Assignment: Query those salaries that are making the same number 
SELECT salary FROM (SELECT salary, COUNT(*)
FROM employees
GROUP BY salary
ORDER BY COUNT(*) DESC, salary DESC
LIMIT 1) a
					 
-- put the subquery in the select section to only show the values of the salary				

SELECT salary 
FROM employees
GROUP BY salary
HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM employees GROUP BY salary)
ORDER BY salary DESC 
LIMIT 1

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
-- MORE PRACTICE WITH SUBQUERIES 

CREATE TABLE dupes (id INT, name varchar(10));

INSERT INTO dupes VALUES (1, 'FRANK');
INSERT INTO dupes VALUES (2, 'FRANK');
INSERT INTO dupes VALUES (3, 'ROBERT');
INSERT INTO dupes VALUES (4, 'ROBERT');
INSERT INTO dupes VALUES (5, 'SAM');
INSERT INTO dupes VALUES (6, 'FRANK');
INSERT INTO dupes VALUES (7, 'PETER');

SELECT * FROM dupes

-- find the unqiue values of the names with the 

SELECT min(id), name
FROM dupes 
GROUP BY name

SELECT * FROM dupes
WHERE id IN (
SELECT min(id)
FROM dupes 
GROUP BY name
) 

-- How to delete data from dupes, delete instead of select, use from to pick the table and WHERE to pick what will be deleted. 
DELETE FROM dupes 
WHERE id NOT IN(
SELECT min(id)
FROM dupes
GROUP BY name
)

-- drop table 
drop table dupes 


-- Find the average salary but exclude the min and max from competing the average 
SELECT AVG(salary) as avg_sal FROM employees 
WHERE AVG(salary) 

(SELECT salary FROM employers WHERE salary IS NOT MAX(salary) AND salary IS NOT MIN(salary))


SELECT ROUND(AVG(salary)) 
FROM employees
WHERE salary NOT IN (
(SELECT MIN(salary) FROM employees),
(SELECT MAX(salary) FROM employees)
)


------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------- SECTION 6 USING CASE CLAUSE IN INTERESTING WAYS 

--- create another column for salary that says underpaid or paid well 
-- USE CASE to create a new column and specify certain attributes 
SELECT first_name, salary, 
CASE 
WHEN salary < 100000 THEN 'UNDER PAID'   -- WHEN this is true THEN 'label'
WHEN salary > 100000 THEN 'PAID WELL'
ELSE 'UNPAID'  -- this can be added for NULL information
END as comp 
FROM employees
ORDER BY salary DESC



-- Use the same type of Query but this time if the employee makes more than 100K but less than 160K its paid well if not they are an executive 
(SELECT first_name, salary, 
CASE
WHEN salary < 100000 THEN 'UNDER PAID'
WHEN salary > 100000 AND salary < 160000 THEN 'PAID WELL'
ELSE 'EXECUTIVE'
END compensation
FROM employees
ORDER BY salary DESC

--- wrap this up into a subquery and get the total count of all the executive and pay group. table needs to display category and total count 
SELECT COUNT(*), (CASE
WHEN salary < 100000 THEN 'UNDER PAID'
WHEN salary > 100000 AND salary < 160000 THEN 'PAID WELL'
ELSE 'EXECUTIVE'
END ) compensation
FROM employees
GROUP by compensation 

--- put all of this in a subquery 
SELECT a.compensation, COUNT(*) FROM 
 (
SELECT first_name, salary, 
CASE
WHEN salary < 100000 THEN 'UNDER PAID'
WHEN salary > 100000 AND salary < 160000 THEN 'PAID WELL'
ELSE 'EXECUTIVE'
END compensation
FROM employees
 ) a
 GROUP BY a.compensation


--- wrap this up into a subquery and get the total count of all the executive and pay group. table needs to display category and total count 
SELECT a.compensation, COUNT(*) 
FROM (
SELECT first_name, salary, 
CASE 
WHEN salary < 100000 THEN 'LOW PAY'
WHEN salary > 100000 AND salary < 160000 THEN 'PAID WELL'
ELSE 'EXECUTIVE'
END compensation 
FROM employees) a
GROUP BY a.compensation










