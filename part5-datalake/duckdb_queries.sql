-- Part 5 — Data Lakes & DuckDB
-- All queries read directly from raw files without pre-loading into tables.
--
-- File paths (adjust if running from a different working directory):
--   customers  : customers.csv
--   orders     : orders_flat__1_.csv
--   products   : products.parquet
--
-- Run in DuckDB CLI:  duckdb < duckdb_queries.sql
-- Or in Python     :  duckdb.sql(open("duckdb_queries.sql").read())

-- ---------------------------------------------------------------------------
-- Q1: List all customers along with the total number of orders they have placed
-- ---------------------------------------------------------------------------
SELECT
    c.customer_id,
    c.name                          AS customer_name,
    COUNT(o.order_id)               AS total_orders
FROM read_csv_auto('customers.csv')        AS c
LEFT JOIN read_csv_auto('orders_flat__1_.csv') AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.name
ORDER BY
    total_orders DESC;

-- ---------------------------------------------------------------------------
-- Q2: Find the top 3 customers by total order value
-- ---------------------------------------------------------------------------
SELECT
    c.customer_id,
    c.name                                      AS customer_name,
    SUM(o.unit_price * o.quantity)              AS total_order_value
FROM read_csv_auto('customers.csv')             AS c
JOIN read_csv_auto('orders_flat__1_.csv')       AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.name
ORDER BY
    total_order_value DESC
LIMIT 3;

-- ---------------------------------------------------------------------------
-- Q3: List all products purchased by customers from Bangalore
-- ---------------------------------------------------------------------------
SELECT DISTINCT
    p.product_id,
    p.product_name,
    p.category
FROM read_csv_auto('customers.csv')             AS c
JOIN read_csv_auto('orders_flat__1_.csv')       AS o
    ON c.customer_id = o.customer_id
JOIN read_parquet('products.parquet')           AS p
    ON o.product_id = p.product_id
WHERE
    c.city = 'Bangalore'
ORDER BY
    p.product_name;

-- ---------------------------------------------------------------------------
-- Q4: Join all three files to show:
--     customer name, order date, product name, and quantity
-- ---------------------------------------------------------------------------
SELECT
    c.name           AS customer_name,
    o.order_date,
    p.product_name,
    p.quantity
FROM read_csv_auto('customers.csv')             AS c
JOIN read_csv_auto('orders_flat__1_.csv')       AS o
    ON c.customer_id = o.customer_id
JOIN read_parquet('products.parquet')           AS p
    ON o.order_id    = p.order_id
   AND o.product_id  = p.product_id
ORDER BY
    o.order_date,
    c.name;
