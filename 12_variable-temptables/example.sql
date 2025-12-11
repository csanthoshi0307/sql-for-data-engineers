--  Variables, Temporary tables for SQL Server examples with sample data.
-- 10 queries demonstrating the use of variables and temporary tables.
-- Sample table creation and data insertion for demonstration
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);
INSERT INTO employees (id, name, department, salary) VALUES
(1, 'John Doe', 'HR', 60000.00),
(2, 'Jane Smith', 'IT', 75000.00),
(3, 'Mike Johnson', 'Finance', 80000.00),
(4, 'Emily Davis', 'IT', 72000.00),
(5, 'William Brown', 'HR', 58000.00);
-- 1. Using a variable to store a department name and filter employees by that department
DECLARE @dept VARCHAR(50) = 'IT';
SELECT * FROM employees WHERE department = @dept;
-- 2. Using a temporary table to store high salary employees and then querying from it
CREATE TABLE #HighSalaryEmployees (
    id INT,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);
INSERT INTO #HighSalaryEmployees (id, name, department, salary)
SELECT id, name, department, salary
FROM employees
WHERE salary > 70000.00;
SELECT * FROM #HighSalaryEmployees;
SELECT  department,  salary,  AVG(salary) OVER (PARTITION BY department ORDER BY id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_salary    
FROM  employees;
Select  salesperson,
    region,
    amount,
    sale_date,
    AVG(amount) OVER (PARTITION BY salesperson ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_amount    
FROM
    sales;
-- Clean up temporary table
DROP TABLE #HighSalaryEmployees;
-- 3. Using a variable to calculate total salary expenditure for a specific department
DECLARE @totalSalary DECIMAL(10, 2);
SET @totalSalary = (SELECT SUM(salary) FROM employees WHERE department = 'HR');
SELECT @totalSalary AS TotalHRSalaries;
-- 4. Using a temporary table to store department-wise average salaries
CREATE TABLE #DeptAvgSalaries (
    department VARCHAR(50),
    avg_salary DECIMAL(10, 2)
);  
INSERT INTO #DeptAvgSalaries (department, avg_salary)
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;
SELECT * FROM #DeptAvgSalaries;
-- Clean up temporary table
DROP TABLE #DeptAvgSalaries;
-- 5. Using a variable to set a salary threshold and retrieve employees above that threshold
DECLARE @salaryThreshold DECIMAL(10, 2) = 65000.00;
SELECT * FROM employees WHERE salary > @salaryThreshold;
-- Clean up sample table
DROP TABLE employees;
-- Sample table creation and data insertion for demonstration
CREATE TABLE sales (
    id INT PRIMARY KEY,
    salesperson VARCHAR(50),
    region VARCHAR(50),
    amount DECIMAL(10, 2),
    sale_date DATE
);
INSERT INTO sales (id, salesperson, region, amount, sale_date) VALUES
(1, 'Alice', 'North', 500.00, '2024-01-10'),
(2, 'Bob', 'South', 300.00, '2024-01-15'),
(3, 'Alice', 'North', 700.00, '2024-01-20'),
(4, 'Charlie', 'East', 400.00, '2024-01-25'),
(5, 'Bob', 'South', 600.00, '2024-01-30'),
(6, 'Alice', 'North', 800.00, '2024-02-05'),
(7, 'Charlie', 'East', 200.00, '2024-02-10');
-- Clean up sample table
DROP TABLE sales;
-- 6. Using a temporary table to store sales data for a specific region
CREATE TABLE #RegionSales (
    id INT,
    salesperson VARCHAR(50),
    region VARCHAR(50),
    amount DECIMAL(10, 2),
    sale_date DATE
);
INSERT INTO #RegionSales (id, salesperson, region, amount, sale_date)
SELECT id, salesperson, region, amount, sale_date
FROM sales
WHERE region = 'North';
SELECT * FROM #RegionSales;
-- Clean up temporary table
DROP TABLE #RegionSales;
-- 7. Using a variable to store a salesperson's name and retrieve their sales records
DECLARE @salespersonName VARCHAR(50) = 'Alice';
SELECT * FROM sales WHERE salesperson = @salespersonName;
-- 8. Using a temporary table to calculate total sales per region
CREATE TABLE #TotalSalesPerRegion (
    region VARCHAR(50),
    total_sales DECIMAL(10, 2)
);
INSERT INTO #TotalSalesPerRegion (region, total_sales)
SELECT region, SUM(amount) AS total_sales
FROM sales
GROUP BY region;
SELECT * FROM #TotalSalesPerRegion;
-- Clean up temporary table
DROP TABLE #TotalSalesPerRegion;
-- 9. Using a variable to set a date range and retrieve sales within that range
DECLARE @startDate DATE = '2024-01-15';
DECLARE @endDate DATE = '2024-01-31';
SELECT * FROM sales WHERE sale_date BETWEEN @startDate AND @endDate;
-- Clean up sample table
DROP TABLE sales;
-- 10. Using a temporary table to store top 3 sales amounts per salesperson
CREATE TABLE #TopSalesPerSalesperson (
    salesperson VARCHAR(50),
    amount DECIMAL(10, 2)
);
INSERT INTO #TopSalesPerSalesperson (salesperson, amount)
SELECT salesperson, amount
FROM (
    SELECT salesperson, amount,
           ROW_NUMBER() OVER (PARTITION BY salesperson ORDER BY amount DESC) AS sales_rank
    FROM sales
) AS ranked_sales
WHERE sales_rank <= 3;
SELECT * FROM #TopSalesPerSalesperson;
-- Clean up temporary table
DROP TABLE #TopSalesPerSalesperson;
-- Clean up sample table
DROP TABLE sales;

