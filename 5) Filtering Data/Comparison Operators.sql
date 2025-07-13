/*
Expression - operator - Expression (condition)
{
Col1 = Col2
Col1 = Value
Function = Value 
Expression = Value 
SubQuery = value (advance topic will be covered afterwards)
}
= -> Equal to  ( Checks if the two values are equal ) 
<> , =! -> Not Equal ( Checks if two values are not equal ) 
>  -> Greater than ( checks whether the 1st value is greather than the other ) 
>=  -> Greater than Equal To ( checks whether the 1st value is greather equal to than the other )
<   -> Less than ( checks whether the 1st value is Less than the other )
<=   -> Less than Equal To ( checks whether the 1st value is Less equal to than the other )
*/


-- First specify the data base to be used 
USE MyDatabase

-- Check the data of customers 
SELECT * FROM customers

-- Equal To (=)
--Q) Retrive all the customers form Germany
SELECT *
FROM customers
WHERE country = 'Germany'

-- Not Equal
--Q) Retrive all the customers who are not from germany 
SELECT *
FROM customers
WHERE country <> 'Germany'

SELECT *
FROM customers
WHERE country != 'Germany'

-- Greater than and greater than equal to 
--Q) Retrive all the customers having score greater than 500
SELECT * 
FROM customers
WHERE score > 500

--Q) Retrive all the customers having score greater than equal to 500
SELECT * 
FROM customers
WHERE score >= 500

-- Less than and Less than equal to 
--Q) Retrive all the customers having score less than 500
SELECT * 
FROM customers
WHERE score < 500

--Q) Retrive all the customers having score less than equal to 500
SELECT * 
FROM customers
WHERE score <= 500