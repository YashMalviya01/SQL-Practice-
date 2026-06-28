
/* Self Joins & Inner Joins*/

SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id
FROM 
	customers AS c
INNER JOIN orders AS o on c.customer_id = o.customer_id;



SELECT
	o.order_id,
    c.customer_id,
    c.first_name
FROM 
	orders AS o
INNER JOIN customers as c ON o.customer_id = c.customer_id;




SELECT
	oi.order_id,
    oi.order_item_id,
    p.product_name,
    p.product_id
    
FROM
 	order_items AS oi
INNER JOIN products AS p on p.product_id = oi.product_id;    
    
    
    

SELECT
	s.store_id,
    s.store_name,
    o.order_id
FROM stores AS s   
JOIN orders o on s.store_id = o.store_id;




SELECT 
	e.employee_id,
    e.employee_name,
    o.order_id
From 
	employees as e
JOIN orders as o on e.employee_id = o.employee_id;




SELECT c.first_name,
       SUM(o.total_amount) sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.first_name;
    
    
    
SELECT 
	e.employee_id,
    e.employee_name,
    m.manager_id,
    m.department
FROM 
	employees e
JOIN employees m on e.employee_id = m.employee_id    


/*Managers with no team.*/

SELECT m.employee_name
FROM employees m
LEFT JOIN employees e
ON m.employee_id=e.manager_id
GROUP BY m.employee_name
HAVING COUNT(e.employee_id)=0;



/*Show reporting hierarchy.*/

SELECT e.employee_name,
       m.employee_name manager
FROM employees e
JOIN employees m
ON e.manager_id=m.employee_id;
    

/* Employees having same manager*/


SELECT a.employee_name,
       b.employee_name
FROM employees a
JOIN employees b
ON a.manager_id=b.manager_id
AND a.employee_id<>b.employee_id;    





/* LEFT JOIN Practice Queries 

/*Customers who never ordered.*/

SELECT c.*
FROM 
	customers c
LEFT Join orders o on c.customer_id = o.customer_id
WHERE o.customer_id is NULL;

/* Products never sold.*/

SELECT p.*
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;


/* Stores with no orders */

SELECT s.*
FROM stores s
LEFT JOIN orders o ON s.store_id = o.store_id
WHERE o.order_id = NULL;

/* Employeess with no sales*/

SELECT 
	e.employee_id,
    e.employee_name,
    e.department
From 
	employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
WHERE o.order_id is NULL;

/*Show all products and sales quantity.*/

SELECT p.product_name,
       COALESCE(SUM(oi.quantity),0)
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name;

    
/*Stores and total revenue.*/

 SELECT s.store_name,
       COALESCE(SUM(o.total_amount),0)
FROM stores s
LEFT JOIN orders o
ON s.store_id=o.store_id
GROUP BY s.store_name;   

    