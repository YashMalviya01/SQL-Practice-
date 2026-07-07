/*Window functions part 1 ROW NUMBER & RANK*/


/*Question 1
Assign a unique row number to all orders based on the highest order amount.*/

SELECT 
	order_id,
	customer_id
	total_amount,
	ROW_NUMBER() OVER (ORDER BY total_amount DESC) AS row_number
FROM orders;


/*Question 2
Assign row numbers to products according to price (highest first).*/

SELECT 
	product_id,
	product_name,
	price,
	ROW_NUMBER() OVER(ORDER BY price DESC) AS product_rank
FROM products;


/*Question 3
Assign row numbers to employees according to the number of orders they handled.*/

SELECT
	employee_id,
	COUNT(order_id) as total_orders,
	ROW_NUMBER() OVER(ORDER BY COUNT(order_id) DESC) AS employee_rank
FROM orders
GROUP BY employee_id;


/*Question 4
Give every order a row number inside each store based on the highest order amount.*/

SELECT 
	order_id,
	store_id,
	total_amount,
	ROW_NUMBER () OVER ( PARTITION BY store_id ORDER BY total_amount DESC) as highest_order
FROM orders;


/*Question 5
Give every customer a row number inside each city according to total spending.*/

SELECT 
	c.city,
	c.customer_id,
	SUM(o.total_amount) AS revenue,
	ROW_NUMBER() OVER(PARTITION BY c.city ORDER BY SUM(o.total_amount) DESC) AS customer_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id; 


/*Question 6
Give products a row number inside every category based on price.*/ 

SELECT 
	category,
	product_name,
	price,
	ROW_NUMBER()OVER(PARTITION BY category ORDER BY price DESC) AS product_rank
FROM products;



/*RANK*/

/*Question 1
Rank customers according to total spending.*/

SELECT 
	customer_id,
	SUM(total_amount) as total_profit,
	RANK() OVER(ORDER BY SUM(total_amount) DESC) as customer_rank
FROM orders
GROUP BY customer_id;

/*Question 2
Rank employees according to orders handled.*/

SELECT
	employee_id,
    COUNT(order_id) as total_orders,
	RANK() OVER(ORDER BY COUNT(order_id) DESC) as employee_rank
FROM orders
GROUP BY employee_id;


/*Question 3
Rank products according to price.*/

SELECT
	product_name,
	price,
	RANK() OVER(ORDER BY price DESC) AS product_rank
FROM products;

/*Question 4
Rank stores according to revenue.*/

SELECT
	store_id,
	SUM(total_amount) as revenue,
	RANK() OVER(ORDER BY SUM(total_amount) DESC) As store_rank
FROM orders
GROUP BY store_id;


/*Question 5
Rank customers inside every city according to revenue.*/

SELECT
	c.city,
	c.customer_id,
	SUM(total_amount) AS revenue,
	RANK() OVER(PARTITION BY c.city ORDER BY SUM(o.total_amount) DESC) AS city_rank
FROM customers c
JOIN orders o on c.customer_id = o.customer_id
GROUP BY 
	c.city,
	c.customer_id;


/*Question 6
Rank products inside each category based on price.*/

SELECT 
	category,
	product_name,
	price,
	RANK() OVER(PARTITION BY category ORDER BY price DESC) AS category_rank
FROM products;

 