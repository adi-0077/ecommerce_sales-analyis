-- ========================================
-- E-Commerce SQL Analysis
-- Author: Adithya Ranjith
-- Database: ecommerce_sql
-- ========================================

-- Create database
CREATE DATABASE ecommerce_sql;

-- Use database
USE ecommerce_sql;

-- USERS TABLE
CREATE TABLE users (
    user_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    gender VARCHAR(10),
    city VARCHAR(50),
    signup_date DATE
);

-- PRODUCTS TABLE
CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(150),
    category VARCHAR(50),
    brand VARCHAR(50),
    price DECIMAL(10,2),
    rating DECIMAL(3,2)
);

-- ORDERS TABLE
CREATE TABLE orders (
    order_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10),
    order_date DATE,
    order_status VARCHAR(20),
    total_amount DECIMAL(10,2),

    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ORDER ITEMS TABLE
CREATE TABLE order_items (
    order_item_id VARCHAR(15) PRIMARY KEY,
    order_id VARCHAR(10),
    product_id VARCHAR(10),
    user_id VARCHAR(10),
    quantity INT,
    item_price DECIMAL(10,2),
    item_total DECIMAL(10,2),

    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
USE ecommerce_sql;

SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM order_items;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM users;
SET SQL_SAFE_UPDATES = 1;

SHOW VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE 'C:/Users/adith/OneDrive/Documents/Desktop/mysql_csv/users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(user_id, name, email, gender, city, signup_date);

SELECT COUNT(*) FROM users;

LOAD DATA LOCAL INFILE 'C:/Users/adith/OneDrive/Documents/Desktop/mysql_csv/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_name, category, brand, price, rating);
SELECT COUNT(*) FROM products;

LOAD DATA LOCAL INFILE 'C:/Users/adith/OneDrive/Documents/Desktop/mysql_csv/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, user_id, order_date, order_status, total_amount);
SELECT COUNT(*) FROM orders;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE 'C:/Users/adith/OneDrive/Documents/Desktop/mysql_csv/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_item_id, order_id, product_id, user_id, quantity, item_price, item_total);

SELECT 
    (SELECT COUNT(*) FROM users) AS users_count,
    (SELECT COUNT(*) FROM products) AS products_count,
    (SELECT COUNT(*) FROM orders) AS orders_count,
    (SELECT COUNT(*) FROM order_items) AS order_items_count;
    
    













