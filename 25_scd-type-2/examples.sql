-- SCD Type 2 (Slowly Changing Dimension Type 2) — SQL Examples
-- Core Idea
-- Keep multiple versions of a dimension record
-- Track:
-- EffectiveStartDate
-- EffectiveEndDate
-- IsCurrent flag (Y/N or 1/0)
-- Old record → closed
-- New record → active

-- Dimension Table Design
CREATE TABLE DimCustomer (
    CustomerSK INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    CustomerBK INT,                           -- Business Key
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    Email VARCHAR(100),
    EffectiveStartDate DATE,
    EffectiveEndDate DATE,
    IsCurrent CHAR(1)
);


-- Source (Staging) Table
CREATE TABLE StgCustomer (
    CustomerBK INT,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    Email VARCHAR(100)
);

-- Initial Load (First Time)
INSERT INTO DimCustomer (
    CustomerBK,
    CustomerName,
    City,
    Email,
    EffectiveStartDate,
    EffectiveEndDate,
    IsCurrent
)
SELECT
    CustomerBK,
    CustomerName,
    City,
    Email,
    GETDATE(),
    '9999-12-31',
    'Y'
FROM StgCustomer;

-- Detect Changes (Compare Source vs Current Records)
SELECT
    s.CustomerBK
FROM StgCustomer s
JOIN DimCustomer d ON s.CustomerBK = d.CustomerBK AND d.IsCurrent = 'Y'
WHERE
    ISNULL(s.CustomerName,'') <> ISNULL(d.CustomerName,'')
 OR ISNULL(s.City,'') <> ISNULL(d.City,'')
 OR ISNULL(s.Email,'') <> ISNULL(d.Email,'');

-- Step 1: Expire Old Records
UPDATE d
SET
    EffectiveEndDate = DATEADD(DAY, -1, GETDATE()),
    IsCurrent = 'N'
FROM DimCustomer d
JOIN StgCustomer s ON s.CustomerBK = d.CustomerBK
WHERE d.IsCurrent = 'Y'
  AND (
        ISNULL(s.CustomerName,'') <> ISNULL(d.CustomerName,'')
     OR ISNULL(s.City,'') <> ISNULL(d.City,'')
     OR ISNULL(s.Email,'') <> ISNULL(d.Email,'')
  );

-- Step 2: Insert New Version
INSERT INTO DimCustomer (
    CustomerBK,
    CustomerName,
    City,
    Email,
    EffectiveStartDate,
    EffectiveEndDate,
    IsCurrent
)
SELECT
    s.CustomerBK,
    s.CustomerName,
    s.City,
    s.Email,
    GETDATE(),
    '9999-12-31',
    'Y'
FROM StgCustomer s
LEFT JOIN DimCustomer d
    ON s.CustomerBK = d.CustomerBK
   AND d.IsCurrent = 'Y'
WHERE d.CustomerBK IS NULL   -- New customer
   OR (
        ISNULL(s.CustomerName,'') <> ISNULL(d.CustomerName,'')
     OR ISNULL(s.City,'') <> ISNULL(d.City,'')
     OR ISNULL(s.Email,'') <> ISNULL(d.Email,'')
   );

-- Result Example
-- | CustomerSK | CustomerBK | Name | City | Start Date | End Date   | IsCurrent |
-- | ---------- | ---------- | ---- | ---- | ---------- | ---------- | --------- |
-- | 1          | 1001       | John | NY   | 2024-01-01 | 2024-06-30 | N         |
-- | 2          | 1001       | John | LA   | 2024-07-01 | 9999-12-31 | Y         |
-- -------------------------------------------------------------------------------

-- Single MERGE-Based SCD Type 2 (Advanced)
MERGE DimCustomer AS TARGET
USING StgCustomer AS SOURCE
ON TARGET.CustomerBK = SOURCE.CustomerBK
AND TARGET.IsCurrent = 'Y'

WHEN MATCHED AND (
       ISNULL(TARGET.CustomerName,'') <> ISNULL(SOURCE.CustomerName,'')
    OR ISNULL(TARGET.City,'') <> ISNULL(SOURCE.City,'')
    OR ISNULL(TARGET.Email,'') <> ISNULL(SOURCE.Email,'')
)
THEN UPDATE SET
    TARGET.EffectiveEndDate = DATEADD(DAY, -1, GETDATE()),
    TARGET.IsCurrent = 'N'

WHEN NOT MATCHED BY TARGET
THEN INSERT (
    CustomerBK,
    CustomerName,
    City,
    Email,
    EffectiveStartDate,
    EffectiveEndDate,
    IsCurrent
)
VALUES (
    SOURCE.CustomerBK,
    SOURCE.CustomerName,
    SOURCE.City,
    SOURCE.Email,
    GETDATE(),
    '9999-12-31',
    'Y'
);


-- When to Use SCD Type 2?
-- Use when:
-- - You need audit/history
-- - Reporting requires point-in-time analysis
-- - Regulatory or financial systems
-- Avoid when:
-- - Dimension changes frequently and history isn’t needed