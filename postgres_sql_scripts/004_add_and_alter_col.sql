ALTER TABLE invoices ADD COLUMN invoice_no bigint;
ALTER TABLE invoices ADD COLUMN invoice_date date;

ALTER TABLE customers
ALTER COLUMN card_no TYPE varchar(30);

ALTER TABLE invoices
ALTER COLUMN order_no TYPE varchar(30);

ALTER TABLE orders
ALTER COLUMN order_no TYPE varchar(30);

ALTER TABLE products DROP COLUMN offer_3;
ALTER TABLE products DROP COLUMN offer_4;
