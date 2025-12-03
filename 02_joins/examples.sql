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
