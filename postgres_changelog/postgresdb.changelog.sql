--liquibase formatted sql
--changeset deep:1
--comment: Create new tables - customers, invoices, orders, products.
CREATE TABLE customers (
  cust_id bigint,
  cust_name varchar(100),
  cust_addr varchar(100),
  cust_type varchar(20),
  cust_email varchar(40),
  cust_phone varchar(15),
  card_no varchar(40),
  acc_no varchar(40),
  paypal_acc varchar(40)
);

CREATE TABLE invoices (
  order_no varchar(40),
  customer_id bigint,
  product_id varchar(25),
  qty int
);

CREATE TABLE orders (
  order_no varchar(40),
  customer_id bigint,
  order_date date,
  payment_method varchar(20)
);

CREATE TABLE products (
  product_id varchar(30),
  product_desc varchar(60),
  product_category varchar(40),
  price decimal(18,2),
  total_qty_in_stock int,
  total_cust_review_count int,
  avg_review_stars decimal(4,2),
  offer_1 varchar(40),
  offer_2 varchar(40),
  offer_3 varchar(40),
  offer_4 varchar(40),
  model_number varchar(10),
  processor varchar(10)
);

ALTER TABLE customers ADD PRIMARY KEY (cust_id);
ALTER TABLE invoices ADD PRIMARY KEY (order_no);
ALTER TABLE orders ADD PRIMARY KEY (order_no);
ALTER TABLE products ADD PRIMARY KEY (product_id);

--rollback DROP TABLE customers;
--rollback DROP TABLE orders;
--rollback DROP TABLE products;


--changeset deep:5
--comment: Change data type in orders table.
ALTER TABLE orders
ALTER COLUMN order_date TYPE timestamp;

--rollback ALTER TABLE orders ALTER COLUMN order_date TYPE date;
