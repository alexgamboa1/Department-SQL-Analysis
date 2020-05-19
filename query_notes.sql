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
								   
								  
















