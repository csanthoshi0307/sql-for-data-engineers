-- Transactions (ACID Basics)
-- ACID
-- Atomicity - all steps succeed or none
-- Consistency - data remains valid
-- Isolation – concurrent transactions don’t interfere
-- Durability – committed data persists

-- Basic Transaction
BEGIN TRAN;

INSERT INTO Accounts(AccountId, Balance)
VALUES (1, 1000);

UPDATE Accounts
SET Balance = Balance - 100
WHERE AccountId = 1;

COMMIT TRAN;   -- saves changes
-- ROLLBACK TRAN; -- undo changes

-- SQL Server Isolation Levels (Lowest ➜ Highest)
-- 1. READ UNCOMMITTED
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRAN;
SELECT * FROM Orders;
COMMIT;

SELECT * FROM Orders WITH (NOLOCK);

-- 2. READ COMMITTED (Default)
-- No dirty reads
-- Non-repeatable & phantom reads possible
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRAN;
SELECT * FROM Orders WHERE OrderId = 10;
COMMIT;

-- 3. REPEATABLE READ
-- Prevents dirty + non-repeatable reads
-- Phantom reads possible
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN TRAN;
SELECT * FROM Orders WHERE CustomerId = 5;
COMMIT;

-- 4. SERIALIZABLE
-- Safest
-- Prevents all read problems
-- Lowest concurrency
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRAN;
SELECT * FROM Orders WHERE CustomerId = 5;
COMMIT;

-- 5. SNAPSHOT (Row Versioning)
-- Reads a consistent snapshot
-- No blocking
-- Requires DB option
ALTER DATABASE MyDB
SET ALLOW_SNAPSHOT_ISOLATION ON;

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

BEGIN TRAN;
SELECT * FROM Orders;
COMMIT;
-- Excellent for high-concurrency systems
-- Common in modern applications

-- Quick Cheat Sheet
-- Check current isolation level
DBCC USEROPTIONS;

-- Start transaction
BEGIN TRAN;

-- Commit
COMMIT;

-- Rollback
ROLLBACK;
