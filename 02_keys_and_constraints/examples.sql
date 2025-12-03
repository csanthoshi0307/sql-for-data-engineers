-- PRIMARY KEY
-- Single-column Primary Key
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

-- Composite Primary Key
-- (Primary key made of multiple columns)
CREATE TABLE course_enrollment (
    student_id INT,
    course_id INT,
    semester VARCHAR(10),
    PRIMARY KEY (student_id, course_id)
);

-- FOREIGN KEY
-- Foreign Key referencing another table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Foreign Key with cascade options
-- In this example, if an Order is deleted from the Orders table, all associated OrderItems in the OrderItems table will also be automatically deleted.
    CREATE TABLE Orders (
        OrderID INT PRIMARY KEY,
        CustomerID INT,
        OrderDate DATE
    );

    CREATE TABLE OrderItems (
        ItemID INT PRIMARY KEY,
        OrderID INT,
        ProductName VARCHAR(50),
        Quantity INT,
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
    );
-- On UPDATE CASCADE works similarly for updates.
--  if the ProductID in the Products table is updated (actually not recommended), the ProductID in the Inventory table for all related inventory records will also be updated accordingly.
    CREATE TABLE Products (
        ProductID INT PRIMARY KEY,
        ProductName VARCHAR(50)
    );

    CREATE TABLE Inventory (
        InventoryID INT PRIMARY KEY,
        ProductID INT,
        StockQuantity INT,
        FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON UPDATE CASCADE
    );
-- NOT NULL Constraint
-- Basic NOT NULL constraint
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(8,2) NOT NULL
);

-- Prevent Empty values
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);

-- UNIQUE Constraint
-- Single column UNIQUE
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20)
);

-- Composite UNIQUE
--(Useful for preventing duplicate combinations)
CREATE TABLE attendance (
    student_id INT,
    attendance_date DATE,
    status VARCHAR(20),
    UNIQUE (student_id, attendance_date)
);

-- DEFAULT Constraint
-- Default values
CREATE TABLE tasks (
    task_id INT PRIMARY KEY,
    title VARCHAR(255),
    status VARCHAR(20) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Default numeric value
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    balance DECIMAL(10,2) DEFAULT 0.00
);

-- BONUS: Table combining all constraints
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount DECIMAL(10,2) CHECK (total_amount >= 0),
    order_status VARCHAR(20) DEFAULT 'NEW',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    UNIQUE (customer_id, order_date)
);

-- Inner Join
SELECT e.name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.id;

-- Left Join
SELECT c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id;

-- Anti Join
SELECT * FROM customers c
WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);
