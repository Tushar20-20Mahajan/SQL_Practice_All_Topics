/*
CASE STATEMENTS -: Evaluates a list of conditions and the returns a value when the first condition is met

SYNTAX-:
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN condition3 THEN result3
    WHEN condition4 THEN result4
    .
    .
    .
    ELSE result
END


Rule -: The data of the result must be matching 

USE CASES -: 
* Drive new information
*Categorizing Data
* Mapping Values 
* Handling Nulls
* Conditional Aggregations 
*/

--Q) Generate a report showing the total sales for each category 
--* High if the sales is greater than 50 
-- * Medium if the sales is between 20 and  50 
--* Low if the sales are equal or low than 20 
-- Sort the result from lowest sales to higest sales
USE SalesDB
SELECT
OrderID,
Sales,
CASE
    WHEN Sales > 50 THEN 'High'
    WHEN Sales <=50 AND Sales>20 THEN 'Medium'
    WHEN Sales<=20 THEN 'Low'
    ELSE 'Unkown'
END AS Category
FROM Sales.Orders
ORDER BY Sales ASC ,Category ASC


--Q) Generate a report showing the total sales for each category 
--* High if the sales is greater than 50 
-- * Medium if the sales is between 20 and  50 
--* Low if the sales are equal or low than 20 
-- Sort the result from higest sales to lowest sales 
USE SalesDB

SELECT 
Category,
SUM(Sales) AS TotalSAles
FROM(
SELECT
OrderID,
Sales,
CASE
    WHEN Sales > 50 THEN 'High'
    WHEN Sales <=50 AND Sales>20 THEN 'Medium'
    WHEN Sales<=20 THEN 'Low'
    ELSE 'Unkown'
END AS Category
FROM Sales.Orders
)t
GROUP BY Category
ORDER BY TotalSAles DESC


--Retrive the employes details with gender displaced as full text 
SELECT 
EmployeeID,
FirstName,
LastName,
Department,
BirthDate ,
CASE 
 WHEN Gender = 'M' THEN 'Male'
 WHEN Gender = 'F' THEN 'Female'
 ELSE 'Others'
END AS Gender,
Salary,
ManagerID
FROM Sales.Employees


--Q) Retrive customers details with abbreviated country code
SELECT 
*,
CASE
    WHEN Country = 'Germany' THEN 'DE'
    WHEN Country = 'USA' THEN 'US'
    ELSE 'Unknown' 
END AS Abbreviated_Country_Code
FROM Sales.Customers

SELECT DISTINCT Country
FROM Sales.Customers

--Quick Form
SELECT 
*,
CASE Country
    WHEN 'Germany' THEN 'DE'
    WHEN 'USA' THEN 'US'
    ELSE 'Unknown' 
END AS Abbreviated_Country_Code
FROM Sales.Customers

SELECT DISTINCT Country
FROM Sales.Customers


--Q) Count how many times each customer has made an order with sales greater than 30
SELECT 
CustomerID,
SUM(
CASE 
    WHEN Sales > 30 THEN 1
    ELSE 0
END
) AS SalesHigerThan30,
COUNT(*) TotalSales
FROM Sales.Orders
GROUP BY CustomerID