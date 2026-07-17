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
