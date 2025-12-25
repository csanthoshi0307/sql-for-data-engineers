### SCD Type 2 (Slowly Changing Dimension Type 2) — SQL Examples

SCD Type 2 is used in data warehousing to preserve full history of dimension changes.
Instead of overwriting old data, we insert a new row for every change and mark the old row as inactive.

# What is SCD Type 2?

SCD Type 2 is a dimensional modeling technique used to track full historical changes in dimension attributes by creating a new row for each change.

👉 Old records are expired, new records are inserted.

# Why SCD Type 2 is Needed?

Because business attributes change over time and history matters.

 Examples
- Customer changes City
- Employee changes Department
- Product changes Category
- Store changes Region
- Without SCD Type 2 → history is lost

# 🔹 Core Idea
- Keep multiple versions of a dimension record
- Track:
1. EffectiveStartDate
2. EffectiveEndDate
3. IsCurrent flag (Y/N or 1/0)
- Old record → closed
- New record → active

# Core Characteristics
```
| Feature  | Description                    |
| -------- | ------------------------------ |
| History  | ✔ Preserved                    |
| Rows     | Multiple rows per business key |
| Keys     | Business Key + Surrogate Key   |
| Tracking | Start Date, End Date           |
| Status   | IsCurrent flag                 |
```

# 🔹 Best Practices
```
✔ Always use Surrogate Keys
✔ Keep 9999-12-31 as open-ended date
✔ Compare only Type-2 columns
✔ Never update history rows
✔ Index (CustomerBK, IsCurrent)
```

# Typical SCD Type 2 Table Structure
```
CustomerSK        -- Surrogate Key (PK)
CustomerBK        -- Business Key (Natural Key)
CustomerName
City
Email
EffectiveStartDate
EffectiveEndDate
IsCurrent
```
How SCD Type 2 Works (Flow)

Load source data into staging
Compare source with current dimension record

If change detected:

Expire old row (IsCurrent = N)
Set EndDate

Insert new row with:
Updated values
IsCurrent = Y
Open-ended end date (9999-12-31)

Example Timeline
```
| Customer | City | Start Date | End Date   | Current |
| -------- | ---- | ---------- | ---------- | ------- |
| John     | NY   | 2023-01-01 | 2024-03-31 | N       |
| John     | LA   | 2024-04-01 | 9999-12-31 | Y       |
```

# Columns Used in SCD Type 2
```
| Column        | Purpose                      |
| ------------- | ---------------------------- |
| Surrogate Key | Unique version identifier    |
| Business Key  | Identifies real-world entity |
| Start Date    | When record became active    |
| End Date      | When record expired          |
| IsCurrent     | Current active record        |
```

# SCD Type 2 vs Type 1
```
| Aspect    | Type 1     | Type 2          |
| --------- | ---------- | --------------- |
| History   | ❌ No       | ✔ Yes           |
| Rows      | 1          | Multiple        |
| Overwrite | Yes        | No              |
| Use Case  | Correction | Audit / History |
```

# When NOT to Use SCD Type 2?
- High-frequency attribute changes
- History not required
- Storage constraints
- Real-time OLTP system

## 🔹 INTERVIEW QUESTIONS & ANSWERS
01. What is Slowly Changing Dimension?
A dimension whose attribute values change slowly over time rather than frequently.

02. What is SCD Type 2?
A technique that tracks historical changes by inserting a new row for each change and expiring the old one.

03. Difference between Business Key and Surrogate Key?
Business Key: Natural identifier (CustomerID)
Surrogate Key: System-generated unique key for each version

04. Why Surrogate Key is mandatory in SCD Type 2?
Because the same business key can have multiple versions, and surrogate key uniquely identifies each row.

05. How do you detect changes in SCD Type 2?
By comparing source data with current records using business key and checking attribute differences.

06. What columns are required for SCD Type 2?
Surrogate Key
Business Key
Start Date
End Date
Current Flag

07. What is 9999-12-31 used for?
To represent an open-ended active record (current version).

08. Can we use MERGE for SCD Type 2?
Yes, but UPDATE + INSERT approach is safer in high-concurrency ETL environments.

09. What happens if no change is detected?
No action — existing record remains current.

10. What happens when a new business key arrives?

A new row is inserted as current record.

11. How do you handle deletes in SCD Type 2?

Common approaches:
Soft delete using IsActive flag
Expire record by setting EndDate

12. What is Type 2 attribute?

An attribute whose history must be preserved (e.g., Address, Department).

13. Can a dimension have both Type 1 and Type 2 columns?

✔ Yes
Some columns overwrite (Type 1), some track history (Type 2).

14. How do fact tables connect to SCD Type 2?

Fact tables store the Surrogate Key, enabling point-in-time analysis.

15.  What are common SCD Type 2 pitfalls?

Forgetting surrogate key
Incorrect end dates
Multiple current records
Not indexing business key + IsCurrent

16.  How do you ensure only one current record exists?

Using:
ETL logic
Constraints or filtered index (IsCurrent = 'Y')

17. SCD Type 2 real-time or batch?
Mostly batch ETL, but possible in micro-batch pipelines.

18.  How do you query current records only?
SELECT *
FROM DimCustomer
WHERE IsCurrent = 'Y';

19.  How do you get historical data for a given date?
SELECT *
FROM DimCustomer
WHERE '2024-05-01'
BETWEEN EffectiveStartDate AND EffectiveEndDate;

20.  Interview One-Line Summary

SCD Type 2 preserves history by inserting new records for every change and expiring old records using dates and flags.
