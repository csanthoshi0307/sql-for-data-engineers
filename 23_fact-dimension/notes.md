## 🔹 What is Fact & Dimension Design?
Fact & Dimension Design is a data modeling technique used in Data Warehousing to organize data for reporting and analytics, not for transactions.

It focuses on:
- Facts → measurable business events
- Dimensions → descriptive business context
- This design is most commonly implemented as a Star Schema.

## 🔸 Fact Table (Theory)
✔ What is a Fact Table?
A Fact Table stores quantitative data (measures) generated from business processes.

# ✔ Characteristics

- Contains numeric values (sales, quantity, amount)
- Contains foreign keys to dimension tables
- Usually very large (millions/billions of rows)
- Grows continuously over time
- Data is mostly insert-only

# ✔ Types of Fact Tables

1. Transactional Fact
One row per transaction
- Example: each sales bill

2. Periodic Snapshot Fact
Data captured at regular intervals
- Example: daily inventory balance

3. Accumulating Snapshot Fact
Tracks process lifecycle
- Example: order → shipped → delivered

## 🔸 Dimension Table (Theory)
✔ What is a Dimension Table?

A Dimension Table stores descriptive attributes that explain the facts.

# ✔ Characteristics

- Contains textual or categorical data
- Smaller than fact tables
- Used for filtering, grouping, and labeling
- Changes slowly over time

# ✔ Common Dimensions

- Date
- Product
- Customer
- Store / Location
- Employee

# 🔹 Star Schema vs Snowflake Schema
```
| Feature     | Star Schema  | Snowflake Schema |
| ----------- | ------------ | ---------------- |
| Structure   | Simple, flat | Normalized       |
| Performance | Faster       | Slower           |
| Complexity  | Easy         | Complex          |
| Usage       | Preferred    | Rare             |
```
📌 Interview Tip:

Always recommend Star Schema unless normalization is mandatory.

# 🔸 Grain (Very Important Concept)
✔ What is Grain?

Grain defines the level of detail stored in a fact table.

Example:
- One row per bill
- One row per product per bill
- One row per customer per day

📌 Interview Tip:

Grain must be decided before designing the fact table.

🔸 Measures in Fact Table
# Types of Measures

1. Additive
 Can be summed across all dimensions
- Example: SalesAmount

2. Semi-Additive
Cannot be summed across time
- Example: Account balance

3. Non-Additive
Cannot be summed at all
- Example: Percentage

🔸 Slowly Changing Dimensions (SCD)
✔ What is SCD?

When dimension data changes over time, it is handled using SCD techniques.

Types:

- Type 1 → Overwrite old data (no history)
- Type 2 → Create new row (maintain history)
- Type 3 → Limited history using extra column

📌 Most commonly used: SCD Type 2

🔸 Surrogate Key vs Natural Key
```
| Key Type      | Description                        |
| ------------- | ---------------------------------- |
| Natural Key   | Business key (CustomerCode)        |
| Surrogate Key | System-generated key (CustomerKey) |
```

- 📌 Fact tables always use surrogate keys.

🔸 Factless Fact Table
 ✔ What is Factless Fact Table?
A fact table with no numeric measures, only dimension keys.

Example:
- Student attendance
- Promotion eligibility


## 🎯 INTERVIEW QUESTIONS & ANSWERS
## 🟢 BEGINNER LEVEL
# 1️⃣ What is a fact table?
Answer:
A fact table stores measurable business data and foreign keys referencing dimension tables.

# 2️⃣ What is a dimension table?
Answer:
A dimension table stores descriptive attributes that provide context to fact data.

# 3️⃣ What is Star Schema?
Answer:
A schema where a central fact table is connected directly to multiple dimension tables.

# 4️⃣ Difference between Fact and Dimension?
Answer:
Fact tables store numeric measures; dimension tables store descriptive data.

# 5️⃣ Why use Fact & Dimension design?
Answer:
For faster reporting, simplified queries, and better analytics performance.

## 🟡 INTERMEDIATE LEVEL
# 6️⃣ What is grain in data warehouse?
Answer:
Grain defines the level of detail represented by each row in a fact table.

# 7️⃣ Types of fact tables?
Answer:
Transactional, Periodic Snapshot, and Accumulating Snapshot.

# 8️⃣ What are additive and non-additive measures?
Answer:
Additive measures can be summed across all dimensions; non-additive cannot.

# 9️⃣ What is Slowly Changing Dimension?
Answer:
A technique to manage changes in dimension data over time while preserving history.

# 🔟 Difference between Star Schema and Snowflake Schema?
Answer:
Star schema is denormalized and faster; snowflake schema is normalized and complex.

# 1️⃣1️⃣ What is surrogate key and why is it used?
Answer:
A surrogate key is a system-generated key used to uniquely identify dimension records and improve performance.

# 1️⃣2️⃣ What is factless fact table?
Answer:
A fact table without measures, used to track events or relationships.

# 1️⃣3️⃣ Why dimension tables change slowly?
Answer:
Because business attributes (like customer address) do not change frequently.

# ⭐ FINAL INTERVIEW GOLDEN LINES
```
“Facts record business events; dimensions describe the context of those events.”
“Always define the grain before designing the fact table.”
“Star schema is preferred for analytical workloads.”
```