/*
============================================================
Supply Chain & Logistics Analytics

File: 05_Advanced_Analytics.sql

Purpose:
Perform advanced business analysis using Common Table
Expressions (CTEs) and Window Functions to identify
trends, rankings, and business insights.
============================================================
*/



-- ==========================================================
-- Q21. Rank Products by Revenue
-- ==========================================================

SELECT
    p.product_name,
    ROUND(SUM(o.quantity * o.unit_price), 2) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(o.quantity * o.unit_price) DESC
    ) AS revenue_rank
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_name;



-- ==========================================================
-- Q22. Top 3 Products in Each Category
-- ==========================================================

WITH product_sales AS
(
    SELECT
        p.category,
        p.product_name,
        ROUND(SUM(o.quantity * o.unit_price), 2) AS revenue,
        ROW_NUMBER() OVER
        (
            PARTITION BY p.category
            ORDER BY SUM(o.quantity * o.unit_price) DESC
        ) AS row_num
    FROM orders o
    JOIN products p
    ON o.product_id = p.product_id
    GROUP BY p.category, p.product_name
)

SELECT *
FROM product_sales
WHERE row_num <= 3;



-- ==========================================================
-- Q23. Running Monthly Revenue
-- ==========================================================

WITH monthly_sales AS
(
    SELECT
        DATE_TRUNC('month', order_date) AS sales_month,
        SUM(quantity * unit_price) AS revenue
    FROM orders
    GROUP BY sales_month
)

SELECT
    sales_month,
    revenue,
    SUM(revenue) OVER
    (
        ORDER BY sales_month
    ) AS running_revenue
FROM monthly_sales;



-- ==========================================================
-- Q24. Monthly Revenue Growth
-- ==========================================================

WITH monthly_sales AS
(
    SELECT
        DATE_TRUNC('month', order_date) AS sales_month,
        SUM(quantity * unit_price) AS revenue
    FROM orders
    GROUP BY sales_month
)

SELECT
    sales_month,
    revenue,
    revenue -
    LAG(revenue) OVER
    (
        ORDER BY sales_month
    ) AS revenue_growth
FROM monthly_sales;



-- ==========================================================
-- Q25. Revenue Contribution by Category
-- ==========================================================

SELECT
    p.category,
    ROUND(SUM(o.quantity * o.unit_price), 2) AS revenue,

    ROUND(
        SUM(o.quantity * o.unit_price) * 100.0 /
        SUM(SUM(o.quantity * o.unit_price)) OVER (),
        2
    ) AS revenue_percentage

FROM orders o
JOIN products p
ON o.product_id = p.product_id

GROUP BY p.category

ORDER BY revenue_percentage DESC;



-- ==========================================================
-- Q26. Rank Customers by Revenue
-- ==========================================================

SELECT
    c.customer_name,

    ROUND(SUM(o.quantity * o.unit_price), 2) AS revenue,

    DENSE_RANK() OVER
    (
        ORDER BY SUM(o.quantity * o.unit_price) DESC
    ) AS customer_rank

FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id

GROUP BY c.customer_name;



-- ==========================================================
-- Q27. Customers Spending Above Average
-- ==========================================================

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



-- ==========================================================
-- Q28. Warehouse Revenue Ranking
-- ==========================================================

SELECT
    w.warehouse_city,

    ROUND(SUM(o.quantity * o.unit_price), 2) AS revenue,

    RANK() OVER
    (
        ORDER BY SUM(o.quantity * o.unit_price) DESC
    ) AS warehouse_rank

FROM orders o
JOIN warehouses w
ON o.warehouse_id = w.warehouse_id

GROUP BY w.warehouse_city;



-- ==========================================================
-- Q29. Supplier Rating Ranking
-- ==========================================================

SELECT
    supplier_name,
    rating,

    DENSE_RANK() OVER
    (
        ORDER BY rating DESC
    ) AS supplier_rank

FROM suppliers;



-- ==========================================================
-- Q30. Monthly Order Ranking
-- ==========================================================

SELECT
    DATE_TRUNC('month', order_date) AS sales_month,

    COUNT(*) AS total_orders,

    RANK() OVER
    (
        ORDER BY COUNT(*) DESC
    ) AS month_rank

FROM orders

GROUP BY sales_month;