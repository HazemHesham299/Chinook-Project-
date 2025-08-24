--Requirement 1
---Use INNER JOIN and LEFT JOIN to combine the Customer, Invoice, and InvoiceLine tables
---Use a CTE (Common Table Expression) to calculate the total amount spent by each customer.
WITH customer_total_spending AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(il.unit_price * il.quantity) AS total_spent
    FROM customer c
    INNER JOIN invoice i ON c.customer_id = i.customer_id
    INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)

SELECT 
    customer_id,
    first_name,
    last_name,
    total_spent
FROM customer_total_spending
ORDER BY total_spent DESC
LIMIT 10;

--Requirement2:
---use window functions to rank products by total sales 
---Calculate the rank of each product by total sales amount.
---Identify the top-selling products in the database
WITH product_sales AS (
    SELECT
        t.track_id,
        t.name AS track_name,
        SUM(il.quantity * il.unit_price) AS total_sales,
        SUM(il.quantity) AS total_quantity
    FROM track t
    INNER JOIN invoice_line il ON t.track_id = il.track_id
    GROUP BY t.track_id, t.name
)

SELECT 
    track_id,
    track_name,
    total_sales,
    total_quantity,
    RANK() OVER (ORDER BY total_quantity DESC) AS sales_rank
FROM product_sales
ORDER BY total_quantity DESC
LIMIT 10;

--Requirement 3:
---Identify the most commonly queried columns CustomerId in the Invoice table)
---Create indexes on these columns and compare query performance with and without indexing.
---Write a query that lists total sales for each customer, and optimize it using indexing.
explain analyze 
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(il.unit_price * il.quantity) AS total_sales
FROM customer c
INNER JOIN invoice i ON c.customer_id = i.customer_id
INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_sales DESC;

CREATE INDEX idx_invoice_customer_id ON invoice (customer_id);


explain analyze 
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(il.unit_price * il.quantity) AS total_sales
FROM customer c
INNER JOIN invoice i ON c.customer_id = i.customer_id
INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_sales DESC;