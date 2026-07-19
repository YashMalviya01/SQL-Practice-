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



/*Query 26: Customer churn detection

Question: Identify customers whose latest order was at least 90 days ago.*/


WITH customer_activity AS(
	SELECT 
		customer_id,
  		MAX(order_date)::DATE AS last_order_date
	FROM orders
	GROUP BY customer_id
)

SELECT 
	c.customer_id,
	c.customer_name,
	ca.;ast_order_date,
	CURRENT_DATE - ca.last_order_date AS inactive_days
FROM customers c
JOIN customer_activity ca ON c.customer_id = ca.customer_id	
WHERE ca.last_order_date <= CURRENT_DATE - INTERVAL'90 days'
ORDER BY inactive_days DESC;

                             

/*Query 27: First-to-second purchase conversion within 30 days

Question: Calculate the percentage of customers who made their second purchase within 30 days of their first purchase.*/


WITH ranked_orders AS (
    SELECT
        customer_id,
        order_date,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS order_number

    FROM orders
),

first_second_orders AS (
    SELECT
        customer_id,

        MAX(
            CASE
                WHEN order_number = 1
                THEN order_date
            END
        ) AS first_order_date,

        MAX(
            CASE
                WHEN order_number = 2
                THEN order_date
            END
        ) AS second_order_date

    FROM ranked_orders
    WHERE order_number <= 2
    GROUP BY customer_id
)

SELECT
    COUNT(*) AS customers_with_first_order,

    COUNT(*) FILTER (
        WHERE second_order_date
              <= first_order_date + INTERVAL '30 days'
    ) AS converted_within_30_days,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE second_order_date
                  <= first_order_date + INTERVAL '30 days'
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS conversion_percentage

FROM first_second_orders;


/*Query 28: Monthly active, new, and returning customers

Question: For every month, calculate:

Total active customers
New customers making their first-ever purchase
Returning customers*/


WITH customer_months AS (
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', order_date)::DATE AS order_month
    FROM orders
),

first_purchase AS (
    SELECT
        customer_id,
        MIN(order_month) AS first_purchase_month
    FROM customer_months
    GROUP BY customer_id
)

SELECT
    cm.order_month,

    COUNT(DISTINCT cm.customer_id)
        AS active_customers,

    COUNT(DISTINCT cm.customer_id) FILTER (
        WHERE cm.order_month = fp.first_purchase_month
    ) AS new_customers,

    COUNT(DISTINCT cm.customer_id) FILTER (
        WHERE cm.order_month > fp.first_purchase_month
    ) AS returning_customers

FROM customer_months cm

JOIN first_purchase fp
    ON cm.customer_id = fp.customer_id

GROUP BY cm.order_month
ORDER BY cm.order_month;



/*Query 29: Longest consecutive monthly purchase streak

Question: For every customer, determine their longest streak of consecutive calendar months containing at least one purchase.*/

WITH customer_months AS (
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', order_date)::DATE AS order_month
    FROM orders
),

numbered_months AS (
    SELECT
        customer_id,
        order_month,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_month
        ) AS rn

    FROM customer_months
),

streak_groups AS (
    SELECT
        customer_id,
        order_month,
        order_month - rn * INTERVAL '1 month' AS streak_group
    FROM numbered_months
),

streak_lengths AS (
    SELECT
        customer_id,
        streak_group,
        COUNT(*) AS streak_length
    FROM streak_groups
    GROUP BY customer_id, streak_group
)

SELECT
    customer_id,
    MAX(streak_length) AS longest_monthly_streak
FROM streak_lengths
GROUP BY customer_id
ORDER BY longest_monthly_streak DESC;


/*Query 30: Cohort retention matrix for Months 0–3

Question: Build a cohort retention matrix showing retention percentages for:

Month 0
Month 1
Month 2
Month 3*/

WITH customer_cohorts AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', signup_date)::DATE AS cohort_month
    FROM customers
),

customer_activity AS (
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', order_date)::DATE AS activity_month
    FROM orders
),

cohort_activity AS (
    SELECT
        cc.customer_id,
        cc.cohort_month,
        ca.activity_month,

        (
            EXTRACT(YEAR FROM AGE(ca.activity_month, cc.cohort_month)) * 12
            +
            EXTRACT(MONTH FROM AGE(ca.activity_month, cc.cohort_month))
        )::INT AS month_number

    FROM customer_cohorts cc

    JOIN customer_activity ca
        ON cc.customer_id = ca.customer_id

    WHERE ca.activity_month >= cc.cohort_month
),

cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_size
    FROM customer_cohorts
    GROUP BY cohort_month
)

SELECT
    ca.cohort_month,
    cs.cohort_size,

    ROUND(
        100.0 * COUNT(DISTINCT ca.customer_id)
        FILTER (WHERE month_number = 0)
        / NULLIF(cs.cohort_size, 0),
        2
    ) AS month_0_retention,

    ROUND(
        100.0 * COUNT(DISTINCT ca.customer_id)
        FILTER (WHERE month_number = 1)
        / NULLIF(cs.cohort_size, 0),
        2
    ) AS month_1_retention,

    ROUND(
        100.0 * COUNT(DISTINCT ca.customer_id)
        FILTER (WHERE month_number = 2)
        / NULLIF(cs.cohort_size, 0),
        2
    ) AS month_2_retention,

    ROUND(
        100.0 * COUNT(DISTINCT ca.customer_id)
        FILTER (WHERE month_number = 3)
        / NULLIF(cs.cohort_size, 0),
        2
    ) AS month_3_retention

FROM cohort_activity ca

JOIN cohort_sizes cs
    ON ca.cohort_month = cs.cohort_month

GROUP BY
    ca.cohort_month,
    cs.cohort_size

ORDER BY ca.cohort_month;





























































































