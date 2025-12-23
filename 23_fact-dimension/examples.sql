-- Fact Table
FactSales
---------
SalesKey
DateKey
ProductKey
CustomerKey
StoreKey
Quantity
SalesAmount
DiscountAmount

-- Dimension Tables
DimDate
-------
DateKey
FullDate
Year
Month
Day
Quarter

DimProduct
----------
ProductKey
ProductName
Category
Brand

DimCustomer
-----------
CustomerKey
CustomerName
City
Country


DimStore
--------
StoreKey
StoreName
Region

-- BEGINNER LEVEL QUERIES
-- Total Sales Amount
SELECT 
    SUM(SalesAmount) AS TotalSales
FROM FactSales;
-- Concept: Aggregate measure from fact table

-- Total Sales by Year
SELECT 
    d.Year,
    SUM(f.SalesAmount) AS TotalSales
FROM FactSales f
JOIN DimDate d ON f.DateKey = d.DateKey
GROUP BY d.Year;
-- Concept: Fact + Date Dimension

-- Sales by Product
SELECT 
    p.ProductName,
    SUM(f.SalesAmount) AS TotalSales
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.ProductName;
-- Concept: Fact + Product Dimension

-- Sales by Customer
SELECT 
    c.CustomerName,
    SUM(f.SalesAmount) AS TotalSales
FROM FactSales f
JOIN DimCustomer c ON f.CustomerKey = c.CustomerKey
GROUP BY c.CustomerName;
-- Concept: Fact + Customer Dimension

-- INTERMEDIATE LEVEL QUERIES
-- Monthly Sales Trend
SELECT 
    d.Year,
    d.Month,
    SUM(f.SalesAmount) AS MonthlySales
FROM FactSales f
JOIN DimDate d ON f.DateKey = d.DateKey
GROUP BY d.Year, d.Month
ORDER BY d.Year, d.Month;
-- Concept: Time-series analysis

-- Top 5 Products by Sales
SELECT TOP 5
    p.ProductName,
    SUM(f.SalesAmount) AS TotalSales
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.ProductName
ORDER BY TotalSales DESC;
-- Concept: Ranking products by sales

-- Sales by Region
SELECT 
    s.Region,
    SUM(f.SalesAmount) AS TotalSales
FROM FactSales f
JOIN DimStore s ON f.StoreKey = s.StoreKey
GROUP BY s.Region;
-- Concept: Fact + Store Dimension

-- Average Order Value per Customer
SELECT 
    c.CustomerName,
    AVG(f.SalesAmount) AS AvgOrderValue
FROM FactSales f
JOIN DimCustomer c ON f.CustomerKey = c.CustomerKey
GROUP BY c.CustomerName;
-- Concept: Average measure calculation

-- SLIGHTLY ADVANCED (STILL EASY)
-- Sales with Discount Percentage
SELECT 
    SUM(SalesAmount) AS TotalSales,
    SUM(DiscountAmount) AS TotalDiscount,
    (SUM(DiscountAmount) * 100.0 / SUM(SalesAmount)) AS DiscountPercent
FROM FactSales;
-- Concept: Calculated measures

-- Year-over-Year Sales Growth
SELECT 
    d.Year,
    SUM(f.SalesAmount) AS TotalSales,
    LAG(SUM(f.SalesAmount)) OVER (ORDER BY d.Year) AS PreviousYearSales,
    ((SUM(f.SalesAmount) - LAG(SUM(f.SalesAmount)) OVER (ORDER BY d.Year)) * 100.0 / LAG(SUM(f.SalesAmount)) OVER (ORDER BY d.Year)) AS YoYGrowthPercent   
FROM FactSales f
JOIN DimDate d ON f.DateKey = d.DateKey
GROUP BY d.Year
ORDER BY d.Year;
-- Concept: Window functions for growth calculation

-- Best Product Category per Year
SELECT 
    d.Year,
    p.Category,
    SUM(f.SalesAmount) AS TotalSales
FROM FactSales f
JOIN DimDate d ON f.DateKey = d.DateKey
JOIN DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY d.Year, p.Category
ORDER BY d.Year, TotalSales DESC;
-- Concept: Multi-dimensional aggregation



