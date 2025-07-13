/*
Membership operator
IN -> Checks whether the value exists in the list 
NOT IN -> Checks whether the value not exists in the list 
*/

USE MyDatabase
SELECT * FROM customers

--Q) Retrive all customers that are either from Germany or USA
SELECT * 
FROM customers
WHERE country = 'Germany' OR country = 'USA'

SELECT * 
FROM customers
WHERE country IN ('Germany' , 'USA')


--Q) Retrive all customers that are not either from Germany or USA
SELECT * 
FROM customers
WHERE country NOT IN ('Germany' , 'USA')