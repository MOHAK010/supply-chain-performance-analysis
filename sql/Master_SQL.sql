-- Customers

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    segment VARCHAR(50) NOT NULL
);

-- Suppliers

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    rating INT NOT NULL
);

-- Warehouses

CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_city VARCHAR(100) NOT NULL,
    capacity INT NOT NULL
);

-- Products

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    supplier_id INT NOT NULL,
    unit_cost NUMERIC(10,2) NOT NULL,

    CONSTRAINT fk_products_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
);

-- Orders

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_orders_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT fk_orders_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id)
);

-- Inventory

CREATE TABLE inventory (
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    stock_qty INT NOT NULL,
    reorder_level INT NOT NULL,

    PRIMARY KEY (product_id, warehouse_id),

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT fk_inventory_warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id)
);

-- Shipments

CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    shipping_mode VARCHAR(30) NOT NULL,
    delivery_date DATE NOT NULL,
    delivery_status VARCHAR(30) NOT NULL,
    shipping_cost NUMERIC(10,2) NOT NULL,

    CONSTRAINT fk_shipments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- Returns

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    return_reason VARCHAR(50) NOT NULL,
    returned_qty INT NOT NULL,

    CONSTRAINT fk_returns_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- Q1. Check total records in every table

SELECT 'customers' AS table_name, COUNT(*) AS total_records FROM customers
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'warehouses', COUNT(*) FROM warehouses
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL
SELECT 'shipments', COUNT(*) FROM shipments
UNION ALL
SELECT 'returns', COUNT(*) FROM returns;

-- Q2. Check NULL values in all tables

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

-- Q3. Check duplicate primary keys

SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT supplier_id, COUNT(*)
FROM suppliers
GROUP BY supplier_id
HAVING COUNT(*) > 1;

SELECT warehouse_id, COUNT(*)
FROM warehouses
GROUP BY warehouse_id
HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT shipment_id, COUNT(*)
FROM shipments
GROUP BY shipment_id
HAVING COUNT(*) > 1;

SELECT return_id, COUNT(*)
FROM returns
GROUP BY return_id
HAVING COUNT(*) > 1;

-- Q4. Validate primary key uniqueness

SELECT
COUNT(*) AS total_customers,
COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM customers;

SELECT
COUNT(*) AS total_products,
COUNT(DISTINCT product_id) AS unique_product_ids
FROM products;

SELECT
COUNT(*) AS total_orders,
COUNT(DISTINCT order_id) AS unique_order_ids
FROM orders;

-- Q5. Validate foreign key relationships

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

-- Inventory → Products

SELECT i.product_id
FROM inventory i
LEFT JOIN products p
ON i.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Inventory → Warehouses

SELECT i.warehouse_id
FROM inventory i
LEFT JOIN warehouses w
ON i.warehouse_id = w.warehouse_id
WHERE w.warehouse_id IS NULL;

-- Shipments → Orders

SELECT s.shipment_id
FROM shipments s
LEFT JOIN orders o
ON s.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Returns → Orders

SELECT r.return_id
FROM returns r
LEFT JOIN orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


                                      --Basic_Analytics--

 
-- Q6. Total Customers

SELECT COUNT(*) AS total_customers
FROM customers;


-- Q7. Total Orders

SELECT COUNT(*) AS total_orders
FROM orders;


-- Q8. Total Products

SELECT COUNT(*) AS total_products
FROM products;


-- Q9. Total Suppliers

SELECT COUNT(*) AS total_suppliers
FROM suppliers;


-- Q10. Total Warehouses

SELECT COUNT(*) AS total_warehouses
FROM warehouses;

                                      -- Intermediate_Analytics -- 

-- Q11. Total Revenue

SELECT
SUM(quantity * unit_price) AS total_revenue
FROM orders;


-- Q12. Revenue by Category

SELECT
p.category,
SUM(o.quantity * o.unit_price) AS total_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- Q13. Revenue by Region

SELECT
c.region,
SUM(o.quantity * o.unit_price) AS total_revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY total_revenue DESC;


-- Q14. Revenue by Warehouse

SELECT
w.warehouse_city,
SUM(o.quantity * o.unit_price) AS total_revenue
FROM orders o
JOIN warehouses w
ON o.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_city
ORDER BY total_revenue DESC;


-- Q15. Monthly Revenue Trend

SELECT
TO_CHAR(order_date,'YYYY-MM') AS month,
SUM(quantity * unit_price) AS total_revenue
FROM orders
GROUP BY month
ORDER BY month;


-- Q16. Top 10 Customers by Revenue

SELECT
c.customer_name,
SUM(o.quantity * o.unit_price) AS total_revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_revenue DESC
LIMIT 10;


-- Q17. Top 10 Products by Revenue

SELECT
p.product_name,
SUM(o.quantity * o.unit_price) AS total_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;


-- Q18. Customer Count by Region

SELECT
region,
COUNT(*) AS total_customers
FROM customers
GROUP BY region
ORDER BY total_customers DESC;


-- Q19. Average Order Value

SELECT
ROUND(AVG(quantity * unit_price),2) AS average_order_value
FROM orders;


-- Q20. Revenue by Customer Segment

SELECT
c.segment,
SUM(o.quantity * o.unit_price) AS total_revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_revenue DESC;



                                    -- Advanced_Analytics --


-- Q21. Rank Products by Revenue

SELECT
    p.product_name,
    SUM(o.quantity * o.unit_price) AS total_revenue,
    RANK() OVER(
        ORDER BY SUM(o.quantity * o.unit_price) DESC
    ) AS revenue_rank
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name;


-- Q22. Top 3 Products in Each Category

WITH product_sales AS
(
    SELECT
        p.category,
        p.product_name,
        SUM(o.quantity * o.unit_price) AS revenue,
        ROW_NUMBER() OVER(
            PARTITION BY p.category
            ORDER BY SUM(o.quantity * o.unit_price) DESC
        ) AS rn
    FROM orders o
    JOIN products p
    ON o.product_id = p.product_id
    GROUP BY p.category, p.product_name
)

SELECT *
FROM product_sales
WHERE rn <= 3;


-- Q23. Running Monthly Revenue

WITH monthly_sales AS
(
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(quantity * unit_price) AS revenue
    FROM orders
    GROUP BY month
)

SELECT
    month,
    revenue,
    SUM(revenue) OVER(
        ORDER BY month
    ) AS running_revenue
FROM monthly_sales;


-- Q24. Monthly Revenue Growth

WITH monthly_sales AS
(
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(quantity * unit_price) AS revenue
    FROM orders
    GROUP BY month
)

SELECT
    month,
    revenue,
    revenue -
    LAG(revenue) OVER(ORDER BY month) AS revenue_growth
FROM monthly_sales;


-- Q25. Revenue Contribution %

SELECT
    p.category,
    SUM(o.quantity * o.unit_price) AS revenue,
    ROUND(
        SUM(o.quantity * o.unit_price) * 100.0 /
        SUM(SUM(o.quantity * o.unit_price)) OVER(),
        2
    ) AS revenue_percent
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue_percent DESC;


-- Q26. Rank Customers by Revenue

SELECT
    c.customer_name,
    SUM(o.quantity * o.unit_price) AS revenue,
    DENSE_RANK() OVER(
        ORDER BY SUM(o.quantity * o.unit_price) DESC
    ) AS customer_rank
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name;


-- Q27. Above Average Spending Customers

WITH customer_sales AS
(
    SELECT
        c.customer_name,
        SUM(o.quantity * o.unit_price) AS revenue
    FROM orders o
    JOIN customers c
    ON o.customer_id = c.customer_id
    GROUP BY c.customer_name
)

SELECT *
FROM customer_sales
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM customer_sales
);


-- Q28. Warehouse Revenue Ranking

SELECT
    w.warehouse_city,
    SUM(o.quantity * o.unit_price) AS revenue,
    RANK() OVER(
        ORDER BY SUM(o.quantity * o.unit_price) DESC
    ) AS warehouse_rank
FROM orders o
JOIN warehouses w
ON o.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_city;


-- Q29. Supplier Rating Ranking

SELECT
    supplier_name,
    rating,
    DENSE_RANK() OVER(
        ORDER BY rating DESC
    ) AS supplier_rank
FROM suppliers;


-- Q30. Monthly Order Ranking

SELECT
    DATE_TRUNC('month', order_date) AS month,
    COUNT(*) AS total_orders,
    RANK() OVER(
        ORDER BY COUNT(*) DESC
    ) AS month_rank
FROM orders
GROUP BY month;


                                  -- Business_Case_Studies --


-- Q31. Which products should be restocked immediately?

SELECT
    p.product_name,
    i.stock_qty,
    i.reorder_level
FROM inventory i
JOIN products p
ON i.product_id = p.product_id
WHERE i.stock_qty <= i.reorder_level
ORDER BY i.stock_qty ASC;


-- Q32. Which warehouses have the highest number of low-stock products?

SELECT
    w.warehouse_city,
    COUNT(*) AS low_stock_products
FROM inventory i
JOIN warehouses w
ON i.warehouse_id = w.warehouse_id
WHERE i.stock_qty <= i.reorder_level
GROUP BY w.warehouse_city
ORDER BY low_stock_products DESC;


-- Q33. Which products are overstocked?

SELECT
    p.product_name,
    i.stock_qty,
    i.reorder_level
FROM inventory i
JOIN products p
ON i.product_id = p.product_id
WHERE i.stock_qty > (i.reorder_level * 2)
ORDER BY i.stock_qty DESC;


-- Q34. Which warehouses hold the highest inventory value?

SELECT
    w.warehouse_city,
    ROUND(SUM(i.stock_qty * p.unit_cost),2) AS inventory_value
FROM inventory i
JOIN warehouses w
ON i.warehouse_id = w.warehouse_id
JOIN products p
ON i.product_id = p.product_id
GROUP BY w.warehouse_city
ORDER BY inventory_value DESC;


-- Q35. Which product categories generate the highest revenue?

SELECT
    p.category,
    ROUND(SUM(o.quantity * o.unit_price),2) AS revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;


-- Q36. Which products generate the highest revenue?

SELECT
    p.product_name,
    ROUND(SUM(o.quantity * o.unit_price),2) AS revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;


-- Q37. Which customers generate the highest revenue?

SELECT
    c.customer_name,
    ROUND(SUM(o.quantity * o.unit_price),2) AS revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY revenue DESC
LIMIT 10;


-- Q38. Which regions contribute the highest revenue?

SELECT
    c.region,
    ROUND(SUM(o.quantity * o.unit_price),2) AS revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY revenue DESC;


-- Q39. Which shipping mode is the most cost-effective?

SELECT
    shipping_mode,
    ROUND(AVG(shipping_cost),2) AS avg_shipping_cost
FROM shipments
GROUP BY shipping_mode
ORDER BY avg_shipping_cost;


-- Q40. Which delivery status occurs most frequently?

SELECT
    delivery_status,
    COUNT(*) AS total_shipments
FROM shipments
GROUP BY delivery_status
ORDER BY total_shipments DESC;


-- Q41. Which products have the highest return quantity?

SELECT
    p.product_name,
    SUM(r.returned_qty) AS total_returned
FROM returns r
JOIN orders o
ON r.order_id = o.order_id
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_returned DESC
LIMIT 10;


-- Q42. Which return reason occurs most frequently?

SELECT
    return_reason,
    COUNT(*) AS total_returns
FROM returns
GROUP BY return_reason
ORDER BY total_returns DESC;


-- Q43. Which suppliers contribute the highest sales revenue?

SELECT
    s.supplier_name,
    ROUND(SUM(o.quantity * o.unit_price),2) AS revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
JOIN suppliers s
ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY revenue DESC;


-- Q44. Which suppliers have the highest average product cost?

SELECT
    s.supplier_name,
    ROUND(AVG(p.unit_cost),2) AS avg_product_cost
FROM suppliers s
JOIN products p
ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name
ORDER BY avg_product_cost DESC;


-- Q45. Which warehouses process the highest number of orders?

SELECT
    w.warehouse_city,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN warehouses w
ON o.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_city
ORDER BY total_orders DESC;


                                  -- Views --


-- Q46. Revenue Summary View

CREATE VIEW vw_revenue_summary AS
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(quantity * unit_price) AS total_revenue
FROM orders
GROUP BY month;


-- Q47. Inventory Status View

CREATE VIEW vw_inventory_status AS
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


-- Q48. Customer Revenue View

CREATE VIEW vw_customer_revenue AS
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(o.quantity * o.unit_price),2) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;


                                -- Project Insights --


-- Q49. Top 5 Highest Revenue Products

SELECT
    p.product_name,
    ROUND(SUM(o.quantity * o.unit_price),2) AS total_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;



-- Q50. Executive Business Summary

SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT ROUND(SUM(quantity * unit_price),2) FROM orders) AS total_revenue,
    (SELECT COUNT(*) FROM returns) AS total_returns,
    (SELECT ROUND(AVG(shipping_cost),2) FROM shipments) AS avg_shipping_cost;
	