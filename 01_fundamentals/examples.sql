-- Create table
CREATE TABLE employees (
    emp_id INT,
    name VARCHAR(100),
    salary DECIMAL(10,2),
    dept_id INT
);
-- Columns & Data Types
-- Different column types store different kinds of data.
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(255),
    price DECIMAL(8,2),
    available_from DATE,
    in_stock BOOLEAN
);

-- Primary Key
-- Ensures each row is unique & not null.
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(150)
);

-- Foreign Key
-- Establishes relationship between tables.
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Constraints
-- NOT NULL
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- UNIQUE
-- email VARCHAR(150) UNIQUE

-- CHECK
-- salary DECIMAL(10,2) CHECK (salary > 0)

-- DEFAULT
-- status VARCHAR(20) DEFAULT 'ACTIVE'

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10,2) CHECK (salary > 0),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- CRUD Operations
-- INSERT
INSERT INTO employees (emp_id, name, salary, dept_id)
VALUES (1, 'John Doe', 50000, 10);

 INSERT INTO employees (emp_id, name, salary, dept_id)
VALUES 
(2, 'Mary', 60000, 20),
(3, 'Alex', 55000, 10);

-- UPDATE
UPDATE employees
SET salary = 65000
WHERE emp_id = 2;

-- DELETE 
DELETE FROM employees
WHERE emp_id = 3;

-- Select all employees
SELECT * FROM employees;

-- Filtering
SELECT name, salary FROM employees WHERE salary > 50000;

-- AND Operator
SELECT * FROM employees
WHERE salary > 50000 AND dept_id = 10;

-- OR Operator
SELECT * FROM employees
WHERE dept_id = 10 OR dept_id = 20;

-- IN Operator
SELECT * FROM employees
WHERE dept_id IN (10, 20);

-- LIKE Operator
SELECT * FROM employees
WHERE name LIKE 'J%';

-- Ends With
SELECT * FROM employees
WHERE name LIKE '%e';

-- Contains
SELECT * FROM employees
WHERE name LIKE '%an%';

-- One character match 
SELECT * FROM customers
WHERE customer_name LIKE 'J_hn';

-- Coimbined Filtering 
SELECT name, salary
FROM employees
WHERE salary BETWEEN 50000 AND 80000
  AND dept_id IN (10, 20)
  AND name LIKE 'J%'
  OR [status] = 'ACTIVE';

