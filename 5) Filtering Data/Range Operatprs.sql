/*
Range Operators 
* BETWEEN -> Checks if a value is between a specific range   Lower Boundary -------True-------- Upper Boundary
Boundary are inclusive
*/

USE MyDatabase
SELECT * FROM customers


--Q) Retrive all customers whose score falls in between the range of 100 and 500
SELECT * 
FROM customers
WHERE score BETWEEN 100 AND 500

--Q) Retrive all customers whose score falls in between the range of 100 and 500
SELECT * 
FROM customers
WHERE score >=100 AND score<=500