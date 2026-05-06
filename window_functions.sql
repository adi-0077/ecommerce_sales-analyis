-- ========================================
-- E-Commerce SQL Analysis
-- Author: Adithya Ranjith
-- Database: ecommerce_sql
-- ========================================

-- 1. RUNNING REVENUE(CUMILATIVE SALES TREND)
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, SUM(oi.item_total) AS monthly_revenue, SUM(SUM(oi.item_total)) OVER (
        ORDER BY DATE_FORMAT(o.order_date, '%Y-%m')
    ) AS cumulative_revenue
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- 2.RANK PRODUCTS BY SALES

SELECT p.product_name, SUM(oi.quantity) AS total_units_sold, RANK() OVER (
        ORDER BY SUM(oi.quantity) DESC
    ) AS product_rank

FROM order_items oi
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY p.product_name;

-- 3. TOP PRODUCT WITHIN EACH CATEGORY
SELECT *
FROM (
    SELECT p.category, p.product_name, SUM(oi.quantity) AS total_sold, RANK() OVER (
            PARTITION BY p.category
            ORDER BY SUM(oi.quantity) DESC
        ) AS rank_in_category
        
    FROM order_items oi
    JOIN products p 
        ON oi.product_id = p.product_id
	GROUP BY p.category, p.product_name
) AS ranked_products
WHERE rank_in_category = 1;

-- 4..IDENTIFY FIRST PURCHASE DATE PER CUSTOMER

SELECT user_id,order_id, order_date, MIN(order_date) OVER (
        PARTITION BY user_id
    ) AS first_purchase_date
FROM orders;

-- 5. CUSTOMER ORDER FREQUENCY

SELECT o.user_id, o.order_id, COUNT(o.order_id) OVER (
        PARTITION BY o.user_id
    ) AS total_orders_per_customer
FROM orders o;

-- 6.CALCULATE DAYS BETWEEN ORDERS

SELECT user_id, order_date, LAG(order_date) OVER (
        PARTITION BY user_id
        ORDER BY order_date
    ) AS previous_order_date,
    
    DATEDIFF(
        order_date,
        LAG(order_date) OVER (
            PARTITION BY user_id
            ORDER BY order_date
        )
    ) AS days_between_orders
FROM orders;

-- 7. TOP 10% CUSTOMERS BY SPENDING

SELECT *
FROM (
    SELECT u.user_id, SUM(oi.item_total) AS total_spent, NTILE(10) OVER (
            ORDER BY SUM(oi.item_total) DESC
        ) AS spending_decile
        
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY u.user_id
) customer_segments
WHERE spending_decile = 1;




