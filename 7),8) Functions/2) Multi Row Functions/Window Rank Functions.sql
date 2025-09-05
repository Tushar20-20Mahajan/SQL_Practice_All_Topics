/*
a) Integer Based Ranking -: ( Discreate Values ) 
                            ( Use case eg -: Top 3 Products ) 
                            ( Known as TOP/Bottom N Analysis )
                            
                            Functions are -: 
                            1) ROW_NUMBER() -: Assign a unique number to each row in a window 
                            2) RANK() -: Assign a rank to each row in a window with gaps 
                            3) DENSE_RANK() -: Assign a rank to each row in a window without gaps
                            4) NTILE(n) -: Devides the rows into a specified number of approximately equal gaps  

b) Percentage Based Ranking -: ( Continuous values from scale of 0-1 ) 
                                ( Use case eg -: Top 20% of Product Sales ) 
                                ( Known as Distribution analysis ) 

                                Functions are -: 
                                1) CUME_DIST() -: Calculate the cumulative distribution of a value within a set of values
                                2) PERCENT_RANK() -: Returns the percentile ranking number of a row 


RANK Functions Syntax -> RANK() OVER(PARTITION BY ProductID ORDER BY Sales)
                           |                |                      |
                           V                V                      V
                       {Expression must    { Optinal}          { IS REQUIRED}   { Frame clause if NOT Allowed } 
                       be empty but number 
                       in the case of 
                       NTILE()}


*/
USE SalesDB



-- INTEGER - BASED RANKING FUNCTIONS -:> 
--Q) Rank the oders based on their sales from lowest to higest 
SELECT
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER(ORDER BY Sales DESC) AS Row_Based_Rank,
RANK() OVER( ORDER BY Sales DESC) AS Rank_Based_Rank,
DENSE_RANK() OVER(ORDER BY Sales DESC) AS Rank_Based_Dense
FROM Sales.Orders



--USE Case -: Top-N Analysis
--Q) Find the Top Higest Sales for the Each Product 
SELECT
* 
FROM (
SELECT 
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) As HigestSalesOfProducts
FROM Sales.Orders
)t WHERE HigestSalesOfProducts = 1

-- USE Case -: Bottom - N Aalysis 
-- Q) Find the bottom two customers based on the total sales 
SELECT *
FROM (
SELECT 
CustomerID,
SUM(Sales) AS TotalSales,
ROW_NUMBER() OVER(ORDER BY SUM(Sales)) AS RankOfCustomerBySales
FROM Sales.Orders
GROUP BY CustomerID
) t WHERE RankOfCustomerBySales IN (1,2)

SELECT *
FROM (
SELECT 
CustomerID,
SUM(Sales) AS TotalSales,
ROW_NUMBER() OVER(ORDER BY SUM(Sales)) AS RankOfCustomerBySales
FROM Sales.Orders
GROUP BY CustomerID
) t WHERE RankOfCustomerBySales <= 2

SELECT *
FROM (
SELECT 
CustomerID,
SUM(Sales) AS TotalSales,
ROW_NUMBER() OVER(ORDER BY SUM(Sales)) AS RankOfCustomerBySales
FROM Sales.Orders
GROUP BY CustomerID
) t WHERE RankOfCustomerBySales = 1 OR RankOfCustomerBySales = 2


-- USE Case -: Assign Unique ID's -> Help to assign Unique Identifier for each row to help paginating 

--Assign Unique ID's to the rows of the 'Orders Archive '
SELECT 
ROW_NUMBER() OVER(ORDER BY OrderID , OrderDate) AS ArchiveOrderID,
* 
FROM Sales.OrdersArchive
 

 -- Use Case -> Identify Duplicates
 -- Identify duplicate rows in the table Order's Archive  and return a clean result without any duplicates
 SELECT
 * 
 FROM(
 SELECT 
 ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS runTime,
 * 
 FROM Sales.OrdersArchive
 )t WHERE runTime = 1


 -- NTILE
 SELECT 
 OrderID,
 ProductID,
 Sales,
 NTILE(1) OVER(Order BY Sales DESC) AS Bucket1,
 NTILE(2) OVER(Order BY Sales DESC) AS Bucket2,
 NTILE(3) OVER(Order BY Sales DESC) AS Bucket3,
 NTILE(4) OVER(Order BY Sales DESC) AS Bucket4,
 NTILE(5) OVER(Order BY Sales DESC) AS Bucket5,
 NTILE(6) OVER(Order BY Sales DESC) AS Bucket6,
 NTILE(9) OVER(Order BY Sales DESC) AS Bucket
 FROM Sales.Orders


 -- USE Cases 
 -- Data Analyst -> Data Segmentation ( Divive data into distinct subsets based on certain criteria ) 
 -- Data ENgineer -> Equalizing Load Processing (Divide the data into subsets before exporting it from one DB to another ) 

 -- Q) Segment orders into 3 categories high , medium and low
 SELECT 
 * ,
 CASE WHEN Buckets = 1 THEN 'High'
      WHEN Buckets = 2 THEN 'Medium'
      WHEN Buckets = 3 THEN 'Low'
      Else 'Low'
 END AS Category
 FROM (
 SELECT 
 OrderID,
 ProductID,
 Sales,
 NTILE(3) OVER( ORDER BY Sales DESC) AS Buckets
 FROM Sales.Orders
 )t



 -- PERCENTAGE - BASED RANKING FUNCTIONS -:> 
 -- CUME_DIST () -> Position NR/ Number of rows  ( Current row is includive # inclusive ) 
 -- PERCENT_RANK() -> Position NR-1 / Number of rows -1 ( Current row is excluded # exclusive ) 

 -- Q) Find products that fall within the higest 40% of the prices 
 SELECT * FROM (
SELECT 
* ,
CUME_DIST() OVER (ORDER BY Price DESC) AS PercentagePrice
FROM Sales.Products )t WHERE  PercentagePrice <= 0.4



SELECT 
* ,
CONCAT(PercentagePrice * 100 , '%' ) PercentagePriceProduct
FROM (
SELECT 
* ,
PERCENT_RANK() OVER (ORDER BY Price DESC) AS PercentagePrice
FROM Sales.Products 
)t WHERE  PercentagePrice <= 0.4