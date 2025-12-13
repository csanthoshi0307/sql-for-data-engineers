#### Sales & Inventory Management System

### SQL Concepts: Theory & Design Explanation
📌 Project Overview

This project demonstrates core SQL querying and optimization concepts using a Sales & Inventory Management System.
The primary objective is to practice real-world SQL patterns commonly used in backend systems such as ERP, POS, and reporting applications.

## The project focuses on:

- Data analysis using advanced queries
- Query optimization techniques
- Encapsulation of business logic inside the database

This project is suitable for Beginner to Intermediate SQL developers and serves as a foundation for backend integrations (e.g., .NET, Java APIs).

## 🗄️ Database Design Rationale

The schema models a realistic sales workflow:

- Customers → Place orders
- Orders → Represent transactions
- OrderItems → Capture item-level details
- Products → Define catalog data
- Inventory → Track stock and reorder levels

This separation:

Avoids data redundancy
Enables flexible reporting
Supports performance tuning using indexes

## 📅  Subqueries & Correlated Subqueries
🔹 What is a Subquery?

A subquery is a query nested inside another query. It allows SQL to:

- Compute intermediate results
- Filter or compare data dynamically

## 🔹 Correlated Subqueries

A correlated subquery depends on values from the outer query and is executed once per row.

🔍 Why used in this project?

In this project, correlated subqueries are used to:

Compare a customer's total spending against average order value
Compare product sales against category-level averages

These patterns are common in:

Business analytics
Performance benchmarking
Rule-based filtering

## 📌 Learning Outcome

Understand row-by-row evaluation

Learn when correlated subqueries may impact performance

## 📅 Common Table Expressions (CTEs)
🔹 What is a CTE?

A CTE (Common Table Expression) is a temporary named result set used within a query.

🔹 Benefits of CTEs

Improves readability

Simplifies complex queries
Enables reuse of logic within a query

## 🔁 Recursive CTEs

Recursive CTEs reference themselves and are used to:

Generate sequences

Traverse hierarchies

Handle time-series data

## 🔍 Why used in this project?

Generate date ranges for reporting

Prepare data for missing sales days

Structure multi-step aggregations cleanly

📌 Learning Outcome

Replace complex subqueries with readable logic

Understand recursion in SQL

## 📅 Indexing Concepts
🔹 What is an Index?

An index is a data structure that improves query performance by allowing faster data retrieval.

🔹 Types used in this project:

Single-column index

Composite (multi-column) index

🔍 Why indexing matters here?

Indexes improve:

Search performance (WHERE, JOIN)
Sorting and grouping
Reporting queries on large datasets

📌 Learning Outcome

Learn where indexes help

Understand trade-offs (read vs write performance)

## 📅 Execution Plans
🔹 What is an Execution Plan?

An execution plan shows:

How SQL Server executes a query
Which indexes are used
Cost of each operation

🔍 Why execution plans are important?

They help identify:

- Table scans vs index seeks
- Missing or unused indexes
- Expensive operations

In this project:

Queries are tested before and after indexing

Performance improvements are visually analyzed

📌 Learning Outcome

Learn to read execution plans

Make data-driven optimization decisions

## 📅 Views
🔹 What is a View?

A view is a virtual table created from a SELECT query.

🔹 Why use Views?

Encapsulate complex joins
Improve security by exposing only required data
Simplify reporting queries

🔍 Views in this project

Sales summary per order
Low stock and reorder monitoring

📌 Learning Outcome

Separate reporting logic from application code

Use views as reusable data layers

## 📅 Stored Procedures
🔹 What is a Stored Procedure?

A stored procedure is a precompiled SQL program that:

Accepts parameters
Executes business logic
Returns results

🔹 Why use Stored Procedures?

Improve performance
Enforce consistency
Centralize business rules
Reduce SQL injection risk

🔍 Procedures in this project

Place orders

Update inventory after sales

📌 Learning Outcome

Encapsulate database logic

Prepare database for API integration

📅 Weekly Project Integration
🔹 End-to-End Practice

This project combines:

Analytical queries
Optimization techniques
Reusable database objects

🔹 Real-World Relevance

The design closely mirrors:

ERP systems
POS sales pipelines
Inventory tracking platforms
