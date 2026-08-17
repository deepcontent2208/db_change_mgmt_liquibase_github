--liquibase formatted sql
--changeset deep:1
--comment: Create new tables - customers, invoices, orders, products.

CREATE TABLE ${schema_name}.customers (
  cust_id bigint not null,
  cust_name varchar(100) not null,
  cust_addr varchar(100),
  cust_type varchar(20),
  cust_email varchar(40) not null,
  cust_phone varchar(15) not null,
  card_no varchar(40),
  acc_no varchar(40),
  paypal_acc varchar(40)
);

CREATE TABLE ${schema_name}.invoices (
  order_no varchar(40) not null,
  customer_id bigint not null,
  product_id varchar(30) not null,
  qty int
);

CREATE TABLE ${schema_name}.orders (
  order_no varchar(40) not null,
  customer_id bigint not null,
  order_date date,
  payment_method varchar(20)
);

CREATE TABLE ${schema_name}.products (
  product_id varchar(30) not null,
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

ALTER TABLE ${schema_name}.customers ADD PRIMARY KEY (cust_id);
ALTER TABLE ${schema_name}.invoices ADD PRIMARY KEY (order_no);
ALTER TABLE ${schema_name}.orders ADD PRIMARY KEY (order_no);
ALTER TABLE ${schema_name}.products ADD PRIMARY KEY (product_id);

--rollback DROP TABLE ${schema_name}.customers;
--rollback DROP TABLE ${schema_name}.orders;
--rollback DROP TABLE ${schema_name}.products;


--changeset deep:2
--comment: Create indexes for the tables - customers, invoices, orders, products.
CREATE INDEX customers_cust_id_ix1 ON ${schema_name}.customers (cust_id);
CREATE INDEX customers_cust_email_ix2 ON ${schema_name}.customers (cust_email);
CREATE INDEX customers_cust_phone_ix3 ON ${schema_name}.customers (cust_phone);

CREATE INDEX invoices_cust_id_ix1 ON ${schema_name}.invoices (customer_id);
CREATE INDEX invoices_ordr_no_ix2 ON ${schema_name}.invoices (order_no);

CREATE INDEX orders_ordr_no_ix1 ON ${schema_name}.orders (order_no);
CREATE INDEX orders_cust_id_ix2 ON ${schema_name}.orders (customer_id);

CREATE INDEX products_prd_id_ix1 ON ${schema_name}.products (product_id);

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
ALTER TABLE ${schema_name}.invoices
ADD CONSTRAINT fk_invoices_customers
FOREIGN KEY (customer_id)
REFERENCES customers (cust_id);

ALTER TABLE ${schema_name}.invoices
ADD CONSTRAINT fk_invoices_orders
FOREIGN KEY (order_no)
REFERENCES orders (order_no);

ALTER TABLE ${schema_name}.invoices
ADD CONSTRAINT fk_invoices_products
FOREIGN KEY (product_id)
REFERENCES products (product_id);

ALTER TABLE ${schema_name}.orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers (cust_id);

--rollback ALTER TABLE ${schema_name}.invoices DROP CONSTRAINT fk_invoices_customers;
--rollback ALTER TABLE ${schema_name}.invoices DROP CONSTRAINT fk_invoices_orders;
--rollback ALTER TABLE ${schema_name}.invoices DROP CONSTRAINT fk_invoices_products;
--rollback ALTER TABLE ${schema_name}.orders DROP CONSTRAINT fk_orders_customers;


--changeset deep:4
--comment: Add new columns in invoices table.
--comment: Change data type in customers and invoices tables.
--comment: Drop columns in products table.
ALTER TABLE ${schema_name}.invoices ADD invoice_no bigint;
ALTER TABLE ${schema_name}.invoices ADD invoice_date date;

ALTER TABLE ${schema_name}.customers
ALTER COLUMN card_no varchar(30);

ALTER TABLE ${schema_name}.invoices
ALTER COLUMN order_no varchar(30);

ALTER TABLE ${schema_name}.orders
ALTER COLUMN order_no varchar(30);

ALTER TABLE ${schema_name}.products DROP COLUMN offer_3;
ALTER TABLE ${schema_name}.products DROP COLUMN offer_4;

--rollback ALTER TABLE ${schema_name}.invoices DROP COLUMN invoice_no bigint;
--rollback ALTER TABLE ${schema_name}.invoices DROP COLUMN invoice_date date;
--rollback ALTER TABLE ${schema_name}.customers ALTER COLUMN card_no varchar(40);
--rollback ALTER TABLE ${schema_name}.invoices ALTER COLUMN order_no varchar(40);
--rollback ALTER TABLE ${schema_name}.orders ALTER COLUMN order_no varchar(40);
--rollback ALTER TABLE ${schema_name}.products ADD offer_3;
--rollback ALTER TABLE ${schema_name}.products ADD offer_4;

--changeset deep:5
--comment: Change data type in orders table.
ALTER TABLE ${schema_name}.orders
ALTER COLUMN order_date timestamp;

--rollback ALTER TABLE ${schema_name}.orders ALTER COLUMN order_date date;
