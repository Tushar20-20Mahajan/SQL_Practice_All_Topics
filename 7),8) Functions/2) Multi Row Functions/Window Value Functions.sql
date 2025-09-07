/*

Access a value from other row 
You can use it for comparison of current row with other row 

 FUNCTIONS                      EXPRESSION           PARTITION BY CLAUSE          ORDER BY CLAUSE              FRAME CLAUSE 
a) LEAD(exp,offset,default)   |           |         |                   |         |              |             | NOT-ALLOWED   |
b) LAG(exp,offset,default)    | All data  |         |      Optional     |         |   Required   |             | NOT_ALLOWED   |
c) FIRST_VALUE(exp)           | Types     |         |                   |         |              |             | Optional      |
d) LAST_VALUE(exp)            |           |         |                   |         |              |             | Should be used|

LEAD -> Return the value from a previws(next) row 
LAG -> Return the value from subsequient row
FIRST_VALUE-> Return the first value in a window
LAST_VALUE -> Return the last value in a window
*/

USE SalesDB
--USE Case - Time series analyzes -> The process of analyzing the data to understand patterns , trends and behaviours over time .
--Q) Analyze the month - over - month (MOM) performance by finding the percentage change in sales between the current and previous month
SELECT
*,
CurrentMonthSales-PreviousMonthSales AS CurrentSubPrivious,
CASE 
        WHEN PreviousMonthSales = 0 THEN '100%'
        ELSE CAST(CAST(((CurrentMonthSales - PreviousMonthSales) * 100.0) / PreviousMonthSales AS DECIMAL(10,2)) AS VARCHAR(20)) + '%'
        --FORMAT(((CurrentMonthSales - PreviousMonthSales) * 100.0) / PreviousMonthSales, 'N2') + '%'
    END AS MOM_PercentageChange
FROM(
SELECT 
MONTH(OrderDate) AS OrderMonth,
SUM(Sales) AS CurrentMonthSales,
LAG(SUM(Sales),1,0) OVER ( ORDER BY MONTH(OrderDate)) AS PreviousMonthSales
FROM Sales.Orders
GROUP BY Month(OrderDate)
)t


--USE Case -> Customer Retention Analysis -: Analysis customer behaviours and loyality to help bussiness build strong relationships wih customers.

--Q) Analyze customer loyality by ranking customers based on the average number of days between orders
/*
Steps -: 
1) Find lag of the order date and remove the unnecessary columns for the next step 
2) Fnd the diffrence between the previous order date and the current order date 
3) Find the average 
4) then rank 

order by should be at the last 
fetch columns when required and remove them when use is over 
LEAD can also be used
*/

SELECT
      CustomerID,
      AVG( DifferenceInDays) AS AverageOrderInDays,
      RANK() OVER(ORDER BY COALESCE( AVG( DifferenceInDays),99999)) AS LoyalCustomer
FROM (
     SELECT
          CustomerID,
          OrderID,
          OrderDate,
          LAG(OrderDate, 1) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousDate,
          DATEDIFF(
                  DAY,
                  LAG(OrderDate, 1) OVER(PARTITION BY CustomerID ORDER BY OrderDate),
                  OrderDate
                  ) AS DifferenceInDays
      FROM Sales.Orders
) t
GROUP BY CustomerID


-- Q) Find the lowest and higest sales for each sale product
SELECT DISTINCT
ProductID , 
LowestSales,
HigestSales,
HigestSales-LowestSales AS SalesDifference
FROM(
SELECT 
OrderID,
ProductID,
Sales,
FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS LowestSales,
FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS  HigestSales,
LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS HigestSales1,
MIN(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS LowestSales2,
MAX(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS  HigestSales2
FROM Sales.Orders
)t

