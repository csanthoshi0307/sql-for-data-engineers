### Columnar Databases
## 📌 What is a Columnar Database?
A columnar (column-oriented) database stores data column by column instead of row by row.

- Row Store:
(Date, Region, Product, Amount) stored together
- Column Store:
Date → all values, Region → all values, Product → all values, Amount → all values

This design enables faster analytical queries, especially for large datasets.

# 🧠 Why Columnar Storage is Faster?

1. Reads only required columns
Queries scanning 2 columns do not read unused columns.

2. High compression
Repeated values (Region, Status, Flags) compress extremely well.

3. Batch processing (Vectorized execution)
Processes thousands of rows per CPU instruction.

4. Optimized for aggregation
SUM, COUNT, AVG, GROUP BY are much faster than row-based storage.

# Columnar in SQL Server (Columnstore Index)
SQL Server supports columnar storage using Columnstore Indexes.

Types:

1. Clustered Columnstore Index (CCI)

- Entire table stored in column format
- Used for data warehouse / analytics

2. Nonclustered Columnstore Index (NCCI)

- Columnstore index on top of rowstore table
- Used for hybrid workloads

# ⚙️ Basic Syntax (SQL Server)
Create Clustered Columnstore Index
```
CREATE CLUSTERED COLUMNSTORE INDEX CCI_Sales
ON SalesFact;
```
Create Nonclustered Columnstore Index
```
CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_Sales
ON SalesFact (SaleDate, Region, Amount);
```
# ✅ When to Use Columnar Storage
✔ Reporting systems
✔ Data warehouses
✔ BI dashboards
✔ Aggregation-heavy queries
✔ Historical / time-series data

# ❌ When NOT to Use Columnar Storage
❌ High-frequency inserts (row-by-row)
❌ OLTP systems (orders, payments, logins)
❌ Tables with frequent updates/deletes

# 📊 Typical Use Cases

- Sales & finance analytics
- SAP / ERP reporting tables
- Audit & log analysis
- Monthly / yearly trend reports
- Dashboard backends (Power BI, Tableau)

# 🚀 Performance Example
```
SELECT Region, SUM(Amount)
FROM SalesFact
GROUP BY Region;
```
- Row Store → Scans entire rows
- Columnstore → Scans only Region & Amount columns

Result: ⚡ 10x–100x faster on large data

# 🔎 SQL Server Columnstore Internals (Interview Points)

- Data stored in segments (~1 million rows each)
- Each column compressed separately
- Uses delta store for recent inserts
- Automatically converts delta store → compressed store
- Uses batch mode execution

# 🎯 Advantages Summary
```
| Feature             | Benefit               |
| ------------------- | --------------------- |
| Column-wise storage | Faster scans          |
| Compression         | Less disk + memory    |
| Batch mode          | High CPU efficiency   |
| Ideal for analytics | Excellent performance |
```
## 🧑‍💼 SQL Server Interview Questions (Columnstore Focus)
## Beginner Level
# Q1. What is a columnstore index?
A columnstore index stores data column-wise and is optimized for analytical queries.

# Q2. Difference between rowstore and columnstore?
Rowstore is optimized for transactions; columnstore is optimized for analytics.

# Q3. When should we use columnstore index?
For large tables with aggregation-heavy queries.

## 🔹 Intermediate Level

# Q4. Difference between clustered and nonclustered columnstore index?

Clustered: entire table stored in column format
Nonclustered: columnstore index on top of rowstore table

# Q5. What is batch mode execution?
SQL Server processes rows in batches (not one row at a time), improving CPU efficiency.

# Q6. What is a delta store?
Temporary rowstore used to hold newly inserted rows before compression.

## 🔹 Advanced Level

# Q7. Can we update data in columnstore index?
Yes, but frequent updates are expensive and reduce performance.

# Q8. What is segment elimination?
SQL Server skips entire segments based on metadata (min/max values).

# Q9. Can columnstore index coexist with primary key?
Yes, usually primary key is a nonclustered index with columnstore.

# Q10. Columnstore vs Partitioning?

Columnstore: storage optimization
Partitioning: data management & pruning
Best performance comes when both are combined.
