### What is a CTE (Common Table Expression)?
A CTE is a temporary named result set defined within a SQL statement using the WITH keyword.

- It exists only during the execution of a single query
- It is not stored in the database
- It behaves like a temporary view

# Syntax (CTE)
```
WITH CTE_Name AS (
    SELECT column1, column2
    FROM table_name
)
SELECT * FROM CTE_Name;
```
## Why CTE Was Introduced (Problem It Solves)
# Before CTEs:
- Queries had deep nested subqueries
- Same logic repeated multiple times
- Queries were hard to read and maintain

# CTEs solve:
✔ Readability
✔ Reusability inside a query
✔ Complex logic structuring
✔ Recursive data traversal

## Types of CTE
🔹 1. Simple CTE (Non-Recursive)
Most commonly used type.
```
WITH SalesCTE AS (
    SELECT CustomerId, SUM(Amount) AS Total
    FROM Sales
    GROUP BY CustomerId
)
SELECT * FROM SalesCTE;
```
Used for:
- Aggregation
- Filtering
- Joins
- Simplifying complex queries

🔹 2. Multiple CTEs
More than one CTE in a single query.
```
WITH A AS (
    SELECT * FROM Orders
),
B AS (
    SELECT * FROM Customers
)
SELECT *
FROM A
JOIN B ON A.CustomerId = B.CustomerId;
```

Used when:
- Data needs step-by-step processing
- Business logic must be broken into stages

🔹 3. Recursive CTE
CTE that references itself.
```
WITH EmployeeCTE AS (
    SELECT Id, ManagerId FROM Employees WHERE ManagerId IS NULL
    UNION ALL
    SELECT e.Id, e.ManagerId
    FROM Employees e
    JOIN EmployeeCTE ec ON e.ManagerId = ec.Id
)
SELECT * FROM EmployeeCTE;
```
Used for:
- Hierarchies
- Trees
- Parent-child relationships
- Sequence generation

🔹 4. CTE with Window Functions
```
WITH RankedCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY CustomerId ORDER BY OrderDate DESC) AS rn
    FROM Orders
)
SELECT * FROM RankedCTE WHERE rn = 1;
```
Used for:
- Deduplication
- Top-N per group
- Latest record logic

4️⃣ Components of a Recursive CTE

A recursive CTE has two mandatory parts:

1️⃣ Anchor Member
- Base result
- Executes first
```
SELECT Id, ManagerId FROM Employees WHERE ManagerId IS NULL
```
2️⃣ Recursive Member
References the CTE itself
```
SELECT e.Id, e.ManagerId
FROM Employees e
JOIN EmployeeCTE ec ON e.ManagerId = ec.Id
```
5️⃣ Importance of CTE (Why It Matters)
✔ Improves Query Readability
- Logical flow
- No deeply nested queries
- Simplifies Maintenance
- Change logic in one place
- Less error-prone
- Supports Recursion
- Only clean way to handle hierarchical data in SQL
- Reusable Logic (Within Query)
- Same result set used multiple times
- Works with Analytical Functions
- Clean separation of calculation and filtering

6️⃣ Usage Benefits of CTE
```
Benefit	        Explanation
Readability 	Query reads top-down
Modularity	    Logic split into blocks
Debugging	    Easy to test parts
Recursion	    Handles trees & hierarchies
Performance	    Optimizer treats like inline view
Cleaner joins	Pre-processed datasets
```
⚠ Note: CTE does not automatically improve performance. It improves clarity.

7️⃣ CTE vs Temp Table vs Subquery (Interview Favorite)
```
Feature	        CTE	            Temp Table	        Subquery
Scope	        Single query	Session / batch	    Inline
Reusable	    Within query	Yes	                No
Stored	        No	            Yes (tempdb)	    No
Indexable	    No	            Yes	                No
Recursive	    Yes	            No	                No
Performance	    Logical	        Physical	        Logical
```

8️⃣ Common Mistakes with CTE
❌ Assuming CTE improves performance
❌ Forgetting recursion limit
❌ Using CTE for large reusable datasets
❌ Overusing recursive CTEs for deep trees

## 9️⃣ Interview Questions with Answers
# Q1: What is a CTE in SQL?
Answer:
A CTE is a temporary named result set defined using the WITH clause that exists only for the duration of a single SQL statement. It improves readability and supports recursion.

# Q2: Is CTE stored in database?
Answer:
No. CTE is not stored physically. It is a logical construct evaluated during query execution.

# Q3: Can we use CTE multiple times in a query?
Answer:
Yes, a CTE can be referenced multiple times within the same query.

# Q4: Does CTE improve performance?
Answer:
Not directly. CTE mainly improves readability and maintainability. The SQL optimizer usually treats it like an inline view.

# Q5: Difference between CTE and Temp Table?
Answer:
CTE is temporary and logical, scoped to a single query. Temp tables are physically created in tempdb and can be indexed and reused across multiple statements.

# Q6: What is a Recursive CTE?
Answer:
A recursive CTE is a CTE that references itself and is used to process hierarchical or tree-structured data like employee-manager relationships.

# Q7: What is MAXRECURSION?
Answer:
In SQL Server, recursion depth is limited to 100 by default. OPTION (MAXRECURSION n) controls this limit.

# Q8: Can CTE be updated or deleted?
Answer:
Yes, if the CTE references a single base table, you can perform UPDATE, DELETE, or INSERT through it.

# Q9: When should you avoid CTE?

Answer:
When:
- Data needs reuse across multiple queries
- Indexing is required
- Processing large datasets repeatedly

# Q10: Real-world use case of CTE?
Answer:
- Sales aggregation
- Financial reports
- Employee hierarchies
- POS transaction grouping
- Latest record per customer

## 🔟 One-Line Interview Summary
“CTE is a temporary, readable, reusable query structure that simplifies complex SQL logic and enables recursion without storing data physically.”
