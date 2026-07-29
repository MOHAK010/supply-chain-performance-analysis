/*
============================================================
Supply Chain & Logistics Analytics

File: 07_Views.sql

Purpose:
Create reusable SQL views for frequently used business
reports. These views simplify analysis and can be directly
used in Power BI dashboards.
============================================================
*/



-- ==========================================================
-- View 1. Revenue Summary
-- ==========================================================

CREATE OR REPLACE VIEW vw_revenue_summary AS

SELECT
    DATE_TRUNC('month', order_date) AS sales_month,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM orders
GROUP BY sales_month;



-- View Result

SELECT *
FROM vw_revenue_summary;



-- ==========================================================
-- View 2. Customer Revenue
-- ==========================================================

CREATE OR REPLACE VIEW vw_customer_revenue AS

SELECT
    c.customer_id,
    c.customer_name,
    c.region,
    c.segment,
    ROUND(SUM(o.quantity * o.unit_price), 2) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.region,
    c.segment;



-- View Result

SELECT *
FROM vw_customer_revenue;



-- ==========================================================
-- View 3. Inventory Status
-- ==========================================================

CREATE OR REPLACE VIEW vw_inventory_status AS

SELECT
    p.product_name,
    w.warehouse_city,
    i.stock_qty,
    i.reorder_level
FROM inventory i
JOIN products p
ON i.product_id = p.product_id
JOIN warehouses w
ON i.warehouse_id = w.warehouse_id;



-- View Result

SELECT *
FROM vw_inventory_status;



-- ==========================================================
-- View 4. Product Performance
-- ==========================================================

CREATE OR REPLACE VIEW vw_product_performance AS

SELECT
    p.product_name,
    p.category,
    ROUND(SUM(o.quantity * o.unit_price), 2) AS total_revenue,
    SUM(o.quantity) AS total_quantity_sold
FROM products p
JOIN orders o
ON p.product_id = o.product_id
GROUP BY
    p.product_name,
    p.category;



-- View Result

SELECT *
FROM vw_product_performance;



-- ==========================================================
-- View 5. Supplier Performance
-- ==========================================================

CREATE OR REPLACE VIEW vw_supplier_performance AS

SELECT
    s.supplier_name,
    COUNT(DISTINCT p.product_id) AS total_products,
    ROUND(SUM(o.quantity * o.unit_price), 2) AS total_revenue
FROM suppliers s
JOIN products p
ON s.supplier_id = p.supplier_id
JOIN orders o
ON p.product_id = o.product_id
GROUP BY s.supplier_name;



-- View Result

SELECT *
FROM vw_supplier_performance;