/*
JOINS 
1) Left Join { +1-> where B.key is null } 
2) Right Join  { +1-> where A.key is null } 
3) Inner Join 
4) Outer Join { +1-> where A.key is null OR B.key is null } 

5) No Join -> Returns data from two tables without joing them 
6) Cross Join 

## When to use Joins 
a) Recombine Data   -> Inner , Left , Full
b) Data Enrichment "Getting Extra Data" -> Left
c) Check for existance "Filtering the Data" -> Inner , Left + where , Full + where
*/


-- Set up 
USE MyDatabase


-- (a) No Join
SELECT * FROM customers;
SELECT * FROM orders;



-- (b) Inner Join -> only the matching from A and B
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



-- c) LEFT JOIN  -> Everything from left but only the matching from the right
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



--d) RIGHT JOIN -> Everything from right but only the matching from the left 
--Q) Get all customers with their orders ,including orders without maching orders 
SELECT 
orders.order_id,
orders.customer_id,
orders.order_date,
orders.sales,
customers.first_name,
customers.country
FROM customers
RIGHT JOIN orders
ON customers.id = orders.customer_id


--Q) Get all the customers along with their orders , including orders without matching their customers (Using Left Join) 
SELECT
orders.order_id,
orders.order_date,
orders.sales,
orders.customer_id,
customers.first_name,
customers.country
FROM orders
LEFT JOIN customers
ON customers.id = orders.customer_id


-- e) FULL OUTER JOIN -> Return all rows from both the tables 
--Q) Get all customers and all orders even if there is no match 
SELECT 
customers.id ,
customers.first_name,
customers.country,
customers.score,
orders.order_id,
orders.order_date,
orders.sales
FROM customers
FULL OUTER JOIN orders
ON customers.id = orders.customer_id



-- f) Left Anti Joint -> Returns Rows from left that has no match on right 
-- Q) Get all the customers who have not placed any order 
SELECT 
c.id,
c.first_name,
c.country,
c.score
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL
--ON customers.id = orders.customer_id
--WHERE orders.customer_id IS NULL



--h) Right Anti Join -> Returns the rows of the right table that  is not matched by the left table 
--Q) Get all orders without matching customers 
SELECT * 
FROM customers
RIGHT JOIN orders
ON customers.id = orders.customer_id
WHERE customers.id IS NULL

--Q) Get all orders without matching customers (using left join ) 
SELECT * 
FROM orders
LEFT JOIN customers
ON customers.id = orders.customer_id
WHERE customers.id IS NULL



-- i)  FULL Outer Anti Join -> Return the rows that don't match in the either table 
--Q) Find customers without orders and orders without customers 
SELECT * 
FROM customers
FULL OUTER JOIN orders
ON customers.id = orders.customer_id
WHERE customers.id IS NULL OR orders.customer_id IS NULL




--Q) Get all customers along with their orders , but only those customers who have placed any orders (without using inner join ) 
SELECT * 
FROM customers
LEFT JOIN orders
ON customers.id = orders.customer_id
WHERE orders.customer_id IS NOT NULL 



-- j) CROSS JOIN -> Combines every row from left to the every row from the right -{ All Possible combinations -> Cartesian Join }-
--Q) Generate all possible combinations of customers and orders 
SELECT * 
FROM customers
CROSS JOIN orders


/*
Multiple Table 

SELECT * 
FROM A
LEFT JOIN B ON 
LEFT JOIN C ON 
LEFT JOIN D ON 
......
WHERE .... { Where controls what to keep }
*/




-- USING MULTIPE TABLES 
-- Q) Using salesDB retrive a list of all orders , along with the related products ,customers , and employee details
/*
For each oder display :
Order Id 
Customer's Name 
Product Name 
Sales Amount 
Product Price 
Salesperson's name 
*/

USE SalesDB
SELECT * FROM Sales.Customers
SELECT * FROM Sales.Employees
SELECT * FROM Sales.Orders
SELECT * FROM Sales.Products
SELECT * FROM Sales.OrdersArchive


SELECT 
Sales.Orders.OrderID,
Sales.Orders.Sales,
Sales.Customers.FirstName AS Customer_firstName , 
Sales.Customers.LastName AS Customer_lastName,
Sales.Products.Product,
Sales.Products.Price,
Sales.Employees.FirstName AS Employee_firstName,
Sales.Employees.LastName AS Employee_lastName
FROM Sales.Orders
LEFT JOIN Sales.Customers ON Sales.Orders.CustomerID = Sales.Customers.CustomerID
LEFT JOIN Sales.Employees ON Sales.Orders.SalesPersonID = Sales.Employees.EmployeeID
LEFT JOIN Sales.Products ON Sales.Orders.ProductID = Sales.Products.ProductID