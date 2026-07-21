/*String functions level 2 medium lecel queries*/


/*Query 11 – Extract First 3 Characters of Customer Name
Problem

Display the first 3 letters of every customer's first name.*/


SELECT 
	first_name,
    LEFT(first_name, 3) AS first_three_letters
FROM customers;


/*Query 12 – Extract Last 4 Digits of Phone Number
Problem

Display only the last 4 digits of each customer's phone number.*/


SELECT 
	phone,
    RIGHT(phone,4) AS last_four_digit
FROM customers;


/*Query 13 – Extract Email Username
Problem

Extract everything before the @ symbol from the email.*/


SELECT 
	email,
    SUBSTRING(email FROM 1 FOR POSITION('@' IN email) - 1 ) AS username
FROM customers;



/*Query 14 – Extract Email Domain
Problem

Display only the domain name after the @.*/


SELECT 
	email,
    SPLIT_PART(email, '@', 2) AS domain
FROM customers;


/*Query 15 – Find Position of '@' in Email
Problem

Find where the @ symbol occurs in every email.*/


SELECT 
	email,
    POSITION('@' IN email) AS at_position
FROM customers;


/*Query 16 – Find Position of a Word Using STRPOS()
Problem

Find where the word "Street" begins in the address column.*/


SELECT 
	address,
    STRPOS(address, 'Street') AS street_position
FROM customers;


/*Query 17 – Replace Country Code
Problem

Replace the country code +91 with 0 in phone numbers.*/


SELECT 
	phone,
    REPLACE(phone, '+91','0') AS local_phone
FROM customers;



/*Query 18 – Mask Phone Number
Problem

Show only the last 4 digits of the phone number while masking the rest.*/


SELECT 
	phone,
    REPEAT('*', LENGTH(phone)- 4) || RIGHT(phone.4) AS masked_phone
FROM customers;


/*Query 19 – Pad Customer IDs with Leading Zeros
Problem

Display customer IDs as 6-digit values.*/


SELECT 
	customer_id,
	LPAD(customer_id::TEXT,6,'0') AS formatted_id
FROM customers;



/*Query 20 – Pad Product Codes with Trailing X
Problem

Assume a product_code column exists.

Display all product codes as 10 characters by adding X to the right.*/



SELECT 
	product_code,
    RPAD(product_code, 10, 'X') AS formatted_code
FROM products;











































































