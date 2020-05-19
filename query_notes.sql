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


SELECT *
FROM employees
WHERE department = 'Sports' AND 
