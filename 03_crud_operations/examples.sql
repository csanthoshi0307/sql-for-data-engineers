-- Crud operations examples in SQL
-- Create a new table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0
);

-- Insert data in  table
INSERT INTO products (product_id, product_name, price, stock) VALUES
(1, 'Laptop', 999.99, 10),
(2, 'Smartphone', 499.99, 25),
(3, 'Tablet', 299.99, 15);

-- Read data from table
-- Select all products
SELECT * FROM products;

-- Select products with price greater than 300
SELECT * FROM products WHERE price > 300;

-- Update data in table
UPDATE products
SET stock = stock + 5
WHERE product_id = 1;   

-- Delete data from table
DELETE FROM products
WHERE product_id = 3;   

-- Drop the table
DROP TABLE products;
