/*
Data Manuplation Language (DML) -> Used to manuplate or modify the data 
1) INSERT -> To add data/new rows to the table 
2) UPDATE -> Used to change the content of already existing rows ( dont forget to add where condition )
3) DELETE -> Delete specific row ( dont forget to add where condition ) 
*/

-- First Specify the data base to be used
USE MyDatabase
SELECT * FROM customers


-- INSERT
-- Q) Insert new data to customers 
INSERT INTO customers(id,first_name,country,score)
VALUES 
(6,'Anna','USA',NULL),
(7,'Sam',NULL,100)

--Q) Insert data from customers into persons
INSERT INTO persons(id,person_name,birth_date,phone)
SELECT 
id,
first_name,
NULL,
'Unknown'
FROM customers

SELECT * FROM persons


-- UPDATE
--Q) Change the score of the customer 6 to 0
UPDATE customers
SET score = 0
WHERE id = 6

--Q) change the score to 0 where it is NULL
UPDATE customers
SET score = 0
WHERE score IS NULL


--DELETE
--Q) Delete all the id's greater than 5 
DELETE FROM customers
WHERE id>5

--Q) DELETE all data from persons
DELETE FROM persons
TRUNCATE TABLE persons 