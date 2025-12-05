### 📌 SQL Set Operators — ETL Theory Notes

Set operators allow combining the results of multiple queries in the same way mathematical sets work.
They are especially powerful in ETL when comparing datasets, merging outputs from different sources, or performing data reconciliation.

The primary SQL set operators are:

UNION

UNION ALL

EXCEPT

INTERSECT

### 🔹 1. UNION

Purpose:
Combine results of two query result sets while removing duplicates.

ETL Use Case:
When merging datasets from different sources and you want a unique list of records.

Behavior:

Eliminates duplicate rows

Performs sorting internally → can be slightly slower

Requires both queries to have same number & order of columns

### 🔹 2. UNION ALL

Purpose:
Combine results of two queries without removing duplicates.

ETL Use Case:
Useful for appending data from multiple logs, batches, or partitions where duplicates are meaningful.

Behavior:

Faster than UNION (no de-duplication)

Preserves duplicates

Often used in ETL pipelines before applying transformations or aggregations

### 🔹 3. EXCEPT

Purpose:
Return rows that exist in the first query but not in the second.

ETL Use Case:
Perfect for change detection, identifying:

Records missing in the target dataset

Deleted/obsolete entries

Mismatches between two systems

Behavior:

Removes duplicates

Order of queries matters: A EXCEPT B ≠ B EXCEPT A

### 🔹 4. INTERSECT

Purpose:
Return rows that are common to both query result sets.

ETL Use Case:
Useful for:

Identifying overlapping data between two sources

Validating consistency

Finding records present in both staging and production datasets

Behavior:

Removes duplicates

Only returns values appearing in both queries

### 📘 Summary: Set Operators in ETL Context
Operator	Returns	                            Removes Duplicates	    Typical ETL Purpose
UNION	    All rows from both queries	            ✔ Yes	            Merge datasets while keeping unique records
UNION ALL	All rows from both queries	            ❌ No	           Append datasets, keep duplicates
EXCEPT	    Rows in first query not in second	    ✔ Yes	            Detect missing or changed records
INTERSECT	Common rows between both queries	    ✔ Yes	            Validate overlapping or consistent data

### 📌 Key Rules for All Set Operators

Both queries must return the same number of columns.

Corresponding columns must have compatible data types.

Column names in the result set come from the first query.

ORDER BY can only be applied after the full set operation.  