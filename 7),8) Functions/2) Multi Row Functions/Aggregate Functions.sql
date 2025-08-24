/*
Aggregate Functions -: They accept multiple rows as input and their output is single value
* COUNT(*)
* SUM()
* AVG()
* MAX()
* MIN()
*/
USE MyDatabase

SELECT * FROM customers
SELECT * FROM orders


--Q) Find the total number of Orders
--Q) Find total sales of all orders
--Q) Find the avg sales of all orders
--Q) Find the higest sales of all orders
--Q) Find the lowerst sales of all orders
SELECT 
COUNT(*) AS TotalNumberOfOrders,
SUM(sales) AS TotalSales,
AVG(sales) AS AverageSales,
MAX(sales) AS HigestSales,
MIN(sales) AS LowestSales
FROM orders


SELECT 
customer_id,
COUNT(*) AS TotalNumberOfOrders,
SUM(sales) AS TotalSales,
AVG(sales) AS AverageSales,
MAX(sales) AS HigestSales,
MIN(sales) AS LowestSales
FROM orders
GROUP BY customer_id
