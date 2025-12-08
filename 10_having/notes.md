### 🔍 SQL HAVING Clause 

The HAVING clause in SQL is used to filter groups created by GROUP BY.
It works similarly to the WHERE clause, but WHERE filters rows before grouping, while HAVING filters after grouping.

### 🧠 Why HAVING is important in aggregate functions?

When we use aggregate functions (SUM, COUNT, AVG, MAX, MIN), we cannot filter using conditions in WHERE.

SQL processes queries in this order:

FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY



WHERE cannot see aggregated data.

HAVING can see aggregated results and filter on them.

### ✔️ Basic Syntax
```
SELECT column1, aggregate_function(column2)
FROM table_name
GROUP BY column1
HAVING condition_on_aggregated_data;
```

### 📘 Example 1: Find departments having more than 5 employees
```
SELECT department, COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;
```

👉 HAVING COUNT(*) > 5 filters groups after grouping by department.

### 📘 Example 2: Show products whose total sales exceed 10,000
```
SELECT product_id, SUM(amount) AS total_sales
FROM sales
GROUP BY product_id
HAVING SUM(amount) > 10000;
```

### 📘 Example 3: Using HAVING with multiple conditions
```
SELECT city, AVG(salary) AS avg_salary, MAX(salary) AS highest_salary
FROM employees
GROUP BY city
HAVING AVG(salary) > 50000 AND MAX(salary) < 150000;
```

### 🆚 WHERE vs HAVING (Differences)
```
Feature	                        WHERE	            HAVING
Filters	                        Before grouping	    After grouping
Can use aggregate functions?	❌ No	           ✔️ Yes
Used with	                    Any SELECT	        Requires GROUP BY (usually)
Applies to	                    Individual rows	    Aggregated groups
```
### ⚙️ Query Processing Order (Important!)
1. FROM  
2. WHERE  
3. GROUP BY  
4. HAVING  
5. SELECT  
6. ORDER BY  


This explains why HAVING can use aggregated values.

### 🧩 Example: Using WHERE + GROUP BY + HAVING together
```
SELECT department, SUM(salary) AS total_salary
FROM employees
WHERE active = 1
GROUP BY department
HAVING SUM(salary) > 500000;
```

WHERE active = 1 → filters rows first

GROUP BY department → groups remaining rows

HAVING SUM(salary) > 500000 → filters aggregated groups

### 💡 Best Practices
✔️ 1. Use WHERE whenever possible

It reduces data early → better performance.

WHERE sale_date > '2024-01-01'

✔️ 2. Use HAVING only for aggregates
HAVING COUNT(*) > 10        -- Good
WHERE COUNT(*) > 10         -- ❌ Invalid

✔️ 3. Prefer naming aggregates using aliases
```
SELECT product_id, SUM(qty) AS total_qty
FROM orders
GROUP BY product_id
HAVING total_qty > 100;     -- ❌ Not supported in all SQL engines
```

Better:

HAVING SUM(qty) > 100;

### 📦 Summary

HAVING filters aggregated data after grouping.

Used with GROUP BY + aggregate functions.

WHERE filters rows; HAVING filters groups.

Essential for reporting, analytics, dashboards, and BI queries.