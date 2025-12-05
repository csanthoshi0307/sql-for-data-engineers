-- Weekly Project SQL Script

-- Customers Table
-- Column	Type	Description
-- customer_id	    INT (PK)	    Unique customer identifier
-- customer_name	VARCHAR(100)	Customer full name
-- city	        VARCHAR(100)	Customer city

-- Orders Table
-- Column	Type	Description
-- order_id	    INT (PK)	    Unique order ID
-- customer_id	    INT (FK)	    Links to Customers
-- amount	        DECIMAL	        Order total amount
-- status	        VARCHAR	        Pending / Completed / Cancelled

-- Customers
-- customer_id	    customer_name	city
-- 1	            John Doe	    Chennai
-- 2	            Jane Smith	    Bangalore
-- 3	            Emily Davis	    Mumbai
-- 4	            David Clark	    Chennai

-- Orders
-- order_id	customer_id	    amount	    status
-- 101	            1	           2500	    Completed
-- 102	            1	           1200	    Pending
-- 103	            2	           800	    Completed
-- 104	            3	           1600	    Cancelled
-- 105	            5	           900	    Completed

-- A. INNER JOIN (5 Queries)
--1. Select query to get all orders with their customer name

SELECT o.order_id, o.customer_id, c.customer_name, o.amount, o.status
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;

-- 2. List customers who have placed at least one order.
SELECT DISTINCT c.customer_id, c.customer_name, c.city
FROM customers c
INNER JOIN orders o
  ON c.customer_id = o.customer_id;

-- 3. Retrieve orders above ₹1000 with customer names.
SELECT o.order_id, o.amount, o.status, c.customer_id, c.customer_name
FROM orders o
INNER JOIN customers c
  ON o.customer_id = c.customer_id
WHERE o.amount > 1000;

-- 4. Get customers from Chennai with their orders.
SELECT c.customer_id, c.customer_name, o.order_id, o.amount, o.status
FROM customers c
INNER JOIN orders o
  ON c.customer_id = o.customer_id
WHERE c.city = 'Chennai';

-- 5. Show each order along with customer city.
SELECT o.order_id, o.amount, o.status, c.customer_id, c.customer_name, c.city
FROM orders o
INNER JOIN customers c
  ON o.customer_id = c.customer_id;

-- B. LEFT JOIN (5 Queries)
-- 6. Get all customers and their orders (even if no orders).
SELECT c.customer_id, c.customer_name, c.city, o.order_id, o.amount, o.status
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- 7. List customers who have no orders.
SELECT c.customer_id, c.customer_name, c.city
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 8. Show customers with total order amount (NULL if no orders).
SELECT c.customer_id, c.customer_name, SUM(o.amount) AS total_amount
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- 9. Get customers and number of orders per customer.
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS orders_count
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- 10. Show all customers with latest order (use MAX with GROUP BY + JOIN).
-- (Note: replace MAX(o.order_id) with MAX(order_date) if you add a date column.)
-- find latest order_id per customer
WITH latest AS (
  SELECT customer_id, MAX(order_id) AS latest_order_id
  FROM orders
  GROUP BY customer_id
)
SELECT c.customer_id, c.customer_name, l.latest_order_id, o.amount, o.status
FROM customers c
LEFT JOIN latest l
  ON c.customer_id = l.customer_id
LEFT JOIN orders o
  ON l.latest_order_id = o.order_id;


-- C. RIGHT JOIN (3 Queries)
-- Note: Some DBs (e.g., older MySQL) support RIGHT JOIN; others prefer LEFT JOIN. I provide RIGHT JOIN forms and equivalent LEFT JOIN forms where clearer.

-- 11. Show all orders with customer names (even orphan orders).
-- (Using LEFT JOIN on orders — simpler and portable)
SELECT o.order_id, o.customer_id, c.customer_name, o.amount, o.status
FROM orders o
LEFT JOIN customers c
  ON o.customer_id = c.customer_id;

-- (If you prefer RIGHT JOIN from customers side:)
SELECT o.order_id, o.customer_id, c.customer_name, o.amount, o.status
FROM customers c
RIGHT JOIN orders o
  ON c.customer_id = o.customer_id;

-- 12. Identify orders placed by non-existing customers.
SELECT o.order_id, o.customer_id, o.amount, o.status
FROM orders o
LEFT JOIN customers c
  ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 13. Retrieve orders with customer city (include missing customers).
SELECT o.order_id, o.customer_id, c.customer_name, c.city, o.amount, o.status
FROM orders o
LEFT JOIN customers c
  ON o.customer_id = c.customer_id;

-- D. FULL OUTER JOIN (3 Queries)
-- Note: FULL OUTER JOIN is supported in PostgreSQL, SQL Server, Oracle (as FULL JOIN), but not in MySQL 5.x. If your DB doesn't support FULL JOIN, you can emulate using UNION of LEFT and RIGHT.
-- 14. Get combined list of customers and orders.
SELECT c.customer_id, c.customer_name, c.city, o.order_id, o.amount, o.status
FROM customers c
FULL OUTER JOIN orders o
  ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_id;

-- 15. Display all customers and all orders, marking missing matches.
SELECT
  c.customer_id AS cust_id,
  c.customer_name,
  c.city,
  o.order_id,
  o.customer_id AS order_customer_id,
  o.amount,
  o.status
FROM customers c
FULL OUTER JOIN orders o
  ON c.customer_id = o.customer_id
ORDER BY cust_id, o.order_id;

-- 16. Find mismatched records (customers without orders + orphan orders).
SELECT
  CASE
    WHEN c.customer_id IS NULL THEN 'Orphan Order'
    WHEN o.order_id IS NULL THEN 'Customer Without Orders'
    ELSE 'Matched'
  END AS record_type,
  c.customer_id, c.customer_name, c.city,
  o.order_id, o.customer_id AS order_customer_id, o.amount, o.status
FROM customers c
FULL OUTER JOIN orders o
  ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL OR o.order_id IS NULL;

-- E. CROSS JOIN (2 Queries)
-- 17. Generate all combinations of customers and order statuses (e.g., Pending/Completed/Cancelled).
-- Option A: use a derived table for statuses
SELECT c.customer_id, c.customer_name, s.status
FROM customers c
CROSS JOIN (SELECT 'Pending' AS status UNION ALL SELECT 'Completed' UNION ALL SELECT 'Cancelled') s;
-- Option B: use VALUES (if supported)
 SELECT c.customer_id, c.customer_name, s.status
 FROM customers c
 CROSS JOIN (VALUES ('Pending'), ('Completed'), ('Cancelled')) AS s(status);

-- 18. Create customer × city pairs for segmentation testing.
-- (This is slightly redundant since city is on customer, but if you want all combinations of customers × unique cities:)
-- get distinct cities then cross-join with customers
SELECT c.customer_id, c.customer_name, d.city AS segment_city
FROM customers c
CROSS JOIN (
  SELECT DISTINCT city FROM customers
) d;

-- F. SELF JOIN (2 Queries)
-- Add a manager_id column to customers (example):
-- ALTER TABLE customers ADD COLUMN manager_id INT NULL;
-- Set manager_id values as needed (must reference existing customer_id). Below queries assume that column exists.

-- 19. Show customer + their manager name.
SELECT c.customer_id,
       c.customer_name AS employee_name,
       c.manager_id,
       m.customer_name AS manager_name
FROM customers c
LEFT JOIN customers m
  ON c.manager_id = m.customer_id;

-- 20. List all customers who report under the same manager.
SELECT m.customer_id AS manager_id,
       m.customer_name AS manager_name,
       c.customer_id AS employee_id,
       c.customer_name AS employee_name
FROM customers c
JOIN customers m
  ON c.manager_id = m.customer_id
ORDER BY m.customer_id, c.customer_id;

-- G. UNION / UNION ALL / EXCEPT / INTERSECT (10 Queries)
-- These operate between two SELECT result sets. I used compatible projections for each.

-- A. UNION (2 Queries)
-- 21. Retrieve a combined unique list of all customer names and all order statuses.
SELECT customer_name AS value
FROM customers
UNION
SELECT status AS value
FROM orders;

-- 22. Get a list of all unique cities appearing in Customers and a temp list
SELECT city
FROM customers
UNION
SELECT 'Chennai' AS city
UNION
SELECT 'Delhi' AS city
UNION
SELECT 'Kolkata' AS city;


-- B. UNION ALL (2 Queries)
-- 23. Retrieve customer names and append 'Guest User' three times using UNION ALL.
SELECT customer_name
FROM customers
UNION ALL
SELECT 'Guest User'
UNION ALL
SELECT 'Guest User'
UNION ALL
SELECT 'Guest User';

-- 24. List all order statuses and duplicate them using UNION ALL.
SELECT customer_id
FROM customers
UNION ALL
SELECT customer_id
FROM orders;

-- C. EXCEPT (3 Queries)
-- 25. Find customer IDs that exist in Customers but not in Orders (customers without orders).
SELECT customer_id
FROM customers
EXCEPT
SELECT DISTINCT customer_id
FROM orders;
-- (In MySQL use NOT IN or LEFT JOIN ... WHERE o.customer_id IS NULL since EXCEPT isn't supported.)

-- 26. Find customer cities that are in customer data but not in a reference list (['Chennai','Bangalore']).
SELECT city
FROM customers
EXCEPT
SELECT 'Chennai' AS city
UNION
SELECT 'Bangalore' AS city;
-- (Equivalent with a derived table:)
SELECT city
FROM customers
EXCEPT
(
  SELECT 'Chennai' AS city
  UNION
  SELECT 'Bangalore' AS city
);

-- 27. Identify order customer IDs that are not present in the Customers table (orphan orders).
SELECT customer_id
FROM orders
EXCEPT
SELECT customer_id
FROM customers;
-- (Or using LEFT JOIN)
SELECT DISTINCT o.customer_id
FROM orders o
LEFT JOIN customers c
  ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- D. INTERSECT (3 Queries)
-- 28. Find customer IDs that appear in both Customers and Orders tables
SELECT customer_id
FROM customers
INTERSECT
SELECT DISTINCT customer_id
FROM orders;
-- (Or portable alternative:)
SELECT DISTINCT c.customer_id
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id;

-- 29. Find customer names that are common between Customers and a sample list
SELECT customer_name
FROM customers
INTERSECT
SELECT 'John Doe' AS customer_name
UNION
SELECT 'Emily Davis' AS customer_name;


-- 30. Identify cities where customers have placed at least one order.
SELECT city
FROM customers
WHERE customer_id IN (SELECT DISTINCT customer_id FROM orders)
-- or using INTERSECT
INTERSECT
SELECT city
FROM customers
WHERE customer_id IS NOT NULL;

-- (A clearer version:)
SELECT DISTINCT c.city
FROM customers c
INNER JOIN orders o
  ON c.customer_id = o.customer_id;

-- Final Notes & Small Tips
-- Replace MAX(order_id) with MAX(order_date) in the “latest order” query if you add timestamps.
-- FULL OUTER JOIN, EXCEPT, and INTERSECT are not supported in some DBs (older MySQL); use UNION/LEFT/RIGHT JOIN alternatives if needed.
-- For presentation/README, you can paste these 30 queries under the respective headings. If you want, I can also:
-- Provide expected result sets for each query using your sample data, or
-- Produce a single SQL script that creates the tables, inserts your sample rows, and runs each query with a comment header.
