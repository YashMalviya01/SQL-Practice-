/* CTE'S & Subqueries Practice queries*/


/*1. Find customers whose total spending is greater than the average customer spending.*/


SELECT
    customer_id,
    SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) >
(
    SELECT AVG(customer_total)
    FROM
    (
        SELECT
            customer_id,
            SUM(total_amount) AS customer_total
        FROM orders
        GROUP BY customer_id
    ) t
);



/*2. Find products whose price is greater than the average product price.*/

select 
	product_name,
    price
from products
where price >
(
	select AVG(price)
  	from products
);


/*3. Find the customer(s) who spent the most money.*/


SELECT
	customer_id,
    sum(total_amount) as total_spent
from orders
group by customer_id
having sum(total_amount) = 
(
	select max(total_spent)
  	from
  	(
		select
      		customer_id,
      		sum(total_amount) as total_spent
      	from orders
      	group by customer_id
)
);

/*4. Find stores whose revenue is above the average store revenue.*/



select
	store_id,
    sum(total_amount) as revenue
from orders
group by store_id
having sum(total_amount)> 
(
	select avg(store_revenue)
	from
(
	select 
	store_id,
    sum(total_amount) as store_revenue
from orders 
group by store_id
)
);


/*5. Find employees who handled the highest-value order.*/


SELECT
	employee_name
from employees
where employee_id = 	
(
select 
	employee_id
from orders
order by total_amount DESC
limit 1
);


/*6. Find customers who never placed an order.*/



select 
	customer_id,
	first_name
from customers
where customer_id NOT IN
(
  select customer_id
  from orders
) ;


/*7. Find products that have never been sold.*/


SELECT
    product_name
FROM products
WHERE product_id NOT IN
(
    SELECT product_id
    FROM order_items
);


/*8. Find employees whose revenue is greater than the average employee revenue.*/



SELECT
    employee_id,
    SUM(total_amount) revenue
FROM orders
GROUP BY employee_id
HAVING SUM(total_amount) >
(
    SELECT AVG(emp_revenue)
    FROM
    (
        SELECT
            employee_id,
            SUM(total_amount) emp_revenue
        FROM orders
        GROUP BY employee_id
    ) x
);


/*9. Find the second-highest order amount.*/

select max(total_amount)
from orders
where total_amount <
(
select max(total_amount)
from orders
);


/*10. Find customers who placed more orders than the average customer.*/

SELECT
    customer_id,
    COUNT(*) total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) >
(
    SELECT AVG(order_count)
    FROM
    (
        SELECT
            customer_id,
            COUNT(*) order_count
        FROM orders
        GROUP BY customer_id
    ) t
);


/*1. Find customers whose total spending is less than the average customer spending.*/

SELECT
    customer_id,
    SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) <
(
    SELECT AVG(customer_total)
    FROM
    (
        SELECT
            customer_id,
            SUM(total_amount) AS customer_total
        FROM orders
        GROUP BY customer_id
    ) t
);



/*12 Find employees who handled orders with a value greater than the average order value.*/
SELECT
    e.employee_name,
    o.order_id,
    o.total_amount
FROM employees e
JOIN orders o
    ON e.employee_id = o.employee_id
WHERE o.total_amount >
(
    SELECT AVG(total_amount)
    FROM orders
);

/*13. Find products whose price is equal to the most expensive product.*/


select 
	product_name,
    price
from products
where price =
(
	select MAX(price)
  	from products
);
