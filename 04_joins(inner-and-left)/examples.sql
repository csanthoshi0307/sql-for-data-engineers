--  Real ETL use cases: merge datasets
--  using INNER JOIN and LEFT JOIN
--  to combine data from multiple tables.
-- Sample Tables Creation
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
-- Insert Orders Data
INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2024-01-15', 250.00),
(2, 2, '2024-01-17', 450.00),
(3, 1, '2024-02-05', 150.00);
-- Inser Customers rows
INSERT INTO customers (customer_id, customer_name, contact_email) VALUES
(1, 'Alice Johnson', 'alice.jhon@example.com'),
(2, 'Bob Smith', 'bob.smith@test.com'),
(3, 'Charlie Brown', 'charlie@false.com');
-- INNER JOIN Example
-- Retrieve customers with their orders 
SELECT c.customer_name, o.order_id, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;
-- LEFT JOIN Example
-- Retrieve all customers and their orders (if any)
SELECT c.customer_name, o.order_id, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
-- Identify customers without orders
SELECT c.customer_name  
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
-- Clean up: Drop tables
DROP TABLE orders;
DROP TABLE customers;
-- End of ETL use cases with JOINs example