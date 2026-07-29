/*
============================================================
Supply Chain & Logistics Analytics

File: 08_Insights.sql

Purpose:
Provide a concise business summary by highlighting key
performance indicators and actionable insights derived
from the SQL analysis.
============================================================
*/



-- ==========================================================
-- Q46. Overall Business Summary
-- ==========================================================

SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM suppliers) AS total_suppliers,
    (SELECT COUNT(*) FROM warehouses) AS total_warehouses,
    (SELECT ROUND(SUM(quantity * unit_price),2) FROM orders) AS total_revenue;



-- ==========================================================
-- Q47. Top 5 Revenue Generating Products
-- ==========================================================

SELECT
    p.product_name,
    ROUND(SUM(o.quantity * o.unit_price),2) AS total_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;



-- ==========================================================
-- Q48. Top 5 Revenue Generating Customers
-- ==========================================================

SELECT
    c.customer_name,
    ROUND(SUM(o.quantity * o.unit_price),2) AS total_revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_revenue DESC
LIMIT 5;



-- ==========================================================
-- Q49. Best Performing Region
-- ==========================================================

SELECT
    c.region,
    ROUND(SUM(o.quantity * o.unit_price),2) AS total_revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY total_revenue DESC;



-- ==========================================================
-- Q50. Final KPI Snapshot
-- ==========================================================

SELECT
    ROUND(AVG(quantity * unit_price),2) AS average_order_value,
    (SELECT COUNT(*) FROM returns) AS total_returns,
    (SELECT ROUND(AVG(shipping_cost),2) FROM shipments) AS average_shipping_cost;

 