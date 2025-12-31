Data Engineer Theory — Crisp & Practical
## 1️⃣ Data Modeling (Very High Priority)
# ⭐ Star Schema

- One fact table
- Multiple denormalized dimension tables
- Best for BI & analytics

Why interviewers care
```
“Can this person design tables that analysts won’t complain about?”
```
Hands-on you must know
```
FactSales (DateKey, ProductKey, StoreKey, Amount)
DimProduct (ProductKey, Name, Category)
```
# ❄️ Snowflake Schema
- Dimensions normalized
- Saves storage, slightly complex queries
When used
- Very large dimensions
- Master data managed separately
Fact vs Dimension
```
| Fact     | Dimension   |
| -------- | ----------- |
| Measures | Descriptive |
| Large    | Smaller     |
| Additive | Filterable  |
```
Golden rule
- Facts change fast, dimensions change slowly
# 2️⃣ ETL vs ELT (Daily Job Reality)
```
| ETL                   | ELT                            |
| --------------------- | ------------------------------ |
| Transform before load | Transform after load           |
| Traditional DW        | Cloud DW (Snowflake, BigQuery) |
```
Job skill

- Write MERGE / INSERT / UPDATE
- Handle incremental loads
- Validate row counts

# 3️⃣ Slowly Changing Dimensions (SCD) ⭐⭐⭐⭐⭐
SCD Types (Interview Favorite)
```
| Type   | Meaning         | Usage       |
| ------ | --------------- | ----------- |
| Type 1 | Overwrite       | Corrections |
| Type 2 | History         | Auditing    |
| Type 3 | Limited history | Rare        |
```

SCD Type 2 Core Theory

- Never update old data
- Close old record
- Insert new record

- IsCurrent = 1
- StartDate / EndDate

Interview line
```
“We preserve business history using SCD Type 2.”
```
# 4️⃣ MERGE / UPSERT (Production Skill)
Why MERGE is critical
- Incremental loads
- Idempotent jobs
- Avoid duplicates
```
MERGE target
USING source
WHEN MATCHED THEN UPDATE
WHEN NOT MATCHED THEN INSERT
```
Real-world
- Run daily/hourly jobs
- Handle late-arriving data

# 5️⃣ Partitioning (Performance Savior)
What is Partitioning?

Split large table physically by:
- Date
- Region
- Tenant
Why
- Faster queries
- Archiving
- Manage TB-scale tables
Interview phrase
```
“Partition by date to enable partition pruning.”
```
# 6️⃣ Columnar Databases (Analytics Engine)
```
| Row Store       | Column Store     |
| --------------- | ---------------- |
| OLTP            | Analytics        |
| Row-by-row      | Column-by-column |
| Slow aggregates | Fast aggregates  |
```
Hands-on
```
CREATE CLUSTERED COLUMNSTORE INDEX

```
Real-life
- Fact tables → Columnstore
- Dimensions → Rowstore

# 7️⃣ Transactions & Isolation Levels (Data Safety)
ACID
- Atomicity
- Consistency
- Isolation
- Durability

Isolation Levels (Must Know)
```
| Level            | Dirty Read |
| ---------------- | ---------- |
| READ UNCOMMITTED | ❌ Yes      |
| READ COMMITTED   | ✅ No       |
| SERIALIZABLE     | ✅ No       |
| SNAPSHOT         | ✅ No       |

```
Job usage
- OLTP → READ COMMITTED
- Analytics → SNAPSHOT

# 8️⃣ Indexing (Silent Performance Booster)
Types
- Clustered
- Non-clustered
- Columnstore

Rule
- Index filter columns
- Avoid over-indexing facts

# 9️⃣ Data Quality & Validation (Job Survival Skill)

Checks you must always add
- Row count
- Null check
- Duplicate check

Reconciliation totals
```
SELECT COUNT(*) FROM Staging;
SELECT COUNT(*) FROM Target;
```

Interview gold
```
“I never deploy ETL without data validation.”
```
# 🔟 Incremental Loading Strategy
Methods
- Watermark (last_updated)
- CDC
- Hash comparison
```
WHERE ModifiedDate > @LastRunDate
```
#  1️⃣1️⃣ Performance Tuning Basics
```
| Problem      | Fix                |
| ------------ | ------------------ |
| Slow queries | Partition + Index  |
| High CPU     | Columnstore        |
| Blocking     | Snapshot isolation |
| Long loads   | Batch inserts      |
```


# 1️⃣2️⃣ Real-World Mindset (VERY IMPORTANT)

💡 Data Engineer ≠ SQL Writer
💡 Data Engineer = Data Reliability Engineer

Your daily responsibilities
- Fix failed pipelines
- Handle late data
- Optimize slow reports
- Support BI users
- Maintain historical accuracy

## 🎯 Top Interview Questions (Rapid Fire)

# Q: Difference between Fact & Dimension?
→ Facts store measures, dimensions store context.

# Q: Why SCD Type 2?
→ To track historical changes.

# Q: How do you optimize a 1B row table?
→ Partition + Columnstore + selective indexes.

# Q: How do you avoid duplicate loads?
→ MERGE with business keys.

# Q: OLTP vs OLAP?
→ Transactions vs analytics.

# 🧾 10-Minute Revision Plan
1. Revise Star vs Snowflake
2. Memorize SCD Type 2 flow
3. Understand MERGE logic
4. Partition pruning concept
5. Columnstore benefits
6. Isolation levels use cases
