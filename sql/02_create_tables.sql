/*
File: 02_create_tables.sql
Purpose: Create the galaxy schema (2 fact tables and 4 dimension tables) for The Look data warehouse.
Run this second, while connected to the 'thelook_dwh' database.
Tables are dropped first, so the script can be re-run safely.
*/

-- Drop fact tables first, then dimension tables (facts reference dimensions)
DROP TABLE IF EXISTS fact_sales, fact_inventory;
DROP TABLE IF EXISTS dim_product, dim_distribution_center, dim_user, dim_date;

-- Dimension 1: product (what is sold)
CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(300),
    category VARCHAR(100),
    brand VARCHAR(100),
    department VARCHAR(100),
    retail_price NUMERIC(10, 2)
);

-- Dimension 2: distribution center (where stock is stored and shipped from)
CREATE TABLE dim_distribution_center(
    distribution_center_id INT PRIMARY KEY,
    distribution_center_name VARCHAR(100),
    latitude NUMERIC(10, 6),
    longitude NUMERIC(10, 6)
);

-- Dimension 3: user (who buys the products)
CREATE TABLE dim_user(
    user_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(8),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    traffic_source VARCHAR(50)
);

-- Dimension 4: date (shared by both fact tables, date_id format is yyyyMMdd)
CREATE TABLE dim_date(
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(10) NOT NULL,
    day_name VARCHAR(10) NOT NULL
);

-- Fact (main): sales, one row per order item
CREATE TABLE fact_sales (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    inventory_item_id INT,
    user_id INT NOT NULL REFERENCES dim_user (user_id),
    product_id INT NOT NULL REFERENCES dim_product (product_id),
    distribution_center_id INT REFERENCES dim_distribution_center (distribution_center_id),
    order_date_id INT NOT NULL REFERENCES dim_date (date_id),
    shipped_date_id INT REFERENCES dim_date (date_id),
    delivered_date_id INT REFERENCES dim_date (date_id),
    status VARCHAR(30) NOT NULL,
    sale_price NUMERIC(10, 2) NOT NULL,
    cost NUMERIC(10, 2),
    profit NUMERIC(10, 2)
);

-- Fact (supporting): inventory, one row per stock unit (is_sold is 1 if sold and 0 if not, days_in_stock is NULL if unsold)
CREATE TABLE fact_inventory (
    inventory_item_id INT PRIMARY KEY,
    product_id INT NOT NULL REFERENCES dim_product (product_id),
    distribution_center_id INT REFERENCES dim_distribution_center (distribution_center_id),
    received_date_id INT NOT NULL REFERENCES dim_date (date_id),
    sold_date_id INT REFERENCES dim_date (date_id),
    cost NUMERIC(10, 2),
    is_sold INT NOT NULL,
    days_in_stock INT
);