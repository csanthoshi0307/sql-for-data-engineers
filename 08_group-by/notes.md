### 📘 Understanding GROUP BY in SQL

The GROUP BY clause in SQL is used to organize rows that have the same values into groups.
This is especially useful when combined with aggregate functions such as:

COUNT() → Counts rows

SUM() → Adds numeric values

AVG() → Calculates average

MIN() → Finds minimum value

MAX() → Finds maximum value

The GROUP BY clause tells SQL how to group rows, and then aggregates are applied on each group.

### Example Employee Table:
```
EmployeeID	Department	Salary
1	        HR	        50000
2	        IT	        60000
3	        HR	        55000
4	        IT	        70000
5	Finance	80000
```
### 📌 How GROUP BY Works

When SQL sees a query like:
```
SELECT Department, COUNT(*)
FROM Employees
GROUP BY Department;
```


It performs three steps:

Scan the rows in the table

Group rows based on the value in Department

Apply the aggregate function (COUNT(*)) to each group

Result → One output row per department.

### 📚 Query Explanations
Example 1 — Count employees in each department
```
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department;
```

Explanation:
Groups employees by department and counts how many employees are in each.

### Example 2 — Average salary per department
```
SELECT Department, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department;
```

Explanation:
Calculates the average salary of employees within each department.

### Example 3 — Highest salary per department
```
SELECT Department, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY Department;
```

Explanation:
Returns the maximum salary for each department.

### Example 4 — Total salary cost per department
```
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department;
```

Explanation:
Computes the sum of salaries for each department—useful for budgeting.

### Example 5 — Minimum salary per department
```
SELECT Department, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY Department;
```

Explanation:
Finds the lowest salary within each department.

### Example 6 — Count employees earning more than 60,000 per department
```
SELECT Department, COUNT(*) AS HighEarnerCount
FROM Employees
WHERE Salary > 60000
GROUP BY Department;
```

Explanation:
WHERE filters rows before grouping. Only employees with salary > 60000 are grouped and counted.

### Example 7 — Number of employees and average salary per department
```
SELECT Department, COUNT(*) AS EmployeeCount, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department;
```

Explanation:
Uses multiple aggregate functions on the same group.

### Example 8 — Count employees per department ordered alphabetically
```
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department
ORDER BY Department;
```

Explanation:
ORDER BY sorts the final grouped results (not the table rows).

### Example 9 — Total salary expense ordered by highest to lowest
```
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department
ORDER BY TotalSalary DESC;
```

Explanation:
Sorts departments by total salary expenditure in descending order.

### Example 10 — Count employees earning less than 70,000 per department
```
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
WHERE Salary < 70000
GROUP BY Department;
```

Explanation:
Again, WHERE filters rows before grouping, then counts per department.

### 🔍 Key Concepts Summary
✔ GROUP BY

Used to split data into groups based on one or more columns.

✔ Aggregate Functions

Operate on each group of rows:

COUNT(), SUM(), AVG(), MIN(), MAX()

✔ WHERE

Filters rows before grouping (affects which rows enter groups).

✔ ORDER BY

Sorts the final output
(after grouping and aggregation are complete).

### 📝 Tip for Real Projects

When using GROUP BY, every selected column must either:

be part of the GROUP BY clause, or

be inside an aggregate function

Example ✔

```
SELECT Department, SUM(Salary)
FROM Employees
GROUP BY Department;
```

Example ❌ (invalid SQL)
```
SELECT Department, Salary
FROM Employees
GROUP BY Department;
```