-- =============================================================
-- schema_design.sql
-- 3NF Schema for orders_flat.csv
-- =============================================================

-- Drop tables in reverse dependency order (safe re-run)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS sales_reps;

-- =============================================================
-- TABLE: sales_reps
-- Stores each sales representative exactly once.
-- Eliminates update anomaly on office_address.
-- =============================================================
CREATE TABLE sales_reps (
    sales_rep_id   VARCHAR(10)  NOT NULL,
    sales_rep_name VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(150) NOT NULL,
    office_address VARCHAR(255) NOT NULL,
    CONSTRAINT pk_sales_reps PRIMARY KEY (sales_rep_id)
);

INSERT INTO sales_reps (sales_rep_id, sales_rep_name, sales_rep_email, office_address) VALUES
('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021'),
('SR02', 'Anita Desai',  'anita@corp.com',  'Delhi Office, Connaught Place, New Delhi - 110001'),
('SR03', 'Ravi Kumar',   'ravi@corp.com',   'South Zone, MG Road, Bangalore - 560001');


-- =============================================================
-- TABLE: customers
-- Stores each customer exactly once.
-- Eliminates delete anomaly — customer records survive order deletions.
-- =============================================================
CREATE TABLE customers (
    customer_id    VARCHAR(10)  NOT NULL,
    customer_name  VARCHAR(100) NOT NULL,
    customer_email VARCHAR(150) NOT NULL,
    customer_city  VARCHAR(100) NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
);

INSERT INTO customers (customer_id, customer_name, customer_email, customer_city) VALUES
('C001', 'Rohan Mehta',  'rohan@gmail.com',  'Mumbai'),
('C002', 'Priya Sharma', 'priya@gmail.com',  'Delhi'),
('C003', 'Amit Verma',   'amit@gmail.com',   'Bangalore'),
('C004', 'Sneha Iyer',   'sneha@gmail.com',  'Chennai'),
('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai'),
('C006', 'Neha Gupta',   'neha@gmail.com',   'Delhi'),
('C007', 'Arjun Nair',   'arjun@gmail.com',  'Bangalore'),
('C008', 'Kavya Rao',    'kavya@gmail.com',  'Hyderabad');


-- =============================================================
-- TABLE: products
-- Stores each product and its price exactly once.
-- Eliminates insert anomaly — products can exist without orders.
-- =============================================================
CREATE TABLE products (
    product_id   VARCHAR(10)  NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    category     VARCHAR(100) NOT NULL,
    unit_price   DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    CONSTRAINT pk_products PRIMARY KEY (product_id)
);

INSERT INTO products (product_id, product_name, category, unit_price) VALUES
('P001', 'Laptop',        'Electronics', 55000.00),
('P002', 'Mouse',         'Electronics',   800.00),
('P003', 'Desk Chair',    'Furniture',    8500.00),
('P004', 'Notebook',      'Stationery',    120.00),
('P005', 'Headphones',    'Electronics',  3200.00),
('P006', 'Standing Desk', 'Furniture',   22000.00),
('P007', 'Pen Set',       'Stationery',    250.00),
('P008', 'Webcam',        'Electronics',  2100.00);


-- =============================================================
-- TABLE: orders
-- One row per order transaction.
-- References customers and sales_reps via foreign keys.
-- =============================================================
CREATE TABLE orders (
    order_id     VARCHAR(20) NOT NULL,
    customer_id  VARCHAR(10) NOT NULL,
    sales_rep_id VARCHAR(10) NOT NULL,
    order_date   DATE        NOT NULL,
    CONSTRAINT pk_orders        PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_cust   FOREIGN KEY (customer_id)  REFERENCES customers(customer_id),
    CONSTRAINT fk_orders_sr     FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(sales_rep_id)
);

INSERT INTO orders (order_id, customer_id, sales_rep_id, order_date) VALUES
('ORD1002', 'C002', 'SR02', '2023-01-17'),
('ORD1003', 'C001', 'SR01', '2023-01-22'),
('ORD1004', 'C003', 'SR01', '2023-01-30'),
('ORD1006', 'C005', 'SR01', '2023-02-10'),
('ORD1007', 'C004', 'SR01', '2023-02-18'),
('ORD1010', 'C006', 'SR01', '2023-03-01'),
('ORD1011', 'C001', 'SR01', '2023-03-05'),
('ORD1012', 'C002', 'SR01', '2023-03-10'),
('ORD1013', 'C008', 'SR01', '2023-03-15'),
('ORD1022', 'C005', 'SR01', '2023-10-15'),
('ORD1025', 'C004', 'SR01', '2023-10-20'),
('ORD1027', 'C002', 'SR02', '2023-11-02'),
('ORD1028', 'C003', 'SR01', '2023-11-08'),
('ORD1030', 'C007', 'SR01', '2023-11-12'),
('ORD1031', 'C008', 'SR01', '2023-11-18'),
('ORD1037', 'C002', 'SR03', '2023-03-06'),
('ORD1043', 'C006', 'SR01', '2023-04-02'),
('ORD1044', 'C001', 'SR01', '2023-04-10'),
('ORD1045', 'C003', 'SR01', '2023-04-15'),
('ORD1046', 'C004', 'SR01', '2023-04-20'),
('ORD1051', 'C005', 'SR01', '2023-05-01'),
('ORD1052', 'C006', 'SR01', '2023-05-05'),
('ORD1053', 'C007', 'SR01', '2023-05-09'),
('ORD1054', 'C002', 'SR03', '2023-10-04'),
('ORD1055', 'C008', 'SR01', '2023-05-14'),
('ORD1056', 'C001', 'SR01', '2023-05-18'),
('ORD1057', 'C003', 'SR01', '2023-05-22'),
('ORD1059', 'C004', 'SR01', '2023-05-28'),
('ORD1061', 'C006', 'SR01', '2023-10-27'),
('ORD1063', 'C007', 'SR01', '2023-06-05'),
('ORD1065', 'C008', 'SR01', '2023-06-10'),
('ORD1066', 'C001', 'SR01', '2023-06-14'),
('ORD1068', 'C002', 'SR01', '2023-06-20'),
('ORD1071', 'C003', 'SR01', '2023-06-27'),
('ORD1073', 'C004', 'SR01', '2023-07-02'),
('ORD1075', 'C005', 'SR03', '2023-04-18'),
('ORD1076', 'C004', 'SR03', '2023-05-16'),
('ORD1077', 'C006', 'SR01', '2023-07-08'),
('ORD1078', 'C007', 'SR01', '2023-07-12'),
('ORD1080', 'C008', 'SR01', '2023-07-18'),
('ORD1081', 'C001', 'SR01', '2023-07-22'),
('ORD1082', 'C002', 'SR01', '2023-07-28'),
('ORD1083', 'C006', 'SR01', '2023-07-03'),
('ORD1084', 'C003', 'SR01', '2023-08-01'),
('ORD1086', 'C004', 'SR01', '2023-08-07'),
('ORD1091', 'C001', 'SR01', '2023-07-24'),
('ORD1092', 'C002', 'SR01', '2023-08-20'),
('ORD1094', 'C003', 'SR01', '2023-08-25'),
('ORD1097', 'C004', 'SR01', '2023-09-01'),
('ORD1098', 'C007', 'SR03', '2023-10-03'),
('ORD1099', 'C005', 'SR01', '2023-09-07'),
('ORD1100', 'C006', 'SR01', '2023-09-12'),
('ORD1102', 'C007', 'SR01', '2023-09-18'),
('ORD1109', 'C008', 'SR01', '2023-10-05'),
('ORD1110', 'C001', 'SR01', '2023-10-10'),
('ORD1114', 'C001', 'SR01', '2023-08-06'),
('ORD1116', 'C002', 'SR01', '2023-10-18'),
('ORD1118', 'C006', 'SR02', '2023-11-10'),
('ORD1121', 'C003', 'SR01', '2023-10-25'),
('ORD1126', 'C004', 'SR01', '2023-11-02'),
('ORD1128', 'C005', 'SR01', '2023-11-06'),
('ORD1130', 'C006', 'SR01', '2023-11-10'),
('ORD1131', 'C008', 'SR02', '2023-06-22'),
('ORD1132', 'C003', 'SR02', '2023-03-07'),
('ORD1133', 'C001', 'SR03', '2023-10-16'),
('ORD1137', 'C005', 'SR02', '2023-05-10'),
('ORD1140', 'C007', 'SR01', '2023-11-18'),
('ORD1141', 'C008', 'SR01', '2023-11-22'),
('ORD1153', 'C006', 'SR01', '2023-02-14'),
('ORD1155', 'C001', 'SR01', '2023-12-01'),
('ORD1156', 'C002', 'SR01', '2023-12-05'),
('ORD1158', 'C003', 'SR01', '2023-12-09'),
('ORD1160', 'C004', 'SR01', '2023-12-13'),
('ORD1162', 'C006', 'SR03', '2023-09-29'),
('ORD1165', 'C005', 'SR01', '2023-12-20'),
('ORD1166', 'C006', 'SR01', '2023-12-24'),
('ORD1167', 'C007', 'SR01', '2023-12-28'),
('ORD1169', 'C008', 'SR01', '2023-12-30'),
('ORD1170', 'C005', 'SR01', '2024-01-03'),
('ORD1171', 'C008', 'SR01', '2024-01-06'),
('ORD1172', 'C005', 'SR01', '2024-01-09'),
('ORD1173', 'C006', 'SR01', '2024-01-12'),
('ORD1174', 'C008', 'SR01', '2024-01-15'),
('ORD1175', 'C008', 'SR01', '2024-01-18'),
('ORD1176', 'C001', 'SR01', '2024-01-21'),
('ORD1177', 'C005', 'SR01', '2024-01-24'),
('ORD1178', 'C007', 'SR01', '2024-01-27'),
('ORD1179', 'C004', 'SR01', '2024-01-30'),
('ORD1180', 'C008', 'SR01', '2024-02-02'),
('ORD1181', 'C007', 'SR01', '2024-02-05'),
('ORD1182', 'C001', 'SR01', '2024-02-08'),
('ORD1183', 'C004', 'SR01', '2024-02-11'),
('ORD1184', 'C003', 'SR01', '2024-02-14'),
('ORD1185', 'C003', 'SR03', '2023-06-15');


-- =============================================================
-- TABLE: order_items
-- One row per product line within an order.
-- Stores quantity; unit_price is looked up from products.
-- This resolves the many-to-many between orders and products.
-- =============================================================
CREATE TABLE order_items (
    order_item_id INT          NOT NULL AUTO_INCREMENT,
    order_id      VARCHAR(20)  NOT NULL,
    product_id    VARCHAR(10)  NOT NULL,
    quantity      INT          NOT NULL CHECK (quantity > 0),
    unit_price    DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    CONSTRAINT pk_order_items    PRIMARY KEY (order_item_id),
    CONSTRAINT fk_items_order    FOREIGN KEY (order_id)    REFERENCES orders(order_id),
    CONSTRAINT fk_items_product  FOREIGN KEY (product_id)  REFERENCES products(product_id)
);

-- Representative sample of 30+ order items (5+ per table requirement satisfied above;
-- including enough rows to make all 5 queries meaningful)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
('ORD1002', 'P005', 1,  3200.00),
('ORD1003', 'P002', 3,   800.00),
('ORD1004', 'P004', 5,   120.00),
('ORD1006', 'P001', 2, 55000.00),
('ORD1007', 'P003', 1,  8500.00),
('ORD1010', 'P007', 4,   250.00),
('ORD1011', 'P006', 1, 22000.00),
('ORD1012', 'P001', 1, 55000.00),
('ORD1013', 'P002', 5,   800.00),
('ORD1022', 'P002', 5,   800.00),
('ORD1025', 'P003', 2,  8500.00),
('ORD1027', 'P004', 4,   120.00),
('ORD1028', 'P005', 2,  3200.00),
('ORD1030', 'P007', 3,   250.00),
('ORD1031', 'P006', 2, 22000.00),
('ORD1037', 'P007', 2,   250.00),
('ORD1043', 'P001', 3, 55000.00),
('ORD1044', 'P004', 2,   120.00),
('ORD1054', 'P001', 1, 55000.00),
('ORD1061', 'P001', 4, 55000.00),
('ORD1075', 'P003', 3,  8500.00),
('ORD1076', 'P006', 5, 22000.00),
('ORD1083', 'P007', 2,   250.00),
('ORD1091', 'P006', 3, 22000.00),
('ORD1098', 'P001', 2, 55000.00),
('ORD1114', 'P007', 2,   250.00),
('ORD1118', 'P007', 5,   250.00),
('ORD1131', 'P001', 4, 55000.00),
('ORD1132', 'P007', 5,   250.00),
('ORD1137', 'P007', 1,   250.00),
('ORD1153', 'P007', 3,   250.00),
('ORD1162', 'P004', 3,   120.00),
('ORD1185', 'P008', 1,  2100.00);
