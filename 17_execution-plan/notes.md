### 🔷 SQL Execution Plan – Theory & Interview Guide
## 1️⃣ What is an Execution Plan?
Definition (Interview Answer):
An Execution Plan is a roadmap created by the SQL optimizer that shows how the database engine will retrieve data, including:

- Access method (Scan / Seek)
- Join strategy
- Index usage
- Estimated cost
- Memory & CPU usage

📌 SQL is declarative → you say what you want, not how.
The optimizer decides the “how”.

## 2️⃣ Types of Execution Plans
🔹 Estimated Execution Plan

- Generated without executing the query
- Based on statistics
- Faster to generate
- May be inaccurate
```
SET SHOWPLAN_XML ON;
```
🔹 Actual Execution Plan

- Generated after execution
- Shows real row counts
- Includes runtime metrics
```
SET STATISTICS PROFILE ON;
```
Tip: Always trust Actual Plan over Estimated Plan.

## 3️⃣ Query Lifecycle (Important Theory)
```
SQL Query
   ↓
Parser (Syntax check)
   ↓
Algebrizer (Objects & permissions)
   ↓
Query Optimizer
   ↓
Execution Plan
   ↓
Storage Engine

```
🔹 Optimizer tries multiple plans
🔹 Picks the lowest cost plan
## 4️⃣ Cost-Based Optimizer (CBO)
SQL Server uses a Cost-Based Optimizer

- Cost Factors
- CPU cost
- I/O cost
- Memory cost
- Estimated rows
📌 Cost ≠ Time
Cost is an internal unit, not milliseconds.

## 5️⃣ Core Execution Plan Operators (VERY IMPORTANT)
🔹 Table Access Operators
```
| Operator   | Meaning            | Interview View          |
| ---------- | ------------------ | ----------------------- |
| Table Scan | Reads entire table | ❌ Bad for large tables |
| Index Scan | Reads full index   | ⚠️ Acceptable sometimes |
| Index Seek | Direct access      | ✅ Best                 |
```
🔹 Join Operators
```
| Join Type   | When Used           |
| ----------- | ------------------- |
| Nested Loop | Small data          |
| Hash Match  | Large unsorted data |
| Merge Join  | Sorted inputs       |
```
📌 Optimizer chooses join, not query order.
🔹 Lookup Operator

Key Lookup

- Happens when index does not cover query
- Executes once per row

❌ Red flag inside loops

## 6️⃣ Estimated vs Actual Rows (Critical Concept)
```
| Scenario          | Effect       |
| ----------------- | ------------ |
| Accurate estimate | Good plan    |
| Under-estimate    | Memory spill |
| Over-estimate     | Slow joins   |
```
📌 Mismatch usually due to:

- Outdated statistics
- Parameter sniffing
- Skewed data

## 7️⃣ Statistics (Optimizer’s Brain)
Statistics contain:

- Row count
- Data distribution (histogram)
- Density
```
UPDATE STATISTICS Orders;
```
📌 Without good stats → bad plan

## 8️⃣ Index Impact on Execution Plans
❌ Bad Pattern
```
WHERE YEAR(OrderDate) = 2024
```
✅ Good Pattern
```
WHERE OrderDate >= '2024-01-01'
AND OrderDate < '2025-01-01'
```
📌 Functions on columns = Index not usable
## 9️⃣ Covering Index
Definition:
An index that contains all columns needed by a query.
```
CREATE INDEX IX_Cover
ON Orders(CustomerId)
INCLUDE (OrderDate, TotalAmount);
```
Result
- No Key Lookup
- Faster execution

## 🔟 Parameter Sniffing
What is it?

First execution plan cached

Reused for all parameter values

Problem

- Works well for some parameters
- Poor for others

Fixes

- OPTION (RECOMPILE)
- Local variables
- Dynamic SQL

## 1️⃣1️⃣ Common Execution Plan Warnings 🚨
```
| Warning             | Meaning             |
| ------------------- | ------------------- |
| Missing Index       | Query could benefit |
| Spill to TempDB     | Insufficient memory |
| Implicit Conversion | Data type mismatch  |
| Parallelism         | CPU heavy           |

```
## 1️⃣2️⃣ Parallelism in Execution Plan

Multiple threads

Controlled by MAXDOP

📌 Parallelism is not always good
Context switching can slow queries.

## 1️⃣3️⃣ Execution Plan Reading Order

📌 Read RIGHT → LEFT

Because data flows from leaf operators to root.

## 1️⃣4️⃣ Execution Plan vs Query Rewrite

❌ Do not trust query text order
✔ Trust execution plan operators

### 🎯 INTERVIEW QUESTIONS & ANSWERS
# Q1. What is an execution plan?

It shows how SQL Server retrieves data, including index usage, joins, and estimated cost.

# Q2. Difference between Estimated and Actual Plan?
```
| Estimated      | Actual         |
| -------------- | -------------- |
| No execution   | Executes query |
| Based on stats | Real metrics   |
| Faster         | Accurate       |
```
# Q3. What causes Table Scan?

Missing index
Small table
Poor selectivity

# Q4. When does SQL Server choose Hash Join?

- Large datasets
- No useful indexes

# Q5. What is a Key Lookup?

Fetching missing columns from clustered index after index seek.

# Q6. What is parameter sniffing?

Plan optimized for first parameter reused for others.

# Q7. What causes poor cardinality estimation?
- Outdated stats
- Data skew
- Functions on columns

# Q8. What is a covering index?

Index that satisfies the query without lookup.

# Q9. What is cost in execution plan?

Internal estimate of resource usage.

# Q10. Why Estimated rows ≠ Actual rows?

Bad statistics or wrong assumptions by optimizer.

# Q11. How do you identify performance issues from plan?

- Table scans
- Key lookups
- Row mismatch
- Memory spills

# Q12. Can SQL ignore an index?

Yes — if optimizer decides scan is cheaper.

## 🔚 FINAL INTERVIEW ONE-LINER
```
“Execution plans help us understand how SQL Server executes a query and where performance bottlenecks occur, mainly around scans, joins, and incorrect row estimations.”
```