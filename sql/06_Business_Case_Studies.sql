/*
============================================================
Supply Chain & Logistics Analytics

File: 06_Business_Case_Studies.sql

Purpose:
Solve real-world business problems using SQL by analyzing
inventory, warehouse operations, suppliers, returns,
shipping, and overall business performance.
============================================================
*/



-- ==========================================================
-- Q31. Products That Need Immediate Restocking
-- ==========================================================

SELECT
    p.product_name,
    i.stock_qty,
    i.reorder_level
FROM inventory i
JOIN products p
ON i.product_id = p.product_id
WHERE i.stock_qty <= i.reorder_level
ORDER BY i.stock_qty ASC;



-- ==========================================================
-- Q32. Warehouses with the Highest Low-Stock Products
-- ==========================================================

SELECT
    w.warehouse_city,
    COUNT(*) AS low_stock_products
FROM inventory i
JOIN warehouses w
ON i.warehouse_id = w.warehouse_id
WHERE i.stock_qty <= i.reorder_level
GROUP BY w.warehouse_city
ORDER BY low_stock_products DESC;



-- ==========================================================
-- Q33. Overstocked Products
-- ==========================================================

SELECT
    p.product_name,
    i.stock_qty,
    i.reorder_level
FROM inventory i
JOIN products p
ON i.product_id = p.product_id
WHERE i.stock_qty > (i.reorder_level * 2)
ORDER BY i.stock_qty DESC;



-- ==========================================================
-- Q34. Warehouse Inventory Value
-- ==========================================================

SELECT
    w.warehouse_city,
    ROUND(SUM(i.stock_qty * p.unit_cost), 2) AS inventory_value
FROM inventory i
JOIN warehouses w
ON i.warehouse_id = w.warehouse_id
JOIN products p
ON i.product_id = p.product_id
GROUP BY w.warehouse_city
ORDER BY inventory_value DESC;



-- ==========================================================
-- Q35. Highest Revenue Product Categories
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
-- Q36. Top Revenue Generating Products
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
-- Q37. Top Revenue Generating Customers
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
-- Q38. Revenue by Region
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
-- Q39. Average Shipping Cost by Shipping Mode
-- ==========================================================

SELECT
    shipping_mode,
    ROUND(AVG(shipping_cost), 2) AS average_shipping_cost
FROM shipments
GROUP BY shipping_mode
ORDER BY average_shipping_cost;



-- ==========================================================
-- Q40. Delivery Status Distribution
-- ==========================================================

SELECT
    delivery_status,
    COUNT(*) AS total_shipments
FROM shipments
GROUP BY delivery_status
ORDER BY total_shipments DESC;



-- ==========================================================
-- Q41. Products with Highest Return Quantity
-- ==========================================================

SELECT
    p.product_name,
    SUM(r.returned_qty) AS total_return_quantity
FROM returns r
JOIN orders o
ON r.order_id = o.order_id
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_return_quantity DESC
LIMIT 10;



-- ==========================================================
-- Q42. Most Common Return Reasons
-- ==========================================================

SELECT
    return_reason,
    COUNT(*) AS total_returns
FROM returns
GROUP BY return_reason
ORDER BY total_returns DESC;



-- ==========================================================
-- Q43. Supplier Revenue Contribution
-- ==========================================================

SELECT
    s.supplier_name,
    ROUND(SUM(o.quantity * o.unit_price), 2) AS total_revenue
FROM suppliers s
JOIN products p
ON s.supplier_id = p.supplier_id
JOIN orders o
ON p.product_id = o.product_id
GROUP BY s.supplier_name
ORDER BY total_revenue DESC;



-- ==========================================================
-- Q44. Suppliers with Highest Average Product Cost
-- ==========================================================

SELECT
    s.supplier_name,
    ROUND(AVG(p.unit_cost), 2) AS average_product_cost
FROM suppliers s
JOIN products p
ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name
ORDER BY average_product_cost DESC;



-- ==========================================================
-- Q45. Warehouse Order Processing Performance
-- ==========================================================

SELECT
    w.warehouse_city,
    COUNT(o.order_id) AS total_orders
FROM warehouses w
JOIN orders o
ON w.warehouse_id = o.warehouse_id
GROUP BY w.warehouse_city
ORDER BY total_orders DESC;