-- Set Operators  for Combining Query Results
-- UNION vs UNION ALL  
-- EXCEPT, INTERSECT  
-- Note: The syntax may vary slightly depending on the SQL database system you are using.
-- Sample Tables Creation
CREATE TABLE table_a (
    id INT PRIMARY KEY,
    value VARCHAR(100) NOT NULL
);
CREATE TABLE table_b (
    id INT PRIMARY KEY,
    value VARCHAR(100) NOT NULL
);
-- Insert Data into Table A
INSERT INTO table_a (id, value) VALUES
(1, 'Apple'),
(2, 'Banana'),
(3, 'Cherry');
-- Insert Data into Table B
INSERT INTO table_b (id, value) VALUES
(3, 'Cherry'),
(4, 'Date'),
(5, 'Elderberry');
-- UNION Example
-- Combine results from both tables, removing duplicates    
SELECT value FROM table_a
UNION
SELECT value FROM table_b;
-- UNION ALL Example
-- Combine results from both tables, including duplicates    
SELECT value FROM table_a
UNION ALL
SELECT value FROM table_b;
-- EXCEPT Example
-- Get values in Table A that are not in Table B    
SELECT value FROM table_a
EXCEPT
SELECT value FROM table_b;
-- INTERSECT Example
-- Get values that are common to both Table A and Table B
SELECT value FROM table_a
INTERSECT
SELECT value FROM table_b;
-- Clean up: Drop tables
DROP TABLE table_a;
DROP TABLE table_b;
-- End of Set Operators example

