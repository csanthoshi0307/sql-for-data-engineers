## 1. Transactions in SQL Server

A transaction in SQL Server is a logical unit of work that groups one or more database operations and ensures they execute reliably.

# Key Properties (ACID)

- Atomicity
All operations within a transaction succeed or fail together.

- Consistency
The database moves from one valid state to another valid state.

- Isolation
Concurrent transactions do not interfere with each other.

- Durability
Once committed, changes persist even after system failure.

Transaction States

- Active – Transaction is executing
- Committed – Changes are permanently saved
- Rolled Back – Changes are undone
- Partially Committed – Waiting to finalize commit

# Why Transactions Matter

- Prevent partial data updates
- Maintain data integrity
- Enable safe concurrent access
- Support error handling and recovery

## 2. Concurrency Problems in SQL Server

When multiple transactions access the same data simultaneously, the following issues may occur:

- Dirty Read
Reading data that has been modified but not yet committed by another transaction.

- Non-Repeatable Read
Reading the same row twice and getting different values due to another committed update.

- Phantom Read
Re-executing a query and seeing new rows inserted by another transaction.

Isolation levels define which of these problems are allowed or prevented.

## 3. Isolation Levels in SQL Server

SQL Server supports five isolation levels, ranging from least restrictive to most restrictive.

1. READ UNCOMMITTED

- Lowest isolation level
- Allows dirty reads
- No shared locks are issued
- Highest concurrency, lowest data accuracy

Use case: Reporting or analytics where slight inconsistencies are acceptable

2. READ COMMITTED (Default)

- Prevents dirty reads
- Allows non-repeatable reads and phantom reads
- Uses shared locks released immediately after reading

Use case: Most OLTP applications

3. REPEATABLE READ

- Prevents dirty reads and non-repeatable reads
- Allows phantom reads
- Holds shared locks on read rows until transaction completes

Use case: When consistent row values are required

4. SERIALIZABLE

- Highest isolation level
- Prevents dirty, non-repeatable, and phantom reads
- Uses range locks
- Lowest concurrency, highest consistency

Use case: Financial, inventory, and critical transactional systems

5. SNAPSHOT

- Uses row versioning instead of locks
- Provides a consistent snapshot of data
- Prevents all read anomalies
- Requires database-level configuration
Use case: High-concurrency systems requiring consistency without blocking

## 4. Isolation Levels vs Concurrency Issues
```
| Isolation Level  | Dirty Reads | Non-Repeatable Reads | Phantom Reads |
| ---------------- | ----------- | -------------------- | ------------- |
| READ UNCOMMITTED | Allowed     | Allowed              | Allowed       |
| READ COMMITTED   | Prevented   | Allowed              | Allowed       |
| REPEATABLE READ  | Prevented   | Prevented            | Allowed       |
| SERIALIZABLE     | Prevented   | Prevented            | Prevented     |
| SNAPSHOT         | Prevented   | Prevented            | Prevented     |
```
## 5. Locking vs Row Versioning
Lock-Based Isolation

- READ UNCOMMITTED
- READ COMMITTED
- REPEATABLE READ
SERIALIZABLE

Locks block other transactions and may cause contention.

Version-Based Isolation
- SNAPSHOT
- READ COMMITTED SNAPSHOT (RCSI)

Uses tempdb row versions to improve concurrency and reduce blocking.

## 6. Best Practices

- Use the lowest isolation level that satisfies business requirements
- Avoid long-running transactions
- Prefer SNAPSHOT or RCSI for high-concurrency systems
- Use SERIALIZABLE only when strict data correctness is mandatory
- Monitor blocking and deadlocks regularly

## 7. Interview Questions & Answers (SQL Server)
# Basic

1. What is a transaction?
A transaction is a logical unit of work that ensures data consistency using ACID principles.

2. What is the default isolation level in SQL Server?
READ COMMITTED

3. What is a dirty read?
Reading uncommitted data from another transaction.

Intermediate

4. Which isolation level prevents non-repeatable reads?
REPEATABLE READ and higher

5. Which isolation level prevents phantom reads?
SERIALIZABLE and SNAPSHOT

6. What is the difference between READ COMMITTED and SNAPSHOT?
READ COMMITTED uses locks; SNAPSHOT uses row versioning.

# Advanced

7. What is READ COMMITTED SNAPSHOT (RCSI)?
A version-based implementation of READ COMMITTED that reduces blocking.

8. Why is SERIALIZABLE rarely used?
It reduces concurrency and can cause blocking and deadlocks.

9. How does SNAPSHOT isolation improve performance?
By avoiding locks and using row versions stored in tempdb.

10. Can SNAPSHOT cause blocking?
No, but it can fail with update conflicts.