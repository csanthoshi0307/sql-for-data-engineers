-- VIEWS 
-- Use views for read/reporting only
-- Avoid heavy logic inside views if data is huge
-- Add indexes on joined columns (customer_id, order_id)
-- Use materialized views in PostgreSQL for performance-heavy reports
-- CREATE Tables

-- CUSTOMER (Parent Table)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50)
);


-- Product table (Parent Table)
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50)
);

-- Orders Table (FK → Customers) 
-- MySQL
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2),

    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
-- PostgreSQL
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount NUMERIC(10,2),

    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
-- Order Items Table (FK → Orders, Products)
-- MySQL
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_orderitems_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_orderitems_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
-- PostgreSQL
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price NUMERIC(10,2) NOT NULL,

    CONSTRAINT fk_orderitems_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_orderitems_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
-- MySQL & PostgreSQL
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orderitems_order_id ON order_items(order_id);
CREATE INDEX idx_orderitems_product_id ON order_items(product_id);

--- 1: Customer Order Summary View
-- (Customers + Orders)
-- MySQL / PostgreSQL
CREATE VIEW vw_customer_order_summary AS
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_sales
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.city;

-- Usage
SELECT * FROM vw_customer_order_summary;


-- 2: Order Details View
-- (Orders + Order Items + Products)
-- MySQL / PostgreSQL
CREATE VIEW vw_order_details AS
SELECT
    o.order_id,
    o.order_date,
    p.product_name,
    p.category,
    oi.quantity,
    oi.price,
    (oi.quantity * oi.price) AS line_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id;

-- Usage
SELECT * FROM vw_order_details
WHERE order_date >= '2025-01-01';

-- 3: Monthly Sales by Product Category
-- (Orders + Order Items + Products)
-- MySQL / PostgreSQL

-- MySQL doesn’t support DATE_TRUNC, use this instead:
CREATE VIEW vw_monthly_category_sales AS
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m-01') AS sales_month,
    p.category,
    SUM(oi.quantity * oi.price) AS total_sales
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY
    DATE_FORMAT(o.order_date, '%Y-%m-01'),
    p.category;

-- Usage
SELECT * FROM vw_monthly_category_sales
ORDER BY sales_month DESC;


