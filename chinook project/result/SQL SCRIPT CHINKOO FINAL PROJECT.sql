--Requirement2:
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

