/*
JOINS 
1) Left Join { +1-> where B.key is null } 
2) Right Join  { +1-> where A.key is null } 
3) Inner Join 
4) Outer Join { +1-> where A.key is null OR B.key is null } 

5) No Join -> Returns data from two tables without joing them 
6) Cross Join 

## When to use Joins 
a) Recombine Data   -> Inner , Left
b) Data Enrichment "Getting Extra Data" -> Left
c) Check for existance "Filtering the Data" -> Inner , Left + where
*/


-- Set up 
USE MyDatabase


-- (a) No Join
SELECT * FROM customers;
SELECT * FROM orders;



-- (b) Inner Join 
--Q) Get all customers along with there orders but only those who have placed an order
SELECT 
customers.id ,
customers.first_name,
customers.country,
customers.score,
orders.order_id,
orders.order_date,
orders.sales
FROM customers
INNER JOIN orders
ON customers.id=orders.customer_id
-- Selecting all the columns at once 
SELECT *
FROM customers
INNER JOIN orders
ON customers.id=orders.customer_id



-- c) LEFT JOIN
--Q) Get all customers with their orders along with those who don't have any order 
SELECT 
customers.id ,
customers.first_name,
customers.country,
customers.score,
orders.order_id,
orders.order_date
FROM customers
LEFT JOIN orders
ON customers.id = orders.customer_id
