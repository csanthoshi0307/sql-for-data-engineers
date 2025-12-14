-- Employees earning more than department average

SELECT e.emp_name, e.salary
FROM Employees e
WHERE e.salary >
(
    SELECT AVG(e2.salary)
    FROM Employees e2
    WHERE e2.dept_id = e.dept_id
);


-- Highest paid employee in each department
SELECT e.emp_name, e.dept_id, e.salary
FROM Employees e
WHERE e.salary =
(
    SELECT MAX(e2.salary)
    FROM Employees e2
    WHERE e2.dept_id = e.dept_id
);

-- Employees hired after the average hire date of their department
SELECT e.emp_name, e.hire_date
FROM Employees e
WHERE e.hire_date >
(
    SELECT AVG(e2.hire_date)
    FROM Employees e2
    WHERE e2.dept_id = e.dept_id
);


--Departments with more than 5 employees
SELECT d.dept_name
FROM Departments d
WHERE 5 <
(
    SELECT COUNT(*)
    FROM Employees e
    WHERE e.dept_id = d.dept_id
);

-- Customers who placed orders above their own average order value
SELECT o.order_id, o.customer_id, o.amount
FROM Orders o
WHERE o.amount >
(
    SELECT AVG(o2.amount)
    FROM Orders o2
    WHERE o2.customer_id = o.customer_id
);

-- Customers who have placed at least one order
SELECT c.customer_name
FROM Customers c
WHERE EXISTS
(
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);
-- EXISTS is a correlated subquery (checks per customer)

-- Employees whose salary is greater than at least one colleague
SELECT e.emp_name
FROM Employees e
WHERE e.salary >
(
    SELECT MIN(e2.salary)
    FROM Employees e2
    WHERE e2.dept_id = e.dept_id
);


-- Employees who earn less than the department maximum
SELECT e.emp_name, e.salary
FROM Employees e
WHERE e.salary <
(
    SELECT MAX(e2.salary)
    FROM Employees e2
    WHERE e2.dept_id = e.dept_id
);

-- Customers with no orders (NOT EXISTS)
SELECT c.customer_name
FROM Customers c
WHERE NOT EXISTS
(
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);

-- Latest order per customer
SELECT o.order_id, o.customer_id, o.order_date
FROM Orders o
WHERE o.order_date =
(
    SELECT MAX(o2.order_date)
    FROM Orders o2
    WHERE o2.customer_id = o.customer_id
);

