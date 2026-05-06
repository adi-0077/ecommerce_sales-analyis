-- ========================================
-- E-Commerce SQL Analysis
-- Author: Adithya Ranjith
-- Database: ecommerce_sql
-- ========================================

-- PHASE 7 : CUSTOMER SEGMENTATION (HIGH VALUE VS LOW VALUE)
SELECT u.user_id,u.name, COUNT(DISTINCT o.order_id) AS total_orders, ROUND(SUM(oi.item_total), 2) AS total_spent
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.user_id, u.name
ORDER BY total_spent DESC;

SELECT
    CASE
        WHEN total_spent > 5000 THEN 'High Value'
        WHEN total_spent BETWEEN 2000 AND 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(*) AS customer_count
FROM (
    SELECT 
        u.user_id, SUM(oi.item_total) AS total_spent
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY u.user_id
) AS customer_data
GROUP BY customer_segment;

-- PHASE 8 - REPEAT CUSTOMERS BY PERCENTAGE
SELECT 
    COUNT(*) AS repeat_customers
FROM (
    SELECT user_id
    FROM orders
    GROUP BY user_id
    HAVING COUNT(order_id) > 1
) AS repeat_users;

SELECT 
    ROUND(
        (COUNT(DISTINCT CASE WHEN order_count > 1 THEN user_id END) 
        / COUNT(DISTINCT user_id)) * 100, 2
    ) AS repeat_customer_percentage
FROM (
    SELECT user_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY user_id
) AS user_orders;





