-- ========================================
-- E-Commerce SQL Analysis
-- Author: Adithya Ranjith
-- Database: ecommerce_sql
-- ========================================

USE ecommerce_sql;

-- PHASE 1 — Revenue & Sales Overview

-- 1.Total Revenue
SELECT ROUND(SUM(item_total), 2) AS total_revenue
FROM order_items;

-- 2.Total Orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- 3.Average order value
SELECT 
    ROUND(SUM(oi.item_total) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id;
    
-- PHASE 2 — Revenue by Category
SELECT p.category, ROUND(SUM(oi.item_total), 2) AS revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- PHASE 3 — Top selling products
SELECT p.product_name, SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units_sold DESC
LIMIT 10;

-- PHASE 4 - CUSTOMER INSIGHTS
-- 1.Top Customers by Spending
SELECT u.name, ROUND(SUM(oi.item_total), 2) AS total_spent
FROM users u
JOIN orders o 
    ON u.user_id = o.user_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY u.name
ORDER BY total_spent DESC
LIMIT 10;

-- 2. Repeat Customers
SELECT 
    COUNT(*) AS repeat_customers
FROM (
    SELECT user_id
    FROM orders
    GROUP BY user_id
    HAVING COUNT(order_id) > 1
) AS sub;

-- PHASE 5 - MONTHLY SALES TREND
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(oi.item_total), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- 6. ORDER STATUS ANALYSIS
SELECT order_status,COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;

-- Revenue by status
SELECT o.order_status, ROUND(SUM(oi.item_total), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_status;







