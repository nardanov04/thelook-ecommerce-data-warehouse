/*
File: extract_thelook_queries.sql
Purpose: Extract data for the data warehouse from BigQuery (bigquery-public-data.thelook_ecommerce).
Run each query in BigQuery and export the result as a CSV file into the data folder.
Scope: orders and stock received in 2025.
*/

-- Query 1: order_items_2025.csv (feeds fact_sales)
-- Order items created in 2025
SELECT
    id,
    order_id,
    user_id,
    product_id,
    inventory_item_id,
    status,
    created_at,
    shipped_at,
    delivered_at,
    sale_price
FROM `bigquery-public-data.thelook_ecommerce.order_items`
WHERE EXTRACT(YEAR FROM created_at) = 2025;

-- Query 2: inventory_items_2025.csv (feeds fact_inventory)
-- Stock units received in 2025
SELECT
    id,
    product_id,
    created_at,
    sold_at,
    cost,
    product_distribution_center_id
FROM `bigquery-public-data.thelook_ecommerce.inventory_items`
WHERE EXTRACT(YEAR FROM created_at) = 2025;

-- Query 3: products.csv (feeds dim_product, and gives cost and distribution_center_id to fact_sales)
-- All products
SELECT
    id,
    name,
    category,
    brand,
    department,
    retail_price,
    cost,
    distribution_center_id
FROM `bigquery-public-data.thelook_ecommerce.products`;

-- Query 4: users_2025.csv (feeds dim_user)
-- Only customers who ordered in 2025
SELECT
    id,
    age,
    gender,
    city,
    state,
    country,
    traffic_source
FROM `bigquery-public-data.thelook_ecommerce.users`
WHERE id IN (
    SELECT user_id
    FROM `bigquery-public-data.thelook_ecommerce.order_items`
    WHERE EXTRACT(YEAR FROM created_at) = 2025
);

-- Query 5: distribution_centers.csv (feeds dim_distribution_center)
-- All distribution centers
SELECT
    id,
    name,
    latitude,
    longitude
FROM `bigquery-public-data.thelook_ecommerce.distribution_centers`;