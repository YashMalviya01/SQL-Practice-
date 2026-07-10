/*LAG--retrieves a value from a previous row without needing a self join.*/


/*Question 1: Display each order with the previous order amount.*/


select 
	order_id,
	order_date,
	lag(total_amount) over ( order by order_date) as previous_order_amount,
    lead(total_amount) over ( order by order_date) as next_order_amount
from orders;


/*Question 3: Calculate the difference between the current and previous order amount.*/

select 
	order_id,
	order_date,
    total_amount,
    lag(total_amount) over (order by order_date) as previous_oa,
    total_amount -lag(total_amount) over (order by order_date) as diffrence
from orders; 

/*
Question 4: Display the previous order amount separately for each customer.*/

select
	customer_id,
	order_date,
    order_id,
    total_amount,
    lag(total_amount) over(PARTITION by customer_id order by order_date) as previous_oa
from orders;


/*Question 5: Calculate the percentage change from the previous order.*/

With order_comparision as
(
	select
	   	order_id,
  		order_date,
		total_amount,
		lag(total_amount) over(order by order_date) as previous_amount
	from orders
)
select
	order_id,
    order_date,
    total_amount,
	previous_amount,
	round((total_amount - previous_amount) * 100.0 / nullif(previous_amount,0),2) as percentage_change

FROM order_comparision;



/*Question 6: Classify each order as increased, decreased, or unchanged compared with the previous order.*/


WITH order_comparison AS
(
    SELECT
        order_id,
        order_date,
        total_amount,

        LAG(total_amount) OVER
        (
            ORDER BY order_date
        ) AS previous_amount

    FROM orders
)

SELECT
    order_id,
    order_date,
    total_amount,
    previous_amount,

    CASE
        WHEN previous_amount IS NULL
            THEN 'No Previous Order'

        WHEN total_amount > previous_amount
            THEN 'Increased'

        WHEN total_amount < previous_amount
            THEN 'Decreased'

        ELSE 'No Change'
    END AS order_status

FROM order_comparison;



/*SUM OVER*/


/*Question 1: Calculate a running total of revenue based on order date.*/


SELECT
	order_id,
	order_date,
    total_amount,
	sum(total_amount) over (order by order_date ) as running_total
from orders;


/*Question 4: Calculate a running total separately for each customer.*/

select
	customer_id,
	order_id,
    order_date,
    total_amount,
    SUM(total_amount) over (partition by customer_id order by order_date ) as customer_running_total
from orders;


/*Question 6: Calculate a running total separately for each store.*/


SELECT
    store_id,
    order_id,
    order_date,
    total_amount,

    SUM(total_amount) OVER
    (
        PARTITION BY store_id
        ORDER BY order_date
    ) AS store_running_total

FROM orders;



/*avg*/

/*Question 4: Calculate a running average separately for each customer.*/

SELECT
    customer_id,
    order_id,
    order_date,
    total_amount,
    AVG(total_amount) OVER
    (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS customer_running_avg
FROM orders;



/*Question 6: Classify each order as above or below the customer's average.*/


WITH order_analysis AS
(
    SELECT
        customer_id,
        order_id,
        total_amount,
        AVG(total_amount) OVER
        (
            PARTITION BY customer_id
        ) AS customer_avg
    FROM orders
)

SELECT
    customer_id,
    order_id,
    total_amount,
    customer_avg,
    CASE
        WHEN total_amount > customer_avg THEN 'Above Average'
        WHEN total_amount < customer_avg THEN 'Below Average'
        ELSE 'Equal to Average'
    END AS order_status
FROM order_analysis;


/*count*/

/*Question 5: Show every employee's orders along with their total number of handled orders.*/

SELECT
    employee_id,
    order_id,
    COUNT(*) OVER
    (
        PARTITION BY employee_id
    ) AS employee_order_count
FROM orders;



/*Question 6: Classify customers based on their total number of orders.*/

WITH customer_activity AS
(
    SELECT
        customer_id,
        order_id,
        COUNT(*) OVER
        (
            PARTITION BY customer_id
        ) AS total_customer_orders
    FROM orders
)

SELECT
    customer_id,
    order_id,
    total_customer_orders,
    CASE
        WHEN total_customer_orders >= 10 THEN 'Highly Active'
        WHEN total_customer_orders >= 5 THEN 'Active'
        ELSE 'Occasional'
    END AS activity_status
FROM customer_activity;


/*max over & min over*/


/*Question 5: Calculate the running maximum order amount.*/

SELECT
    order_id,
    order_date,
    total_amount,
    MAX(total_amount) OVER
    (
        ORDER BY order_date
    ) AS running_maximum
FROM orders;


/*Question 6: Calculate the running minimum separately for each customer.*/

SELECT
    customer_id,
    order_id,
    order_date,
    total_amount,
    MIN(total_amount) OVER
    (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS customer_running_min
FROM orders;
