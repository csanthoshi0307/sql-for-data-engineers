### Subqueries & Correlated Subqueries – Theory & Interview Notes


## What is a Subquery?

A subquery is a SQL query nested inside another query.
It is used to return data that the outer (main) query depends on.

Characteristics

Enclosed in parentheses ( )
- Can appear in:
- SELECT
- FROM
- WHERE
- HAVING

Executes before the outer query (for non-correlated subqueries)

## Types of Subqueries
# Non-Correlated Subquery

Runs once

Independent of the outer query

Result is reused

# Correlated Subquery
 One-Line Answer
```
A correlated subquery is a subquery that depends on the outer query, executes once per row, and is commonly used for row-level comparisons, though JOINs are preferred for better performance.
```
- A correlated subquery:
- Refers to a column from the outer query
- Executes once per row
- Cannot be executed independently

# Why Correlated Subqueries Run Row-by-Row
The subquery depends on values from the outer query.
```
WHERE e2.dept_id = e.dept_id

```

# Correlated Subqueries vs JOIN + GROUP BY
Correlated Subquery (Slower)
```
SELECT e.emp_name
FROM Employees e
WHERE e.salary >
(
    SELECT AVG(e2.salary)
    FROM Employees e2
    WHERE e2.dept_id = e.dept_id
);

```

JOIN + GROUP BY (Faster)
```
SELECT e.emp_name
FROM Employees e
JOIN (
    SELECT dept_id, AVG(salary) avg_sal
    FROM Employees
    GROUP BY dept_id
) d ON e.dept_id = d.dept_id
WHERE e.salary > d.avg_sal;
```
Why EXISTS is Faster

Stops searching as soon as a match is found

Does not return full result sets

Better for large tables

# When to Use Correlated Subqueries
Correlated subqueries are useful when:

Logic depends on row-specific comparison

Each row needs its own calculated condition

Using EXISTS / NOT EXISTS

## Key Points
- Correlated subqueries run row-by-row
- They are slower than non-correlated subqueries
- Often replaced by JOIN + GROUP BY for performance
- EXISTS is usually faster than IN
- Best used when logic depends on row-specific comparison
- Query optimizer may rewrite correlated subqueries internally
- Overuse can cause performance issues on large tables

