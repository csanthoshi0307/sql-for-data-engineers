### MATERIALIZED VIEWS (for PostgreSQL)
# 🔹 What is a Materialized View? (Quick Recap)

A materialized view:

- Stores the query result physically
- Improves read performance
- Needs manual or scheduled refresh

# 🔹 PostgreSQL vs MySQL
```
| Feature           | PostgreSQL            | MySQL        |
| ----------------- | --------------------- | ------------ |
| Materialized View | ✔ Native              | ❌ Not native |
| Refresh           | ✔ Manual / Concurrent | ❌            |
| Index Support     | ✔ Yes                 | ❌            |
```

# MySQL Alternative

Use:

- Summary tables
- Scheduled jobs=
- Triggers

# 🔹 Advantages of Materialized Views

✔ Very fast reads
✔ Ideal for reporting
✔ Can be indexed
✔ Reduces load on base tables

# 🔹 Disadvantages
```
❌ Data can be stale
❌ Refresh cost
❌ Uses storage
❌ Not good for real-time data
```

## 🔹 Interview Questions (Materialized Views)
# 1️⃣ Why materialized view instead of normal view?

Answer:
To improve performance by storing precomputed results.

# 2️⃣ How do you keep data fresh?

Answer:
Using REFRESH MATERIALIZED VIEW manually or scheduled jobs.

# 3️⃣ Can materialized views be updated?

Answer:
No. They are refreshed, not updated row by row.

# 4️⃣ Can we index materialized views?

Answer:
Yes, PostgreSQL supports indexing materialized views.

# 5️⃣ When NOT to use materialized views?

Answer:
For real-time transactional data.

# 🔹 Real-World Use Cases
```
✔ Monthly finance reports
✔ SAP posting summaries
✔ POS sales dashboards
✔ BI tools (Power BI, Tableau)
✔ Heavy aggregation queries
```
# 🔹Materialized Views in MS SQL Server
In MS SQL Server, materialized views are called:

👉 Indexed Views

SQL Server may automatically use the indexed view for queries on Orders if beneficial.

They:

- Physically store data
- Persist query results
- Improve performance
- Are automatically maintained by SQL Server

```
| Feature       | SQL Server (Indexed View) | PostgreSQL        |
| ------------- | ------------------------- | ----------------- |
| Name          | Indexed View              | Materialized View |
| Data Storage  | ✔ Yes                     | ✔ Yes             |
| Refresh       | Auto-maintained           | Manual            |
| Index Support | ✔ Yes                     | ✔ Yes             |
| Realtime      | ✔ Always fresh            | ❌ Can be stale    |
```

## 🔹 Important SQL Server Rules (Interview Favorite)

# ✔ Mandatory Requirements

- WITH SCHEMABINDING
- Deterministic functions only
- COUNT_BIG(*) for aggregates
- Unique clustered index required
- No LEFT JOIN, OUTER JOIN
- No DISTINCT
- No subqueries

# 🔹 Pros of Indexed Views (SQL Server)
```
✔ Always up-to-date
✔ Very fast read queries
✔ No manual refresh
✔ Transparent to queries
```
# 🔹 Cons of Indexed Views
```
❌ Slower INSERT / UPDATE / DELETE
❌ Strict creation rules
❌ Higher maintenance cost
```
# 🔹 When to Use Indexed Views
```
✔ Reporting on large tables
✔ Heavy aggregations
✔ Read-heavy workloads
✔ BI dashboards
```
🔹 Interview Questions (SQL Server)
# 1️⃣ What is materialized view in SQL Server?

Answer:
Indexed View.

# 2️⃣ How does SQL Server keep indexed views updated?

Answer:
Automatically during base table DML operations.

# 3️⃣ Why COUNT_BIG is mandatory?

Answer:
To support large row counts and maintain determinism.

# 🔹 Real-World Tip (ERP / Finance)

* Use Indexed Views for:
- Monthly sales
- Ledger summaries
- POS transaction aggregates

* Avoid for:
- High-frequency OLTP inserts