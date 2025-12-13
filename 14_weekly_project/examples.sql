-- Sales & Inventory Management System (SQL-Focused)
-- Database Schema (Simple & Realistic)
-- Analyze sales
-- Track inventory
-- Optimize queries
-- Encapsulate logic using views & procedures
CREATE TABLE Customers(
    CustomerId INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50)
);

CREATE TABLE Products(
    ProductId INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Orders(
    OrderId INT PRIMARY KEY,
    CustomerId INT,
    OrderDate DATE
);

CREATE TABLE OrderItems(
    OrderItemId INT PRIMARY KEY,
    OrderId INT,
    ProductId INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);

CREATE TABLE Inventory(
    ProductId INT PRIMARY KEY,
    StockQuantity INT,
    ReorderLevel INT
);

-- Subqueries (Correlated Subqueries)
-- Outer query depends on inner query → correlated subquery
SELECT c.CustomerName
FROM Customers c
WHERE (
    SELECT SUM(oi.Quantity * oi.UnitPrice)
    FROM Orders o
    JOIN OrderItems oi ON o.OrderId = oi.OrderId
    WHERE o.CustomerId = c.CustomerId
) >
(
    SELECT AVG(TotalAmount)
    FROM (
        SELECT SUM(Quantity * UnitPrice) AS TotalAmount
        FROM OrderItems
        GROUP BY OrderId
    ) t
);


-- Products sold more than category average
SELECT p.ProductName
FROM Products p
WHERE (
    SELECT SUM(oi.Quantity)
    FROM OrderItems oi
    WHERE oi.ProductId = p.ProductId
) >
(
    SELECT AVG(ProductQty)
    FROM (
        SELECT SUM(oi.Quantity) AS ProductQty
        FROM OrderItems oi
        JOIN Products pr ON oi.ProductId = pr.ProductId
        WHERE pr.Category = p.Category
        GROUP BY oi.ProductId
    ) x
);

-- CTEs (Recursive + Non-Recursive)
-- Monthly Sales using CTE
WITH MonthlySales AS (
    SELECT 
        FORMAT(o.OrderDate, 'yyyy-MM') AS SalesMonth,
        SUM(oi.Quantity * oi.UnitPrice) AS TotalSales
    FROM Orders o
    JOIN OrderItems oi ON o.OrderId = oi.OrderId
    GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
)
SELECT * FROM MonthlySales;

-- Recursive CTE — Generate Date Range
WITH DateRange AS (
    SELECT CAST('2025-01-01' AS DATE) AS SalesDate
    UNION ALL
    SELECT DATEADD(DAY, 1, SalesDate)
    FROM DateRange
    WHERE SalesDate < '2025-01-10'
)
SELECT * FROM DateRange;

-- Indexing Concepts
CREATE INDEX IX_Orders_OrderDate
ON Orders(OrderDate);

-- Used In
SELECT * FROM Orders
WHERE OrderDate BETWEEN '2025-01-01' AND '2025-01-31';


-- Composite Index for Reporting
CREATE INDEX IX_OrderItems_Order_Product
ON OrderItems(OrderId, ProductId);


-- Execution Plans
-- Analyze query without index
SELECT *
FROM OrderItems
WHERE ProductId = 101;

-- Same query after index
CREATE INDEX IX_OrderItems_ProductId
ON OrderItems(ProductId);

-- Views
-- Sales Summary View
CREATE VIEW vw_SalesSummary AS
SELECT 
    o.OrderId,
    c.CustomerName,
    SUM(oi.Quantity * oi.UnitPrice) AS OrderTotal
FROM Orders o
JOIN Customers c ON o.CustomerId = c.CustomerId
JOIN OrderItems oi ON o.OrderId = oi.OrderId
GROUP BY o.OrderId, c.CustomerName;

-- Low Stock Products View
CREATE VIEW vw_LowStockProducts AS
SELECT 
    p.ProductName,
    i.StockQuantity,
    i.ReorderLevel
FROM Products p
JOIN Inventory i ON p.ProductId = i.ProductId
WHERE i.StockQuantity < i.ReorderLevel;

-- STORED PROCEDURE
-- Place Order Procedure
CREATE PROCEDURE sp_PlaceOrder
    @CustomerId INT,
    @OrderDate DATE
AS
BEGIN
    INSERT INTO Orders(CustomerId, OrderDate)
    VALUES (@CustomerId, @OrderDate);
END;

-- Update Inventory After Sale
CREATE PROCEDURE sp_UpdateInventory
    @ProductId INT,
    @Quantity INT
AS
BEGIN
    UPDATE Inventory
    SET StockQuantity = StockQuantity - @Quantity
    WHERE ProductId = @ProductId;
END;


