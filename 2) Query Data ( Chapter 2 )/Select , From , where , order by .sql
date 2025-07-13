-- This is a Comment 
/* This is 
a
comment */


-- First Specify which data base you want to use by using USE DataBaseName
USE MyDatabase



-- SELECT and FROM clause 

-- Q) Retrive All Customer Data
SELECT * 
FROM customers

-- Q) Retrive all the order data
SELECT *
From orders 


-- Select Only the required data instead of whole -  Pick only the Columns you need instead of all ( Select few columns) 
-- Q) Retrive each customers name , country , and score 
SELECT 
	first_name , 
	country , 
	score 
FROM customers


-- WHERE Clause -> Filter data based on the condition

-- Q) Retrive customers with a score not equal to 0 
SELECT *
FROM customers
WHERE score!=0

-- Q) Retrive customers name and country with a score >500
SELECT 
	first_name,
	country
FROM customers
WHERE score>500

-- Q) Retrive customers name and country with a score >500 and <900
SELECT 
	first_name,
	country
FROM customers
WHERE score>500 AND score<900

-- Q) Retrive customers from germany 
SELECT * 
FROM customers
WHERE country = 'Germany'


-- ORDER BY -> To sort your data in either accending(ASC) or decending(DESC) order 

-- Q) Retrieve all customers and sort the results by the higest score first 
SELECT * 
FROM customers
ORDER BY score DESC

-- Q) Retrieve all customers and sort the results by the lowest score first 
SELECT * 
FROM customers
ORDER BY score ASC

-- ( Nested) ORDER BY -> column order is very important like outer column must come first 
-- Q) Retrieve all customers and sort the result by the country and then by the higest score 
SELECT * 
FROM customers
ORDER BY country ASC , score DESC


-- GROUP BY clause -> combine the rows with same values ( aggregate a col with another col ) 
-- AS(ALIAS) -> shorthand name ( lable ) assigned to a column or table in a query 
-- Q) Find the total score for each country and arrange the total score in ascending order  
SELECT 
	country, 
	SUM(score) AS total_score 
FROM customers
GROUP BY country
ORDER BY total_score ASC


-- Q) Find the total score for each country and total number of customers for each country   
SELECT 
	country, 
	SUM(score) AS total_score,
	COUNT(country) AS total_customers
FROM customers
GROUP BY country
ORDER BY total_score ASC


-- HAVING clause -> Filter Data after aggregation of data 
-- **** Can be used only with GROUP BY 
/* Differnce b/w where and having clause -: 
In the order of using the clause WHERE comes before GROUP BY and HAVING comes after GROUP BY

if both are used then filter is applied twice 

*> WHERE apply filter on the Table 
*> HAVING apply filter on the Aggregrated Data
*/

--Q) Find the average score for each country considering only customers with a score not equal to 0 and return only those countries with average score greater than 430
SELECT 
	country,
	AVG(score) AS agerage_score,
	COUNT(country) AS total_customer_fulfilling_the_condition
FROM customers
WHERE score != 0 
GROUP BY country 
HAVING AVG(score) > 430
ORDER BY agerage_score ASC



-- DISTINCT clause - Remove duplicate values ( always used just after select ) 
-- Note -> Don't use DISTINCT unless it's necessary , it can slow down your query 
-- Q) Return unique list of all countries 
SELECT DISTINCT country
FROM customers


-- TOP cause -> Limit your data ( restricted the number of rows returned) 
-- Q) Retrive only three rows 
SELECT TOP(3) * 
FROM customers

--Q) Retrieve the top 3 customers with the higest scores 
SELECT TOP(3) *
FROM customers
ORDER BY score DESC

--Q) Retrive lowest 2 customers based on the score 
SELECT TOP(2) *
FROM customers
ORDER BY score ASC

-- Q) Get the 2 most recent orders 
SELECT TOP(2) * 
FROM orders
ORDER BY order_date DESC



-- Clubing all clauses together
-- Execution Order vs Coding Order
-- Multi-Queries in other softwares had to be end by ";"
