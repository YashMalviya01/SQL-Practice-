/*UNION & UNION ALL SQL QUERIES PRACTICE*/


/*Query 1 — Combine Online & Offline Orders (UNION ALL)
Problem

The company stores online and offline orders in separate tables. Display all orders from both tables.*/


SELECT 
	order_id,
    customer_id,
    order_date,
    amount
FROM online_orders

UNION ALL

SELECT 
	order_id,
    customer_id,
    order_date,
    amount
FROM offline_orders;



/*Query 2 — List Every Unique Customer (UNION)
Problem

Some customers are VIP customers. Show every unique customer ID from both tables.*/


SELECT 
	customer_id
FROM customers

UNION 

SELECt 
	customer_id
FROM vip_customers;



/*Query 3 — Combine Product Lists Alphabetically
Problem

Display every product sold by the Electronics and Furniture departments in one list.*/


SELECT 
	product_name
FROM electronics_products

UNION 

SELECT 
	product_name
FROM furniture_products

ORDER BY product_name;


/*Query 4 — Employees from Two Departments
Problem

Display all employees from the Sales and Marketing teams, including duplicates if the same employee appears in both teams.*/


SELECT
	employee_name
FROM sales_team

UNION ALL

SELECt 
	employee_name
FROM marketing_team;


/*Query 5 — Customers Who Registered or Placed an Order
Problem

Find every customer who either:

registered in the system, or
has placed an order.*/


SELECT 
	customer_id
FROM customers

UNION 

SELECT
	customer_id
FROM online_orders

UNION 

SELECT 
	customer_id
FROM offline_orders

ORDER BY customer_id;


/*Query 6 — Online and Offline Customers in 2024
Problem

Find all customers who purchased online or offline during 2024.*/


SELECT 
	customer_id
FROM online_orders
WHERE EXTRACT(YEAR FROM order_date) = 2024

UNION 

SELECT 
 	customer_id
FROM offline_orders
WHERE EXTRACT(YEAR FROM order_date) = 2024

ORDER BY customer_id;


/*Query 7 — Total Online vs Offline Revenue
Problem

Create a report showing total revenue for online and offline sales.*/


SELECT 
	'Online' AS source,
	SUM(amount) AS total_revenue
FROM online_orders

UNION ALL

SELECT 
	'Offline',
	SUM(amount)
FROM offline_orders;



/*Query 8 — UNION Inside a CTE
Problem

Combine current and archived orders, then calculate monthly revenue.*/


WITH all_orders AS (
SELECT 
	order_date,
	amount
FROM orders

UNION ALL

SELECT 
	order_date,
  	amount
FROM orders_archive
)

SELECT 
	DATE_TRUNC('month', order_date) AS month,
	SUM(amount) AS revenue
FROM all_orders
GROUP BY month
ORDER BY month;


/*Query 9 — Customer Spending Leaderboard
Problem

Merge online and offline orders and rank customers by total spending.*/



WITH all_orders AS (

SELECT
    customer_id,
    amount
FROM online_orders

UNION ALL

SELECT
    customer_id,
    amount
FROM offline_orders

),

customer_sales AS (

SELECT
    customer_id,
    SUM(amount) AS total_spent
FROM all_orders
GROUP BY customer_id

)

SELECT
    customer_id,
    total_spent,
    RANK() OVER(ORDER BY total_spent DESC) AS spending_rank
FROM customer_sales;




/*Query 10 — Find Duplicate Order IDs Across Systems
Problem

Orders are stored in two systems:

erp_orders
website_orders

Find order IDs that appear in both systems.*/

WITH all_orders AS(

  SELECT 
	order_id
FROM erp_orders

UNION ALL

SELECT 
  order_id
FROM website_orders
)

SELECT 
	order_id,
	COUNT(*) AS occurrences
FROM all_orders
GGROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY occurences DESC;


/*Query 17 — Customer Activity Timeline
Problem

Create a unified activity feed showing:

Customer registrations
Orders
Returns

sorted chronologically*/


SELECT
    customer_id,
    signup_date AS activity_date,
    'Signup' AS activity_type
FROM customers

UNION ALL

SELECT
    customer_id,
    order_date,
    'Order'
FROM orders

UNION ALL

SELECT
    customer_id,
    return_date,
    'Return'
FROM returns

ORDER BY activity_date;




/*Query 18 — Revenue Report by Sales Channel
Problem

Generate a report showing:

Sales Channel
Total Revenue
Number of Orders

for Online, Offline, and Marketplace sales.*/


SELECT
    'Online' AS source,
    SUM(amount) AS total_revenue,
    COUNT(*) AS total_orders
FROM online_orders

UNION ALL

SELECT
    'Offline',
    SUM(amount),
    COUNT(*)
FROM offline_orders

UNION ALL

SELECT
    'Marketplace',
    SUM(amount),
    COUNT(*)
FROM marketplace_orders;



/*Query 19 — Lifetime Customer Transactions
Problem

Create a complete transaction history by combining:

Orders
Archived Orders
Refunds
Replacements*/


SELECT
    customer_id,
    order_date AS transaction_date,
    'Order' AS transaction_type,
    amount
FROM orders

UNION ALL

SELECT
    customer_id,
    order_date,
    'Archived Order',
    amount
FROM orders_archive

UNION ALL

SELECT
    customer_id,
    refund_date,
    'Refund',
    refund_amount
FROM refunds

UNION ALL

SELECT
    customer_id,
    replacement_date,
    'Replacement',
    replacement_amount
FROM replacements

ORDER BY customer_id, transaction_date;



/*Query 20 — Multi-Source Sales Analytics
Problem

Combine Online, Offline, and Archived orders, then calculate:

Monthly Revenue
Running Revenue
Total Orders
Average Order Value
Customer Spending Rank*/



WITH all_orders AS (

SELECT
    customer_id,
    order_date,
    amount
FROM online_orders

UNION ALL

SELECT
    customer_id,
    order_date,
    amount
FROM offline_orders

UNION ALL

SELECT
    customer_id,
    order_date,
    amount
FROM orders_archive

),

customer_sales AS (

SELECT
    customer_id,
    SUM(amount) AS total_spent
FROM all_orders
GROUP BY customer_id

),

monthly_sales AS (

SELECT
    DATE_TRUNC('month', order_date) AS sales_month,
    SUM(amount) AS monthly_revenue
FROM all_orders
GROUP BY sales_month

)

SELECT
    sales_month,
    monthly_revenue,
    SUM(monthly_revenue)
        OVER(ORDER BY sales_month) AS running_revenue
FROM monthly_sales
ORDER BY sales_month;




















    
