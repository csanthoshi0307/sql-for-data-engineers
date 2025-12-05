--  Real ETL use cases: merge datasets
--  using RIGHT JOIN, CROSS JOIN, SELF JOIN, and FULL JOIN
--  to combine data from multiple tables.
-- Sample Tables Creation
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department_id INT
);
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);
-- Insert Departments Data
INSERT INTO departments (department_id, department_name) VALUES
(1, 'Sales'),
(2, 'Engineering'),
(3, 'HR');
-- Insert Employees Data
INSERT INTO employees (employee_id, employee_name, department_id) VALUES
(1, 'John Doe', 1),
(2, 'Jane Smith', 2),
(3, 'Emily Davis', NULL);
-- RIGHT JOIN Example
-- Retrieve all departments and their employees (if any)
SELECT d.department_name, e.employee_name
FROM departments d
RIGHT JOIN employees e ON d.department_id = e.department_id;
-- CROSS JOIN Example
-- Retrieve all combinations of employees and departments
SELECT e.employee_name, d.department_name
FROM employees e
CROSS JOIN departments d;
-- FULL JOIN Example
-- Retrieve all employees and all departments, matching where possible
SELECT e.employee_name, d.department_name
FROM employees e
FULL JOIN departments d ON e.department_id = d.department_id;
-- SELF JOIN Example
-- Retrieve employees along with their managers (assuming manager_id is employee_id)
CREATE TABLE employee_hierarchy (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employee_hierarchy(employee_id)
);
INSERT INTO employee_hierarchy (employee_id, employee_name, manager_id) VALUES
(1, 'John Doe', NULL),
(2, 'Jane Smith', 1),
(3, 'Emily Davis', 1);
SELECT e1.employee_name AS Employee, e2.employee_name AS Manager
FROM employee_hierarchy e1
LEFT JOIN employee_hierarchy e2 ON e1.manager_id = e2.employee_id;
-- Clean up: Drop tables
DROP TABLE employee_hierarchy;
DROP TABLE employees;
DROP TABLE departments;
-- End of ETL use cases with JOINs example
