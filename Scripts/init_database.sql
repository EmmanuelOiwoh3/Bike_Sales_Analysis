/*
===============================================
Create Database and Schemas
===============================================
Script Purpose:
This script creates the new database alongside its Schemas within the database: 'Bronze', 'Silver', and 'Gold'

Warning: 
    Running this script will drop the entire 'Bike_store Database' if it exists.
    All data in the database would be permanently deleted. Thus proceed with caution.

*/

USE master;
GO

--Drop and recreate the 'Bike_store' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Bike_Store')
BEGIN
    ALTER DATABASE bike_store SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE bike_store;
END;
GO

-- Create the Database  Bike_store
Create Database Bike_Store;
GO
  
Use Bike_Store;
GO
  
-- Create Schema Bronze, Silver, and Gold
Create Schema Bronze;
Go
  
Create Schema Silver;
Go
  
Create Schema Gold;
Go
