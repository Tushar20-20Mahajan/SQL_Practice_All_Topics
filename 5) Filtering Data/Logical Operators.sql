/*
LOGICAL OPERATORS 
1) AND -> All conditions must be true 
2) OR -> Atleast one condition must be true 
3) NOT -> (Reerse) Excludes machine rows
*/

USE MyDatabase
SELECT * FROM customers

--Q) Retrive all customers who are from USA and have score greater than 500 
SELECT* 
FROM customers
WHERE country = 'USA' AND score>500



--Q) Retrive all customers who are either from USA or have score greater than 500 
SELECT* 
FROM customers
WHERE country = 'USA' OR score>500


--Q) Retrive all customers with a score not less than 500
SELECT* 
FROM customers
WHERE NOT score<500