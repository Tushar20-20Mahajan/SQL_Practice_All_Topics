/*
STRING FUNCTIONS 
1) Manipulation -: CONCAT , UPPER , LOWER , TRIM , REPLACE 
2) Calculation -: LEN 
3) String Extraction -: LEFT , RIGHT , SUBSTRING
*/

--Database
USE MyDatabase
SELECT *
FROM customers

--MANIPULATION
--a) CONCAT -: Combines multiple string values into one string
--b) UPPER -: Converts all the characters of the string into Upper case
--c) LOWER -: Converts all the characters of the string into Lower case
--d) TRIM -: Removers the leading and trailing spaces
--e) REPLACE -: Replaces specific character with a new character 

--Q) Show the list of customers - first name together with their country in one column 
SELECT 
first_name,
country,
CONCAT(first_name ,' ', country ) AS name_country
FROM customers


--Q) Transform all the characters of the first name into lower case
SELECT 
first_name,
LOWER( first_name) AS LowerCased
FROM customers

--Q) Transform all the characters of the first name into upper case
SELECT 
first_name,
UPPER( first_name) AS UpperCased
FROM customers

--Q) Find the customers whose first name contains leading or trailing spaces 
SELECT 
first_name,
LEN(first_name) AS lengthTotal
FROM customers
where first_name != TRIM(first_name)

--Q) Remove dashes from a phone number 
SELECT
'123-456-789-0' AS phone,
REPLACE('123-456-789-0' , '-' , ' ') AS clean_phone

--Q) Convert .txt to .csv
SELECT
'Report.txt' AS OldFileName,
REPLACE('Report.txt' , '.txt' , '.csv') AS NewFileName




--CALCULATION 
--LEN -: To calculate the length of the string i.e. count how many characters 
--Q) Calculate the length of each customers first_name 
SELECT 
first_name ,
LEN(first_name) AS lengthName
FROM customers


--STRING EXTRACTION
--a)LEFT-: Extract specific number of characters from the left (start)
--b)RIGHT -: Extract specific number of charcters from the right (end)
--c)SUBSTRING -: Extract a part of a string at a specified position (1 based indexing)

--Q) Retrive the first two and the last two characters of the first name 
SELECT 
first_name,
LEFT(first_name , 2) AS startName,
RIGHT(first_name,2) AS endName
FROM customers

--Q) Retrive the list of customers first name after removing first character 
SELECT
first_name,
SUBSTRING(first_name , 2 , LEN(first_name)) AS subStringName
FROM customers