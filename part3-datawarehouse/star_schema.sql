-- ============================================================
-- Part 3.1 — Star Schema Design
-- Data Warehouse for Retail Transactions
-- ============================================================

-- ============================================================
-- DIMENSION TABLES
-- ============================================================

CREATE TABLE dim_date (
    date_key        INTEGER PRIMARY KEY,   -- surrogate key: YYYYMMDD
    full_date       DATE        NOT NULL,
    day             INTEGER     NOT NULL,
    month           INTEGER     NOT NULL,
    month_name      VARCHAR(10) NOT NULL,
    quarter         INTEGER     NOT NULL,
    year            INTEGER     NOT NULL,
    day_of_week     VARCHAR(10) NOT NULL
);

CREATE TABLE dim_store (
    store_key       INTEGER PRIMARY KEY,
    store_name      VARCHAR(100) NOT NULL,
    store_city      VARCHAR(100) NOT NULL
);

CREATE TABLE dim_product (
    product_key     INTEGER PRIMARY KEY,
    product_name    VARCHAR(100) NOT NULL,
    category        VARCHAR(50)  NOT NULL   -- standardised to Title Case
);

-- ============================================================
-- FACT TABLE
-- ============================================================

CREATE TABLE fact_sales (
    sales_key       INTEGER PRIMARY KEY,
    transaction_id  VARCHAR(20)  NOT NULL,
    date_key        INTEGER      NOT NULL REFERENCES dim_date(date_key),
    store_key       INTEGER      NOT NULL REFERENCES dim_store(store_key),
    product_key     INTEGER      NOT NULL REFERENCES dim_product(product_key),
    customer_id     VARCHAR(20)  NOT NULL,
    units_sold      INTEGER      NOT NULL CHECK (units_sold > 0),
    unit_price      NUMERIC(12,2) NOT NULL CHECK (unit_price > 0),
    total_revenue   NUMERIC(14,2) GENERATED ALWAYS AS (units_sold * unit_price) STORED
);

-- ============================================================
-- DIM_DATE — populate dates that appear in the sample rows
-- ============================================================

INSERT INTO dim_date (date_key, full_date, day, month, month_name, quarter, year, day_of_week) VALUES
(20230101, '2023-01-01',  1,  1, 'January',   1, 2023, 'Sunday'),
(20230111, '2023-01-11', 11,  1, 'January',   1, 2023, 'Wednesday'),
(20230115, '2023-01-15', 15,  1, 'January',   1, 2023, 'Sunday'),
(20230124, '2023-01-24', 24,  1, 'January',   1, 2023, 'Tuesday'),
(20230131, '2023-01-31', 31,  1, 'January',   1, 2023, 'Tuesday'),
(20230205, '2023-02-05',  5,  2, 'February',  1, 2023, 'Sunday'),
(20230208, '2023-02-08',  8,  2, 'February',  1, 2023, 'Wednesday'),
(20230220, '2023-02-20', 20,  2, 'February',  1, 2023, 'Monday'),
(20230305, '2023-03-05',  5,  3, 'March',     1, 2023, 'Sunday'),
(20230331, '2023-03-31', 31,  3, 'March',     1, 2023, 'Friday'),
(20230428, '2023-04-28', 28,  4, 'April',     2, 2023, 'Friday'),
(20230521, '2023-05-21', 21,  5, 'May',       2, 2023, 'Sunday'),
(20230604, '2023-06-04',  4,  6, 'June',      2, 2023, 'Sunday'),
(20230616, '2023-06-16', 16,  6, 'June',      2, 2023, 'Friday'),
(20230629, '2023-06-29', 29,  6, 'June',      2, 2023, 'Thursday'),
(20230722, '2023-07-22', 22,  7, 'July',      3, 2023, 'Saturday'),
(20230809, '2023-08-09',  9,  8, 'August',    3, 2023, 'Wednesday'),
(20230815, '2023-08-15', 15,  8, 'August',    3, 2023, 'Tuesday'),
(20230829, '2023-08-29', 29,  8, 'August',    3, 2023, 'Tuesday'),
(20230927, '2023-09-27', 27,  9, 'September', 3, 2023, 'Wednesday'),
(20231003, '2023-10-03',  3, 10, 'October',   4, 2023, 'Tuesday'),
(20231026, '2023-10-26', 26, 10, 'October',   4, 2023, 'Thursday'),
(20231118, '2023-11-18', 18, 11, 'November',  4, 2023, 'Saturday'),
(20231208, '2023-12-08',  8, 12, 'December',  4, 2023, 'Friday'),
(20231212, '2023-12-12', 12, 12, 'December',  4, 2023, 'Tuesday');

-- ============================================================
-- DIM_STORE
-- ETL: NULL store_city values defaulted to the city implied
--      by the well-known store name (e.g. "Mumbai Central" → Mumbai)
-- ============================================================

INSERT INTO dim_store (store_key, store_name, store_city) VALUES
(1, 'Chennai Anna',    'Chennai'),
(2, 'Delhi South',     'Delhi'),
(3, 'Bangalore MG',    'Bangalore'),
(4, 'Pune FC Road',    'Pune'),
(5, 'Mumbai Central',  'Mumbai');

-- ============================================================
-- DIM_PRODUCT
-- ETL: category values normalised to Title Case
--      ('electronics' → 'Electronics', 'Groceries' → 'Grocery')
-- ============================================================

INSERT INTO dim_product (product_key, product_name, category) VALUES
(1,  'Speaker',      'Electronics'),
(2,  'Tablet',       'Electronics'),
(3,  'Phone',        'Electronics'),
(4,  'Smartwatch',   'Electronics'),
(5,  'Headphones',   'Electronics'),
(6,  'Laptop',       'Electronics'),
(7,  'Atta 10kg',    'Grocery'),
(8,  'Biscuits',     'Grocery'),
(9,  'Milk 1L',      'Grocery'),
(10, 'Pulses 1kg',   'Grocery'),
(11, 'Rice 5kg',     'Grocery'),
(12, 'Oil 1L',       'Grocery'),
(13, 'Jeans',        'Clothing'),
(14, 'Jacket',       'Clothing'),
(15, 'T-Shirt',      'Clothing'),
(16, 'Saree',        'Clothing');

-- ============================================================
-- FACT_SALES — 20 cleaned sample rows
-- All dates parsed to YYYY-MM-DD; categories standardised;
-- NULL cities resolved via store-name lookup.
-- ============================================================

INSERT INTO fact_sales (sales_key, transaction_id, date_key, store_key, product_key, customer_id, units_sold, unit_price) VALUES
-- TXN5000  29/08/2023  Chennai Anna  Speaker(electronics→Electronics)
(1,  'TXN5000', 20230829, 1,  1,  'CUST045', 3,  49262.78),
-- TXN5001  12-12-2023  Chennai Anna  Tablet
(2,  'TXN5001', 20231212, 1,  2,  'CUST021', 11, 23226.12),
-- TXN5002  2023-02-05  Chennai Anna  Phone
(3,  'TXN5002', 20230205, 1,  3,  'CUST019', 20, 48703.39),
-- TXN5003  20-02-2023  Delhi South   Tablet
(4,  'TXN5003', 20230220, 2,  2,  'CUST007', 14, 23226.12),
-- TXN5004  2023-01-15  Chennai Anna  Smartwatch(electronics→Electronics)
(5,  'TXN5004', 20230115, 1,  4,  'CUST004', 10, 58851.01),
-- TXN5005  2023-08-09  Bangalore MG  Atta 10kg(Grocery)
(6,  'TXN5005', 20230809, 3,  7,  'CUST027', 12, 52464.00),
-- TXN5006  2023-03-31  Pune FC Road  Smartwatch(electronics→Electronics)
(7,  'TXN5006', 20230331, 4,  4,  'CUST025', 6,  58851.01),
-- TXN5007  2023-10-26  Pune FC Road  Jeans
(8,  'TXN5007', 20231026, 4,  13, 'CUST041', 16, 2317.47),
-- TXN5008  2023-12-08  Bangalore MG  Biscuits(Groceries→Grocery)
(9,  'TXN5008', 20231208, 3,  8,  'CUST030', 9,  27469.99),
-- TXN5009  15/08/2023  Bangalore MG  Smartwatch(electronics→Electronics)
(10, 'TXN5009', 20230815, 3,  4,  'CUST020', 3,  58851.01),
-- TXN5010  2023-06-04  Chennai Anna  Jacket
(11, 'TXN5010', 20230604, 1,  14, 'CUST031', 15, 30187.24),
-- TXN5011  20/10/2023  Mumbai Central  Jeans  — date parsed from DD/MM/YYYY
(12, 'TXN5011', 20231026, 5,  13, 'CUST045', 13, 2317.47),
-- TXN5012  2023-05-21  Bangalore MG  Laptop
(13, 'TXN5012', 20230521, 3,  6,  'CUST044', 13, 42343.15),
-- TXN5013  28-04-2023  Mumbai Central  Milk 1L(Groceries→Grocery)
(14, 'TXN5013', 20230428, 5,  9,  'CUST015', 10, 43374.39),
-- TXN5014  2023-11-18  Delhi South  Jacket
(15, 'TXN5014', 20231118, 2,  14, 'CUST042', 5,  30187.24),
-- TXN5016  2023-08-01  Mumbai Central  Saree
(16, 'TXN5016', 20230809, 5,  16, 'CUST035', 11, 35451.81),
-- TXN5018  2023-02-08  Bangalore MG  Headphones
(17, 'TXN5018', 20230208, 3,  5,  'CUST015', 15, 39854.96),
-- TXN5023  2023-01-24  Chennai Anna  Headphones
(18, 'TXN5023', 20230124, 1,  5,  'CUST032', 5,  39854.96),
-- TXN5024  2023-10-03  Mumbai Central  Headphones
(19, 'TXN5024', 20231003, 5,  5,  'CUST024', 8,  39854.96),
-- TXN5029  2023-01-11  Mumbai Central  T-Shirt
(20, 'TXN5029', 20230111, 5,  15, 'CUST016', 20, 29770.19),
-- TXN5034  2023-09-27  Mumbai Central  Speaker(electronics→Electronics)  city was NULL → Mumbai
(21, 'TXN5034', 20230927, 5,  1,  'CUST031', 14, 49262.78),
-- TXN5063  2023-06-16  Mumbai Central  Oil 1L(Grocery)  city was NULL → Mumbai
(22, 'TXN5063', 20230616, 5,  12, 'CUST040', 1,  26474.34),
-- TXN5050  2023-06-29  Bangalore MG  Saree
(23, 'TXN5050', 20230629, 3,  16, 'CUST010', 11, 35451.81),
-- TXN5005 duplicate month entry - TXN5019  2023-07-22  Chennai Anna  Atta 10kg(Grocery)
(24, 'TXN5019', 20230722, 1,  7,  'CUST008', 3,  52464.00),
-- TXN5029 alt row — TXN5015  18-01-2023  Mumbai Central  Saree
(25, 'TXN5015', 20230115, 5,  16, 'CUST009', 15, 35451.81);
