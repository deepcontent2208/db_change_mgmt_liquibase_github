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


--rollback ALTER TABLE ${schema_name}.invoices DROP CONSTRAINT fk_invoices_customers;
--rollback ALTER TABLE ${schema_name}.invoices DROP CONSTRAINT fk_invoices_orders;
--rollback ALTER TABLE ${schema_name}.invoices DROP CONSTRAINT fk_invoices_products;
--rollback ALTER TABLE ${schema_name}.orders DROP CONSTRAINT fk_orders_customers;

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


--changeset deep:3
--comment: Create indexes for the tables - customers, invoices, orders, products.
CREATE TABLE ${schema_name}.order_items (
  order_item_no varchar(40) not null,
  order_no varchar(40),
  order_item_qty int,
  order_item_price decimal(10,2)
);

ALTER TABLE ${schema_name}.order_items ADD PRIMARY KEY (order_item_no);

--rollback drop table order_items;
--rollback DROP INDEX customers_cust_phone_ix3;
--rollback DROP INDEX invoices_cust_id_ix1;
--rollback DROP INDEX invoices_ordr_no_ix2;
--rollback DROP INDEX orders_ordr_no_ix1;
--rollback DROP INDEX orders_cust_id_ix2;
--rollback DROP INDEX products_prd_id_ix1;

