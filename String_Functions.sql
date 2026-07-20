/*STRING functions practice queries level 1 - Easy*/


/*Query 1 – Convert First Name to Uppercase
Problem

Display every customer's first name in uppercase.*/


SELECT 
	customer_id,
    first_name,
    UPPER(first_name) AS upper_name
FROM customers;


/*Query 2 – Convert Last Name to Lowercase
Problem

Display every customer's last name in lowercase.*/


SELECT 
	customer_name,
    last_name,
    LOWER(last_name) as lower_name
FROM customers;



/*Query 3 – Proper Case Customer Names
Problem

Display customer names in proper case.*/


SELECT 
	customer_id,
    INITCAP(first_name) AS formatted_name
FROM customers;



/*Query 4 – Find Length of Customer Names
Problem

Display every customer's name and its length.*/


SELECT 
	first_name,
    LENGTH(first_name) AS name_length
FROM customers;


/*Query 5 – Create Full Name
Problem

Combine first name and last name into one column.*/


SELECT
	CONCAT(first_name,' ',last_name) AS full_length
FROM customers;


/*Query 6 – Create Full Name Using ||
Problem

Create full name using PostgreSQL concatenation operator.*/


SELECT 
	first_name || ' ' || last_name AS full_length
FROM customers;


/*Query 7 – CONCAT_WS()
Problem

Display customer's full name using CONCAT_WS().*/

SELECT 
	CONCAT_WS(' ',first_name,last_name) AS full_name
FROM customers;



/*Query 8 – Remove Leading Spaces
Problem

Remove leading spaces from customer names.*/


SELECT 
	LTRIM(first_name) AS cleaned_name
FROM customers;



/*Query 9 – Remove Trailing Spaces
Problem

Remove ending spaces.*/


SELECT 
	RTRIM(first_name) AS cleaned_name
FROM customers;



/*Query 10 – Remove Both Leading and Trailing Spaces
Problem

Clean customer names completely.*/


SELECT 
	TRIM(first_name) AS cleaned_name
FROM customers;




















































