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


--changeset deep:2
--comment: Create indexes for the tables - customers, invoices, orders, products.
CREATE INDEX customers_cust_id_ix1 ON customers (cust_id);
CREATE INDEX customers_cust_email_ix2 ON customers (cust_email);
CREATE INDEX customers_cust_phone_ix3 ON customers (cust_phone);

CREATE INDEX invoices_cust_id_ix1 ON invoices (customer_id);
CREATE INDEX invoices_ordr_no_ix2 ON invoices (order_no);

CREATE INDEX orders_ordr_no_ix1 ON orders (order_no);
CREATE INDEX orders_cust_id_ix2 ON orders (customer_id);

CREATE INDEX products_prd_id_ix1 ON products (product_id);

--rollback DROP INDEX customers_cust_id_ix1;
--rollback DROP INDEX customers_cust_email_ix2;
--rollback DROP INDEX customers_cust_phone_ix3;
--rollback DROP INDEX invoices_cust_id_ix1;
--rollback DROP INDEX invoices_ordr_no_ix2;
--rollback DROP INDEX orders_ordr_no_ix1;
--rollback DROP INDEX orders_cust_id_ix2;
--rollback DROP INDEX products_prd_id_ix1;


--changeset deep:3
--comment: Create referential integrities between invoices and customers, orders, products.
--comment: Create referential integrities between orders and customers.
ALTER TABLE invoices
ADD CONSTRAINT fk_invoices_customers
FOREIGN KEY (customer_id)
REFERENCES customers (cust_id);

ALTER TABLE invoices
ADD CONSTRAINT fk_invoices_orders
FOREIGN KEY (order_no)
REFERENCES orders (order_no);

ALTER TABLE invoices
ADD CONSTRAINT fk_invoices_products
FOREIGN KEY (product_id)
REFERENCES products (product_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers (cust_id);

--rollback ALTER TABLE invoices DROP CONSTRAINT fk_invoices_customers;
--rollback ALTER TABLE invoices DROP CONSTRAINT fk_invoices_orders;
--rollback ALTER TABLE invoices DROP CONSTRAINT fk_invoices_products;
--rollback ALTER TABLE orders DROP CONSTRAINT fk_orders_customers;

--changeset deep:4
--comment: Create new table order_items.
CREATE TABLE order_items (
  order_item_no varchar(40),
  order_no varchar(40),
  order_item_qty int,
  order_item_price decimal(10,2)
);

ALTER TABLE order_items ADD PRIMARY KEY (order_item_no);

ALTER TABLE order_items ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_no)
REFERENCES orders (order_no);
