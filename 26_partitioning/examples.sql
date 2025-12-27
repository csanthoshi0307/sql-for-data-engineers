-- SQL Partitioning – Queries
-- Why Partitioning Helps (Concept)
SELECT *
FROM Sales
WHERE OrderDate >= '2025-01-01'
  AND OrderDate < '2025-02-01';

-- Range Partitioning (Date-Based)
Sales_2023
Sales_2024
Sales_2025

-- Query (Same as normal table)
SELECT SUM(Amount)
FROM Sales
WHERE OrderDate BETWEEN '2025-01-01' AND '2025-01-31';
-- SQL automatically performs partition pruning.

-- Insert Data into Partitioned Table
INSERT INTO Sales (OrderId, OrderDate, Amount)
VALUES (101, '2025-02-10', 5000);
-- Database routes the row to the correct partition automatically.

-- Check Which Partition Is Used (Conceptual)
 EXPLAIN
SELECT *
FROM Sales
WHERE OrderDate = '2025-02-10';
-- Execution plan shows only one partition scanned.


-- Partitioning vs WHERE Clause (Key Idea)
-- Without partitioning:
SELECT * FROM Sales WHERE OrderDate = '2025-02-10';
-- Full table scan

-- With partitioning:
-- Only one partition scanned


-- Intermediate Level Examples
-- Creating Range Partitioning (PostgreSQL Example)
CREATE TABLE Sales (
    OrderId INT,
    OrderDate DATE,
    Amount NUMERIC
) PARTITION BY RANGE (OrderDate);

-- Create Partitions
CREATE TABLE Sales_2024 PARTITION OF Sales
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE Sales_2025 PARTITION OF Sales
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Query Automatically Hits Correct Partition
SELECT *
FROM Sales
WHERE OrderDate = '2025-06-15';
-- Only Sales_2025 is accessed

-- Hash Partitioning (Even Data Distribution)
-- Create Hash Partitioned Table
CREATE TABLE Users (
    UserId INT,
    UserName VARCHAR(100)
) PARTITION BY HASH (UserId);

-- Create Partitions
CREATE TABLE Users_p0 PARTITION OF Users
FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE Users_p1 PARTITION OF Users
FOR VALUES WITH (MODULUS 4, REMAINDER 1);

-- Query
SELECT *
FROM Users
WHERE UserId = 105;
-- Hash function routes query to correct partition

-- List Partitioning Example
CREATE TABLE Customers (
    CustomerId INT,
    Country VARCHAR(50)
) PARTITION BY LIST (Country);

CREATE TABLE Customers_ASIA PARTITION OF Customers
FOR VALUES IN ('India', 'UAE');

CREATE TABLE Customers_US PARTITION OF Customers
FOR VALUES IN ('USA', 'Canada');

SELECT *
FROM Customers
WHERE Country = 'India';
-- Only Customers_ASIA partition scanned

-- Partition-Wise Aggregation
SELECT DATE_TRUNC('year', OrderDate) AS Year,
       SUM(Amount)
FROM Sales
GROUP BY DATE_TRUNC('year', OrderDate);
-- Each partition can be processed in parallel for aggregation

-- Deleting Old Data Using Partition
-- Slow approach:
DELETE FROM Sales
WHERE OrderDate < '2023-01-01';

-- Fast approach (Drop Partition):
DROP TABLE Sales_2023;
-- Instant delete without row-by-row scanning

-- Indexes on Partitioned Tables
CREATE INDEX idx_sales_orderdate
ON Sales (OrderDate);
-- Each partition gets its own index, improving performance.

-- Cross-Partition Query (Costly)
SELECT *
FROM Sales
WHERE Amount > 10000;
-- No partition key used → all partitions scanned



