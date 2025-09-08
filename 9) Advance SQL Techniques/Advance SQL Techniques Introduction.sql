/*
Data Wearhouse -> A special database that collects and integrates data from different sources to enable analytics and support decision making .

DataBase Engine -> It is the brain of the databse executing multiple operations such as storing ,retriving ,and managing data within the database.

Disk Storage -> Long term memory ,where data is stored permanently. ( +Capacity -: Can hold a large amount of data , -Speed -: Slow to read and to write .

               a) User Data Storage -: The main content of the data base . This is where the actual data that the users care about is stored 
               b) System Catalog -: Database internal storage for its own information . A blueprint that keeps the track of everything about the database itself , not the user data .
                                    It holds the metadata information about the database.
                                    Metadata is data about data
                                    Information Schema -: A system defined schema with build-in views that provide info about the database , like tables and colums 
               c) Temp Data Storage -: Temporary space used by the database for short-term tasks , like processing queries and sorting data.
                                       Once these tasks are done then the storage is cleared.


Cache Storage -> Fast short term memory where data is stored temporarily.
*/


SELECT 
* 
FROM INFORMATION_SCHEMA.COLUMNS


SELECT 
DISTINCT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS