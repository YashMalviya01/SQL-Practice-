/*Date Functions Advance Questions*/


/*Query 21: Customers purchasing in 3+ consecutive months

Question: Find customers who placed at least one order in three or more consecutive calendar months.*/


WITH monthly_orders AS (
	SELECT DISTINCT
	 	customer_id,
  		DATE_TRUNC('month', order_date)::DATE as order_month
	FROM orders
),

numbered_month AS (
	SELECT
	  	customer_id,
  		order_month,
		ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_month) AS rn
	FROM monthly_orders
),

streak_groups AS (
	SELECT 
	 	customer_id,
		order_month,
  		order_month - (rn - INTERVAL '1 month') AS streak_group
	FROM numbered_month
)

SELECT
	customer_id,
    MIN(order_month) AS streak_start,
	MAX(order_month) AS streak_end
	COUNT(*) AS consecutive_months
FROM streak_group
GROUP BY customer_id,
		 streak_group
HAVING COUNT(*) >= 3
ORDER BY customer_id,
		 streak_start;


/*Query 22: Next-month retention by signup cohort

Question: For each signup-month cohort, calculate the percentage of customers who placed an order in the calendar month immediately following their signup month.*/


WITH customer_cohort AS (
	SELECT 
		customer_id,
		DATE_TRUNC('month', signup_date)::DATE AS cohort_month
	FROM customers
),

retention_status AS (
	SELECT
		c.customer_id,
  		c.cohort_month,
  		CASE WHEN EXISTS( SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id AND DATE_TRUNC('month', o.order_date)::DATE = (c.cohort_month + INTERVAL '1 month')::DATE) THEN 1 
        ELSE 0
	END AS retained
FROM customer_cohort c
)

SELECT 
	cohort_month,
	COUNT(*) AS cohort_size,
	SUM(retained) AS retained_customers,
	ROUND(100.0 * SUM(retained) / NULLIF(COUNT(*),0),2 ) AS retention_percentage
FROM retention_status
GROUP BY cohort_month
ORDER BY cohort_month;
        
                         
	  
/*Query 23: Longest inactivity gap for every customer

Question: For every customer, calculate the longest number of days between two consecutive orders.*/


WITH previous_orders AS (
	SELECT 
		customer_id,
		order_date,
  		LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date
FROM orders
),

order_gaps AS (
	SELECT 
		customer_id,
  		order_date,
  		previous_year_order_date,
  		order_date::DATE - previous_order_date::DATE as gap_days
FROM previous_orders
WHERE previous_order_date IS NOT NULL 
)

SELECT 
	customer_id,
	MAX(gap_days) AS longest_inactivity_days
FROM order_gaps
GROUP BY customer_id
ORDER BY longest_inactivity_days DESC;



/*Query 24: Rolling 30-calendar-day revenue

Question: For every order date, calculate total revenue generated on that date and during the previous 29 calendar days.*/


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
	SUM(daily_revenue) OVER (ORDER BY order_day RANGE BETWEEN INTERVAL '29 dauys' PRECEDING AND CURRENT ROW  AS rolling_30_day_revenue

FROM daily_revenue
ORDER BY order_day;


                             

/*Query 25: Year-over-year monthly revenue growth

Question: For every month, compare revenue with the same calendar month from the previous year and calculate YoY growth percentage.*/


WITH month_revenue AS(
	SELECT 
		DATE_TRUNC('month', order_date)::DATE as order_month,
  		SUM(total_amount) AS revenue
	FROM orders
	GROUP BY DATE_TRUNC('month', order_date)::DATE
)

SELECT
    current_month.order_month,
    current_month.revenue,
    previous_year.revenue AS previous_year_revenue,

    ROUND(
        100.0 * (
            current_month.revenue - previous_year.revenue
        ) / NULLIF(previous_year.revenue, 0),
        2
    ) AS yoy_growth_percentage

FROM monthly_revenue current_month

LEFT JOIN monthly_revenue previous_year
    ON previous_year.order_month
       = (current_month.order_month - INTERVAL '1 year')::DATE
















































































