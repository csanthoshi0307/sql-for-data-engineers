### 📌 Project: Sales Analytics & Optimization (SQL Server–oriented)
🗂️ Database Schema
## 1️⃣ Tables
```
CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY IDENTITY,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    IsActive BIT
);

CREATE TABLE Products (
    ProductId INT PRIMARY KEY IDENTITY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Orders (
    OrderId INT PRIMARY KEY IDENTITY,
    CustomerId INT,
    OrderDate DATE,
    TotalAmount DECIMAL(12,2),
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);

CREATE TABLE OrderItems (
    OrderItemId INT PRIMARY KEY IDENTITY,
    OrderId INT,
    ProductId INT,
    Quantity INT,
    LineAmount DECIMAL(12,2),
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);
```
## 🔹 1. Subqueries
# A. Simple Subquery

Find customers who placed orders above average order value
```
SELECT CustomerName
FROM Customers
WHERE CustomerId IN (
    SELECT CustomerId
    FROM Orders
    WHERE TotalAmount >
          (SELECT AVG(TotalAmount) FROM Orders)
);
```

✅ Optimization Tip

Avoid IN with large result sets → use EXISTS.

# B. Correlated Subquery

Customers whose total orders exceed their city average
```
SELECT c.CustomerName, c.City
FROM Customers c
WHERE (
    SELECT SUM(o.TotalAmount)
    FROM Orders o
    WHERE o.CustomerId = c.CustomerId
) >
(
    SELECT AVG(o2.TotalAmount)
    FROM Orders o2
    JOIN Customers c2 ON o2.CustomerId = c2.CustomerId
    WHERE c2.City = c.City
);
```

⚠️ Performance issue: Executes subquery per row
✅ Better using CTE (below)

## 🔹 2. CTEs (Common Table Expressions)
A. Basic CTE (Replacing Correlated Subquery)
WITH CityAvg AS (
    SELECT c.City, AVG(o.TotalAmount) AS AvgOrder
    FROM Orders o
    JOIN Customers c ON o.CustomerId = c.CustomerId
    GROUP BY c.City
),
CustomerTotal AS (
    SELECT CustomerId, SUM(TotalAmount) AS TotalOrder
    FROM Orders
    GROUP BY CustomerId
)
SELECT c.CustomerName, c.City
FROM Customers c
JOIN CustomerTotal ct ON c.CustomerId = ct.CustomerId
JOIN CityAvg ca ON c.City = ca.City
WHERE ct.TotalOrder > ca.AvgOrder;


# 🚀 Much faster & readable

# Recursive CTE (Hierarchy Example)

Product Category Hierarchy
```
CREATE TABLE Categories (
    CategoryId INT PRIMARY KEY,
    ParentCategoryId INT NULL,
    CategoryName VARCHAR(50)
);

WITH CategoryTree AS (
    SELECT CategoryId, ParentCategoryId, CategoryName, 0 AS Level
    FROM Categories
    WHERE ParentCategoryId IS NULL

    UNION ALL

    SELECT c.CategoryId, c.ParentCategoryId, c.CategoryName, ct.Level + 1
    FROM Categories c
    JOIN CategoryTree ct ON c.ParentCategoryId = ct.CategoryId
)

SELECT * FROM CategoryTree;
```
## 🔹 3. Views
A. Normal View
```
CREATE VIEW vw_OrderSummary
AS
SELECT
    o.OrderId,
    o.OrderDate,
    c.CustomerName,
    o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerId = c.CustomerId;
```

⚠️ Views do not store data
⚠️ Performance depends on base tables

## 4. Indexed Views (Materialized Views in SQL Server)
# A. Indexed View (Performance Boost)
```
CREATE VIEW vw_DailySales
WITH SCHEMABINDING
AS
SELECT
    o.OrderDate,
    COUNT_BIG(*) AS OrderCount,
    SUM(o.TotalAmount) AS TotalSales
FROM dbo.Orders o
GROUP BY o.OrderDate;

CREATE UNIQUE CLUSTERED INDEX IX_DailySales
ON vw_DailySales (OrderDate);
```

🚀 Stored physically
🚀 Very fast for reporting queries

⚠️ Rules

- COUNT_BIG
- SCHEMABINDING
- No SELECT *

## 🔹 5. Execution Plans (Critical for Optimization)
How to Analyze
```
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT * FROM Orders WHERE OrderDate = '2025-01-01';
```
What look for
```
| Warning     | Meaning                |
| ----------- | ---------------------- |
| Table Scan  | Missing index          |
| Key Lookup  | Covering index missing |
| Nested Loop | OK for small data      |
| Hash Match  | Large dataset          |

```

## 6. Indexing Strategies
# A. Non-clustered Index
```
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
ON Orders(OrderDate)
INCLUDE (CustomerId, TotalAmount);
```
# B. Composite Index
```
CREATE NONCLUSTERED INDEX IX_Orders_Customer_Date
ON Orders(CustomerId, OrderDate);
```
## 7. Stored Procedures (Optimized)
```
A. Parameterized Stored Procedure
CREATE PROCEDURE sp_GetCustomerOrders
    @CustomerId INT,
    @FromDate DATE,
    @ToDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT o.OrderId, o.OrderDate, o.TotalAmount
    FROM Orders o
    WHERE o.CustomerId = @CustomerId
      AND o.OrderDate BETWEEN @FromDate AND @ToDate;
END;
```

# 🚀 Benefits:
- Execution plan reuse
- Prevents SQL injection
- Faster than ad-hoc queries

## 8. Common Optimization Tips (VERY IMPORTANT)
✅ Query Level
Avoid SELECT *
Use EXISTS instead of IN
Replace correlated subqueries with CTEs
Filter early (WHERE before GROUP BY)

# ✅ Index Level

- Index columns used in:
    - WHERE
    - JOIN
    - ORDER BY
- Use INCLUDE columns to avoid Key Lookups
- Avoid over-indexing (write cost)

# ✅ Architecture Level

- Use Indexed Views for reports
- Use Stored Procedures for heavy queries
- Use partitioning for large tables (date-based)

# 📌 Real-World Usage Mapping
```
| Feature           | Where Used                 |
| ----------------- | -------------------------- |
| Subqueries        | Validations, thresholds    |
| CTEs              | Reporting, transformations |
| Recursive CTE     | Category / Org hierarchy   |
| Indexed Views     | Dashboards                 |
| Stored Procedures | APIs                       |
| Execution Plans   | Performance tuning         |
```