CREATE INDEX customers_cust_id_ix1 ON customers (cust_id);
CREATE INDEX customers_cust_email_ix2 ON customers (cust_email);
CREATE INDEX customers_cust_phone_ix3 ON customers (cust_phone);

CREATE INDEX invoices_cust_id_ix1 ON invoices (customer_id);
CREATE INDEX invoices_ordr_no_ix2 ON invoices (order_no);

CREATE INDEX orders_ordr_no_ix1 ON orders (order_no);
CREATE INDEX orders_cust_id_ix2 ON orders (customer_id);

CREATE INDEX products_prd_id_ix1 ON products (product_id);
