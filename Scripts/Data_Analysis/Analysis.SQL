/*

===================================================================================
Scripts Purpose:
      A comprehensive script for data exploration, analytics and reporting. The 
      script covers exploration, measures, metrics, time-based trends, cumulative
      analytics and more.
==================================================================================
*/

Use Bike_Store;
Go

--Total Bike Sales: To get the total sales of all orders

Select 
Round(Sum(sales_Amount), 1) As Total_Sales 
from Gold.fact_order_item;


--Total Quantity Ordered: Script the get the total quantity of bikes ordered

Select 
Sum(Quantity) As Total_Quantity
from Gold.fact_order_item

--Total Sales by product category
Select 
p.Category_name,
Round(Sum(f.Sales_Amount), 1) As Salespercategory
From Gold.fact_order_item f
Left Join Gold.Production p
on f.Product_id = p.Product_id
Group by p.Category_name
Order by Salespercategory Desc

--Total Sales by Product category and brand
Select 
Category_name,
Brand,
Salespercategory,
Row_Number() Over (Partition by Category_name Order by salespercategory Desc) As Rank
From (
Select 
p.Category_name,
p.brand,
Round(Sum(f.Sales_Amount), 1) As Salespercategory
From Gold.fact_order_item f
Left Join Gold.Production p
on f.Product_id = p.Product_id
Group by p.Category_name, p.Brand
)t

-- Top 5 best selling product (By Quantity sold) in each year

--Select * from Gold.Production
-- Use NESTED CTE 
With ProductSales As (
Select 
p.Product_name,
Year(o.order_date) Orderdate,
Sum(f.Quantity) Total_Quantity
from Gold.fact_order_item f
Left join Gold.Production p
on f.Product_id = p.Product_id
Left join Gold.dim_Orders o
on f.Order_id = o.Order_id
Group by p.Product_name, Year(o.order_date)
), 
RankedProduct As (
Select 
Product_name,
Orderdate,
Total_Quantity,
Row_number() Over (Partition by Orderdate Order by Total_Quantity Desc) As Ranked
From Productsales
)
Select 
Product_name,
Orderdate,
Total_Quantity
From RankedProduct
Where Ranked <= 5
Order by Orderdate, Ranked 

--Total Revenue by Year
Select 
Year(o.Order_date) As Year,
Round(Sum(f.Sales_Amount), 1)  As Total_Revenue
From Gold.fact_order_item f
Left Join Gold.dim_Orders o
on f.Order_id = o.Order_id
Group by Year(o.Order_date)
Order by Total_Revenue Desc

/* Which product categories contribute the most revenue, and how has that changed over time */
Select 
p.Category_name,
Round(Sum(f.Sales_Amount), 1) Total_Revenue
From Gold.fact_order_item f
Left join Gold.Production p
on f.Product_id = p.Product_id
Left join Gold.dim_Orders o
on f.Order_id = o.Order_id
Group by p.Category_name
Order by Total_Revenue Desc

-- how has that changed over time
With ProductSales As (
Select 
p.Category_name,
Year(o.order_date) Orderdate,
Round(Sum(f.Sales_Amount), 1) Total_Revenue
From Gold.fact_order_item f
Left join Gold.Production p
on f.Product_id = p.Product_id
Left join Gold.dim_Orders o
on f.Order_id = o.Order_id
Group by p.Category_name, Year(o.order_date)
)
Select 
Category_name,
Orderdate,
Total_Revenue,
Lag(Total_Revenue) Over (Partition by Category_name Order by Orderdate) Prev_Revenue,
Round((Total_Revenue - Lag(Total_Revenue) Over (Partition by Category_name Order by Orderdate))/ 
Nullif(Lag(Total_Revenue) Over (Partition by Category_name Order by Orderdate),0) * 100, 1) As Revenue_Growth_percent
From ProductSales 
Order by Category_name, Orderdate

-- Top Customers (By Total Spending) and how many orders have they placed
Select 
o.Customer_Name,
Sum(f.Sales_Amount) Total_Spending,
Count(o.order_id) Number_of_Orders
from Gold.fact_order_item f
Left join Gold.dim_Orders o
on f.Order_id = o.Order_id
Group by o.Customer_Name
Order by Total_Spending Desc

/* Compare store performance: Revenue per store, average order value versus store*/
-- Revenue per store

Select 
o.Store_name,
o.Store_Phone,
o.Store_Email,
Count(Distinct o.order_id) As Total_Order,
Round(Sum(f.Sales_Amount),1) As Revenue,
Round(Sum(f.Sales_Amount)/Count(Distinct o.order_id), 1) As AverageOrderValue
From Gold.fact_order_item f
Left join Gold.dim_Orders o
on f.Order_id = o.Order_id
Group by o.Store_name,
		 o.Store_Phone,
		 o.Store_Email
Order by Revenue Desc
