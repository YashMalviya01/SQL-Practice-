/*Window functions practice 2.0*/

/*Dense Rank*/


/*Question 1

Rank all products based on price from highest to lowest without skipping ranks after ties.*/

SELECT 
	product_id,
    product_name,
	price,
	DENSE_RANK() OVER (ORDER BY price DESC) AS price_rank
FROM products;


/*Question 2

Rank customers according to total spending without skipping ranks.*/


SELECT
	customer_id,
	SUM(total_amount) AS Total_Spent,
	DENSE_RANK() OVER(ORDER BY SUM(total_amount) DESC) AS customer_rank
FROM orders
GROUP BY customer_id;


/*Question 3

Rank stores according to total revenue.*/


SELECT 
	store_id,
	SUM(total_amount) AS store_revenue,
	DENSE_RANK() OVER(ORDER BY SUM(total_amount) DESC) as store_rank
FROM orders
GROUP BY store_id;


/*Question 4

Rank employees according to the number of orders they handled.*/


SELECT
	employee_id,
	COUNT(order_id) AS total_orders,
	DENSE_RANK() OVER(ORDER BY COUNT(order_id)DESC) as employee_rank
FROM orders
GROUP BY employee_id;
	

/*Question 5

Rank products by price inside each product category.*/


SELECT 
	category,
	product_name,
	price,
	DENSE_RANK() OVER( PARTITION BY category ORDER BY price DESC) AS category_price_rank
FROM products;


/*Question 6

Rank customers by total spending inside each city.*/

SELECT 
	c.city,
	c.customer_id,
	SUM(o.total_amount) AS Total_spent,
	DENSE_RANK() OVER(PARTITION BY c.city ORDER BY SUM(o.total_amount)DESC) as city_rank
FROM customers c
JOIN orders o on c.customer_id = o.customer_id
GROUP BY 
	c.city,
	c.customer_id;



/*LEAD---looks forward to the next row without using a self join.*/


/*Question 1

Display every order amount with the amount of the next order.*/


SELECT 
	order_id,
	order_date,
	total_amount,
	LEAD(total_amount) OVER(ORDER BY order_date) AS next_order_date
FROM orders;


/*Question 2

Display every order date with the next order date.*/

SELECT
	order_id,
	order_date,
	LEAD(order_date) OVER(ORDER BY order_date) AS next_order_date
FROM orders;


/*Question 3

Compare every order amount with the next order amount.*/


SELECT 
	order_id,
	order_date,
	total_amount,
	LEAD(total_amount) OVER ( ORDER BY order_date) as next_order_amount,
	LEAD(total_amount) OVER(ORDER BY order_date) - total_amount AS diffrence
FROM orders;


/*Question 4

Display the next order amount for every customer.*/

SELECT
	customer_id,
	order_id,
	order_date,
	total_amount,
	LEAD(total_amount) OVER ( PARTITION BY customer_id ORDER BY order_date) AS next_order_amount
FROM orders;


/*Question 5

Classify whether the next order amount increased, decreased, or remained unchanged.*/


WITH order_comparision as
(
SELECT 
	order_id,
	order_date,
	total_amount,
	LEAD(total_amount) OVER( ORDER BY order_date) as next_order_amount
FROM orders
)
SELECT 
	order_id,
	order_date,
	total_amount,
	next_order_amount,
	CASE 
    	WHEN next_order_amount > total_amount THEN 'Increased'
        WHEN next_order_amount < total_amount THEN 'Decreased'
        WHEN next_order_amount = total_amount THEN 'No Change'
	    ELSE 'No Next Order'
	END AS order_change
FROM order_comparision;
