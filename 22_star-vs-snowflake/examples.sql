-- Star Schema
-- Concept
-- One central Fact table
-- Denormalized Dimension tables
-- Looks like a star
-- Simple queries, fast performance

-- Fact Table
CREATE TABLE FactSales (
    SalesID INT PRIMARY KEY,
    DateID INT,
    ProductID INT,
    CustomerID INT,
    Quantity INT,
    TotalAmount DECIMAL(10,2)
);

-- Dimension Tables
CREATE TABLE DimDate (
    DateID INT PRIMARY KEY,
    FullDate DATE,
    Year INT,
    Month VARCHAR(20)
);

CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

CREATE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50)
);

-- Query Example (Star Schema)
SELECT 
    d.Year,
    p.Category,
    SUM(f.TotalAmount) AS TotalSales
FROM FactSales f
JOIN DimDate d ON f.DateID = d.DateID
JOIN DimProduct p ON f.ProductID = p.ProductID
GROUP BY d.Year, p.Category;

-- Snowflake Schema
-- Concept
-- Fact table + Normalized dimensions
-- Dimensions split into multiple tables
-- Looks like a snowflake
-- Less redundancy, but more joins
-- Fact Table (same)
CREATE TABLE FactSales (
    SalesID INT PRIMARY KEY,
    DateID INT,
    ProductID INT,
    CustomerID INT,
    Quantity INT,
    TotalAmount DECIMAL(10,2)
);

-- Normalized Dimensions
CREATE TABLE DimDate (
    DateID INT PRIMARY KEY,
    FullDate DATE,
    MonthID INT
);

CREATE TABLE DimMonth (
    MonthID INT PRIMARY KEY,
    MonthName VARCHAR(20),
    Year INT
);

CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    CategoryID INT
);

CREATE TABLE DimCategory (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50)
);

-- Query Example (Snowflake Schema)
SELECT 
    m.Year,
    c.CategoryName,
    SUM(f.TotalAmount) AS TotalSales
FROM FactSales f
JOIN DimDate d ON f.DateID = d.DateID
JOIN DimMonth m ON d.MonthID = m.MonthID
JOIN DimProduct p ON f.ProductID = p.ProductID
JOIN DimCategory c ON p.CategoryID = c.CategoryID
GROUP BY m.Year, c.CategoryName;
-- More joins
-- Less data duplication
-- Better storage efficiency

