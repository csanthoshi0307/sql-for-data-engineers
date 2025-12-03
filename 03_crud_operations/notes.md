### CRUD Operations – Theory Overview

CRUD represents the four fundamental operations performed on data within a relational database: Create, Read, Update, and Delete. These operations allow applications and users to manage records efficiently. Below is a theoretical explanation of each operation along with the purpose of the SQL commands used in typical database workflows.

### 1. Create Operation

The Create operation is used to define new database structures and to add new records.

Creating a Table

A table is created by specifying:

Column names

### Data types (such as INT, VARCHAR, DECIMAL)

### Constraints (such as PRIMARY KEY, NOT NULL, DEFAULT)

This structure forms the blueprint for storing data. In a product-related table, each column stores information such as product ID, name, price, and stock.

### Inserting Records

Once a table exists, new records can be inserted.
The INSERT operation adds rows of data to the table.
Each row represents an individual entity (for example, a product).
Data must match the column data types and respect any constraints defined.

### 2. Read Operation

The Read (or Select) operation retrieves stored data from the database.

It allows:

Fetching all records from a table

Retrieving specific records using conditions

Filtering, sorting, and limiting results

This operation is commonly used to view or analyze stored information, such as listing all products or selecting items that meet particular criteria.

### 3. Update Operation

The Update operation modifies existing records in a table.
It allows changing values of one or more columns for selected rows.

Updates are performed carefully using conditions to ensure only the intended records are changed.
For example, updating stock quantity for a specific product ensures the database reflects accurate inventory levels.

### 4. Delete Operation

The Delete operation removes records from a table.
Conditions are typically used to remove only specific entries, such as deleting a product that is no longer available.

Deletion permanently removes data from the table, so it must be used responsibly.

### 5. Dropping a Table

The Drop operation removes the entire table structure from the database.
This permanently deletes:

All records

The table’s schema

Constraints and indexes

Dropping a table is typically done when the structure is no longer needed.

Summary

CRUD operations enable complete data lifecycle management:

Create → Build table structures and add new data

Read → Retrieve and display stored data

Update → Modify existing data

Delete → Remove unwanted data

Drop → Remove the entire table structure

These concepts form the foundation of working with relational databases and SQL-based applications.