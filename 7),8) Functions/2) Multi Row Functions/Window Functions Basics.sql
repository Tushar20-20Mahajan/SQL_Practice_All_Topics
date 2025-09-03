/*
Performs calculations(Eg-: Aggregations) on a specific subset of data , without losing the level of details of the rows.
Group By -: Returns a single row for each gropup ( Changes the Granuality) ( Simple Aggregations )  ( Simple Data Analysis)
Window-: Returns a result for each row (The Granuality remains the same ) (Aggregation + Keep Details) (Advance Data Analysis)

WINDOW FUNCTIONS -:  Perform calculations within a window

1) Aggregate Func. -: 
    a) COUNT(exp)
    b) SUM(exp)
    c) AVG(exp)
    d) MIN(exp)
    e) MAX(exp)

2) Rank Func. -: 
    a) ROW_NUMBER()
    b) RANK()
    c) DENSE_RANK()
    d) CUME_DIST()
    e) PERCENT_RANK()
    f) NTILE(n)

3) Value(Analytics) Func.-:
   a) LEAD(exp,offset,default)
   b) LAG(exp,offset,default)
   c) FIRST_VALUE(exp)
   d) LAST_VALUE(exp)

   </> WINDOW SYNTAX -:::

   Window_Function Over_Clause(Partition_Clause Order_Clause Frame_Clause)
   Eg-: 
   AVG(Sales) OVER(PARTITION BY Category ORDER BY OrderDate ROWS UNBOUNDED PRECEDING)


   OVER_Clause -> Tells SQL that the function used is is a window function. It defines a window or subset of data.
   Partition By -> Devide the result set into partitions(Windows) like how to divide our data.
   Order By -> Sort the data within teh window (Asc | Desc) * Required in rank and value functions
   Frame_Clause -> Defines a subset of rows within ecah window that is relevant for the calculation
                 Frame Type BETWEEN Frame_Boundary(Lower) AND Frame_Boundary(Higer)
                 Frame Type -> Row , Range
                 Frame Boundary ( Lower) -> CUrrent Row , N PRECEDING , UNBOUNDED PRECEDING
                 Frame Boundary ( Higer) -> CUrrent Row , N FOLLOWING , UNBOUNDED FOLLOWING
        Note -: Frame Clause can't be used without ORDER BY clause and Lower value must be before the Higer value
        Default Frame always with the Order By i.e. Unbounded Preceding and current row

    RULES -: 
            1)Window functions can onl be used in SELECT and ORDER BY clause
            2) Nesting window functions is not allowed
            3) SQL executes window function after the where clause
            4) Window function can be used together with group by in the same query only if the same columns are used

*/

USE SalesDB
SELECT * FROM Sales.Orders

--Q) Find total sales accross all orders
SELECT
SUM(Sales) AS TotalSales
FROM Sales.Orders


--Q) Find total sales for each product
SELECT
ProductID,
Sum(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY ProductID 

--Q) Find total sales for each product additionally provide the details such as order id and order date
SELECT 
* , 
SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSales
FROM Sales.Orders



--Q) Find total sales accross all orders
--Find total sales for each product
--Find total sales for each product additionally provide the details such as order id and order date
--Find total sales for each combination of product order status
SELECT 
* ,
SUM(Sales) OVER() AS TotalSales,
SUM(Sales) OVER(PARTITION BY ProductID) AS Sales_Product,
SUM(Sales) OVER(PARTITION BY ProductID , OrderStatus) AS Sales_Product_OrderStatus
FROM Sales.Orders


--Q) Rank each order based on their sales from higest to lowest and provide additional information like order id and order status 
SELECT 
* ,
RANK() OVER(ORDER BY Sales DESC) AS Rank
FROM Sales.Orders

-- Frame Clause
SELECT 
* ,
SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS Sales_Product_OrderStatus
FROM Sales.Orders



--Q) Rank the customers based on their total sales 
SELECT 
CustomerID,
 SUM(Sales) AS TotalSales,
 RANK() OVER(ORDER BY SUM(Sales) DESC ) AS RankAccCustomer
FROM Sales.Orders
GROUP BY CustomerID 