-- Columnar Databases — SQL
-- Sample Table (Used in All Examples)
CREATE TABLE sales (
    sale_date DATE,
    region VARCHAR(50),
    product VARCHAR(50),
    quantity INT,
    amount DECIMAL(10,2)
);

-- Sample data:
INSERT INTO sales VALUES
('2025-01-01','India','Coffee',10,250.00),
('2025-01-01','India','Tea',5,75.00),
('2025-01-02','UAE','Coffee',20,600.00),
('2025-01-02','UAE','Tea',8,120.00);

-- BEGINNER LEVEL SQL (Columnar-Friendly)
-- 1. Select Only Needed Columns (Very Important)
SELECT product, amount
FROM sales;
-- ✅ Fast because only product and amount columns are scanned.

--2️⃣ Filter (WHERE Clause)
SELECT product, amount
FROM sales
WHERE region = 'India';
-- Columnar engines skip unrelated column data

-- 3️⃣ Aggregate Functions (Core Strength)
SELECT SUM(amount) AS total_sales
FROM sales;
-- Extremely fast in columnar databases.

-- 4️⃣ GROUP BY (Most Common Use Case)
SELECT region, SUM(amount) AS total_sales
FROM sales
GROUP BY region;

-- 5️⃣ Date-based Aggregation
SELECT sale_date, SUM(amount) AS daily_sales
FROM sales
GROUP BY sale_date
ORDER BY sale_date;

-- INTERMEDIATE LEVEL SQL
-- 6 GROUP BY Multiple Columns
SELECT region, product, SUM(quantity) AS total_qty
FROM sales
GROUP BY region, product;

-- 7 HAVING (Filter Aggregates)
SELECT region, SUM(amount) AS total_sales
FROM sales
GROUP BY region
HAVING SUM(amount) > 300;

-- Window Functions (Very Common in Analytics)
SELECT
    region,
    sale_date,
    amount,
    SUM(amount) OVER (PARTITION BY region) AS region_total
FROM sales;

-- 9 SELECT
    product,
    SUM(amount) AS total_sales,
    RANK() OVER (ORDER BY SUM(amount) DESC) AS sales_rank
FROM sales
GROUP BY product;

-- 10 Time-Series Analysis
SELECT
    sale_date,
    SUM(amount) AS total_sales,
    SUM(SUM(amount)) OVER (ORDER BY sale_date) AS running_total
FROM sales
GROUP BY sale_date
ORDER BY sale_date;


-- Columnar-Specific Optimization Concepts
-- 11 Avoid SELECT *
-- Bad
SELECT *
FROM sales;

-- Good
SELECT sale_date, amount
FROM sales;


-- 12 Pre-Aggregated Views (Materialized Views)
CREATE MATERIALIZED VIEW sales_by_region AS
SELECT region, SUM(amount) AS total_sales
FROM sales
GROUP BY region;
-- Used heavily in columnar databases.

-- 13 Compression-Friendly Queries
SELECT COUNT(*)
FROM sales
WHERE region = 'UAE';
-- Columnar DBs compress repeated values like region

-- Real-World Analytical Queries
-- 14 Monthly Sales Report
SELECT
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    SUM(amount) AS monthly_sales
FROM sales
GROUP BY year, month
ORDER BY year, month;

-- 15 Top Product per Region
SELECT region, product, total_sales
FROM (
    SELECT
        region,
        product,
        SUM(amount) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(amount) DESC) AS rn
    FROM sales
    GROUP BY region, product
) t
WHERE rn = 1;



