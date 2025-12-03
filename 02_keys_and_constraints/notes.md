📘 SQL Constraints & Joins – Theory Guide

A simple theoretical explanation of important SQL constraints and join types.
This document is useful for learning, revision, or interview preparation.

🔐 1. Primary Key (PK)

A Primary Key uniquely identifies each record in a table.

Key Characteristics:

Must be unique.

Cannot be NULL.

A table can have only one primary key.

Can be single-column or composite.

Composite Primary Key:

A primary key made of multiple columns.
Used when a single column cannot uniquely identify a row.

🔗 2. Foreign Key (FK)

A Foreign Key creates a relationship between two tables.

Purpose:

Ensures referential integrity.

A foreign key value must exist in the referenced primary key column.

Cascade Options:
ON DELETE CASCADE

When a parent record is deleted, all related child records are deleted automatically.

ON UPDATE CASCADE

If a referenced primary key is updated, the foreign key values in the child table update automatically.

Note: Updating primary keys is generally avoided in real systems.

🚫 3. NOT NULL Constraint

Ensures that a column must always have a value.

Why it's useful:

Prevents missing or incomplete data.

Enforces mandatory inputs (e.g., username, product name).

🔄 4. UNIQUE Constraint

Ensures all values in a column (or a set of columns) are distinct.

Characteristics:

Allows one NULL value (unlike primary key).

A table can have multiple UNIQUE constraints.

Composite UNIQUE:

Prevents duplicate combinations of values across multiple columns.
Useful for cases like preventing attendance duplication (same student + same date).

📦 5. DEFAULT Constraint

Automatically assigns a value to a column when no value is provided.

Common Use Cases:

Default timestamps (CURRENT_TIMESTAMP)

Default statuses ('Pending', 'New')

Default numeric values (0.00)

✔️ 6. CHECK Constraint

Ensures column values meet specific logical conditions.

Purpose:

Enforces business rules at the database level.

Example: ensuring total amount is not negative.

🔍 SQL JOIN Types – Theory
🤝 1. INNER JOIN

Returns only rows that have matching values in both tables.

Use case:

Retrieve related data from two tables where a direct match exists.

↩️ 2. LEFT JOIN (Left Outer Join)

Returns:

All rows from the left table

Matching rows from the right table

If no match exists → right-side columns become NULL

Use case:

Find records that may or may not have related entries (e.g., customers with or without orders).

🚫 3. ANTI JOIN (Using NOT EXISTS, NOT IN)

Returns rows from the left table that do not have a matching record in the right table.

Use case:

List entities without activity
(e.g., customers who never placed an order).

Summary table
| Concept         | Purpose                   | Notes                            |
| --------------- | ------------------------- | -------------------------------- |
| **Primary Key** | Unique row identifier     | Cannot be NULL                   |
| **Foreign Key** | Establishes relationships | Enforces referential integrity   |
| **NOT NULL**    | Mandatory column          | No empty values allowed          |
| **UNIQUE**      | Prevent duplicates        | One NULL allowed                 |
| **DEFAULT**     | Auto-fill values          | Good for timestamps and statuses |
| **CHECK**       | Validates logical rules   | Example: value ≥ 0               |
| **INNER JOIN**  | Matching rows only        | Intersection of tables           |
| **LEFT JOIN**   | All left + matched right  | Missing matches → NULL           |
| **ANTI JOIN**   | Rows without match        | Uses `NOT EXISTS`                |
