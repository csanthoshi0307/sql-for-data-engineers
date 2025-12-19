
-- PROCEDIRE Calculate Discount Based on Amount
CREATE PROCEDURE sp_CalculateDiscount
    @Amount DECIMAL(10,2),
    @Discount DECIMAL(10,2) OUTPUT
AS
BEGIN
    DECLARE @Rate DECIMAL(5,2)

    IF @Amount >= 10000
        SET @Rate = 10
    ELSE IF @Amount >= 5000
        SET @Rate = 5
    ELSE
        SET @Rate = 0

    SET @Discount = (@Amount * @Rate) / 100
END
GO

-- MySQL (Stored Procedure)
DELIMITER $$

CREATE PROCEDURE sp_OrderStatus (
    IN p_amount DECIMAL(10,2),
    OUT p_status VARCHAR(20)
)
BEGIN
    DECLARE v_discount INT DEFAULT 0;

    IF p_amount >= 10000 THEN
        SET v_discount = 10;
        SET p_status = 'PLATINUM';
    ELSEIF p_amount >= 5000 THEN
        SET v_discount = 5;
        SET p_status = 'GOLD';
    ELSE
        SET p_status = 'SILVER';
    END IF;
END$$

DELIMITER ;
--
CALL sp_OrderStatus(8000, @status);
SELECT @status;

-- PostgreSQL (PL/pgSQL)
CREATE OR REPLACE PROCEDURE sp_calculate_tax(
    IN p_amount NUMERIC,
    OUT p_tax NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rate NUMERIC;
BEGIN
    IF p_amount >= 10000 THEN
        v_rate := 18;
    ELSIF p_amount >= 5000 THEN
        v_rate := 12;
    ELSE
        v_rate := 5;
    END IF;

    p_tax := (p_amount * v_rate) / 100;
END;
$$;

-- Execute
CALL sp_calculate_tax(9000, NULL);

-- SQL Server – WHILE Loop
DECLARE @i INT = 1
WHILE @i <= 5
BEGIN
    PRINT @i
    SET @i += 1
END

-- MySQL – WHILE Loop
WHILE i <= 5 DO
    SET i = i + 1;
END WHILE;

-- PostgreSQL – LOOP
LOOP
    EXIT WHEN i > 5;
    i := i + 1;
END LOOP;


-- Sample Table - Indexing
CREATE TABLE Orders (
    OrderId INT PRIMARY KEY,
    CustomerId INT,
    OrderDate DATE,
    Status VARCHAR(20),
    Amount DECIMAL(10,2)
);

-- SQL Server Indexing
-- 1.1 Clustered Index
CREATE CLUSTERED INDEX IX_Orders_OrderDate
ON Orders (OrderDate);
-- Query Uses Clustered Index
SELECT *
FROM Orders
WHERE OrderDate = '2025-01-01';


-- 1.2 Non-Clustered Index
CREATE NONCLUSTERED INDEX IX_Orders_CustomerId
ON Orders (CustomerId);
-- Query Uses Non-Clustered Index
SELECT *
FROM Orders
WHERE CustomerId = 101;

-- 1.3 Composite (Multi-Column) Index
CREATE NONCLUSTERED INDEX IX_Orders_Customer_Status
ON Orders (CustomerId, Status);

-- Query Uses Composite Index
SELECT *
FROM Orders
WHERE CustomerId = 101 AND Status = 'PAID';


-- Does NOT use index efficiently
SELECT *
FROM Orders
WHERE Status = 'PAID';

-- 1.4 Included Columns (Covering Index – SQL Server only)
CREATE NONCLUSTERED INDEX IX_Orders_Customer
ON Orders (CustomerId)
INCLUDE (OrderDate, Amount);
-- Query Uses Covering Index
SELECT OrderDate, Amount
FROM Orders
WHERE CustomerId = 101;

-- 1.5 Filtered Index
CREATE NONCLUSTERED INDEX IX_Orders_PaidOnly
ON Orders (OrderDate)
WHERE Status = 'PAID';
-- Query Uses Filtered Index
SELECT *
FROM Orders
WHERE Status = 'PAID'
AND OrderDate >= '2025-01-01';

-- MySQL Indexing (InnoDB)
-- 2.1 Single-Column Index
ALTER TABLE Orders
ADD PRIMARY KEY (OrderId);

-- 2.2 Secondary Index
CREATE INDEX IX_Orders_CustomerId
ON Orders (CustomerId);
-- Usage
SELECT *
FROM Orders
WHERE CustomerId = 101;

-- 2.3 Composite Index
CREATE INDEX IX_Orders_Customer_Status
ON Orders (CustomerId, Status);
-- Usage
SELECT *
FROM Orders
WHERE CustomerId = 101 AND Status = 'PAID';

-- 2.4 Covering Index (Implicit)
CREATE INDEX IX_Orders_Customer_Amount
ON Orders (CustomerId, Amount);
-- Usage
SELECT Amount
FROM Orders
WHERE CustomerId = 101;


-- 2.5 Prefix Index (String Optimization)
CREATE INDEX IX_Orders_Status
ON Orders (Status(10));


-- PostgreSQL Indexing
-- PostgreSQL does NOT have clustered indexes by default
-- (but supports CLUSTER command)
-- 3.1 B-Tree Index (Default)
CREATE INDEX idx_orders_customer
ON Orders (CustomerId);
-- Usage
SELECT *
FROM Orders
WHERE CustomerId = 101;

-- 3.2 Multi-Column Index
CREATE INDEX idx_orders_customer_status
ON Orders (CustomerId, Status);
-- Usage
SELECT *
FROM Orders
WHERE CustomerId = 101 AND Status = 'PAID';

-- 3.3 Partial Index (Very Powerful)
CREATE INDEX idx_orders_paid
ON Orders (OrderDate)
WHERE Status = 'PAID';
-- Usage
SELECT *
FROM Orders
WHERE Status = 'PAID'
AND OrderDate >= '2025-01-01';

-- 3.4 Expression Index
CREATE INDEX idx_orders_year
ON Orders (EXTRACT(YEAR FROM OrderDate));
-- Usage
SELECT *
FROM Orders
WHERE EXTRACT(YEAR FROM OrderDate) = 2025;

-- 3.5 GIN Index (JSON / Array)
CREATE INDEX idx_orders_json
ON Orders
USING GIN (order_details_json);
-- Checking Index Usage
-- SQL server
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- 
SELECT *
FROM Orders
WHERE CustomerId = 101;

-- MySQL
EXPLAIN
SELECT *
FROM Orders
WHERE CustomerId = 101;

-- PostgreSQL
EXPLAIN ANALYZE
SELECT *
FROM Orders
WHERE CustomerId = 101;
