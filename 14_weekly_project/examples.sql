-- Weekly Project to explore topics Aggregation, Variables, Temp Tables, Conditional statements & Window Functions
-- Create rolling metrics dashboard queries 
-- Sales Transactions Table
CREATE TABLE SalesTransactions (
    TransactionId INT IDENTITY PRIMARY KEY,
    OrderDate DATE,
    Region VARCHAR(50),
    Category VARCHAR(50),
    CustomerId INT,
    Quantity INT,
    Amount DECIMAL(10,2)
);


-- INSERT 
INSERT INTO SalesTransactions 
(OrderDate, Region, Category, CustomerId, Quantity, Amount)
VALUES
('2025-01-01','India','Electronics',101,2,40000),
('2025-01-02','India','Electronics',102,1,20000),
('2025-01-03','US','Clothing',103,3,9000),
('2025-01-04','India','Clothing',101,1,3000),
('2025-01-05','US','Electronics',104,2,45000),
('2025-01-06','India','Electronics',105,1,22000),
('2025-01-07','US','Clothing',106,4,12000);

-- Concept: Aggregation + GROUP BY
SELECT
    OrderDate,
    COUNT(*) AS TotalOrders,
    SUM(Quantity) AS TotalQuantity,
    SUM(Amount) AS TotalSales
FROM SalesTransactions
GROUP BY OrderDate
ORDER BY OrderDate;

-- Using Variables (Dynamic Date Filtering)
DECLARE @StartDate DATE = '2025-01-01';
DECLARE @EndDate   DATE = '2025-01-07';

SELECT *
FROM SalesTransactions
WHERE OrderDate BETWEEN @StartDate AND @EndDate;


-- Temp Table for Dashboard Base
SELECT
    OrderDate,
    Region,
    Category,
    SUM(Amount) AS DailySales
INTO #DailySales
FROM SalesTransactions
GROUP BY OrderDate, Region, Category;

SELECT * FROM #DailySales;

-- Conditional Logic (Business Rules)
SELECT
    OrderDate,
    DailySales,
    CASE
        WHEN DailySales >= 40000 THEN 'High'
        WHEN DailySales BETWEEN 20000 AND 39999 THEN 'Medium'
        ELSE 'Low'
    END AS SalesPerformance
FROM #DailySales;


-- Rolling 7-Day Sales (Window Function)
-- SUM OVER (ROWS)
SELECT
    OrderDate,
    DailySales,
    SUM(DailySales) OVER (
        ORDER BY OrderDate
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS Rolling7DaySales
FROM #DailySales
ORDER BY OrderDate;


-- Rolling Average (Trend Analysis)
SELECT
    OrderDate,
    DailySales,
    AVG(DailySales) OVER (
        ORDER BY OrderDate
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS Rolling7DayAvg
FROM #DailySales;


-- Month-over-Month Growth
-- LAG()
WITH MonthlySales AS (
    SELECT
        FORMAT(OrderDate,'yyyy-MM') AS SalesMonth,
        SUM(Amount) AS MonthlySales
    FROM SalesTransactions
    GROUP BY FORMAT(OrderDate,'yyyy-MM')
)
SELECT
    SalesMonth,
    MonthlySales,
    MonthlySales - LAG(MonthlySales) OVER (ORDER BY SalesMonth) AS MoMGrowth
FROM MonthlySales;

-- RANK()
SELECT
    Category,
    SUM(Amount) AS TotalSales,
    RANK() OVER (ORDER BY SUM(Amount) DESC) AS SalesRank
FROM SalesTransactions
GROUP BY Category;

-- Region-wise Contribution %
-- Window Aggregation
SELECT
    Region,
    SUM(Amount) AS RegionSales,
    CAST(
        SUM(Amount) * 100.0 /
        SUM(SUM(Amount)) OVER ()
    AS DECIMAL(5,2)) AS ContributionPercentage
FROM SalesTransactions
GROUP BY Region;


-- Final Dashboard Query (All-in-One)
SELECT
    OrderDate,
    Region,
    Category,
    DailySales,
    SUM(DailySales) OVER (
        PARTITION BY Region
        ORDER BY OrderDate
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS RollingRegionSales
FROM #DailySales;


-- Cleanup
DROP TABLE #DailySales;
