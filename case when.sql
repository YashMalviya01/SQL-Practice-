/* CASE WHEN PRACTICE QUESTIONS*/


/*1. Categorize orders as High, Medium, or Low Value.*/

SELECT
	order_id,
    total_amount,
	CASE
    	WHEN total_amount >= 5000 THEN 'HIGH VALUE'
		WHEN total_amount >= 2000 THEN 'MEDIUM VALUE'
		ELSE 'LOW VALUE'
	END AS order_category
FROM orders;


/*2. Display whether each customer is Premium or Regular.*/

SELECT 
	customer_id,
    SUM(total_amount) AS total_spent,
	CASE
    	WHEN SUM(total_amount) > 4000 THEN 'Premium Customer BC'
        ELSE 'Regular AF'
    END AS customer_type
FROM orders
GROUP BY customer_id;    


/*3. Classify employees based on number of orders handled.*/

SELECT 
	employee_id,
	COUNT(*) AS total_orders,
    CASE
    	WHEN COUNT(*) >= 6 THEN 'Chak De Phatte'
		WHEN COUNT(*) >= 4 THEN 'Average Lowke'
        ELSE 'Need Improvement'
	END AS performance
FROM orders
GROUP BY employee_id;


/*4. Show whether products are Expensive or Affordable.*/

SELECT 
	product_name,
    price,
    CASE 
    	WHEN price >= 800 THEN 'EXPENSIVE'
        ELSE 'Yhe Gareeb Iski MKC'
    END AS category
FROM products;  


/*5. Categorize stores based on revenue.*/  

SELECT 
	store_id,
    SUM(total_amount) AS Revenue,
    CASE
      	WHEN SUM(total_amount) >= 15000 THEN 'EXCELLENT'
        WHEN SUM(total_amount) >= 3000 THEN 'Good'
        ELSE 'Tumse na Ho Paega'
    END AS store_rating
FROM orders
GROUP BY store_id;


/*6. Display customers and classify them based on order value.*/

SELECT 
	c.first_name,
	o.order_id,
	o.total_amount,
	CASE 
		WHEN o.total_amount >= 5000 then 'HIGH'
        WHEN o.total_amount >= 2000 then 'MEDIUM'
        ELSE 'LOW'
    END AS order_category
FROM customers AS c
JOIN orders o ON c.customer_id = o.customer_id;


/*7. Employee Performance*/

SELECT 
	e.employee_name,
	COUNT(o.order_id) total_orders,
    CASE 
		WHEN COUNT(o.order_id) >= 10 then 'TOP Performer'
        ELSE 'AVERAGE'
    END AS performance
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
group by e.employee_name;   


/*8. Designation*/

select 
	e.employee_name,
	m.employee_name as manager,
	case
    	when m.employee_name is null then 'ceo'
        else 'employee'
	end as designation
from employees e 
left join employees m on e.manager_id = m.manager_id;


/*9. Classify customers as VIP or Regular based on revenue.*/

WITH customer_revenue AS 
(
  SELECT 
  	customer_id,
	SUM(total_amount) AS revenue
  FROM orders
  GROUP BY customer_id
	
)
SELECT 
	customer_id,
	revenue,
	CASE 
    	WHEN revenue >= 10000 THEN 'VIP'
        ELSE 'Regular'
	END AS customer_type
FROM customer_revenue;


WITH customer_revenue AS
(
    SELECT
        customer_id,
        SUM(total_amount) revenue
    FROM orders
    GROUP BY customer_id
)

SELECT
    c.first_name,
    cr.revenue,
    CASE
        WHEN cr.revenue >= 20000 THEN 'Premium'
        ELSE 'Regular'
    END AS customer_status
FROM customers c
JOIN customer_revenue cr
ON c.customer_id = cr.customer_id;



WITH customer_revenue AS
(
    SELECT
        customer_id,
        SUM(total_amount) revenue
    FROM orders
    GROUP BY customer_id
)

SELECT
    c.first_name,
    cr.revenue,

    CASE

        WHEN cr.revenue >=
        (
            SELECT AVG(revenue)
            FROM customer_revenue
        )

        THEN 'Above Average'

        ELSE 'Below Average'

    END AS customer_level

FROM customers c

JOIN customer_revenue cr
ON c.customer_id = cr.customer_id;

