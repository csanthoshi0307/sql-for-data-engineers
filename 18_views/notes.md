## 🔹 What is a SQL View? (Theory)

A VIEW is a virtual table created using a SQL SELECT statement.
It does not store data physically (normal view), but stores the query definition.
```
CREATE VIEW vw_active_customers AS
SELECT customer_id, customer_name
FROM customers
WHERE is_active = 1;
```

When you query a view:
```
SELECT * FROM vw_active_customers;
```

👉 The database executes the underlying SELECT query dynamically.

# 🔹 Key Characteristics of Views
```
✔ Virtual (no data storage)
✔ Based on one or more tables
✔ Can include joins, filters, aggregates
✔ Acts like a table for SELECT
✔ Can restrict data access
```
## 🔹 Types of Views
# 1️⃣ Simple View

- Based on single table
- No aggregates
```
CREATE VIEW vw_customers AS
SELECT customer_id, customer_name FROM customers;
```
# 2️⃣ Complex View

- Multiple tables
- JOINs, GROUP BY, aggregates
```
CREATE VIEW vw_sales_summary AS
SELECT customer_id, SUM(total_amount)
FROM orders
GROUP BY customer_id;
```
# 3️⃣ Materialized View (PostgreSQL, Oracle)

- Stores actual data
- Needs manual/auto refresh
```
CREATE MATERIALIZED VIEW mv_monthly_sales AS
SELECT DATE_TRUNC('month', order_date), SUM(total_amount)
FROM orders
GROUP BY 1;
```
# 4️⃣ Updatable vs Non-Updatable Views

✔ Updatable:

- ingle table
- No GROUP BY, DISTINCT, aggregates

❌ Non-updatable:

- Joins
- Aggregates
- GROUP BY

## 🔹 Advantages of Views
# ✅ 1. Security

Restrict access to sensitive columns.
```
CREATE VIEW vw_public_customers AS
SELECT customer_id, customer_name
FROM customers;
```
Users never see:
- Passwords
- PAN
- Salary

# ✅ 2. Simplifies Complex Queries

Hide JOIN logic.
```
SELECT * FROM vw_order_details;
```
Instead of 3–4 table joins.

# ✅ 3. Reusability

Write once, use everywhere:

- Reports
- APIs
- BI tools

# ✅ 4. Consistent Business Logic

One definition → consistent results.
```
✔ Avoids query duplication
✔ Prevents logic mismatch
```
# ✅ 5. Backward Compatibility

Change table structure without breaking apps.

-- App still uses view
SELECT * FROM vw_customer;

## 🔹 Disadvantages of Views
❌ 1. Performance Overhead

- Views are expanded at runtime
- Complex views → slow queries

⚠ Especially with:

- Multiple joins
- Nested views

❌ 2. Limited Indexing

- Normal views cannot be indexed
- Indexes apply only to base tables

✔ Exception:

- Indexed views (SQL Server)
- Materialized views

❌ 3. Debugging Complexity

- Hard to optimize when:
- View calls another view
- Deep nesting

❌ 4. Update Restrictions

Cannot update:
- Aggregate views
- Join views
```
UPDATE vw_sales_summary SET total = 1000; -- ❌ Invalid
```
❌ 5. Hidden Complexity

- Developers may forget:
- Heavy joins
- Filters inside views

# 🔹 When Should You Use Views?
```
✔ Reporting
✔ Read-heavy queries
✔ Security masking
✔ Shared business logic
✔ BI / Analytics
```
# 🔹 When NOT to Use Views?
```
❌ Heavy transactional logic
❌ High-frequency updates
❌ Performance-critical APIs (without tuning)
```
## 🔹 Interview Questions & Answers
# 1️⃣ What is a view?

Answer:
A view is a virtual table created from a SELECT query that stores only the query definition, not the data.

# 2️⃣ Does a view store data?

Answer:
No, a normal view does not store data. Only materialized views store data.

# 3️⃣ Can we insert/update data through a view?

Answer:
Yes, but only if the view is updatable (single table, no aggregates, no joins).

# 4️⃣ Difference between View and Table?
```
| Table          | View            |
| -------------- | --------------- |
| Stores data    | Stores query    |
| Occupies space | Minimal space   |
| Faster access  | Slight overhead |
| Direct DML     | Limited DML     |
```

# 5️⃣ Difference between View and Materialized View?
```
| View            | Materialized View |
| --------------- | ----------------- |
| No data storage | Stores data       |
| Always fresh    | Needs refresh     |
| Slower          | Faster reads      |
| Lightweight     | Uses space        |

```
# 6️⃣ Are views faster than tables?

Answer:
No. Views execute underlying queries, so performance depends on the base tables and indexes.

# 7️⃣ Can we create index on a view?

Answer:
```
❌ MySQL: No

✔ PostgreSQL: Materialized views

✔ SQL Server: Indexed views
```
# 8️⃣ Why use views instead of queries in application code?

Answer:
For security, reusability, centralized logic, and easier maintenance.

# 9️⃣ Can views improve performance?

Answer:
Indirectly yes (simpler queries), but directly no — except materialized views.

# 🔟 What happens if base table structure changes?

Answer:
View may break if referenced columns are removed or renamed.