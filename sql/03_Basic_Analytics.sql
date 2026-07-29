/*
============================================================
Supply Chain & Logistics Analytics

File: 03_Basic_Analytics.sql

Purpose:
Analyze key business metrics to understand the overall
performance of the supply chain business.
============================================================
*/



-- ==========================================================
-- Q6. Total Customers
-- ==========================================================

SELECT
    COUNT(*) AS total_customers
FROM customers;



-- ==========================================================
-- Q7. Total Orders
-- ==========================================================

SELECT
    COUNT(*) AS total_orders
FROM orders;



-- ==========================================================
-- Q8. Total Products
-- ==========================================================

SELECT
    COUNT(*) AS total_products
FROM products;



-- ==========================================================
-- Q9. Total Suppliers
-- ==========================================================

SELECT
    COUNT(*) AS total_suppliers
FROM suppliers;



-- ==========================================================
-- Q10. Total Warehouses
-- ==========================================================

SELECT
    COUNT(*) AS total_warehouses
FROM warehouses;

-- ==========================================================
-- Overall Business Summary
-- ==========================================================

SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM suppliers) AS total_suppliers,
    (SELECT COUNT(*) FROM warehouses) AS total_warehouses;