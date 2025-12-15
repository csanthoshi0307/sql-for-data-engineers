-- ============================================
-- Simple CTE (Readable Subquery)
-- ============================================
WITH SalesCTE AS (
    SELECT CustomerId, SUM(Amount) AS TotalSales
    FROM Sales
    GROUP BY CustomerId
)
SELECT *
FROM SalesCTE
WHERE TotalSales > 10000;
-- Improves readability compared to nested subqueries.

-- CTE with JOIN
WITH OrderSummary AS (
    SELECT o.OrderId, o.CustomerId, SUM(oi.Price) AS OrderTotal
    FROM Orders o
    JOIN OrderItems oi ON o.OrderId = oi.OrderId
    GROUP BY o.OrderId, o.CustomerId
)
SELECT c.CustomerName, os.OrderTotal
FROM OrderSummary os
JOIN Customers c ON os.CustomerId = c.CustomerId;
-- Clean way to pre-aggregate data.


-- Multiple CTEs
WITH HighValueOrders AS (
    SELECT OrderId, CustomerId
    FROM Orders
    WHERE TotalAmount > 5000
),
CustomerOrders AS (
    SELECT c.CustomerName, h.OrderId
    FROM HighValueOrders h
    JOIN Customers c ON h.CustomerId = c.CustomerId
)
SELECT * FROM CustomerOrders;
-- One CTE can build on another.

--CTE for ROW_NUMBER / Deduplication
WITH RankedOrders AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY CustomerId ORDER BY OrderDate DESC) AS rn
    FROM Orders
)
SELECT *
FROM RankedOrders
WHERE rn = 1;
-- Get latest order per customer.

--CTE for Complex Calculations
WITH MonthlySales AS (
    SELECT
        YEAR(OrderDate) AS Yr,
        MONTH(OrderDate) AS Mn,
        SUM(TotalAmount) AS TotalSales
    FROM Orders
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT *,
       TotalSales - LAG(TotalSales) OVER (ORDER BY Yr, Mn) AS Growth
FROM MonthlySales;
-- Makes analytics queries clean.


-- ============================================
-- Recursive CTE 
-- Recursive CTEs have two parts: Anchor query, Recursive query
-- ============================================

-- Basic Recursive CTE (Numbers 1–10)
WITH Numbers AS (
    SELECT 1 AS Num        -- Anchor
    UNION ALL
    SELECT Num + 1         -- Recursive
    FROM Numbers
    WHERE Num < 10
)
SELECT * FROM Numbers;
-- Generates sequences.

-- Employee Hierarchy
WITH EmployeeTree AS (
    SELECT EmployeeId, Name, ManagerId, 0 AS Level
    FROM Employees
    WHERE ManagerId IS NULL

    UNION ALL

    SELECT e.EmployeeId, e.Name, e.ManagerId, et.Level + 1
    FROM Employees e
    JOIN EmployeeTree et ON e.ManagerId = et.EmployeeId
)
SELECT * FROM EmployeeTree;
-- Org charts / reporting hierarchy.

-- Category / Menu Hierarchy
WITH CategoryTree AS (
    SELECT CategoryId, CategoryName, ParentCategoryId, 0 AS Level
    FROM Categories
    WHERE ParentCategoryId IS NULL

    UNION ALL

    SELECT c.CategoryId, c.CategoryName, c.ParentCategoryId, ct.Level + 1
    FROM Categories c
    JOIN CategoryTree ct ON c.ParentCategoryId = ct.CategoryId
)
SELECT * FROM CategoryTree;
-- Product categories, menus, file systems.

-- Recursive CTE with Path
WITH CategoryPath AS (
    SELECT
        CategoryId,
        CategoryName,
        ParentCategoryId,
        CAST(CategoryName AS VARCHAR(MAX)) AS Path
    FROM Categories
    WHERE ParentCategoryId IS NULL

    UNION ALL

    SELECT
        c.CategoryId,
        c.CategoryName,
        c.ParentCategoryId,
        cp.Path + ' > ' + c.CategoryName
    FROM Categories c
    JOIN CategoryPath cp ON c.ParentCategoryId = cp.CategoryId
)
SELECT * FROM CategoryPath;
-- Builds full hierarchy path.

-- Date Range Generator
WITH DateRange AS (
    SELECT CAST('2025-01-01' AS DATE) AS Dt
    UNION ALL
    SELECT DATEADD(DAY, 1, Dt)
    FROM DateRange
    WHERE Dt < '2025-01-10'
)
SELECT * FROM DateRange
OPTION (MAXRECURSION 100);
-- Very useful for reports with missing dates.

