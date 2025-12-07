--- ----------------------------------------------------------------------------------
--  Find the maximum and minimum salary in each department
SELECT Department, MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY Department;

--  Find the total number of employees, average salary, maximum salary, and minimum salary in each department
SELECT Department, COUNT(*) AS EmployeeCount, AVG(Salary) AS AverageSalary, MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY Department;

--  Find the number of employees in each department and order by employee count descending
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department
ORDER BY EmployeeCount DESC;

-- Find the average salary in each department and order by average salary ascending
SELECT Department, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department
ORDER BY AverageSalary ASC;

--  Find the total salary expenditure for each department and order by total salary ascending
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department
ORDER BY TotalSalary ASC;

--  Find the number of employees in each department with salary greater than 50000 and order by department name
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
WHERE Salary > 50000
GROUP BY Department
ORDER BY Department;

-- End of examples for GROUP BY clause
