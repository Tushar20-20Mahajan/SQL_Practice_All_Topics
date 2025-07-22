/*
SET OPERATORS 
a) Union -> Retun all distinct unique rows from both the queries . ( Remove all the duplicate rows from the result .... like duplicate will shown only once ) 
b) Union All -> Returns all rows from both the queries including the duplicates 
c) Except ( minus ) -> Returns the Distinct rows from the first query that are not found in the second query { This is the only one where the roder of queries affect the final result 
d) Intersect -> Returns the common distinct rows From both the queries 

Syntax -: 
SELECT Statement One / Query 1
SET Operator 
SELECT Statement Two /Query 2


Rules of Set Operator -: 
1) Order By can only be used once and that too at the last .( for other clauses not limit ) 
2) Same Number of colums must be there 
3) Matching Data Type 
4) Same order of columns 
5) First Query controls Aliases ( i.e. the column name will be controlled by the first select query )
6) Mapp the correct column
*/

USE SalesDB
SELECT * FROM Sales.Customers
SELECT * FROM Sales.Employees


--UNION
--Q) Combine the Data from employees and customers in one table 
SELECT 
Sales.Customers.CustomerID AS ID,
Sales.Customers.FirstName AS First_Name,
Sales.Customers.LastName AS Last_Name
FROM Sales.Customers

UNION

SELECT 
Sales.Employees.EmployeeID,
Sales.Employees.FirstName,
Sales.Employees.LastName
FROM Sales.Employees;


--UNION ALL
--Q) Combine the Data from employees and customers in one table including the duplicates 
SELECT 
Sales.Customers.CustomerID AS ID,
Sales.Customers.FirstName AS First_Name,
Sales.Customers.LastName AS Last_Name
FROM Sales.Customers

UNION ALL

SELECT 
Sales.Employees.EmployeeID,
Sales.Employees.FirstName,
Sales.Employees.LastName
FROM Sales.Employees;



-- EXCEPT ( Minus) 
--Q) Find employess who are not customers at the same time 

SELECT 
Sales.Employees.EmployeeID,
Sales.Employees.FirstName,
Sales.Employees.LastName
FROM Sales.Employees

EXCEPT

SELECT 
Sales.Customers.CustomerID AS ID,
Sales.Customers.FirstName AS First_Name,
Sales.Customers.LastName AS Last_Name
FROM Sales.Customers;


-- INTERSECT 
--Q) Find employess who are also customers at the same time 

SELECT 
Sales.Employees.EmployeeID,
Sales.Employees.FirstName,
Sales.Employees.LastName
FROM Sales.Employees

INTERSECT

SELECT 
Sales.Customers.CustomerID AS ID,
Sales.Customers.FirstName AS First_Name,
Sales.Customers.LastName AS Last_Name
FROM Sales.Customers;






/*
USES Of SET OPERATORS (Union)-: 
1) Combining similar information before starting analysizing the data 
*/

--Q) Orders are stored in seprate tables (Orders and Orders Archive) . Combine all orders into one report without duplicates .
SELECT 
'Orders' AS Source_Table ,
*
FROM Sales.Orders
UNION
SELECT
'Orders Archive' AS Source_Table ,
* 
FROM Sales.OrdersArchive
ORDER BY OrderID
;
-- Note -: Instead of '*' better practice is to list all columns in the query 


/*
USES Of SET OPERATORS (Except)-:
1) Delta Deletion -:
Identify the differnece or changes(delta) between two batches of data
{ Eg -> you need to load data from the source data system to the data wearhouse via data pipeline into data lake , you can use except to verify that the data is already in the warehouse or not and add it by initiallly veryfy using except}

2) Data Completeness check -: Except operator can be used to compare tables to detect discrepancies between the databases
{ Eg-> If there are two databases A and B and you need to transfer all the data from A->B , then you can check using Except wether all data is transfered or not  (If the result table is empty then all data is transfered) then do the same from B->A using Except , you will get the desired answer  }

*/