-- GROUP BY clause is used to arrange identical data into groups.
-- It is often used with aggregate functions (COUNT, MAX, MIN, SUM, AVG)
-- to perform operations on each group of data.
-- Example table: Employees
-- Sample data for Employees table
-- | EmployeeID | Department | Salary |
-- |------------|------------|--------|
-- | 1          | HR         | 50000  |
-- | 2          | IT         | 60000  |
-- | 3          | HR         | 55000  |
-- | 4          | IT         | 70000  |
-- | 5          | Finance    | 80000  |
--  Count the number of employees in each department
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department;
--  Find the average salary of each department
SELECT Department, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department;
-- Find the maximum salary of each department
SELECT Department, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY Department;
--  Find the total salary expenses for each department
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department;
--  Find the minimum salary of each department
SELECT Department, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY Department;
--  Count the number of employees with salary greater than 60000 in each departments
SELECT Department, COUNT(*) AS HighEarnerCount
FROM Employees
WHERE Salary > 60000
GROUP BY Department;

-- Find the total number of employees and average salary in each department
SELECT Department, COUNT(*) AS EmployeeCount, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department;
-- Find the number of employees in each department ordered by department name
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department
ORDER BY Department;
-- Find the total salary expenditure for each department ordered by total salary descending
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department
ORDER BY TotalSalary DESC;

-- Find the number of employees in each department with salary less than 70000
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
WHERE Salary < 70000
GROUP BY Department;
-- END OF Examples