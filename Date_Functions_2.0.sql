/*Ddate Functions Part 2 Medium Level Questions*/


/*Query 1: Monthly revenue trend for the last 12 months*/


SELECT 
	DATE_TRUNC('month', order_date) as order_month,
	COUNT(order_id) as total_orders,
    SUM(total_amount) as total_revenue
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY order_month;



/*Query 12: Average delivery time by month

Question: For each order month, calculate the average number of days taken to deliver an order.*/


SELECT 
	DATE_TRUNC('month', order_date) as order_month,
	ROUND(AVG(delivery_date::date - order_date::DATE),2) AS avg_delivery_days
FROM orders
WHERE delivery_date is not null
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY order_month


/*Query 13: Monthly customer signup cohorts

Question: Group customers according to their signup month and calculate the number of customers who joined in each month.*/


SELECT 
	date_trunc('month', signup_date) as signup_month,
	count(customer_id) as new_customers
from customers
group by date_trunc('month', signup_date)
order by signup_month;


/*Query 14: Customers who made their first purchase within 7 days of signup

Question: Find customers whose first-ever order was placed within seven days of their signup date.*/

WITH first_orders as(
	select
		customer_id,
  		MIN(order_date) as first_order_date
FROM orders
group by customer_id
)

SELECT
	c.customer_id,
	c.customer_name,
    c.signup_date,
    f.first_order_date,
    f.first_order_date::date - c.signup_date as days_to_first_order
FROM customers c
join first_orders f on c.customer_id = f.customer_id
WHERE f.first_order_date::date between c.signup_date and c.signup_date + interval '7 days';


/*Query 15: Quarterly revenue analysis

Question: Calculate the total revenue for each year and quarter.*/


SELECT 
	EXTRACT(YEAR FROM order_date) as order_year,
	EXTRACT(QUARTER FROM order_date) as order_quarter,
	SUM(total_amount) as total_revenue
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date),
         EXTRACT(QUARTER FROM order_date)
ORDER BY
    order_year,
    order_quarter;




/*Query 16: Month-over-month revenue growth

Question: Calculate monthly revenue and its percentage growth compared with the previous month.*/

WITH monthly_revenue as(
	SELECT
	   DATE_TRUNC('month', order_date) AS order_month,
	   SUM(total_amount) as revenue
FROM orders
GROUP BY    DATE_TRUNC('month', order_date)
),

revenue_comparision as (
	SELECT
	    order_month,
		revenue,
	    lag(revenue) over(order by order_month ) as previous_month_revenue
FROM monthly_revenue
)
	
SELECT
	order_month,
	revenue,
	previous_month_revenue,
	ROUND((revenue - previous_month_revenue)/ NULLIF(previous_month_revenue,0) * 100,2) as mom_growth_percentage
FROM revenue_comparision
ORDER by order_month;	



/*Query 17: Find customers inactive for the last 90 days

Question: Find customers who haven't placed an order during the last 90 days.*/


SELECT
	c.customer_id,
    c.customer_name,
    MAX(o.order_date) as last_order_date
FROM customers c
LEFT JOIN orders o on c.customer_id = o.customer_id
GROUP BY 
	c.customer_id,
	c.customer_name
HAVING MAX(o.order_date) < CURRENT_DATE - interval '90 days'
	OR MAX(o.order_date) is NULL;


/*Query 18: Average time to first purchase

Question: Calculate the average number of days customers take to make their first purchase after signing up.*/


WITH first_order as(
	SELECT 
	    customer_id,
	    MIN(order_date)::DATE as first_order_date
FROM orders
GROUP BY customer_id
  )

SELECT 
	ROUND(AVG(f.first_order_date - c.signup_date),2) AS avg_days_to_first_purchase
FROM customers c
JOIN first_orders f on c.customer_id = f.customer_id;


/*Query 20: Daily revenue with a 7-day moving average

Question: Calculate daily revenue and its seven-day moving average.*/



WITH daily_revenue AS (
    SELECT
        order_date::DATE AS order_day,
        SUM(total_amount) AS daily_revenue
    FROM orders
    GROUP BY order_date::DATE
)

SELECT
    order_day,
    daily_revenue,

    ROUND(
        AVG(daily_revenue) OVER (
            ORDER BY order_day
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS seven_day_moving_average

FROM daily_revenue
ORDER BY order_day;








































