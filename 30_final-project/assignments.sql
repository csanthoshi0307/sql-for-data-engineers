-- 1. Load 1 Million Sales Records into FactSales
-- Create a Numbers (Tally) Table (once)
WITH N AS (
    SELECT TOP (1000000)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
SELECT * INTO #Numbers FROM N;
-- Bulk Insert 1 Million Rows
INSERT INTO FactSales
(
    DateKey,
    ProductKey,
    StoreKey,
    Quantity,
    SalesAmount
)
SELECT
    20220101 + (n % 365) AS DateKey,        -- spreads across year
    (n % 100) + 1 AS ProductKey,            -- 100 products
    (n % 20) + 1 AS StoreKey,               -- 20 stores
    (n % 5) + 1 AS Quantity,
    ((n % 5) + 1) * 100 AS SalesAmount
FROM #Numbers;
-- Result: 1,000,000 rows inserted into FactSales

-- 2. Change Product Category → Verify SCD Type 2
-- Existing Product (Before Change)
SELECT *
FROM DimProduct
WHERE ProductID = 'P100'
ORDER BY StartDate DESC;
-- Simulate Source Change
UPDATE Stg_Product
SET Category = 'Electronics'
WHERE ProductID = 'P100';

-- Run SCD Type 2 MERGE
MERGE DimProduct AS target
USING Stg_Product AS source
ON target.ProductID = source.ProductID
AND target.IsCurrent = 1

WHEN MATCHED AND target.Category <> source.Category
THEN UPDATE SET
    EndDate = GETDATE(),
    IsCurrent = 0

WHEN NOT MATCHED BY TARGET
THEN INSERT
(
    ProductID, ProductName, Category, Brand,
    StartDate, EndDate, IsCurrent
)
VALUES
(
    source.ProductID, source.ProductName,
    source.Category, source.Brand,
    GETDATE(), NULL, 1
);
-- Verify SCD History
SELECT ProductID, Category, StartDate, EndDate, IsCurrent
FROM DimProduct
WHERE ProductID = 'P100'
ORDER BY StartDate;
-- You should see:
-- Old row → IsCurrent = 0
-- New row → IsCurrent = 1


-- 3. Query Sales by Year → Partition Pruning
-- Query Specific Year
SELECT
    SUM(SalesAmount) AS TotalSales
FROM FactSales
WHERE DateKey BETWEEN 20230101 AND 20231231;

-- Check Execution Plan
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    SUM(SalesAmount)
FROM FactSales
WHERE DateKey BETWEEN 20230101 AND 20231231;
-- Expected Behavior
-- Only relevant partitions scanned
-- Reduced logical reads


-- 4. Compare Performance: With vs Without Columnstore
-- Without Columnstore
DROP INDEX IF EXISTS CCI_FactSales ON FactSales;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    ProductKey,
    SUM(SalesAmount) AS TotalSales
FROM FactSales
GROUP BY ProductKey;

-- With Columnstore
CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactSales
ON FactSales;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    ProductKey,
    SUM(SalesAmount) AS TotalSales
FROM FactSales
GROUP BY ProductKey;
-- Columnstore wins for analytics

-- Simulate Dirty Reads (Isolation Levels)
-- Session 1 (Uncommitted Transaction)
BEGIN TRAN;

UPDATE FactSales
SET SalesAmount = 99999
WHERE SalesKey = 1;
-- Do NOT commit yet


-- Session 2 — READ UNCOMMITTED (Dirty Read)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT SalesAmount
FROM FactSales
WHERE SalesKey = 1;
-- Dirty Read happens (you see 99999)


-- Session 2 — READ COMMITTED (Safe)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT SalesAmount
FROM FactSales
WHERE SalesKey = 1;
-- Sees last committed value only

-- Rollback Session 1   
ROLLBACK;

-- Isolation summary
| Level            | Dirty Read | Use Case          |
| ---------------- | ---------- | ----------------- |
| READ UNCOMMITTED | ❌ Yes      | Fast analytics    |
| READ COMMITTED   | ✅ No       | Default OLTP      |
| REPEATABLE READ  | ✅ No       | Reporting         |
| SERIALIZABLE     | ✅ No       | Financial systems |
| SNAPSHOT         | ✅ No       | Modern analytics  |
-- End of Assignments for Final Project