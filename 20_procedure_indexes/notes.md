### 📘 Database Stored Procedures, Loops & Indexing – Theory & Interview Guide

This document explains core database concepts across SQL Server, MySQL, and PostgreSQL, focusing on stored procedures, control flow, and indexing, along with frequently asked interview questions.

## 1️⃣ Stored Procedures – Theory
What is a Stored Procedure?
A stored procedure is a precompiled database object that contains SQL logic and can accept input/output parameters. It is executed on the database server.

Why Use Stored Procedures?
- Improves performance (execution plan reuse)
- Centralizes business logic
- Enhances security (controlled access)
- Reduces network traffic
- Improves maintainability

# Stored Procedure Concepts Across Databases
```
| Feature           | SQL Server | MySQL   | PostgreSQL |
| ----------------- | ---------- | ------- | ---------- |
| Compiled          | Yes        | Yes     | Yes        |
| Input Parameters  | Yes        | Yes     | Yes        |
| Output Parameters | Yes        | Yes     | Yes        |
| Return Value      | Yes        | Limited | Via OUT    |
| Language          | T-SQL      | SQL/PSM | PL/pgSQL   |
```
# Conditional Logic in Stored Procedures

Stored procedures support:
- IF / ELSE
- ELSE IF / ELSEIF / ELSIF (syntax varies)
- CASE expressions

Used for:
- Discount calculation
- Tax calculation
- Status derivation
- Business rule enforcement
- Variables in Stored Procedures

Variables are used to:
- Hold intermediate results
- Control execution flow
- Store calculation values
- Scope is usually procedure-level, and syntax differs slightly between databases.

## 2️⃣ Looping Constructs – Theory
Why Loops Are Used?

Loops are used when:
- Processing rows iteratively
- Batch operations
- Repeated calculations
- Cursor-based logic

Types of Loops
```
| Database   | Loop Types          |
| ---------- | ------------------- |
| SQL Server | WHILE               |
| MySQL      | WHILE, LOOP, REPEAT |
| PostgreSQL | LOOP, WHILE, FOR    |
```
Best Practice

- Prefer set-based operations over loops
- Use loops only when necessary
- Avoid loops in high-volume transactional logic

## 3️⃣ Indexing – Theory
What is an Index?

An index is a data structure that improves the speed of data retrieval operations by allowing faster lookups.

How Indexes Work
Most databases use B-Tree indexes
Indexes store sorted references to table rows
Improves SELECT performance
Slows down INSERT, UPDATE, DELETE

# Types of Indexes
1. Clustered Index

Defines physical order of data
Only one per table

- SQL Server: Explicit
- MySQL (InnoDB): Implicit on Primary Key
- PostgreSQL: Logical (via CLUSTER)

2. Non-Clustered Index

Separate structure pointing to table rows
Multiple allowed per table
Most common index type

3. Composite (Multi-Column) Index

Index on multiple columns
Follows left-most prefix rule
Column order is critical

4. Covering Index

Index that satisfies query without table access
SQL Server: INCLUDE columns
MySQL/PostgreSQL: Implicit covering

5. Filtered / Partial Index
Index created on a subset of rows
Improves performance and reduces size
Supported in SQL Server and PostgreSQL

6. Expression Index (PostgreSQL)

Index on computed expressions
Useful when functions are used in WHERE clause

7. GIN Index (PostgreSQL)

Used for JSON, arrays, full-text search
Optimized for containment queries

# 4️⃣ Index Usage & Optimization – Theory
When Indexes Are Used
- WHERE clause
- JOIN conditions
- ORDER BY
- GROUP BY

When Indexes Are NOT Used
- Functions on indexed columns (unless expression index)
- Low-cardinality columns alone
- Mismatched data types
- Leading wildcard searches

 Trade-offs
```
| Advantage          | Disadvantage         |
| ------------------ | -------------------- |
| Faster SELECT      | Slower writes        |
| Reduced IO         | Extra storage        |
| Better scalability | Maintenance overhead |
```

# 5️⃣ Index Analysis Tools – Theory
```
| Database   | Tool                          |
| ---------- | ----------------------------- |
| SQL Server | Execution Plan, STATISTICS IO |
| MySQL      | EXPLAIN                       |
| PostgreSQL | EXPLAIN ANALYZE               |
```

Used to:
- Identify index scans vs table scans
- Measure query cost
- Optimize slow queries

### 🎯 Interview Questions & Answers
## Stored Procedures

# Q1. What is a stored procedure?
A database object that stores reusable SQL logic executed on the server.

# Q2. Difference between procedure and function?
Procedures can return multiple values and perform transactions; functions typically return a single value.

# Q3. Are stored procedures faster than queries?
Yes, due to execution plan caching and reduced network traffic.

# Q4. Can stored procedures return result sets?
Yes, all three databases support this.

## Conditional Logic

# Q5. What conditional statements are supported in stored procedures?
IF, ELSE, CASE, ELSEIF/ELSIF.

# Q6. Can business logic be implemented in stored procedures?
Yes, commonly used for validation, calculations, and rules.

## Loops

# Q7. Why are loops discouraged in SQL?
SQL is set-based; loops are slower and less scalable.

# Q8. When would you use a loop?
For row-by-row processing when set-based logic is not possible.

## Indexing

# Q9. What is the difference between clustered and non-clustered index?
Clustered defines data order; non-clustered is a separate structure.

# Q10. How many clustered indexes can a table have?
Only one.

# Q11. What is a covering index?
An index that contains all columns required by a query.

# Q12. What is a composite index?
An index on multiple columns, following left-most rule.

# Q13. Why should indexes be used carefully?
They slow down write operations and increase storage usage.

# Performance

# Q14. How do you find if an index is used?
Using execution plans or EXPLAIN tools.

# Q15. What causes index scans instead of seeks?
Poor selectivity, missing indexes, functions on columns.

## PostgreSQL-Specific

# Q16. What is a partial index?
Index on a subset of rows using a WHERE condition.

# Q17. What is a GIN index used for?
JSON, array, and full-text search.

## SQL Server-Specific

# Q18. What is an included column?
A non-key column stored in the index to avoid lookups.

## MySQL-Specific

# Q19. What is a prefix index?
Index on first N characters of a string column.

