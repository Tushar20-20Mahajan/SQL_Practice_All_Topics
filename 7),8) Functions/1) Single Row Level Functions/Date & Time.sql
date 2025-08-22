/*
DATE & TIME 
Date Format -: { Year - Month - Day }
Time Format -: { Hour(0-23) : Minutes(0-59) : Seconds(0-59) : Miliseconds}

Time Stamp/Datetime2 -: -- DATE & TIME FORMAT -> yyyy-MM-dd HH:mm:ss
Datetime2 (SQL Servers) and Time Stamp (Oracle,Postgres,MySQL)



FUNCTIONS OF DATE & TIME
1) GETDATE() -: Returns the current date and time at the moment when the query is executed .

2) Part Extraction -: 
a) DAY(date) -> Returns the day from the date  ( returns integer ) 
b) MONTH(date) -> Returns the month from the date ( returns integer ) 
c) YEAR(date) -> Returns the year from the date ( returns integer ) 
d) DATEPART(part , date) -> Returns the specific part of the date like , day , month , year , week , quarter etc . ( always return the integer) 
e) DATENAME(part , date) -> Returns the name of the specific part of the date ( returns string ) 
f) DATETRUNCH(part , date) -> Truncates the date to a specific part ( returns datetime ) 
g) EOMONTH(date) -> Returns the last day of the month ( returns date) 

3) Calculation -: (Add) (difference)
a) DATEADD(part , interval , date) -> add or subtract a specific time interval to/from a date 
b) DATEDIFF(part , start date , end date -> returns the difference between the two dates 

4) Format and Casting -: 
(a) Formating -> Changing the format of value from one to another . changing how the date look like .
{ FORMAT(value , format[,culture])-> Formats date and time value ,
  CONVERT(datatype , value [,style]) -> Coverts date or time value to a different data type  & formats a value }
(b) Casting -> Changing the data type from one to another. { CAST() , CONVERT() }

5) Validation -: (0-> False , 1-> True) -: ISDATE(value) -> Checks if the value is a date and that too valid or not .

*/

-- Example of Date & Time Retriving 3 methods
USE SalesDB
SELECT 
--a) Date and time retriving in the form of columns from the Data Base
Sales.Orders.OrderID,
Sales.Orders.OrderDate,
Sales.Orders.ShipDate,
Sales.Orders.CreationTime,
--b) Hardcoded Date and Time 
'2025-08-12' AS Hardcoded,
--c) Getting / Generating Date and time using the GETDATE() function 
GETDATE() AS Generated_Date_Time
FROM Sales.Orders


--2) PART EXTRACTION 
SELECT 
Sales.Orders.OrderID,
Sales.Orders.CreationTime,
DAY(Sales.Orders.CreationTime) AS day_extraction,
MONTH(Sales.Orders.CreationTime) AS month_extraction,
Year(Sales.Orders.CreationTime) AS year_extraction,
--DatePart - Always returns integer
DATEPART(YEAR , Sales.Orders.CreationTime) AS year_dp,
DATEPART(MONTH , Sales.Orders.CreationTime) AS month_dp,
DATEPART(DAY, Sales.Orders.CreationTime) AS day_dp,
DATEPART(WEEK , Sales.Orders.CreationTime) AS week_dp,
DATEPART(WEEKDAY , Sales.Orders.CreationTime) AS weekday_dp,
DATEPART(QUARTER , Sales.Orders.CreationTime) AS Quater_dp,
DATEPART(HOUR , Sales.Orders.CreationTime) AS hour_dp,
DATEPART(MINUTE , Sales.Orders.CreationTime) AS minute_dp,
DATEPART(SECOND , Sales.Orders.CreationTime) AS seconds_dp,
--DateName - Always returns string value 
DATENAME(YEAR , Sales.Orders.CreationTime) AS year_dn,
DATENAME(MONTH , Sales.Orders.CreationTime) AS month_dn,
DATENAME(DAY, Sales.Orders.CreationTime) AS day_dn,
DATENAME(WEEK , Sales.Orders.CreationTime) AS week_dn,
DATENAME(WEEKDAY , Sales.Orders.CreationTime) AS weekday_dn,
DATENAME(QUARTER , Sales.Orders.CreationTime) AS Quater_dn,
DATENAME(HOUR , Sales.Orders.CreationTime) AS hour_dn,
DATENAME(MINUTE , Sales.Orders.CreationTime) AS minute_dn,
DATENAME(SECOND , Sales.Orders.CreationTime) AS seconds_dn,
--DateTrunc
DATETRUNC(YEAR , Sales.Orders.CreationTime) AS year_dc,
DATETRUNC(MONTH , Sales.Orders.CreationTime) AS month_dc,
DATETRUNC(DAY, Sales.Orders.CreationTime) AS day_dc,
DATETRUNC(HOUR , Sales.Orders.CreationTime) AS hour_dc,
DATETRUNC(MINUTE , Sales.Orders.CreationTime) AS minute_dc,
DATETRUNC(SECOND , Sales.Orders.CreationTime) AS seconds_dc,
--EOMONTH()
EOMONTH(Sales.Orders.CreationTime) AS last_day_of_month
FROM Sales.Orders

--Date trunch example
SELECT
DATETRUNC(year,Sales.Orders.CreationTime) AS Creation,
COUNT(*) AS count_number
FROM Sales.Orders
GROUP BY DATETRUNC(year,Sales.Orders.CreationTime)

SELECT
DATETRUNC(MONTH,Sales.Orders.CreationTime) AS Creation,
COUNT(*) AS count_number
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH,Sales.Orders.CreationTime)


--Q) How many orders were placed each year 
SELECT
Year(OrderDate),
Count(*) AS NumberOfOrder
FROM Sales.Orders
GROUP BY Year(OrderDate)

--Q) How many orders were placed each month
SELECT
    MONTH(OrderDate) AS OrderMonthNumber,
    DATENAME(month, OrderDate) AS OrderMonthName,
    COUNT(*) AS NumberOfOrders
FROM Sales.Orders
GROUP BY MONTH(OrderDate), DATENAME(month, OrderDate)
ORDER BY OrderMonthNumber;

--Q) SHow all the orders that were placed in the month of feburary 
SELECT 
*,
DATENAME(month, OrderDate) AS OrderMonthName
FROM Sales.Orders
WHERE DATEPART(month,OrderDate) = 2


--3) FORMATING AND CASTING 
-- DATE & TIME FORMAT -> yyyy-MM-dd HH:mm:ss
SELECT
OrderID,
CreationTime,
FORMAT(CreationTime , 'dd' ) dd,
FORMAT(CreationTime , 'ddd' ) ddd,
FORMAT(CreationTime , 'dddd' ) dddd,
FORMAT(CreationTime , 'MM' ) MM,
FORMAT(CreationTime , 'MMM' ) MMM,
FORMAT(CreationTime , 'MMMM' ) MMMM,
FORMAT(CreationTime , 'dd-MM-yyyy' ) dd_MM_yy_EU_FORMAT,
FORMAT(CreationTime , 'MM-dd-yyyy' ) dd_MM_yy_USA_FORMAT
FROM Sales.Orders

--Q) Show the Creation time using the following format :
-- Day Wed Jan Q1 2025 12:34:56 PM

SELECT
    OrderID,
    CreationTime,
    FORMAT(CreationTime, 'dd ddd MMM') + ' Q' + CAST(DATEPART(QUARTER, CreationTime) AS varchar(2)) + ' ' + FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS Output
FROM Sales.Orders;

--Convert 
SELECT 
CONVERT(INT , '123') AS [String to Integer CONVERT],
CONVERT(DATE , '08-12-2020') AS[String to Date CONVERT],
CreationTime,
CONVERT(DATE , CreationTime) AS [DateTime to DATE CONVERT]
FROM Sales.Orders

--CAST
SELECT
CAST('123' AS INT),
CAST('2025-08-12' AS DATE),
CAST('2025-08-12' AS DATETIME2)

--4) CALCULATIONS
--a)DATEADD()-: 
SELECT
OrderDate,
DATEADD(year,2,OrderDate) as yearAdd,
DATEADD(year,-6,OrderDate) as yearSUb,
DATEADD(month,-6,OrderDate) as monthSUb,
DATEADD(month,6,OrderDate) as monthadd,
DATEADD(day,-12,OrderDate) as daySub,
DATEADD(day,24,OrderDate) as dayadd
FROM Sales.Orders

--b) DATEDIFF()-:
SELECT
OrderDate,
ShipDate,
DATEDIFF(YEAR , OrderDate , ShipDate) yearDIff,
DATEDIFF(MONTH , OrderDate , ShipDate) monthDIff,
DATEDIFF(DAY , OrderDate , ShipDate) dayDIff
FROM Sales.Orders

--Q) Calculate the age of the employes
SELECT * , DATEDIFF(YEAR  , BirthDate ,  GETDATE()) AS Age
FROM Sales.Employees

--Q) Finds the average shipping duration in days in each month 
SELECT 
    FORMAT(CreationTime, 'MMMM') AS Month,
    AVG(DATEDIFF(DAY, CreationTime, ShipDate)) AS Avg_Shipping_Duration
FROM Sales.Orders
GROUP BY FORMAT(CreationTime, 'MMMM'), MONTH(CreationTime)
ORDER BY MONTH(CreationTime);


--Q) Find the number of days between each order and the previous order 
SELECT 
    OrderId,
    OrderDate,
    LAG(OrderDate) OVER (ORDER BY OrderDate) AS PreviousOrder,
    DATEDIFF(
        DAY,
        LAG(OrderDate) OVER (ORDER BY OrderDate),
        OrderDate
    ) AS Diff_days
FROM Sales.Orders;



--5) VALIDATION 
--ISDATE(value)
SELECT
ISDATE('123') ,
ISDATE('08-12-2025'),
ISDATE(2025),
ISDATE('2025'),
 ISDATE('08-13-2025'),
 ISDATE('08')