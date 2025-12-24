-- UPSERT = UPDATE if row exists, otherwise INSERT
-- Sample Tables (Used in all examples)
CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY,
    Name        VARCHAR(50),
    Email       VARCHAR(100),
    UpdatedAt   DATETIME
);

-- Incoming data (new or changed):
CREATE TABLE StagingCustomers (
    CustomerId INT,
    Name        VARCHAR(50),
    Email       VARCHAR(100)
);


-- BEGINNER LEVEL
-- Simple UPSERT (MySQL / PostgreSQL style)
-- MySQL – INSERT ... ON DUPLICATE KEY UPDATE
INSERT INTO Customers (CustomerId, Name, Email, UpdatedAt)
VALUES (1, 'John', 'john@mail.com', NOW())
ON DUPLICATE KEY UPDATE
    Name = VALUES(Name),
    Email = VALUES(Email),
    UpdatedAt = NOW();
-- If CustomerId = 1 exists → UPDATE
-- If not → INSERT

-- PostgreSQL – ON CONFLICT
INSERT INTO Customers (CustomerId, Name, Email, UpdatedAt)
VALUES (1, 'John', 'john@mail.com', NOW())
ON CONFLICT (CustomerId)
DO UPDATE SET
    Name = EXCLUDED.Name,
    Email = EXCLUDED.Email,
    UpdatedAt = NOW();
-- EXCLUDED = incoming row

-- SQL Server (Beginner Way – IF EXISTS)
IF EXISTS (SELECT 1 FROM Customers WHERE CustomerId = 1)
BEGIN
    UPDATE Customers
    SET Name = 'John',
        Email = 'john@mail.com',
        UpdatedAt = GETDATE()
    WHERE CustomerId = 1;
END
ELSE
BEGIN
    INSERT INTO Customers (CustomerId, Name, Email, UpdatedAt)
    VALUES (1, 'John', 'john@mail.com', GETDATE());
END


-- INTERMEDIATE LEVEL
-- SQL Server MERGE (Most Common Interview Topic)
-- Basic MERGE Example
MERGE Customers AS target
USING StagingCustomers AS source
ON target.CustomerId = source.CustomerId

WHEN MATCHED THEN
    UPDATE SET
        target.Name = source.Name,
        target.Email = source.Email,
        target.UpdatedAt = GETDATE()

WHEN NOT MATCHED THEN
    INSERT (CustomerId, Name, Email, UpdatedAt)
    VALUES (source.CustomerId, source.Name, source.Email, GETDATE());
-- MATCHED → UPDATE
-- NOT MATCHED → INSERT

-- MERGE with DELETE (Intermediate)
MERGE Customers AS target
USING StagingCustomers AS source
ON target.CustomerId = source.CustomerId

WHEN MATCHED THEN
    UPDATE SET
        target.Name = source.Name,
        target.Email = source.Email

WHEN NOT MATCHED BY TARGET THEN
    INSERT (CustomerId, Name, Email, UpdatedAt)
    VALUES (source.CustomerId, source.Name, source.Email, GETDATE())

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
-- NOT MATCHED BY SOURCE → DELETE

-- MERGE with Conditional Update
WHEN MATCHED 
AND (
    target.Name <> source.Name OR
    target.Email <> source.Email
)
THEN UPDATE SET
    target.Name = source.Name,
    target.Email = source.Email,
    target.UpdatedAt = GETDATE();

-- MERGE with OUTPUT (Very Useful in Real Projects)
MERGE Customers AS target
USING StagingCustomers AS source
ON target.CustomerId = source.CustomerId

WHEN MATCHED THEN
    UPDATE SET Name = source.Name

WHEN NOT MATCHED THEN
    INSERT (CustomerId, Name, Email, UpdatedAt)
    VALUES (source.CustomerId, source.Name, source.Email, GETDATE())

OUTPUT
    $action AS ActionType,
    inserted.CustomerId,
    inserted.Name;

-- 