/*
====================================================================
DDL Script: Create Bronze Tables
====================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping
    existing tables
====================================================================


-- Create Tables in the Bronze schema of the Database
-- Create table Bronze.Brand

If Object_id('Bronze.Brand', 'U') IS NOT NULL
	Drop Table Bronze.Brand;
GO

Create Table Bronze.Brand (
Brand_id       INT Primary Key,
Brand          Varchar(50)
);
Go

-- Create table Bronze.Categories
If Object_id('Bronze.Categories', 'U') IS NOT NULL
	Drop Table Bronze.Categories;
GO

Create Table Bronze.Categories (
Category_id    INT Primary Key,
Category_name  Varchar(20)
);
Go

-- Create table Bronze.Customers
If Object_id('Bronze.Customers', 'U') IS NOT NULL
	Drop Table Bronze.Customers;
GO

Create Table Bronze.Customers (
Customer_id        INT Primary Key,
first_name         Varchar(20),
last_name          Varchar(20),
Phone              Nvarchar(50),
Email              Nvarchar(100),
Street             Nvarchar(100),
City               Nvarchar(50),
State              Nvarchar(10),
Zip_code           INT
);
Go

-- Create table Bronze.Stores
If Object_id('Bronze.Stores', 'U') IS NOT NULL
	Drop Table Bronze.Stores;
GO

Create Table Bronze.Stores (
Store_id           INT Primary Key,
Store_name         Varchar(20),
Phone              Nvarchar(50),
Email              Nvarchar(100),
Street             Nvarchar(100),
City               Nvarchar(50),
State              Nvarchar(10),
Zip_Code           INT
);
Go

-- Create table Bronze.Staffs
If Object_id('Bronze.Staffs', 'U') IS NOT NULL
	Drop Table Bronze.Staffs;
GO

Create Table Bronze.Staffs (
Staff_id           INT Primary Key,
first_name         Varchar(20),
last_name          Varchar(20),
Email              Nvarchar(100),
Phone              Nvarchar(50),
Active             INT,
Store_id           INT Foreign Key (Store_id) References Bronze.Stores (Store_id),
Manager_id         INT
);
Go

--Create table Bronze.Orders
If Object_id('Bronze.Orders', 'U') IS NOT NULL
	Drop Table Bronze.Orders;
GO

Create Table Bronze.Orders (
Order_id           INT Primary Key,
Customer_Id        INT Foreign Key (Customer_Id) References Bronze.Customers (Customer_Id),
Order_status       INT,
Order_date         Date,
Required_date      Date,
Shipped_date       Date NULL,
Store_id           INT Foreign Key (Store_id) References Bronze.Stores (Store_id),
Staff_id           INT Foreign Key (Staff_id) References Bronze.Staffs (Staff_id)
);
Go

--Change the datatype for shipping date to NVARCHAR
Alter Table Bronze.Orders
Alter Column Shipped_date    Nvarchar(50);
GO

--Create table Bronze.Products
If Object_id('Bronze.Products', 'U') IS NOT NULL
	Drop Table Bronze.Products;
GO

Create Table Bronze.Products (
Product_id         INT Primary Key,
Product_name       Nvarchar(100),
Brand_id           INT Foreign Key (Brand_id) References Bronze.Brand (Brand_id),
Category_id        INT Foreign Key (Category_id) References Bronze.Categories (Category_id),
Model_year         Date,
List_Price         FLOAT
);
Go

--Create table Bronze.Order_items
If Object_id('Bronze.Order_items', 'U') IS NOT NULL
	Drop Table Bronze.Order_items;
GO

Create Table Bronze.Order_items (
Order_id           INT Foreign Key (Order_id) References Bronze.Orders (Order_id),
Item_id            INT,
Product_id         INT Foreign Key (Product_id) References Bronze.Products (Product_id),
Quantity           INT,
List_Price         Float,
Discount           Float
);
Go

--Create table Bronze.Stocks
If Object_id('Bronze.Stocks', 'U') IS NOT NULL
	Drop Table Bronze.Stocks;
GO

Create Table Bronze.Stocks (
Store_id           INT Foreign Key (Store_id) References Bronze.Stores (Store_id),
Product_id         INT Foreign Key (Product_id) References Bronze.Products (Product_id),
Quatity            INT
);
Go

-- Bulk Insert

Bulk insert Bronze.Brand
From 'C:\Users\USER141\Downloads\brands.csv'
With (
	  FirstRow = 2,
	  Fieldterminator = ',',
	  Tablock
	  );
Go

Bulk Insert Bronze.Categories
From 'C:\Users\USER141\Downloads\categories.csv'
With (
	  FirstRow = 2,
	  Fieldterminator = ',',
	  Tablock
	  );
Go

Bulk Insert Bronze.Customers
From 'C:\Users\USER141\Downloads\customers.csv'
With (
	  FirstRow = 2,
	  Fieldterminator = ',',
	  Tablock
	  );
Go

Bulk Insert Bronze.Stores
From 'C:\Users\USER141\Downloads\stores (1).csv'
With (
	  FirstRow = 2,
	  FieldTerminator = ',',
	  Tablock
	  );
Go

Bulk Insert Bronze.Staffs
From 'C:\Users\USER141\Downloads\staffs.csv'
With (
	  FirstRow = 2,
	  FieldTerminator = ',',
	  Tablock
	  );
    
Go
Bulk Insert Bronze.Orders
From 'C:\Users\USER141\Downloads\orders.csv'
With (
	  FirstRow = 2,
	  FieldTerminator = ',',
	  KEEPNULLS,
	  Tablock
	  );
Go

Bulk Insert Bronze.Products
From 'C:\Users\USER141\Downloads\products (1).csv'
With (
	  FirstRow = 2,
	  FieldTerminator = ',',
	  Tablock
	  );
Go

Bulk Insert Bronze.Order_items
From 'C:\Users\USER141\Downloads\order_items.csv'
With ( 
	  FirstRow = 2,
	  FieldTerminator = ',',
	  Tablock
	  );
Select * from Bronze.Order_items
Go

Bulk Insert Bronze.Stocks
From 'C:\Users\USER141\Downloads\stocks.csv'
With (
	  FirstRow = 2,
	  FieldTerminator = ',',
	  Tablock
	  );
Go

Select * From Bronze.Brand;
Select * From Bronze.Categories;
Select * From Bronze.Customers;
Select * From Bronze.Order_items;
Select * From Bronze.Orders;
Select * From Bronze.Products;
Select * From Bronze.Staffs;
Select * From Bronze.Stocks;
Select * From Bronze.Stores
