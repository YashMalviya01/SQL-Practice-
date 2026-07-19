 /*Date functions practice queries level 1 - easy*/


/*Query 1: Extract the year and month from each order date*/

 
SELECT
    order_id,
    order_date,
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month
FROM orders;


/*Query 2: Find orders placed in the current year*/

SELECT *
FROM orders
WHERE order_date >= DATE_TRUNC('year', CURRENT_DATE)
AND order_date < DATE_TRUNC('year', CURRENT_DATE) + INTERVAL '1 year';
	


/*Query 3: Calculate delivery time for each order*/


SELECT 
	order_id,
	order_date,
    delivery_date,
    delivery_date::DATE - order_date::DATE as delivery_days
FROM orders;


/*Query 4: Find orders placed in the last 30 days*/

SELECT * 
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days';


/*Query 5: Calculate monthly revenue*/


SELECT 
	DATE_TRUNC('month', order_date) as order_month
	sum(total_amount) as total_revenue
FROM orders
GROUP BY DATE_TRUNC('month', order_date) 
ORDER BY order_month;


/*Query 6: Calculate the age of each customer*/


SELECT 
	customer_id,
    customer_name,
    birth_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) As age
FROM customers;


/*Query 7: Format order dates as DD-MM-YYYY*/


SELECT
	order_id,
	TO_CHAR(order_date, 'DD_MM_YYYY') as formatted_date_order
FROM orders;


/*Query 8: Find all orders from the previous calendar month*/


SELECT *
FROM orders
WHERE order_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
AND order_date < DATE_TRUNC('month', CURRENT_DATE);


/*Query 9: Calculate shipping delay*/


SELECT
	order_id,
    order_date,
    shipped_date,
    shipped_date::DATE - order_date::DATE as shipping_interval
FROM orders;



/*Query 10: Find orders placed on weekends*/


SELECT *
FROM orders
WHERE EXTRACTION(DOW FROM order_date) IN (0,6);






