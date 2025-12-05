### 🗂 Weekly SQL Project
Mini Relational Dataset: Customers + Orders

This simple dataset helps practice SQL JOINs across typical real-world tables.

### 📌 1. Schema Design
```
Customers Table
Column	Type	Description
customer_id	    INT (PK)	    Unique customer identifier
customer_name	VARCHAR(100)	Customer full name
city	        VARCHAR(100)	Customer city

Orders Table
Column	Type	Description
order_id	    INT (PK)	    Unique order ID
customer_id	    INT (FK)	    Links to Customers
amount	        DECIMAL	        Order total amount
status	        VARCHAR	        Pending / Completed / Cancelled
```
### 📌 2. Sample Data
```
Customers
customer_id	    customer_name	city
1	            John Doe	    Chennai
2	            Jane Smith	    Bangalore
3	            Emily Davis	    Mumbai
4	            David Clark	    Chennai

Orders
order_id	customer_id	    amount	    status
101	            1	           2500	    Completed
102	            1	           1200	    Pending
103	            2	           800	    Completed
104	            3	           1600	    Cancelled
105	            5	           900	    Completed
```
### 🧠 3. SQL JOIN Practice — 20 Queries
## A. INNER JOIN (5 Queries)

Get all orders with their customer names.

List customers who have placed at least one order.

Retrieve orders above ₹1000 with customer names.

Get customers from Chennai with their orders.

Show each order along with customer city.

## B. LEFT JOIN (5 Queries)

Get all customers and their orders (even if no orders).

List customers who have no orders.

Show customers with total order amount (NULL if no orders).

Get customers and number of orders per customer.

Show all customers with latest order (use MAX with GROUP BY + JOIN).

## C. RIGHT JOIN (3 Queries)

Show all orders with customer names (even orphan orders).

Identify orders placed by non-existing customers.

Retrieve orders with customer city (include missing customers).

## D. FULL OUTER JOIN (3 Queries)

Get combined list of customers and orders.

Display all customers and all orders, marking missing matches.

Find mismatched records (customers without orders + orphan orders).

## E. CROSS JOIN (2 Queries)

Generate all combinations of customers and order statuses (e.g., Pending/Completed).

Create customer × city pairs for segmentation testing.

## F. SELF JOIN (2 Queries)

(Add a manager relationship inside customers table if needed)
Schema addition:
manager_id INT NULL referencing customer_id.

Show customer + their manager name.

List all customers who report under the same manager.

### 🧩 4. SQL Set Operator Practice — 10 Queries

(Using Customers + Orders dataset)

Set operators work between two SELECT queries. These exercises help understand dataset comparison and merging behaviors.

## 🔹 A. UNION (2 Queries)

Retrieve a combined unique list of all customer names and all order statuses.
(Useful for merging unrelated fields into a single reference list.)

Get a list of all unique cities appearing in:

Customers table

And a temporary list of target cities ('Chennai', 'Delhi', 'Kolkata')

## 🔹 B. UNION ALL (2 Queries)

Retrieve customer names and append 'Guest User' three times using UNION ALL (to test duplicates).

Combine all customer IDs from Customers + all customer IDs referenced in Orders (including duplicates).

## 🔹 C. EXCEPT (3 Queries)

Find customer IDs that exist in Customers but not in Orders (customers without orders).

Find customer cities that are in customer data but not in a reference list (['Chennai','Bangalore']).

Identify order customer IDs that are not present in the Customers table (orphan orders).

## 🔹 D. INTERSECT (3 Queries)

Find customer IDs that appear in both Customers and Orders tables.

Find customer names that are common between Customers and a sample list (SELECT 'John Doe' UNION SELECT 'Emily Davis').

Identify cities where customers have placed at least one order.

### 📌 Summary of Set Operator Use Cases in ETL Context
```
Operator	Purpose	                            Typical ETL Use
UNION	    Merge rows and remove duplicates	Create unique master lists
UNION ALL	Merge rows and keep duplicates	    Log consolidation, batch append
EXCEPT	    Rows in A not in B	                Detect missing or mismatched records
INTERSECT	Rows common to both	                Consistency validation
```

### ✔ Complete Project Now Includes
20 JOIN Queries

(Inner, Left, Right, Full, Cross, Self Join)

10 Set Operator Queries

(Union, Union All, Except, Intersect)

Total = 30 SQL Practice Queries Perfect for ETL learning.