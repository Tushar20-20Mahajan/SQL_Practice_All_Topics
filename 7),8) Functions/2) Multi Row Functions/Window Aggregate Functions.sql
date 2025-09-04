/*
Aggregate_Func.(exp) Over(.....)
                 |           |
                 V           |_______> Partition By , Order By , Frame Clause all three are optional
      Expression is Required
      (Only numeric in the case of avg , min , max , sum but all data types in the case of count)

      1) COUNT(exp) -> Returns the number of rows within each window ( regardless whether any value is null ) ( COUNT(column) -> Count the number of non-null values in a column)
                       Data Quality Issue-> Duplicates leads to in accuracy in analysis
      2) AVG(exp) -> FInd the avg of the values between each window
      3) MIN(exp) -> Return the lowest value within the window 
      4) MAX(exp) -> Return the maximum value within the window
      5) SUM(exp) ->  Returns sum of values within each window
*/

USE SalesDB
SELECT * FROM Sales.Orders
--Q) Find the total number of orders? Additionaly provide other details also
-- Find total number of orders for each customers
SELECT 
*,
COUNT(OrderID) OVER() AS TotalOrders,
COUNT(OrderID) OVER(PARTITION BY CustomerID) AS OdersOfEachCUstomer
FROM Sales.Orders


--Q) Find the total customers , additionally provide all other details of the customers
--Find the total number of scores for all customers
SELECT 
* ,
COUNT(*) OVER() AS TotalCustomersStar,
COUNT(1) OVER() AS TotalCustomersOne,
COUNT(Score) OVER() CustomersScoreCount
--NULL is not included
FROM Sales.Customers


--Q) Check whether the table orders contains any duplicate rows
SELECT
OrderID,
COUNT(*) OVER(PARTITION BY OrderID) AS CheckPK
FROM Sales.Orders

SELECT
OrderID,
COUNT(*) OVER(PARTITION BY OrderID) AS CheckPK
FROM Sales.OrdersArchive

SELECT
* 
FROM (
        SELECT
        OrderID,
        COUNT(*) OVER(PARTITION BY OrderID) AS CheckPK
        FROM Sales.OrdersArchive
)t WHERE CheckPK > 1


--Q) Find total sales across all products and find total sales for each product , additionally provide other details too 
SELECT
* ,
SUM(Sales) OVER() TotalSales,
SUM(Sales) OVER(PARTITION BY ProductID) SalesOfEachProduct
FROM Sales.Orders

--Comparison use case -> Compare the current value and the aggregated value of the window
--Find the percentage contribution of each product's sales to the total sale 
SELECT 
    ProductID,
    COALESCE(SUM(Sales), 0) AS SalesOfEachProduct,
    COALESCE(SUM(SUM(Sales)) OVER(), 0) AS TotalSales,
    CASE 
        WHEN SUM(SUM(Sales)) OVER() = 0 THEN 0
        ELSE (COALESCE(SUM(Sales), 0) * 100.0 / SUM(SUM(Sales)) OVER())
    END AS PercentageContribution
FROM Sales.Orders
GROUP BY ProductID;

--Q) Find avg sales accross all orders and also avg sales for each product . Additionally provide other details too 
SELECT
*,
AVG(COALESCE(Sales,0)) OVER() AvgOfTotalSales,
AVG(COALESCE(Sales,0)) OVER(PARTITION BY ProductID) AvgOfProductSales
FROM Sales.Orders


--Q) Find the avg score of customers and additionally provide additional info alse 
SELECT 
*,
COALESCE(Score,0) AS CustomerScore,
AVG(Score) OVER() AS AvgOfScoreExcludingNull,
AVG(COALESCE(Score,0)) OVER() AS AvgOfScore
FROM Sales.Customers

--Q) Find all orders where the sales are higer than the avg sales accross all oders 
SELECT
*
FROM (
SELECT
*,
AVG(COALESCE(Sales,0)) OVER() AS AvgSales
FROM Sales.Orders
)t WHERE Sales > AvgSales


--FInd higest and lowest sales accross all orders and find higest and lowest sales for each product also provide additional information
SELECT 
* ,
MIN(Sales) OVER() minSaleOverAll,
MAX(Sales) OVER() maxSaleOverAll,
MIN(Sales) OVER(PARTITION BY ProductID) minSaleOfProduct,
MAX(Sales) OVER(PARTITION BY ProductID) maxSaleOfProduct
FROM Sales.Orders

--Show the Employee with the higest salary 
SELECT
*
FROM (
SELECT 
* ,
MAX(Salary) OVER() AS HigestSalary
FROM Sales.Employees
) t WHERE Salary = HigestSalary


-- Calculate the diviation of each sales from both the min and max sales amount 
SELECT 
ProductID,
Sales ,
MIN(Sales) OVER() minSaleOverAll,
MAX(Sales) OVER() maxSaleOverAll,
Sales-MIN(Sales) OVER() AS deviationFromMinSaleOverAll,
ABS(Sales - MAX(Sales) OVER() ) AS deviationFromMaxSaleOverAll,
MAX(Sales) OVER(PARTITION BY ProductID) maxSaleOfProduct,
MIN(Sales) OVER(PARTITION BY ProductID) minSaleOfProduct,
Sales-MIN(Sales) OVER(PARTITION BY ProductID) deviationMinSaleOfProduct,
ABS(Sales-MAX(Sales) OVER(PARTITION BY ProductID)) deviationMaxSaleOfProduct
FROM Sales.Orders




/* RUNNING AND ROLLING TOTAL -> The aggregate sequence of members and the aggregation is updated each time a new member is added.
Also known as alalysis overtime
      a) Tracking -> Main use case is tracking ( Fro eg-> Tracking current sales with target sales)
      b) Trend Analysis -> Providing insights into historical patterns

      Running Total -> Aggregate all values from the begninning up to the current point without dropping off older data .  (Eg - SUM(Sales) OVER(ORDER BY Month) -: Default frame { ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW } ) 
      Rolling Total -> Aggregate all values within a fixed time ( eg- 30 days ) AS new data is added the oldest one is dropped. ( Eg - SUM(Sales) OVER(ORDER BY Month  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)  -* Fixed frame )

*/
--Analytical use case -> Moving Agerage
--Calculate moving average of sales for each product over time 
-- Moving Average of Sales per product over time
SELECT
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    AVG(COALESCE(Sales,0)) OVER (
        PARTITION BY ProductID 
    ) AS AverageByProduct,
    AVG(COALESCE(Sales,0)) OVER (
        PARTITION BY ProductID 
        ORDER BY OrderDate 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS MovingAverage
FROM Sales.Orders;


--Calculate moving average of sales for each product over time  including only the next order
-- Moving Average of Sales per product over time
SELECT
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    AVG(COALESCE(Sales,0)) OVER (
        PARTITION BY ProductID 
    ) AS AverageByProduct,
    AVG(COALESCE(Sales,0)) OVER (
        PARTITION BY ProductID 
        ORDER BY OrderDate 
        ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
    ) AS RollingAverage
FROM Sales.Orders;
