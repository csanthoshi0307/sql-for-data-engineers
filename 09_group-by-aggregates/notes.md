### 📘 SQL GROUP BY — Few more Examples

The GROUP BY clause is used to group table rows that share the same values in particular columns.
It is typically combined with aggregate functions like :

COUNT(),
SUM(),
AVG(),
MIN(),
MAX()

This allows perform basic calculations on each group of data.

### 📌 Example Table (Employees)

```
EmployeeID	Department	Salary
1	        HR	        50000
2	        IT	        60000
3	        HR	        55000
4	        IT	        70000
5	        Finance	    80000
```
🧩 Extended GROUP BY Examples
### 1️⃣ MAX and MIN Salary of Each Department
```
SELECT Department, MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY Department;
```

Explanation:
Returns the highest and lowest salary for each department.

### 2️⃣ Combined Aggregations per Department
```
SELECT Department, COUNT(*) AS EmployeeCount, AVG(Salary) AS AverageSalary,
MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY Department;
```

Explanation:
Multiple aggregate functions applied on each department group.

### 3️⃣ Employee Count per Department (DESC - Descending Order)
```
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department
ORDER BY EmployeeCount DESC;
```

Explanation:
Sorts departments by number of employees, highest first.

### 4️⃣ Average Salary per Department (ASC - Ascending Order)
```
SELECT Department, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department
ORDER BY AverageSalary ASC;
```
Explanation:
Sorts departments based on average salary, lowest first.

### 5️⃣ Total Salary Expenditure per Department (Ascending Order)
```
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department
ORDER BY TotalSalary ASC;
```

Explanation:
Calculates sum of all salaries in each department.

### 6️⃣ Count Employees With Salary > 50,000 per Department
```
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
WHERE Salary > 50000
GROUP BY Department
ORDER BY Department;
```

Explanation:
WHERE filters the rows before grouping.

### 🎯 Few more additional advanced GROUP BY Examples (Extended part)

Below are additional practical examples to make your GitHub documentation richer.

### 7️⃣ Grouping by Multiple Columns
```
SELECT Department, Salary, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department, Salary;
```

Explanation:
Groups by both department and salary → useful to find duplicates or salary distribution per department.

### 8️⃣ Using GROUP BY with HAVING (Filter Groups)
```
SELECT Department, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 60000;
```

Explanation:
HAVING filters groups after the aggregation.
Returns only departments where the average salary > 60,000.

### 9️⃣ Departments with More Than 1 Employee
```
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department
HAVING COUNT(*) > 1;
```

### 🔟 Total Salary per Department, but Show Only Departments Above 100,000
```
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department
HAVING SUM(Salary) > 100000;
```
### 1️⃣1️⃣ Percentage Contribution of Each Department to Company Salary
```
SELECT Department,
       SUM(Salary) AS TotalSalary,
       (SUM(Salary) * 100.0 / (SELECT SUM(Salary) FROM Employees)) AS SalaryPercentage
FROM Employees
GROUP BY Department;
```

Explanation:
Shows how much each department contributes to overall salary cost.

### 1️⃣2️⃣ Finding Departments Where Highest Salary > 70,000
```
SELECT Department, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY Department
HAVING MAX(Salary) > 70000;
```
### 1️⃣3️⃣ Grouping with Aliases for Better Readability
```
SELECT e.Department, COUNT(*) AS EmployeeCount
FROM Employees AS e
GROUP BY e.Department;
```
### 1️⃣4️⃣ Counting Unique Salaries per Department
```
SELECT Department, COUNT(DISTINCT Salary) AS UniqueSalaryCount
FROM Employees
GROUP BY Department;
```
### 1️⃣5️⃣ Find Departments Where Minimum Salary is Below 55,000
```
SELECT Department, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY Department
HAVING MIN(Salary) < 55000;
```
### 📝 Key Rules Summary for README
✔ Columns in SELECT must be:

part of GROUP BY, or

used inside an aggregate function

✔ WHERE filters rows before grouping
✔ HAVING filters groups after aggregation
✔ ORDER BY sorts the final results