/*
Search Operator 
LIKE -> Search for a pattern in a text 
Pattern 
% ( Anything ) -> 0 , 1 , Many  { X% , %X , %X% }
_ -> Exact 1  { _(1)_(2)X% ,...... other combinations like this .... '_' means only one alphabet }
*/

USE MyDatabase
SELECT * FROM customers

--Q) Retrive all customers whose name start with 'M'
SELECT * 
FROM customers
WHERE first_name LIKE 'M%'

--Q) Retrive all customers whose name end with 'n'
SELECT * 
FROM customers
WHERE first_name LIKE '%n'

--Q) Retrive all customers whose name contain with 'r'
SELECT * 
FROM customers
WHERE first_name LIKE '%r%' OR first_name LIKE '%R%'


--Q) Retrive all customers whose name contain with 'r' in the third position 
SELECT * 
FROM customers
WHERE first_name LIKE '__r%' 