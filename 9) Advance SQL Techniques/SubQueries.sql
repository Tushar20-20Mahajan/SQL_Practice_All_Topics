/*
SUBQUERIES -: A Query inside another query.

Categories -:> 
             A) DEPENDENCY 
                         1) Non-Correlated SubQuery -: A SubQuery that can run independently of the main query.
                         2) Correlated SubQuery -: A SubQuery that relies on values from the main query

             B) Result Type
                         1) Scalar SubQuery -> Return single value
                         2) Row SubQuery -> Return multiple rows and single column
                         3) Table SubQuery -> Return a table (multiple rows and multiple columns


    Location -:>
               a) SELECT -> Used to aggregate the data side by side with the main query's data ,allowing for direct comparison.
                             Rule only scalar subqueries are allowed to be used.
               b) FROM -> Used as a temporary table for the main query
               c) JOIN -> Used to prepare the data (filtering or aggregation ) before joining it with other tables
               d) WHERE -> Used of complex filtering logic and makes query more flexible and dynamic
                       * Comparison Operators
                       * Logical Operators
                           a) IN -> Checks whether a values matches any value in the list. ( subquery can have multipe rows) 
                           b)NOT IN 
                           c) ANY  -> Checks if a value matches ANY value within a list (Used to check if the values is true for ATLEAST one of the values in a list. 
                           d) ALL-> Checks if a value matches all values within a list 
                           e) Exists -> CHecks if a subquery returns any rows
                        Only scalar subqueries are allowed to be used 
*/

USE SalesDB

--Eg Scalar SubQuery
SELECT
AVG(Sales)
FROM Sales.Orders

--Eg Row SubQuery
SELECT
CustomerID
FROM Sales.Orders

--Eg Table subquery
SELECT
OrderID,
OrderDate,
Sales
FROM Sales.Orders


--SubQuery in the FROM Clause

--Q) Find the products that have a higer price than the average price of all the products 
SELECT 
    ProductID,
    Product,
    Category,
    Price
FROM(
    --SubQuery
    SELECT 
        *, 
        AVG(COALESCE(Price,0)) OVER() AS AveragePrice
    FROM Sales.Products
) AS AveragePriceTable 
WHERE Price>AveragePrice

--Q) Rank the customers based on the total amount of their sales
SELECT
    CustomerID,
    ROW_NUMBER() OVER(ORDER BY TotalSalesOfProduct DESC) AS CustomerRank,
    TotalSalesOfProduct
FROM(
    SELECT
        CustomerID,
        Sales,
        SUM(COALESCE(Sales,0)) AS TotalSalesOfProduct
    FROM Sales.Orders
) AS TotalSalesTable
GROUP BY CustomerID , TotalSalesOfProduct

-- Another way 
SELECT
    CustomerID,
    ROW_NUMBER() OVER(ORDER BY TotalSalesOfProduct DESC) AS TopBuyers,
    TotalSalesOfProduct
FROM(
    SELECT
        CustomerID,
        SUM(COALESCE(Sales,0)) AS TotalSalesOfProduct
    FROM Sales.Orders
    GROUP BY CustomerID 
) AS TotalSalesTable


--SubQuery in the SELECT Clause
--Q) Show the productsID , product names , category, prices , and total numner of sales per product id  and total orders of each product
SELECT 
    p.ProductID,
    p.Product,
    p.Category,
    p.Price,
    (
    SELECT
          COALESCE(SUM(o.Sales), 0) 
    FROM Sales.Orders AS o
    WHERE o.ProductID = p.ProductID
    ) AS TotalSalesOfProduct ,
     (
    SELECT
         COUNT(OrderID)
    FROM Sales.Orders AS o
    WHERE o.ProductID = p.ProductID
    ) AS TotalOrderOfProduct
FROM Sales.Products AS p

--Another way to do same thing 
SELECT 
    p.ProductID,
    p.Product,
    p.Category,
    p.Price,
    COALESCE(SUM(o.Sales), 0) AS TotalSalesOfProduct,
    COALESCE(COUNT(o.OrderID), 0) AS TotalOrderOfProduct
FROM Sales.Products AS p
LEFT JOIN Sales.Orders AS o
    ON o.ProductID = p.ProductID
GROUP BY 
    p.ProductID,
    p.Product,
    p.Category,
    p.Price;


--Using JOINS 
--Q) Show all customers details and find the total orders of each customer
SELECT
    c.*,
    COALESCE(o.TotalOrders, 0) AS TotalOrders
FROM Sales.Customers AS c
LEFT JOIN (
    SELECT 
        a.CustomerID,
        COUNT(a.OrderID) AS TotalOrders
    FROM Sales.Orders AS a
    GROUP BY a.CustomerID
) o
ON c.CustomerID = o.CustomerID;



--Using WHERE 
--Q) Find the products that have a higer price than the average price of all the products 
SELECT 
    ProductID,
    Product,
    Category,
    Price
FROM Sales.Products
WHERE Price>(
    --SubQuery
    SELECT 
        AVG(COALESCE(Price,0)) AS AveragePrice
    FROM Sales.Products
)

-- IN Operator 
--Q) Show the list of orders made by customers in Germany 
SELECT 
OrderID,
CustomerID,
OrderDate,
(SELECT Country FROM Sales.Customers AS c WHERE c.CustomerID = o.CustomerID) AS Country
FROM Sales.Orders AS o
WHERE CustomerID IN (
                     SELECT 
                     CustomerID
                     FROM Sales.Customers AS c
                     WHERE Country = 'Germany'
)

-- NOT IN Operator 
--Q) Show the list of orders made by customers not in Germany 
SELECT 
OrderID,
CustomerID,
OrderDate,
(SELECT Country FROM Sales.Customers AS c WHERE c.CustomerID = o.CustomerID) AS Country
FROM Sales.Orders AS o
WHERE CustomerID NOT IN (
                     SELECT 
                     CustomerID
                     FROM Sales.Customers AS c
                     WHERE Country = 'Germany'
)

-- Another way using ! operator  and IN operator 
SELECT 
OrderID,
CustomerID,
OrderDate,
(SELECT Country FROM Sales.Customers AS c WHERE c.CustomerID = o.CustomerID) AS Country
FROM Sales.Orders AS o
WHERE CustomerID IN (
                     SELECT 
                     CustomerID
                     FROM Sales.Customers AS c
                     WHERE Country != 'Germany'
)


--ANY / ALL
--Q) Find the female employees whoes salaries are greater than the salaries of any male employees 
SELECT 
    * 
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary >ANY(SELECT 
                    Salary
                  FROM Sales.Employees
                  WHERE Gender = 'M')


--Q) Find the female employees whoes salaries are greater than the salaries of all male employees 
SELECT 
    * 
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary >ALL(SELECT 
                    Salary
                  FROM Sales.Employees
                  WHERE Gender = 'M')



-- Correlated / Non-Correlated 
-- Correlated SubQuery
--Q) Show all customers details and find the total orders of each customer
SELECT 
* ,
(SELECT 
       COUNT(OrderID) 
       FROM Sales.Orders AS o
       WHERE o.CustomerID = c.CustomerID

) AS TotalOrders
FROM Sales.Customers AS c


--Exists 
--Q) Show the list of orders made by customers in Germany
SELECT 
*
FROM Sales.Orders AS o
WHERE EXISTS (
        SELECT 1
        --CustomerID
        FROM Sales.Customers AS c
        WHERE Country = 'Germany'
        AND o.CustomerID = c.CustomerID
)

--Q) Show the list of orders made by customers not in Germany
SELECT 
*
FROM Sales.Orders AS o
WHERE NOT EXISTS (
        SELECT 1
        --CustomerID
        FROM Sales.Customers AS c
        WHERE Country = 'Germany'
        AND o.CustomerID = c.CustomerID
)