/*STRING FUNCTIONS LEVEL 3 Advance Questions*/


/*Query 21 – Generate Company Email IDs
Problem

Create company email IDs in the format:

firstname.lastname@company.com*/


SELECT 
	customer_id,
	LOWER(first_name) || ',' ||
	LOWE(last_name) ||
	'@company.com' AS company_email
FROM customers;


/*Query 22 – Extract Initials
Problem

Display customer initials.*/

SELECT
	first_name,
	last_name,
    LEFT(first_name,1) ||
	LEFT(last_name,1) AS innitials
FROM customers;


/*Query 23 – Standardize Customer Names
Problem

Names are stored inconsistently.*/


SELECT 
	INITCAP(TRIM(first_nanme)) AS cleaned_name
FROM customers;



/*Query 24 – Mask Customer Email
Problem

Display

john@gmail.com

as

****@gmail.com*/


SELECT 
	email,
	REPEAT('*', POSITION('@' IN email) -1)||
	SUBSTRING(email FROM POSITION('@' IN email)) AS masked_email
FROM customers;



/*Query 25 – Extract File Extension

Suppose

documents

file_name

contains

report.pdf
sales.xlsx
photo.jpg
Problem

Extract only the extension.*/


SELECT 
	file_name,
	SLPIT_PART(file_name,',',2) AS extention
FROM documents;




/*Query 26 – Count Gmail Users
Problem

How many customers use Gmail?*/


SELECT 
	COUNT(*) AS gmail_users
FROM customers
WHERE LOWER( SPLIT_PART(email,'@',2)) = 'gmail.com'




/*Query 27 – Remove Special Characters

Suppose phone numbers are

987-654-3210

Convert them to

9876543210*/


SELECT
	phone,
    REPLACE(phone,'-','') AS cleaned_phone
FROM customers;


/*Query 28 – Generate Customer Code

Create customer code

Example

John Smith

↓

JOH001*/


SELECt
	customer_id,
	UPPER(LEFT(first_name,3)) || LPAD(customer_id::TEXT), 3,'0') AS customer_code
FROM Customers;



/*Query 29 – Find Invalid Emails
Problem

Find customers whose email doesn't contain*/


SELECT 
	customer_id,
	email
FROM customers;
WHERE POSITION('@' IN email)=0;








/*Query 30 – Build Customer Summary

Display

John Smith
City : Mumbai
Email : john@gmail.com

in one column.*/


SELECT

CONCAT_WS(

' | ',

CONCAT(first_name,' ',last_name),

CONCAT('City : ',city),

CONCAT('Email : ',email)

)

AS customer_summary

FROM customers;



































































