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
-- Example 1: Count the number of employees in each department
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department;
-- Example 2: Find the average salary in each department
SELECT Department, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department;
-- Example 3: Find the maximum salary in each department
SELECT Department, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY Department;
-- Example 4: Find the total salary expenditure for each department
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department;
-- Example 5: Find the minimum salary in each department
SELECT Department, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY Department;
-- Example 6: Count the number of employees with salary greater than 60000 in each department
SELECT Department, COUNT(*) AS HighEarnerCount
FROM Employees
WHERE Salary > 60000
GROUP BY Department;

-- Example 7: Find the total number of employees and average salary in each department
SELECT Department, COUNT(*) AS EmployeeCount, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department;
-- Example 8: Find the number of employees in each department ordered by department name
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department
ORDER BY Department;
-- Example 9: Find the total salary expenditure for each department ordered by total salary descending
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department
ORDER BY TotalSalary DESC;
-- while the WHERE clause is used to filter rows before grouping.
-- The ORDER BY clause is used to sort the result set.

-- Example 10: Find the number of employees in each department with salary less than 70000
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
WHERE Salary < 70000
GROUP BY Department;
-- END OF Examples