/*
============================================================
Project : Supply Chain & Logistics Analytics
File    : 01_Database_Setup.sql
Author  : Mohak Chaturvedi

Description:
This script creates the complete database schema used
for the Supply Chain & Logistics Analytics project.

============================================================
Supply Chain & Logistics Analytics

Database : PostgreSQL

Project Overview
----------------
This project analyzes a Supply Chain & Logistics dataset
using SQL to generate business insights related to sales,
inventory, warehouses, suppliers, customers, shipping,
and product performance.

Project Structure
-----------------
01. Database Setup
02. Data Validation
03. Basic Analytics
04. Intermediate Analytics
05. Advanced Analytics
06. Business Case Studies
07. SQL Views
08. Business Insights

SQL Concepts Covered
--------------------
• DDL (CREATE TABLE)
• Joins
• Aggregate Functions
• GROUP BY
• HAVING
• CASE Statements
• Common Table Expressions (CTEs)
• Window Functions
• Ranking Functions
• Views

Total SQL Files : 8
Total Queries   : 50
============================================================
*/




-- ==========================================================
-- Create Database
-- ==========================================================

CREATE DATABASE supply_chain_analytics;

-- Connect to Database
-- \c supply_chain_analytics
-- Tables Included:
-- 1. customers
-- 2. suppliers
-- 3. warehouses
-- 4. products
-- 5. orders
-- 6. inventory
-- 7. shipments
-- 8. returns

-- ============================================================



-- ==========================================================
-- Create Customers Table
-- ==========================================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    segment VARCHAR(50) NOT NULL
);



-- ==========================================================
-- Create Suppliers Table
-- ==========================================================

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    rating INT NOT NULL
);



-- ==========================================================
-- Create Warehouses Table
-- ==========================================================

CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_city VARCHAR(100) NOT NULL,
    capacity INT NOT NULL
);



-- ==========================================================
-- Create Products Table
-- ==========================================================

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



-- ==========================================================
-- Create Orders Table
-- ==========================================================

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



-- ==========================================================
-- Create Inventory Table
-- ==========================================================

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



-- ==========================================================
-- Create Shipments Table
-- ==========================================================

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



-- ==========================================================
-- Create Returns Table
-- ==========================================================

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    return_reason VARCHAR(50) NOT NULL,
    returned_qty INT NOT NULL,

    CONSTRAINT fk_returns_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);



-- ==========================================================
-- Verify Tables
-- ==========================================================

SELECT * FROM customers LIMIT 5;
SELECT * FROM suppliers LIMIT 5;
SELECT * FROM warehouses LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM inventory LIMIT 5;
SELECT * FROM shipments LIMIT 5;
SELECT * FROM returns LIMIT 5;