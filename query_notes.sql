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
(SELECT MAX(salary) FROM employees))

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
END compensation)
FROM employees
ORDER BY salary DESC

--- wrap this up into a subquery and get the total count of all the executive and pay group. table needs to display category and total count 
SELECT COUNT(*), (CASE
WHEN salary < 100000 THEN 'UNDER PAID'
WHEN salary > 100000 AND salary < 160000 THEN 'PAID WELL'
ELSE 'EXECUTIVE'
END) compensation
FROM employees
GROUP by compensation 



--- put all of this in a subquery 
SELECT a.compensation, COUNT(*) FROM (SELECT first_name, salary, 
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

------What if we wanted to make the compensation rows into columns. 
-- the sum function will sum the case
-- SUM(CASE WHEN column name < value THEN 1 ELSE 0 END) AS column name. 
									--THEN 1 is +1 for every time this is True if not 0
									-- THEN if this then that 
SELECT SUM(CASE WHEN salary < 100000 THEN 1 ELSE 0 END) AS low_paid, 
SUM(CASE WHEN salary > 100000 AND salary < 150000 THEN 1 ELSE 0 END) AS paid_well,
SUM(CASE WHEN salary > 150000 THEN 1 ELSE 0 END) AS executive
FROM employees


Select department, count(*)
FROM employees 
WHERE department in ('Sports', 'Tools')
GROUP BY department



---Create a query where you count the number of employees in each department as a header for sports, tools, clothing, and computers 
SELECT SUM(CASE WHEN department= 'Sports' THEN 1 ELSE 0 END) as sports_employees, 
SUM(CASE WHEN department = 'Tools' THEN 1 ELSE 0 END) AS tools_employees, 
SUM(CASE WHEN department = 'Clothing' THEN 1 ELSE 0 END) AS clothing_employees, 
SUM(CASE WHEN department = 'Computers' THEN 1 ELSE 0 END) AS computer_employees
FROM employees 


-- Create a query that has first_name, region_1, region_2, 3, 4, 5, 6, 7. Find the employee name for each of the regions and for each region put the country 
SELECT * FROM regions -- country is in regions table 
-- region_id for United states is 1, 2, 3
-- region_id for Asia is 4, 5
-- region_id for Canada is 6, 7 
SELECT * FROM employees -- region_id is also in employees 

SELECT first_name, 
(CASE WHEN region_id = 1 THEN 'United States' END) as region_1,
(CASE WHEN region_id = 2 THEN 'United States' END) as region_2,
(CASE WHEN region_id = 3 THEN 'United States' END) as region_3,
(CASE WHEN region_id = 4 THEN 'Asia' END) as region_4,
(CASE WHEN region_id = 5 THEN 'Asia' END) as region_5,
(CASE WHEN region_id = 6 THEN 'Canada' END) as region_6,
(CASE WHEN region_id = 7 THEN 'Canada' END) as region_7
FROM employees


-- use the subquery to find the country per region_id 
SELECT first_name, 
CASE WHEN region_id = 1 THEN (SELECT country FROM regions WHERE region_id = 1) END region_1, 
CASE WHEN region_id = 2 THEN (SELECT country FROM regions WHERE region_id = 2) END region_2,
CASE WHEN region_id = 3 THEN (SELECT country FROM regions WHERE region_id = 3) END region_3,
CASE WHEN region_id = 4 THEN (SELECT country FROM regions WHERE region_id = 4) END region_4,
CASE WHEN region_id = 5 THEN (SELECT country FROM regions WHERE region_id = 5) END region_5,
CASE WHEN region_id = 6 THEN (SELECT country FROM regions WHERE region_id = 6) END region_6,
CASE WHEN region_id = 7 THEN (SELECT country FROM regions WHERE region_id = 7) END region_7
FROM employees

--Create a query where you count the number of employees for united states, asia, and canada. Solve without using joins. 
-- use past query to find your result. 
SELECT COUNT(a.region_1)+ COUNT(a.region_2) + COUNT(a.region_3) AS United_states, 
COUNT(a.region_4)+COUNT(a.region_5) AS Asia,
COUNT(a.region_6)+COUNT(a.region_7) AS Canada
FROM (SELECT first_name, 
CASE WHEN region_id = 1 THEN (SELECT country FROM regions WHERE region_id = 1) END region_1, 
CASE WHEN region_id = 2 THEN (SELECT country FROM regions WHERE region_id = 2) END region_2,
CASE WHEN region_id = 3 THEN (SELECT country FROM regions WHERE region_id = 3) END region_3,
CASE WHEN region_id = 4 THEN (SELECT country FROM regions WHERE region_id = 4) END region_4,
CASE WHEN region_id = 5 THEN (SELECT country FROM regions WHERE region_id = 5) END region_5,
CASE WHEN region_id = 6 THEN (SELECT country FROM regions WHERE region_id = 6) END region_6,
CASE WHEN region_id = 7 THEN (SELECT country FROM regions WHERE region_id = 7) END region_7
FROM employees) As a

------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------- SECTION 7 ADVANCED QUERY TECHNIQUES USING CORRELATED SUBQUERIES 

-- UNDERSTANDING CORRELATED SUBQUERIES 

SELECT first_name, salary
FROM employees
WHERE salary > (SELECT ROUND(AVG(salary)) FROM employees) -- not corralted subquery 

-- query employees above 
SELECT first_name, salary
FROM employees e1
WHERE salary > (SELECT ROUND(AVG(salary)) FROM employees e2 WHERE e1.department = e2.department) 
				
-- correlated subquery because we are using two tables but they are both correlated by using the WHERE from column in table e1 and column in table e2 

-- find the avg by region_id 	
SELECT first_name, salary
FROM employees e1
WHERE salary > (SELECT ROUND(AVG(salary)) FROM employees e2 WHERE e1.region_id = e2.region_id) 

-- find the avg salary by department and find the name and salary of the person with greater than the average salary by department. 
SELECT first_name, department, salary, (SELECT ROUND(AVG(salary)) FROM employees e2 WHERE e1.department = e2.department) AS avg_department_sal
FROM employees e1

-- correlated subquery is run from everthing in the outer query. 

--- write a query for name of department that have more than 38 employees working. use a correlated sub query
SELECT * FROM employees


SELECT department 
FROM employees e1
WHERE 38 < (SELECT COUNT(*) FROM employees e2 WHERE e1.department = e2.department)
-- this only gets the department column that have more than 38

SELECT distinct(department)
FROM employees e1 
WHERE 38 < (SELECT COUNT(*) FROM employees e2 WHERE e1.department = e2.department)
-- used distinct to find unqiue department for 13 rows

-- use the group by to find the 13 unqiue departments. Another way from above. 
SELECT department 
FROM employees e1 
WHERE 38 < (SELECT COUNT(*) FROM employees e2 WHERE e1.department = e2.department)
GROUP by department

--- used the department table 
SELECT department 
FROM departments d
WHERE 38 < (SELECT COUNT(*) FROM employees e1 WHERE d.department = e1.department)

----------------
-- Present another column with the highest paid employees salary for each one of these department 

					-- use a correlated subquery and match on WHERE department = d.department 
SELECT department, (SELECT MAX(salary) FROM employees e1 WHERE e1.department = d.department) as max_sal
FROM departments d
WHERE 38 < (SELECT COUNT(*) FROM employees e1 WHERE d.department = e1.department)
ORDER BY max_sal


----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
---------------- 28 Exercise Correlated Subqueiries 

-- Create a table of department, first_name, salary, and salary in department HIGHEST and lowest of the group 
-- 1st find the min and max with added column 
-- we do not want to group by department. 
SELECT max(salary) max_sal, min(salary) min_sal, department FROM employees GROUP BY department

-- create a correlated subquery
SELECT department, first_name, salary, 
(SELECT max(salary) FROM employees e2 WHERE e1.department = e2.department) as max_by_dept
FROM employees e1
ORDER BY department
-- this give us the max of the department 
-- create the min function
SELECT department, first_name, salary, 
(SELECT max(salary) FROM employees e2 WHERE e1.department = e2.department) as max_by_dept,
(SELECT min(salary) FROM employees e2 WHERE e1.department = e2.department) as min_by_dept
FROM employees e1
ORDER BY department
-- use this as a subquery 
-- 3. use the subqeury 
SELECT department, first_name, salary FROM (
SELECT department, first_name, salary, 
(SELECT max(salary) FROM employees e2 WHERE e1.department = e2.department) as max_by_dept,
(SELECT min(salary) FROM employees e2 WHERE e1.department = e2.department) as min_by_dept
FROM employees e1
ORDER BY department
) as a  --give subquery name
WHERE salary in (max_by_dept, min_by_dept)

-- ADD case statement 
SELECT department, first_name, salary, --create the case for high or low 
CASE 
WHEN salary = max_by_dept THEN 'HIGHEST SALARY'
WHEN salary = min_by_dept THEN 'LOWEST SALARY'
END as salary_in_dept    -- add ending column name 
FROM (
SELECT department, first_name, salary, 
(SELECT max(salary) FROM employees e2 WHERE e1.department = e2.department) as max_by_dept,
(SELECT min(salary) FROM employees e2 WHERE e1.department = e2.department) as min_by_dept
FROM employees e1
ORDER BY department
) as a  --give subquery name
WHERE salary in (max_by_dept, min_by_dept)





SELECT department, first_name, salary, e2.salary_in_department
FROM employees e1
GROUP BY department, first_name
WHERE (SELECT salary,
CASE 
WHEN salary = MAX(salary) THEN 'HIGHEST SALARY'
WHEN salary = MIN(salary) THEN 'LOWEST SALARY'
END 
FROM employees e2 GROUP BY salary WHERE e1.department = e2.department) as salary_in_department


SELECT department, first_name, salary, 
(SELECT salary, 
CASE WHEN salary = MAX(salary) THEN 'HIGHEST SALARY'
WHEN salary = MIN(salary) THEN 'LOWEST SALARY'
END
FROM employees e2 WHERE e1.department = e2.department
GROUP BY salary) AS salary_in_department
FROM employees e1

-- 30. INNER and OUTER JOINS

SELECT * FROM employees

-- if table 1 and table 2 have common columns you can use a join to pick 

--SELECT first_name and country from employees and regions use INNER JOIN ON two tables 
SELECT first_name, country 
FROM employees INNER JOIN regions 
ON employees.region_id = regions.region_id

--query first_name, email and division make sure emails is filled in. 
SELECT first_name, email, division 
FROM employees e INNER JOIN departments d
ON e.department = d.department
WHERE email IS NOT NULL 

-- do the same as above but add country 
SELECT first_name, email, division, country
FROM employees e INNER JOIN departments d
ON e.department = d.department
INNER JOIN regions r 				-- add another region for another table 
ON e.region_id = r.region_id		-- add another ON column to specify the common column on a inner join 
WHERE email IS NOT NULL 
-- this exercise joined 3 different tables with 2 different inner joins 

------------------------------------------
-- INNER JOIN - joins on the like data, only when they are equal to one another they will join. 

--if departments table has some not from employees table, you would use an OUTER JOIN 

SELECT distinct department from employees -- 27 department

SELECT distinct department from departments  -- 24 department (camping & fishing)

-- join them by similar items 
SELECT distinct employees.department, departments.department
FROM employees INNER JOIN departments ON employees.department = departments.department
-- return 23 department 

-- there is a row in departments table that is not referenced in the employees table 

-- to expose all of the departments in the departments table you can use LEFT JOIN 
-- give me all departments in employees table regardless if they exisit in the departments table
-- more preference to the left table, same as right join, more preference to right table. 

SELECT distinct employees.department as emp_dept, departments.department depts_dept
FROM employees LEFT JOIN departments ON employees.department = departments.department
-- notice pluming is not matching, maintenance, security, camping 
-- 27 records for department because we are giving priority to employees table with the left join and whatever matches with dept_dept table will show up or will be NULL

SELECT distinct employees.department as emp_dept, departments.department depts_dept
FROM employees RIGHT JOIN departments ON employees.department = departments.department
-- 24 records because its choosing departments as the main and what ever is not on employees table will show NULL 


-- See only departments from employees table that do not exist in departments table 
SELECT distinct e.department as emp_dept, d.department  -- use distinct to find the unique values 
FROM employees e LEFT JOIN departments d ON e.department = d.department
WHERE d.department IS NULL    				-- use IS NULL to find the NULL

-- out put are the 4 departments that are in employees that are not shown in departments table. 



SELECT distinct employees.department as emp_dept, departments.department depts_dept
FROM employees FULL OUTER JOIN departments ON employees.department = departments.department
-- FULL OUTER JOIN is the department that is listed in each table but is not listed in the other table. 
-- where theres a match it shows it, but where there is no match it shows NULL. FULL OUTER JOIN EXPOSES each table 


--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
-- 31 Using UNION, UNION ALL and Except Clauses 

-- UNION stacks each table on top of each other. 
SELECT DISTINCT department 
FROM employees 
UNION 
SELECT department FROM departments 
-- this will join the two tables on top of each other STACKED data and we get 28 rows of department information. 

-- UNION ALL 
SELECT distinct department 
FROM employees --27 records
UNION ALL
SELECT department FROM departments --24 records

-- UNION ALL stacks up the data on top of each other and counts duplicates so we get 51 records. 

SELECT distinct department, first_name 
FROM employees 
UNION ALL 
SELECT department, division -- we are stacking first_name and division so it doesnt makes sense but it stacks on column type both strings. 
FROM departments 

-- EXCEPT clause takes the first result sets and removes from it all the rows found in the second result step. 
SELECT DISTINCT department 
FROM employees 
EXCEPT 
SELECT department 
FROM departments
-- all the employees table for dept that are not found in departments table. 
-- camping, maintenance, pluming, security from employees table but are not found in departments table.


----------_Generate a report, department, number of employees for department, and total count of employees, bottom total. 
SELECT department, count(*)  -- select department and count(*) all 
FROM employees 
GROUP BY department 		-- group by counting from department 
UNION ALL 					-- UNION ALL will show all the departments 
SELECT 'TOTAL', count(*)	-- SELECT 'TOTAL' will create a row and show the result 
from employees

-- 32. Cartesian Product with the CROSS JOIN 

SELECT * FROM employees, departments --if you dont specify a join it will give you all the possible options table rows * table 2 rows 
-- employees name is being repeated. 

SELECT * FROM departments -- 24 records, employees has 1000 records. if you do both as above you will show every single combo of rows will be returned (24K) options


SELECT COUNT(*) FROM (
SELECT * 
FROM employees a, employees b --two sources now because of alias but we will get 1M rows. 1K x 1K 
) sub 
--- CARTENSIA PRODUCT. 

-- When you need a Cartensia Product you can do a Cross Join 
SELECT * 
FROM employees e CROSS JOIN departments d
-- each one of the records is having a added departments table on the right of the table on department d table. 

---33

-- EXERCISES 
-- create a query for the first_name, dpartment, hire_date, country  pick only the first hire and last hire for department. 
SELECT * FROM employees
SELECT * FROM regions

SELECT first_name, department, hire_date, country
FROM employees e INNER JOIN regions r    -- Inner Join 
ON e.region_id = r.region_id
WHERE hire_date = (SELECT MIN(hire_date) FROM employees e2) --WHERE hire_date is Min 
UNION ALL 								-- Use UNION ALL to stack responses 
SELECT first_name, department, hire_date, country
FROM employees e INNER JOIN regions r    -- Inner Join 
ON e.region_id = r.region_id
WHERE hire_date = (SELECT MAX(hire_date) FROM employees e2) --WHERE hire_date is MAX
ORDER BY department 

-- IF you wanted to see only 1 
(SELECT first_name, department, hire_date, country
FROM employees e INNER JOIN regions r    -- Inner Join 
ON e.region_id = r.region_id
WHERE hire_date = (SELECT MIN(hire_date) FROM employees e2) --WHERE hire_date is Min 
LIMIT 1)																				-- Use Paranthese () to allow LIMIT 1 before the UNION ALL because of Union limitations
UNION ALL 								-- Use UNION ALL to stack responses 
SELECT first_name, department, hire_date, country
FROM employees e INNER JOIN regions r    -- Inner Join 
ON e.region_id = r.region_id
WHERE hire_date = (SELECT MAX(hire_date) FROM employees e2) --WHERE hire_date is MAX
ORDER BY department 

-----------EXERCISE 
-- report on spending for salary budget has flucated for every 90 days 
-- Use a correlated subquery 
-- use data artithemtic 
SELECT first_name, hire_date, hire_date + 90 
FROM employees
ORDER BY hire_date

--- use a query like this example 
SELECT first_name, hire_date, hire_date + 90 
FROM employees
WHERE hire_date BETWEEN hire_date AND hire_date -90 

-- start EXERCISE 
-- show how salary spending budget has flucated based on hire_dates 
-- hire_date, salary, and spending column 

SELECT hire_date, salary, 
(SELECT SUM(salary) FROM employees e2
WHERE e2.hire_date BETWEEN e2.hire_date - 90 AND e.hire_date) AS spending_pattern
-- where correlated hire_date starts at hire_date -90 for 90 day period in relation to e.hire_date
FROM employees e 
ORDER BY hire_date

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
-- 34. Creating Views vs INLINE views 

SELECT * FROM employees

SELECT * FROM departments 

SELECT * FROM regions

-- Create a query for all this information 
SELECT first_name, email, e.department, salary, division
FROM employees e, departments d, regions r
WHERE e.department = d.department 
AND e.region_id = r.region_id 

-- to create a view add CREATE View and give alias, usually the alias starts with v because its a view. 
CREATE VIEW v_employee_info as
SELECT first_name, email, e.department, salary, division
FROM employees e, departments d, regions r
WHERE e.department = d.department 
AND e.region_id = r.region_id 


SELECT * FROM v_employee_info 
-- we have created a view and it shows us the data, you cannot insert data into it or delete data from it

-- IN LINE VIEWS 
SELECT * FROM (select * from departments) as b

-- In Line view is a subquery 
								













