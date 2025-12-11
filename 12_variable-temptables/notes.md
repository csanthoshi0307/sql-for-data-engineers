### 📘 SQL Server – Variables & Temporary Tables (With Examples)

This document explains how SQL variables, temporary tables, and window functions work in SQL Server, using 10 practical example queries.
These examples help developers understand dynamic filtering, intermediate data storage, windowed calculations, and modular query design.

### 🧩 1. SQL Variables – What & Why?

A variable in SQL Server is a named memory location used to store a single value temporarily during query execution.

✔ Uses of Variables

Store values for dynamic filtering

Store aggregated values (SUM, AVG, COUNT)

Hold date ranges

Improve readability and maintainability

Avoid repeating hard-coded values

✔ How to Declare and Assign Variables
DECLARE @variableName DataType;
SET @variableName = value;


Or initialize directly:

DECLARE @dept VARCHAR(50) = 'IT';

### 🧩 2. Temporary Tables – What & Why?

A temporary table is a table stored in the SQL Server tempdb database.

✔ Types of Temporary Tables
Type	Example	Scope
Local temporary table	#TempTable	Visible only to current session
Global temporary table	##TempTable	Visible to all sessions until last session ends
✔ Why Use Temporary Tables?

Store intermediate results

Reuse result sets

Perform debugging

Break complex queries into readable parts

Improve performance in some workloads

✔ Syntax
CREATE TABLE #TempTable (...);
INSERT INTO #TempTable SELECT ...
SELECT * FROM #TempTable;
DROP TABLE #TempTable;

### 🧩 3. Window Functions (OVER Clause)

A window function performs calculations across a set of rows related to the current row, without grouping them.

Common Uses:

Moving averages

Ranking (ROW_NUMBER, RANK, DENSE_RANK)

Running totals

Partition-based analysis

---------------------------------------------------------
### ✅ Theory Explanation for Each Example
---------------------------------------------------------
### 1. Using a Variable to Filter Data
```
DECLARE @dept VARCHAR(50) = 'IT';
SELECT * FROM employees WHERE department = @dept;
```
Theory

The variable @dept stores a department name.

SQL uses it in the WHERE clause to filter rows dynamically.

Useful for parameterized queries and reusable scripts.

### 2. Using a Temporary Table to Store Filtered Records
```
CREATE TABLE #HighSalaryEmployees (...);
INSERT INTO #HighSalaryEmployees
SELECT ...
FROM employees
WHERE salary > 70000;
```
Theory

A temporary table #HighSalaryEmployees stores employees with salary > 70000.

This allows reusing filtered data for multiple queries.

Temp tables exist only for the active session.

Window Function: Moving Average
```
SELECT department, salary,
AVG(salary) OVER (PARTITION BY department ORDER BY id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_salary
FROM employees;
```
Theory

PARTITION BY separates data by department.

ORDER BY ensures calculations follow row order.

ROWS BETWEEN 2 PRECEDING AND CURRENT ROW calculates rolling average over last 3 rows.

### 3. Using a Variable to Store Aggregate Value
```
DECLARE @totalSalary DECIMAL(10, 2);
SET @totalSalary = (SELECT SUM(salary) FROM employees WHERE department = 'HR');
```
Theory

The query aggregates salary values using SUM().

The result is stored in a variable.

Useful for reporting, condition checks, or further calculations.

### 4. Temporary Table for Department-Wise Average Salaries
```
CREATE TABLE #DeptAvgSalaries (...);
INSERT INTO #DeptAvgSalaries
SELECT department, AVG(salary)
FROM employees
GROUP BY department;
```
Theory

Stores a summary table of departments and their average salaries.

Can be used in joins, reporting, or additional transformations.

### 5. Using a Variable as a Dynamic Salary Filter
```
DECLARE @salaryThreshold DECIMAL(10, 2) = 65000;
SELECT * FROM employees WHERE salary > @salaryThreshold;
```
Theory

Threshold stored in a variable makes query flexible and reusable.

Good for parameterized filters in stored procedures.

### 6. Temporary Table for Regional Sales Data
```
CREATE TABLE #RegionSales (...);
INSERT INTO #RegionSales
SELECT ...
FROM sales
WHERE region = 'North';
```
Theory

Temporary table stores filtered sales data.

Makes complex analysis easier (multiple joins, aggregations).

### 7. Variable to Filter Sales by Salesperson
```
DECLARE @salespersonName VARCHAR(50) = 'Alice';
SELECT * FROM sales WHERE salesperson = @salespersonName;
```
Theory

Demonstrates using variables with string data.

Useful in dynamic reports and dashboards.

### 8. Temporary Table for Region-Wise Total Sales
```
CREATE TABLE #TotalSalesPerRegion (...);
INSERT INTO #TotalSalesPerRegion
SELECT region, SUM(amount)
FROM sales
GROUP BY region;
```
Theory

Stores pre-aggregated sales totals.

Helpful for performance when reused multiple times.

### 9. Using Variables for Date Range Filtering
```
DECLARE @startDate DATE = '2024-01-15';
DECLARE @endDate DATE = '2024-01-31';
SELECT * FROM sales WHERE sale_date BETWEEN @startDate AND @endDate;
```
Theory

Date range variables allow dynamic reporting.

Useful in dashboards and monthly/quarterly reports.

### 10. Temporary Table for Top N (Top 3) Sales per Salesperson
```
INSERT INTO #TopSalesPerSalesperson
SELECT salesperson, amount
FROM (
    SELECT salesperson, amount,
           ROW_NUMBER() OVER (PARTITION BY salesperson ORDER BY amount DESC) AS sales_rank
    FROM sales
) AS ranked_sales
WHERE sales_rank <= 3;
```
Theory

Uses ROW_NUMBER() window function to rank sales.

PARTITION BY salesperson ensures ranking resets per salesperson.

Temp table stores the top 3 sales amounts for better readability and reuse.

### 🎯 Summary Table of Concepts Used
```
Example	    Concept	                    Description
1	        Variable filter	            Dynamic WHERE filtering
2	        Temp table	                Store intermediate rows
3	        Variable with SUM	        Aggregation into variable
4	        Temp table with GROUP BY	Summary storage
5	        Variable threshold	        Reusable numeric filter
6	        Temp table	                Regional data extraction
7	        Variable filter	            Person-based filtering
8	        Temp table	                Region total sales
9	        Variables for dates 	    Dynamic date range
10	        Window + temp table	        Ranking + top N
```