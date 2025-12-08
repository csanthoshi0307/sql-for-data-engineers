-- -- GROUP BY clause is used to arrange identical data into groups with HAVING clause.
-- -- The HAVING clause is used to filter data that grouped by using GROUP BY results.
-- -- Example: Find the departments having more than 5 employees.
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5;
-- -- Example: Find the products with total sales greater than 1000.
SELECT product_id, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY product_id
HAVING SUM(sales_amount) > 1000;
-- -- Example: Find the customers who have placed more than 3 orders.
SELECT customer_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 3;
-- -- Example: Find the categories with an average price greater than 50.
SELECT category_id, AVG(price) AS average_price
FROM products
GROUP BY category_id
HAVING AVG(price) > 50;
-- -- Example: Find the suppliers who supply more than 10 different products.
SELECT supplier_id, COUNT(DISTINCT product_id) AS product_count
FROM product_suppliers
GROUP BY supplier_id
HAVING COUNT(DISTINCT product_id) > 10;
-- -- Example: Find the cities with more than 1000 residents.
SELECT city, COUNT(*) AS resident_count
FROM residents
GROUP BY city
HAVING COUNT(*) > 1000;
-- -- Example: Find the authors with more than 5 published books.
SELECT author_id, COUNT(book_id) AS book_count
FROM books
GROUP BY author_id
HAVING COUNT(book_id) > 5;
-- -- Example: Find the teams with an average score greater than 75.
SELECT team_id, AVG(score) AS average_score
FROM team_scores
GROUP BY team_id
HAVING AVG(score) > 75;
-- -- Example: Find the stores with total revenue greater than 5000.
SELECT store_id, SUM(revenue) AS total_revenue
FROM store_sales
GROUP BY store_id
HAVING SUM(revenue) > 5000;
-- -- Example: Find the projects with more than 3 assigned employees.
SELECT project_id, COUNT(employee_id) AS employee_count
FROM project_assignments
GROUP BY project_id
HAVING COUNT(employee_id) > 3;
-- -- Example: Find the movies with an average rating greater than 4.5.
SELECT movie_id, AVG(rating) AS average_rating
FROM movie_ratings
GROUP BY movie_id
HAVING AVG(rating) > 4.5;
-- -- Example: Find the countries with more than 50 cities.
SELECT country_id, COUNT(city_id) AS city_count
FROM cities
GROUP BY country_id
HAVING COUNT(city_id) > 50;
-- -- Example: Find the vendors who have supplied more than 20 orders.
SELECT vendor_id, COUNT(order_id) AS order_count
FROM vendor_orders
GROUP BY vendor_id
HAVING COUNT(order_id) > 20;
-- -- Example: Find the employees with an average performance score greater than 90.
SELECT employee_id, AVG(performance_score) AS average_score
FROM employee_performance
GROUP BY employee_id
HAVING AVG(performance_score) > 90;
-- -- Example: Find the courses with more than 30 enrolled students.
SELECT course_id, COUNT(student_id) AS student_count
FROM course_enrollments
GROUP BY course_id
HAVING COUNT(student_id) > 30;
-- -- Example: Find the blogs with more than 100 comments.
SELECT blog_id, COUNT(comment_id) AS comment_count
FROM blog_comments
GROUP BY blog_id
HAVING COUNT(comment_id) > 100;
-- -- Example: Find the events with total attendance greater than 2000.
SELECT event_id, SUM(attendance) AS total_attendance
FROM event_attendance
GROUP BY event_id
HAVING SUM(attendance) > 2000;
-- -- Example: Find the products with more than 10 reviews.
SELECT product_id, COUNT(review_id) AS review_count
FROM product_reviews
GROUP BY product_id
HAVING COUNT(review_id) > 10;
-- -- Example: Find the departments with an average salary greater than 60000.
SELECT department_id, AVG(salary) AS average_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 60000;
-- -- Example: Find the cities with more than 500 businesses.
SELECT city, COUNT(business_id) AS business_count
FROM businesses
GROUP BY city
HAVING COUNT(business_id) > 500;
-- -- Example: Find the authors with total book sales greater than 10000.
SELECT author_id, SUM(sales) AS total_sales
FROM book_sales
GROUP BY author_id
HAVING SUM(sales) > 10000;
-- -- Example: Find the teams with more than 15 players.
SELECT team_id, COUNT(player_id) AS player_count
FROM team_players
GROUP BY team_id
HAVING COUNT(player_id) > 15;
-- -- Example: Find the stores with an average transaction amount greater than 200.
SELECT store_id, AVG(transaction_amount) AS average_transaction
FROM store_transactions
GROUP BY store_id
HAVING AVG(transaction_amount) > 200;
-- -- Example: Find the projects with total hours worked greater than 1000.
SELECT project_id, SUM(hours_worked) AS total_hours
FROM project_hours
GROUP BY project_id
HAVING SUM(hours_worked) > 1000;
-- -- Example: Find the movies with more than 5000 tickets sold.
SELECT movie_id, COUNT(ticket_id) AS tickets_sold
FROM movie_tickets
GROUP BY movie_id
HAVING COUNT(ticket_id) > 5000;
-- -- Example: Find the countries with an average GDP greater than 30000.
SELECT country_id, AVG(gdp) AS average_gdp
FROM country_economics
GROUP BY country_id
HAVING AVG(gdp) > 30000;
