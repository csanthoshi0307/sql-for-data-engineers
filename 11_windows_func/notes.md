### 📘 Window Functions – Theory Overview

Window functions in SQL allow you to perform calculations across a set of rows related to the current row without collapsing the result into a single value (unlike aggregate functions).
They enable advanced analytics such as ranking, running totals, comparisons across rows, and moving averages.

A window function works using:

-- PARTITION BY → divides rows into groups (like GROUP BY but without reducing rows)

-- ORDER BY → defines the order of rows inside each partition

-- FRAME clause → (optional) defines the sliding window for calculations (e.g., last N rows)

### 🔹 1. ROW_NUMBER()

Purpose: Assigns a unique sequential number to each row within a partition.

Key characteristics:

Always increments by 1, even when values are tied.

No duplicates in ranking.

Useful for:

Pagination

Selecting the “first” or “latest” record per group

Removing duplicates

### 🔹 2. RANK()

Purpose: Assigns ranking based on ordering, allowing ties.

Key characteristics:

Rows with identical values receive the same rank.

The next rank number is skipped (gaps appear).

Useful when equal values should have equal importance.

### 🔹 3. LAG()

Purpose: Accesses a value from a previous row in a partition.

Use cases:

Comparing current value with previous value

Calculating change/difference

Trend analysis

Time-based comparisons (e.g., previous month)

### 🔹 4. LEAD()

Purpose: Accesses a value from a following row in a partition.

Use cases:

Forecasting

Comparing current row with the next row

Identifying upcoming trends or values

### 🔹 5. Moving Averages (Window Aggregates)

Purpose: Computes an average over a defined sliding window of rows (e.g., last 3 rows).

Key characteristics:

Does NOT reduce the number of rows.

Helps smooth fluctuations in time-series or sales data.

Frame examples:

ROWS BETWEEN 2 PRECEDING AND CURRENT ROW → last 3 sales

ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW → running total/average

### Common use cases:

Sales trend analysis

Stock price smoothing

Rolling performance tracking

Running totals / cumulative metrics

✔️ Summary of What Window Functions Enable
```
Function	                Purpose	                    Handles Ties?	    Typical Use
ROW_NUMBER()	            Sequential numbering	    ❌ No	       Deduplication, pagination
RANK()	                    Ranking with gaps	        ✔️ Yes	        Leaderboards, competition ranking
LAG()	                    Get previous row value	        –	        Compare with past
LEAD()	                    Get next row value	            –	        Compare with future
Moving Average (AVG OVER)	Rolling/Sliding calculations	–	        Trend smoothing
```