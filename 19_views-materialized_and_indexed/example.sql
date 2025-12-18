-- MATERIALIZED VIEWS, mainly for PostgreSQL
-- Stores the query result physically
-- Improves read performance
-- Needs manual or scheduled refresh


-- Monthly Sales Summary (Most Common)
-- Posgres Scenario: Large orders table → slow monthly reports.
CREATE MATERIALIZED VIEW mv_monthly_sales AS
SELECT
    DATE_TRUNC('month', order_date) AS sales_month,
    SUM(total_amount) AS total_sales,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY DATE_TRUNC('month', order_date);

-- Much faster than scanning millions of rows
SELECT * FROM mv_monthly_sales
ORDER BY sales_month DESC;

-- 2: Customer Sales Summary (ERP / SAP style)
-- Customer-wise revenue for finance posting.
CREATE MATERIALIZED VIEW mv_customer_sales AS
SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_sales,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.customer_name;

-- 
CREATE INDEX idx_mv_customer_sales_customer
ON mv_customer_sales(customer_id);

-- 
SELECT * FROM mv_customer_sales
WHERE customer_id = 1001;

-- 3: Order Detail Snapshot (Reporting / Export)
-- Heavy JOIN between orders, items, products → slow exports.
CREATE MATERIALIZED VIEW mv_order_details AS
SELECT
    o.order_id,
    o.order_date,
    p.product_name,
    p.category,
    oi.quantity,
    oi.price,
    (oi.quantity * oi.price) AS line_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id;

-- Index for filtering
CREATE INDEX idx_mv_order_details_order
ON mv_order_details(order_id);

-- Refresh Strategies (Very Important)
-- Manual Refresh
REFRESH MATERIALIZED VIEW mv_order_details;
-- Concurrent Refresh (No Lock - Requires unique index)
CREATE UNIQUE INDEX idx_mv_order_details_pk
ON mv_order_details(order_id, product_name);
-- Scheduled Refresh (Cron / Job)
-- bash
0 2 * * * psql -d salesdb -c "REFRESH MATERIALIZED VIEW mv_monthly_sales;"

---- SQL Materialized View Examples - Indexed Views ----
-- Indexed Views (SQL Server / Oracle)
-- Similar to materialized views but with automatic indexing
CREATE TABLE dbo.Orders (
    OrderId INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL
);
-- SQL Server requires:
-- SCHEMABINDING
-- COUNT_BIG(*)
-- Two-part names (dbo.TableName)
CREATE VIEW dbo.vw_MonthlySales
WITH SCHEMABINDING
AS
SELECT
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    COUNT_BIG(*) AS TotalOrders,
    SUM(TotalAmount) AS TotalSales
FROM dbo.Orders
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate);
-- Create Clustered Index (This Materializes the View)
CREATE UNIQUE CLUSTERED INDEX IX_vw_MonthlySales
ON dbo.vw_MonthlySales (SalesYear, SalesMonth);
-- Now it is physically stored (materialized)

-- Querying Indexed View
SELECT * FROM dbo.vw_MonthlySales;


