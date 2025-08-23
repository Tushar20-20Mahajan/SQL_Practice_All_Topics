/*
NULL -: Null means nothing , unknown! Null is not equal to anything!

***Functions for handling null values 
A) Replace Values
   * Null ---- ISNULL/COALESCE----> 40
   *40------NULLIF------> NULL
B) Check for Null -: Returns boolean values
   * NULL-------IS NULL------>True
   * NULL-------IS NOT NULL ----->False

   FUNCTIONS-:
   1) ISNULL(value,replacement_value) -: It replaces "NULL" with a specific value.
   2) COALESCE(value1,value2,value3......) -: Return the first non-null value from the list.
   3) NULLIF(value1,value2) -: Compares two expression returns : NULL if they are equal and First value if they are not equal
   4)Value IS NULL -: Returns true if value is null and false if not null.
   5) Value IS NOT NULL -: Returns true if value is not null and false if the value is null
*/

USE SalesDB
SELECT * FROM Sales.Customers

--Q) Find the avg scores for the customers
SELECT 
*,
COALESCE(Score,0),
AVG(Score) OVER() AS excluddingNULL,
AVG(ISNULL(Score,0)) OVER() AS avg_score
FROM Sales.Customers


--Q) Display the full name of the customers in a single feild by merging their first and last names and add 10 bonous points to each customers score 
SELECT
*,
TRIM(COALESCE(FirstName,'') + ' ' + COALESCE(LastName,'')) AS FullName,
COALESCE(Score,0)+10 AS BonousScore
FROM Sales.Customers

--Q) Sort the customers from lowest to the higest scores with nulls appeaing last
/*
SELECT
*,
CASE WHEN Score IS NULL THEN 1 ELSE 0 END Flag
FROM Sales.Customers
ORDER BY  COALESCE(Sales.Customers.Score ,1000 ) ASC
*/
SELECT
*
FROM Sales.Customers
ORDER BY  CASE WHEN Score IS NULL THEN 1 ELSE 0 END ASC , Score ASC


--Q) Find the sales price for each order by dividhing sales by quantity
SELECT * ,
Sales/NULLIF(Quantity,0) AS SalesPrice
FROM Sales.Orders

--Q) Identify the customers who have no score
SELECT *
FROM Sales.Customers
WHERE Score IS NULL

--Q) Identify the customers who have score
SELECT *
FROM Sales.CUstomers
WHERE SCORE IS NOT NULL

--Q) List all details of the customers who have not placed any order
SELECT * FROM Sales.Customers
SELECT * FROM Sales.Orders

SELECT 
c.CustomerID,
c.FirstName,
c.LastName,
c.Country,
c.Score,
o.OrderID
FROM Sales.Customers AS c
LEFT JOIN  Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL