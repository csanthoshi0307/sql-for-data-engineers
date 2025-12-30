-- real-world Data Engineering (DE) SQL case studies with practical SQL example
-- Sales Data Cleaning & Normalization (Real ERP Case)
-- Sales amounts stored as VARCHAR with commas, dates as strings, inconsistent NULLs.
SalesRaw
---------
BillNo
BillDate   VARCHAR(50)
NetAmount  VARCHAR(50)  -- '1,234.50'
TaxAmount  VARCHAR(50)

-- solution
SELECT
    BillNo,
    CONVERT(DATE, BillDate) AS BillDate,
    CAST(REPLACE(NetAmount, ',', '') AS DECIMAL(18,2)) AS NetAmount,
    CAST(REPLACE(TaxAmount, ',', '') AS DECIMAL(18,2)) AS TaxAmount
FROM SalesRaw
WHERE ISNUMERIC(REPLACE(NetAmount, ',', '')) = 1;

--📌 DE Concepts
-- Data cleansing
-- Type normalization
-- Pre-ETL validation


-- Daily Sales Aggregation (POS / SAP Reporting)
-- What is the daily net sales per location?
SELECT
    CAST(BillDate AS DATE) AS SalesDate,
    Location,
    SUM(NetAmount) AS TotalSales
FROM SalesTransactions
GROUP BY CAST(BillDate AS DATE), Location
ORDER BY SalesDate;


-- Duplicate Invoice Detection (Critical Finance Case)
-- Same invoice posted multiple times due to retry/job failure.
SELECT
    InvoiceNo,
    COUNT(*) AS DuplicateCount
FROM Invoices
GROUP BY InvoiceNo
HAVING COUNT(*) > 1;

-- Get Full Records
WITH Dups AS (
    SELECT InvoiceNo
    FROM Invoices
    GROUP BY InvoiceNo
    HAVING COUNT(*) > 1
)
SELECT i.*
FROM Invoices i
JOIN Dups d ON i.InvoiceNo = d.InvoiceNo;

-- Slowly Changing Dimension (SCD Type 2 – Real DE Interview Favorite)
-- Customer address changes — history must be preserved.
DimCustomer
-----------
CustomerID
Address
ValidFrom
ValidTo
IsActive

-- Expire Old Record    
UPDATE DimCustomer
SET ValidTo = GETDATE(),
    IsActive = 0
WHERE CustomerID = 101
  AND IsActive = 1;
-- Insert New Record
INSERT INTO DimCustomer
VALUES (101, 'New Address', GETDATE(), NULL, 1);


-- Month-over-Month Sales Growth (Analytics Case)
-- Compare sales with previous month
SELECT
    MONTH(BillDate) AS MonthNo,
    SUM(NetAmount) AS Sales,
    LAG(SUM(NetAmount)) OVER (ORDER BY MONTH(BillDate)) AS PrevMonthSales
FROM SalesTransactions
GROUP BY MONTH(BillDate);

-- Top N Customers by Revenue (Real BI Requirement)
SELECT TOP 5
    CustomerCode,
    SUM(NetAmount) AS Revenue
FROM SalesTransactions
GROUP BY CustomerCode
ORDER BY Revenue DESC;

-- Failed vs Success Record Tracking (ETL / Queue Processing)
ProcessingLog
-------------
DocEntry
Status      -- SUCCESS / FAILED
ErrorMsg
CreatedOn

SELECT
    Status,
    COUNT(*) AS Total
FROM ProcessingLog
GROUP BY Status;
-- Failed Records Only
SELECT *
FROM ProcessingLog
WHERE Status = 'FAILED';


-- Data Freshness Check (Pipeline Monitoring)
-- Did data load today?
SELECT
    MAX(CreatedOn) AS LastLoadTime
FROM SalesTransactions;

-- Alert Logic
IF DATEDIFF(HOUR, MAX(CreatedOn), GETDATE()) > 24
    PRINT 'DATA DELAY ALERT';


-- Joining Master & Transaction Data
SELECT
    st.BillNo,
    st.BillDate,
    st.NetAmount,
    c.CustomerName,
    c.Region
FROM SalesTransactions st
JOIN Customers c ON st.CustomerCode = c.CustomerCode;

-- Incremental Load (Real ETL Case)
-- Load only new/changed records since last load
DECLARE @LastLoadTime DATETIME;
SET @LastLoadTime = (SELECT MAX(LoadTime) FROM ETLLog WHERE TableName = 'SalesTransactions');
SELECT *
FROM SalesTransactions
WHERE CreatedOn > @LastLoadTime;
--📌 DE Concept
-- Incremental data processing
-- Transaction Management & Isolation Levels (RDE Case Study)
-- Durability – committed data persists
-- Basic Transaction
BEGIN TRAN;
INSERT INTO Accounts(AccountId, Balance)
VALUES (1, 1000);
UPDATE Accounts
SET Balance = Balance - 100
WHERE AccountId = 1;
COMMIT TRAN;   -- saves changes
-- ROLLBACK TRAN; -- undo changes
-- SQL Server Isolation Levels (Lowest ➜ Highest)
-- 1. READ UNCOMMITTED
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRAN;
SELECT * FROM Orders;

COMMIT;
SELECT * FROM Orders WITH (NOLOCK);
-- 2. READ COMMITTED (Default)
-- No dirty reads
-- Non-repeatable & phantom reads possible
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRAN;
SELECT * FROM Orders WHERE OrderId = 10;
COMMIT;
-- 3. REPEATABLE READ
-- Prevents dirty + non-repeatable reads
-- Phantom reads possible
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRAN;
SELECT * FROM Orders WHERE CustomerId = 5;
COMMIT;
-- 4. SERIALIZABLE
-- Safest
-- Prevents all read problems
-- Lowest concurrency
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRAN;
SELECT * FROM Orders WHERE CustomerId = 5;
COMMIT;
-- 5. SNAPSHOT (Row Versioning)
-- Reads a consistent snapshot
-- No blocking
-- Requires DB option
ALTER DATABASE MyDB
SET ALLOW_SNAPSHOT_ISOLATION ON;
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
BEGIN TRAN;
SELECT * FROM Orders WHERE CustomerId = 5;
COMMIT;
--📌 DE Concepts