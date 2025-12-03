-- Select all employees
SELECT * FROM employees;

-- Filtering
SELECT name, salary FROM employees WHERE salary > 50000;

-- Insert sample
INSERT INTO employees (id, name, dept) VALUES (1, 'Alex', 'IT');
