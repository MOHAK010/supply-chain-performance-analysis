/*
============================================================
Supply Chain & Logistics Analytics

File: 02_Data_Validation.sql

Purpose:
Validate the imported dataset before starting the analysis.
This script checks record counts, missing values, duplicate
records, primary keys, and foreign key relationships.
============================================================
*/



-- ==========================================================
-- Q1. Check Total Records in Each Table
-- ==========================================================

SELECT 'customers' AS table_name, COUNT(*) AS total_records
FROM customers

UNION ALL

SELECT 'suppliers', COUNT(*)
FROM suppliers

UNION ALL

SELECT 'warehouses', COUNT(*)
FROM warehouses

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'inventory', COUNT(*)
FROM inventory

UNION ALL

SELECT 'shipments', COUNT(*)
FROM shipments

UNION ALL

SELECT 'returns', COUNT(*)
FROM returns;



-- ==========================================================
-- Q2. Check Missing Values
-- ==========================================================

SELECT
    'customers' AS table_name,
    COUNT(*) FILTER (WHERE customer_id IS NULL) +
    COUNT(*) FILTER (WHERE customer_name IS NULL) +
    COUNT(*) FILTER (WHERE region IS NULL) +
    COUNT(*) FILTER (WHERE segment IS NULL) AS total_nulls
FROM customers

UNION ALL

SELECT
    'suppliers',
    COUNT(*) FILTER (WHERE supplier_id IS NULL) +
    COUNT(*) FILTER (WHERE supplier_name IS NULL) +
    COUNT(*) FILTER (WHERE country IS NULL) +
    COUNT(*) FILTER (WHERE rating IS NULL)
FROM suppliers

UNION ALL

SELECT
    'warehouses',
    COUNT(*) FILTER (WHERE warehouse_id IS NULL) +
    COUNT(*) FILTER (WHERE warehouse_city IS NULL) +
    COUNT(*) FILTER (WHERE capacity IS NULL)
FROM warehouses

UNION ALL

SELECT
    'products',
    COUNT(*) FILTER (WHERE product_id IS NULL) +
    COUNT(*) FILTER (WHERE product_name IS NULL) +
    COUNT(*) FILTER (WHERE category IS NULL) +
    COUNT(*) FILTER (WHERE supplier_id IS NULL) +
    COUNT(*) FILTER (WHERE unit_cost IS NULL)
FROM products

UNION ALL

SELECT
    'orders',
    COUNT(*) FILTER (WHERE order_id IS NULL) +
    COUNT(*) FILTER (WHERE order_date IS NULL) +
    COUNT(*) FILTER (WHERE customer_id IS NULL) +
    COUNT(*) FILTER (WHERE product_id IS NULL) +
    COUNT(*) FILTER (WHERE warehouse_id IS NULL) +
    COUNT(*) FILTER (WHERE quantity IS NULL) +
    COUNT(*) FILTER (WHERE unit_price IS NULL)
FROM orders

UNION ALL

SELECT
    'inventory',
    COUNT(*) FILTER (WHERE product_id IS NULL) +
    COUNT(*) FILTER (WHERE warehouse_id IS NULL) +
    COUNT(*) FILTER (WHERE stock_qty IS NULL) +
    COUNT(*) FILTER (WHERE reorder_level IS NULL)
FROM inventory

UNION ALL

SELECT
    'shipments',
    COUNT(*) FILTER (WHERE shipment_id IS NULL) +
    COUNT(*) FILTER (WHERE order_id IS NULL) +
    COUNT(*) FILTER (WHERE shipping_mode IS NULL) +
    COUNT(*) FILTER (WHERE delivery_date IS NULL) +
    COUNT(*) FILTER (WHERE delivery_status IS NULL) +
    COUNT(*) FILTER (WHERE shipping_cost IS NULL)
FROM shipments

UNION ALL

SELECT
    'returns',
    COUNT(*) FILTER (WHERE return_id IS NULL) +
    COUNT(*) FILTER (WHERE order_id IS NULL) +
    COUNT(*) FILTER (WHERE return_reason IS NULL) +
    COUNT(*) FILTER (WHERE returned_qty IS NULL)
FROM returns;



-- ==========================================================
-- Q3. Check Duplicate Primary Keys
-- ==========================================================

SELECT customer_id, COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


SELECT supplier_id, COUNT(*) AS duplicate_count
FROM suppliers
GROUP BY supplier_id
HAVING COUNT(*) > 1;


SELECT warehouse_id, COUNT(*) AS duplicate_count
FROM warehouses
GROUP BY warehouse_id
HAVING COUNT(*) > 1;


SELECT product_id, COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


SELECT order_id, COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;



-- ==========================================================
-- Q4. Validate Primary Keys
-- ==========================================================

SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM customers;


SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT product_id) AS unique_products
FROM products;


SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT order_id) AS unique_orders
FROM orders;



-- ==========================================================
-- Q5. Validate Foreign Key Relationships
-- ==========================================================

-- Orders → Customers

SELECT o.order_id
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- Orders → Products

SELECT o.order_id
FROM orders o
LEFT JOIN products p
ON o.product_id = p.product_id
WHERE p.product_id IS NULL;


-- Orders → Warehouses

SELECT o.order_id
FROM orders o
LEFT JOIN warehouses w
ON o.warehouse_id = w.warehouse_id
WHERE w.warehouse_id IS NULL;


-- Products → Suppliers

SELECT p.product_id
FROM products p
LEFT JOIN suppliers s
ON p.supplier_id = s.supplier_id
WHERE s.supplier_id IS NULL;