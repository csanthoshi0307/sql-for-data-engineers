-- Window Functions Intro Ranking Functions (ROW_NUMBER, RANK, LAG, LEAD, Moving Averages)
-- Example SQL queries demonstrating the use of window functions for ranking and moving averages.
-- Sample table creation and data insertion for demonstration
CREATE TABLE sales (
    id INT PRIMARY KEY,
    salesperson VARCHAR(50),
    region VARCHAR(50),
    amount DECIMAL(10, 2),
    sale_date DATE
);
INSERT INTO sales (id, salesperson, region, amount, sale_date) VALUES
(1, 'Alice', 'North', 500.00, '2024-01-10'),
(2, 'Bob', 'South', 300.00, '2024-01-15'),
(3, 'Alice', 'North', 700.00, '2024-01-20'),
(4, 'Charlie', 'East', 400.00, '2024-01-25'),
(5, 'Bob', 'South', 600.00, '2024-01-30'),
(6, 'Alice', 'North', 800.00, '2024-02-05'),
(7, 'Charlie', 'East', 200.00, '2024-02-10');   
-- 1. Using ROW_NUMBER to assign a unique sequential integer to rows within a partition of a result set
SELECT
    id,
    salesperson,
    region,
    amount,
    sale_date,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY amount DESC) AS sales_rank
FROM
    sales;
-- 2. Using RANK to assign a rank to each row within a partition of a result set
SELECT
    id,
    salesperson,
    region,
    amount,
    sale_date,
    RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS sales_rank    
FROM
    sales;
-- 3. Using LAG to access data from a previous row in the same result set
SELECT
    id,
    salesperson,
    region,
    amount,
    sale_date,
    LAG(amount, 1) OVER (PARTITION BY salesperson ORDER BY sale_date) AS previous_sale_amount
FROM
    sales;
-- 4. Using LEAD to access data from a subsequent row in the same result set
SELECT
    id,
    salesperson,
    region,
    amount,
    sale_date,
    LEAD(amount, 1) OVER (PARTITION BY salesperson ORDER BY sale_date) AS next_sale_amount 
FROM
    sales;
-- 5. Calculating a moving average of sales amounts over the last 3 sales for each salesperson
SELECT
    id,
    salesperson,
    region,
    amount,
    sale_date,
    AVG(amount) OVER (PARTITION BY salesperson ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_average_3_sales
FROM
    sales;
-- Clean up
DROP TABLE sales;