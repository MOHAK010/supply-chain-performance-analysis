/*
============================================================
Supply Chain & Logistics Analytics

File: 04_Intermediate_Analytics.sql

Purpose:
Analyze revenue, customer performance, product performance,
and regional sales using SQL aggregations and joins.
============================================================
*/



-- ==========================================================
-- Q11. Calculate Total Revenue
-- ==========================================================

SELECT
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM orders;



-- ==========================================================
-- Q12. Revenue by Product Category
-- ==========================================================

SELECT
    p.category,
    ROUND(SUM(o.quantity * o.unit_price), 2) AS total_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;



-- ==========================================================
-- Q13. Revenue by Customer Region
-- ==========================================================

SELECT
    c.region,
    ROUND(SUM(o.quantity * o.unit_price), 2) AS total_revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY total_revenue DESC;



-- ==========================================================
-- Q14. Revenue by Warehouse
-- ==========================================================

SELECT
    w.warehouse_city,
    ROUND(SUM(o.quantity * o.unit_price), 2) AS total_revenue
FROM orders o
JOIN warehouses w
ON o.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_city
ORDER BY total_revenue DESC;



-- ==========================================================
-- Q15. Monthly Revenue Trend
-- ==========================================================

SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS sales_month,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM orders
GROUP BY sales_month
ORDER BY sales_month;



-- ==========================================================
-- Q16. Top 10 Customers by Revenue
-- ==========================================================

SELECT
    c.customer_name,
    ROUND(SUM(o.quantity * o.unit_price), 2) AS total_revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_revenue DESC
LIMIT 10;



-- ==========================================================
-- Q17. Top 10 Products by Revenue
-- ==========================================================

SELECT
    p.product_name,
    ROUND(SUM(o.quantity * o.unit_price), 2) AS total_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;



-- ==========================================================
-- Q18. Customer Distribution by Region
-- ==========================================================

SELECT
    region,
    COUNT(*) AS total_customers
FROM customers
GROUP BY region
ORDER BY total_customers DESC;



-- ==========================================================
-- Q19. Average Order Value
-- ==========================================================

SELECT
    ROUND(AVG(quantity * unit_price), 2) AS average_order_value
FROM orders;



-- ==========================================================
-- Q20. Revenue by Customer Segment
-- ==========================================================

SELECT
    c.segment,
    ROUND(SUM(o.quantity * o.unit_price), 2) AS total_revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_revenue DESC;