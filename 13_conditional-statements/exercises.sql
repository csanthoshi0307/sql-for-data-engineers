-- Conditional statements in SQL
-- Examples for conditional statements with few details in different queries
-- CASE Statement (Most Important)
SELECT 
    OrderId,
    Status,
    CASE Status
        WHEN 'P' THEN 'Pending'
        WHEN 'C' THEN 'Completed'
        WHEN 'X' THEN 'Cancelled'
        ELSE 'Unknown'
    END AS StatusText
FROM Orders;

-- Searched CASE (More flexible)
SELECT 
    EmployeeName,
    Salary,
    CASE
        WHEN Salary < 30000 THEN 'Low'
        WHEN Salary BETWEEN 30000 AND 70000 THEN 'Medium'
        WHEN Salary > 70000 THEN 'High'
    END AS SalaryLevel
FROM Employees;

-- IF / IIF (Database-specific)
SELECT 
    Name,
    IIF(Age >= 18, 'Adult', 'Minor') AS Category
FROM Persons;


-- Conditional Filtering Using WHERE
-- Basic Condition
SELECT *
FROM Orders
WHERE OrderDate >= '2024-01-01'
  AND Status = 'Completed';

-- Conditional Filter Based on Parameter
-- @Status can be NULL
SELECT *
FROM Orders
WHERE (@Status IS NULL OR Status = @Status);

-- COALESCE (Handle NULLs)
SELECT 
    CustomerName,
    COALESCE(Phone, Email, 'Not Available') AS Contact
FROM Customers;

-- NULLIF (Conditional NULL)
SELECT 
    NULLIF(DiscountAmount, 0) AS Discount
FROM Sales;
SELECT 
    TotalAmount / NULLIF(Quantity, 0) AS PricePerItem
FROM Sales;

-- Conditional UPDATE
UPDATE Products
SET Price =
    CASE
        WHEN Category = 'Electronics' THEN Price * 1.10
        WHEN Category = 'Clothing' THEN Price * 1.05
        ELSE Price
    END;

-- Conditional ORDER BY
SELECT *
FROM Orders
ORDER BY
    CASE
        WHEN Status = 'Urgent' THEN 1
        WHEN Status = 'Normal' THEN 2
        ELSE 3
    END;

-- Conditional Aggregation (Very Common)
SELECT
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders,
    SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders
FROM Orders;

-- Conditional INSERT
INSERT INTO Users (UserName, Email)
SELECT 'john', 'john@mail.com'
WHERE NOT EXISTS (
    SELECT 1 FROM Users WHERE UserName = 'john'
);

-- IF EXISTS (SQL Server)
IF EXISTS (SELECT 1 FROM Orders WHERE Status = 'Pending')
BEGIN
    PRINT 'Pending orders exist';
END

-- Declare & Set Variables
DECLARE @Status VARCHAR(20);
DECLARE @MinAmount DECIMAL(10,2);

SET @Status = 'Completed';
SET @MinAmount = 1000;
SELECT *
FROM Orders
WHERE Status = @Status
  AND TotalAmount >= @MinAmount;
-- IF–ELSE Based on Variable Value
DECLARE @UserType VARCHAR(10) = 'Admin';

IF @UserType = 'Admin'
BEGIN
    SELECT * FROM Users;
END
ELSE
BEGIN
    SELECT UserId, UserName FROM Users;
END;
-- Variable-Driven Conditional Filter
DECLARE @CustomerId INT = NULL;

SELECT *
FROM Sales
WHERE (@CustomerId IS NULL OR CustomerId = @CustomerId);

