-- Setup Sample Data (Run Once)
CREATE TABLE Orders (
    OrderId INT IDENTITY PRIMARY KEY,
    CustomerId INT,
    OrderDate DATETIME,
    TotalAmount DECIMAL(18,2)
);

CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50)
);

-- Insert Customers
INSERT INTO Customers
SELECT TOP 10000
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
    CONCAT('Customer-', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    CASE WHEN ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 2 = 0
         THEN 'Bangalore' ELSE 'Chennai' END
FROM sys.objects;

-- Insert Orders
INSERT INTO Orders (CustomerId, OrderDate, TotalAmount)
SELECT TOP 500000
    ABS(CHECKSUM(NEWID())) % 10000 + 1,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE()),
    ABS(CHECKSUM(NEWID())) % 5000 + 100
FROM sys.objects a
CROSS JOIN sys.objects b;


-- 1: View Actual Execution Plan
SET STATISTICS PROFILE ON;

SELECT *
FROM Orders
WHERE CustomerId = 500;

SET STATISTICS PROFILE OFF;
-- Observe
-- Table Scan vs Index Seek
-- Estimated vs Actual Rows

-- 2: Add Index & Compare Plan
CREATE INDEX IX_Orders_CustomerId
ON Orders(CustomerId);

-- 3: Execution Plan with JOIN
SELECT c.CustomerName, o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerId = c.CustomerId
WHERE c.City = 'Bangaluru';
-- observe operators
-- Hash Match
-- Nested Loop
-- Merge Join

-- 4: Fix Bad Join with Index
CREATE INDEX IX_Customers_City
ON Customers(City);
-- Re-run the query and compare:
-- Estimated cost %
-- Operator changes


-- 5: WHERE vs FUNCTION (Index Killer)
-- BAD QUERY
SELECT *
FROM Orders
WHERE YEAR(OrderDate) = 2024;

-- OPTIMIZED
SELECT *
FROM Orders
WHERE OrderDate >= '2024-01-01'
  AND OrderDate < '2025-01-01';

-- 6: SELECT * vs Required Columns
SELECT *
FROM Orders
WHERE CustomerId = 100;

-- vs
SELECT OrderId, OrderDate, TotalAmount
FROM Orders
WHERE CustomerId = 100;
-- Key Lookup
-- I/O cost difference

-- 7: Covering Index
CREATE INDEX IX_Orders_Covering
ON Orders(CustomerId)
INCLUDE (OrderDate, TotalAmount);
-- ReRun above  (6th) Query
--Result
-- Key Lookup disappears
-- Faster execution

-- 8: Parameter Sniffing
CREATE PROC GetOrders
    @CustomerId INT
AS
BEGIN
    SELECT * FROM Orders WHERE CustomerId = @CustomerId;
END
-- Run 
EXEC GetOrders 1;      -- small data
EXEC GetOrders 9000;  -- large data

-- Same cached plan
-- Bad performance for one value

-- Fix
OPTION (RECOMPILE)

-- 9: Estimated vs Actual Rows Mismatch
SELECT *
FROM Orders
WHERE TotalAmount > 100;

-- Then 
UPDATE STATISTICS Orders;
-- Re-run & compare row estimates.


-- 10: Execution Plan Red Flags
SELECT Location, SUM(TotalAmount)
FROM Orders
WHERE OrderDate >= '2025-01-01'
GROUP BY Location;
-- Try:
-- Adding index on (OrderDate, Location)
-- Compare aggregation plan
