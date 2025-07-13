/* 
Data Defination Language ( DDL ) -> Define the structure of your data.
1) CREATE -> Create a new empty table 
2) ALTER -> To alter / change the defination of the table like adding a new column or deleting a column or changing tha datatype of the column (Edit the existing table)
3) DROP -> It means delete ( you can either delete a column using alter and drop statement or drop the whole table 
*/

-- First define the data base you want to do operations 
USE MyDatabase

-- Q) Create a  new table called persons with columns : id , person_name , birth_date , phone 
CREATE TABLE persons (
id INT NOT NULL,
person_name VARCHAR(50) NOT NULL,
birth_date DATE,
phone VARCHAR(15) NOT NULL,
CONSTRAINT pk_persons PRIMARY KEY (id)
)

SELECT * 
FROM persons


-- Q) Add a new column called email to the table persons 
ALTER TABLE persons
ADD email VARCHAR(20) NOT NULL

--Q) Remove the column phone from the persons table 
ALTER TABLE persons 
DROP COLUMN phone 


--Q) Delete the table persons from the data base 
DROP TABLE persons