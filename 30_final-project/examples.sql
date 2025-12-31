-- SQL Mini Project: Retail Sales Data Warehouse
-- Retail Analytics Data Warehouse for a company

--  Star Schema (Primary)
FactSales
 ├── DimDate
 ├── DimProduct
 ├── DimStore
 └── DimCustomer

 -- Snowflake (Product Dimension Normalized)
  DimProduct
 ├── DimCategory
 └── DimBrand

-- Fact Tables
CREATE TABLE FactSales (
    SalesKey BIGINT IDENTITY PRIMARY KEY,
    DateKey INT,
    ProductKey INT,
    StoreKey INT,
    Quantity INT,
    SalesAmount DECIMAL(18,2)
);

 --  Dimension Tables Design
 CREATE TABLE DimProduct (
    ProductKey INT IDENTITY PRIMARY KEY,
    ProductID VARCHAR(50),
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Brand VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    IsCurrent BIT
);

CREATE TABLE DimStore (
    StoreKey INT IDENTITY PRIMARY KEY,
    StoreID VARCHAR(50),
    StoreName VARCHAR(100),
    City VARCHAR(50),
    Country VARCHAR(50)
);

CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    Year INT,
    Month INT,
    Day INT
);


-- Load Product Dimension (UPSERT)
MERGE DimProduct AS target
USING Stg_Product AS source
ON target.ProductID = source.ProductID
AND target.IsCurrent = 1

WHEN MATCHED AND (
     target.ProductName <> source.ProductName
  OR target.Category <> source.Category
  OR target.Brand <> source.Brand
)
THEN UPDATE SET
    EndDate = GETDATE(),
    IsCurrent = 0

WHEN NOT MATCHED BY TARGET
THEN INSERT (
    ProductID, ProductName, Category, Brand,
    StartDate, EndDate, IsCurrent
)
VALUES (
    source.ProductID, source.ProductName,
    source.Category, source.Brand,
    GETDATE(), NULL, 1
);

-- SCD Type 2 (Slowly Changing Dimension)
-- Track Product changes over time (name/category/brand).
-- Query current products
SELECT * FROM DimProduct WHERE IsCurrent = 1;


-- Partitioning (Fact Table)
-- Partition FactSales by Year
CREATE PARTITION FUNCTION pfSalesYear (INT)
AS RANGE RIGHT FOR VALUES (2022, 2023, 2024);

CREATE PARTITION SCHEME psSalesYear
AS PARTITION pfSalesYear
ALL TO ([PRIMARY]);


CREATE TABLE FactSales (
    SalesKey BIGINT IDENTITY,
    DateKey INT,
    ProductKey INT,
    StoreKey INT,
    Quantity INT,
    SalesAmount DECIMAL(18,2)
)
ON psSalesYear(DateKey);


-- Columnar Databases (Conceptual Practice)
-- Convert Fact Table to Columnstore Index
CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactSales
ON FactSales;


-- Transactions & Isolation Levels
-- Transaction Example
BEGIN TRANSACTION;

INSERT INTO FactSales
(DateKey, ProductKey, StoreKey, Quantity, SalesAmount)
VALUES
(20240101, 1, 2, 5, 2500);

IF @@ERROR <> 0
    ROLLBACK;
ELSE
    COMMIT;


-- Isolation Levels Demo

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM FactSales;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM FactSales;


-- Practices:
-- Load 1 million sales records into FactSales

-- Change product category → verify SCD Type 2

-- Query sales by year → observe partition pruning

-- Compare performance with vs without columnstore

-- Simulate dirty reads using different isolation levels