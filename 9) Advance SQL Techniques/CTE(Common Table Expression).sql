/*
CTE(Common Table Expression) -: Temporary , named result ( virtual table ) , that can be used multiple time within your query to simplify and organize complex query.
*** IN the SubQuery , the intermediate result can be only used once but in CTE it can be used multiple time by the main query ( can be used in multiple places in the main query)
Readibility of the code is improved as the query is divided into different subsections i.e Modularity and also Reusability
CTE table data is stored in the cashe memory.

Note -: You can't use ORDER BY driectly within the CTE

CTE Types -: 
*Non-Recursive CTE-: CTE that is excuted only once i.e. without any repetition.
                    a) StandAlone CTE -> Defined and used independently. Runs independently as it's self contained and doesn't rely on other CTE's and queries.
                    b) Nested CTE -> CTE inside another CTE , A nested CTE uses the result of another CTE ,so it can't run independently.
* Recursive CTE -: Self-referencing query that repeatedly processes data untill a specific condition is met 
*/

-- Question Step based
USE SalesDB;

--Step 1 : Find the total sales per customer (Standalone CTE)
--Step 2 : Join the tables (data) CTE with the main query
WITH CTE_TOTAL_SALES AS(
    SELECT 
           CustomerID,
           Sum(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
)

-- Step 3 : Find the last order date for each customer (Standalone CTE)
, CTE_LAST_ORDER_DATE AS (
       SELECT 
       CustomerID,
       OrderDate
       FROM(
            SELECT 
                CustomerID,
                OrderDate,
                ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS rank_customer
            FROM Sales.Orders
        ) t WHERE rank_customer = 1
)
, CTE_LAST_ORDER_DATE_AnotherWay AS (
    SELECT 
    CustomerID,
    MAX(OrderDate) AS LastOrder
    FROM Sales.Orders
    GROUP BY CustomerID
)

--Step 4 : Rank the customers based on Total Sales Per Customer (Nested CTE)
, CTE_Rank_Acc_Sales AS (
    SELECT 
    * ,
    Row_Number() OVER(ORDER BY TotalSales DESC) AS Rank_Customers_Acc_Sales
    FROM CTE_TOTAL_SALES
)

-- Step 5: Segment customers based on their total sales  (Nested CTE)
,CTE_Customers_Segments AS (
 SELECT 
 CustomerID,
 TotalSales,
 CASE WHEN TotalSales > 100 THEN 'High'
      WHEN TotalSales <= 100 AND TotalSales > 50 THEN 'Mediun'
      WHEN TotalSales <= 50 AND TotalSales >= 0 THEN 'Low'
      ELSE 'Do not have information about the sales'
      END AS CustomerSegment
 FROM CTE_TOTAL_SALES
)
--Main Query
SELECT 
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
ctlo.OrderDate,
cras.Rank_Customers_Acc_Sales,
ccs.CustomerSegment
FROM Sales.Customers AS c
-- Left Join with CTE_TOTAL_SALES
LEFT JOIN CTE_TOTAL_SALES AS cts
ON c.CustomerID = cts.CustomerID
-- Left Join with CTE_LAST_ORDER_DATE
LEFT JOIN CTE_LAST_ORDER_DATE AS ctlo
ON ctlo.CustomerID = c.CustomerID
-- Left Join with CTE_Rank_Acc_Sales
LEFT JOIN CTE_Rank_Acc_Sales AS cras
ON cras.CustomerID = c.CustomerID
-- Left Join with CTE_Customers_Segments
LEFT JOIN CTE_Customers_Segments AS ccs
ON ccs.CustomerID = c.CustomerID



-- Recursive CTE 
--Q) Generate a sequence of numbers from 1 - 20

WITH Series AS (
    --Anchor Query
    SELECT 
    1 AS MyNumber
    --Linking Operator
    UNION ALL
    --Recursive CTE
    SELECT 
    MyNumber + 1
    FROM Series
    WHERE MyNumber < 20
)
-- Main Query 
SELECT 
* 
FROM Series
--Defining the recursion like controlling how many recursive calls will take place ( by default it is 100 ) 
OPTION(MAXRECURSION 10)


--Q) Show the employee hierarchy by displaying each employee's level within the organization 

WITH CTE_Level AS (
--Anchor Query
    SELECT 
        EmployeeID,
        FirstName,
        ManagerID,
        1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL
--Linking Qperator 
    UNION ALL
--Recursive Query
    SELECT 
    se.EmployeeID,
    se.FirstName,
    se.ManagerID,
    Level + 1
    FROM Sales.Employees AS se
    INNER JOIN CTE_Level AS cl
    ON se.ManagerID = cl.EmployeeID

)
--Main Query
SELECT 
* 
FROM CTE_Level
