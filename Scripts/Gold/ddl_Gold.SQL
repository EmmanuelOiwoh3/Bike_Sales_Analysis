/*
==============================================================================
DDL Script: Create Gold View
==============================================================================
Script Purpose
        This Script creates views for Gold layer in the data warehouse.
        The Gold layer shows the dimension tables and fact table (Star Schema)

        Each view performs transformations and combines data from the bronze
        layer, to produce a clean, enriched and ready to use dataset

Usage: Views can be querried for analytics and reporting
==============================================================================
*/




Use Bike_Store;
GO
==============================================================================
-- Create Gold Views;
==============================================================================

--Create Dimension Gold.Production

if Object_ID("Gold.Production", "V") Is not null
    DROP VIEW Gold.Production;
GO
  
Create View Gold.Production As (
Select 
p.Product_id As Product_id,
p.Product_name As Product_name,
b.Brand As Brand,
c.Category_name As Category_name,
p.Model_year As Model_year,
p.List_Price As List_Price,
Sum(s.Quatity) As Stock_Quantity
from bronze.Products   p
Left Join Bronze.Categories  c
on p.Category_id = c.Category_id
Left join Bronze.Brand b
on p.Brand_id = b.Brand_id
left join Bronze.Stocks s
on p.Product_id = s.Product_id
Group by p.Product_id,
	     Product_name,
         Brand,
		 Category_name,
		 Model_year,
		 List_Price
);
GO

-- Check the view Gold.Production
Select *
From Gold.Production

-- Create Dimension Gold.dim_Orders

if Object_ID("Gold.dim_Orders", "V") Is not null
    DROP VIEW Gold.dim_Orders;
GO
  
Create View Gold.dim_Orders As (
Select 
Row_number() Over (Order by o.Order_id) As Order_Number,
o.Order_id,
(c.first_name + ' ' + C.last_name) As Customer_Name,
c.Phone,
c.Email,
(c.City + ',' + c.State) Customer_Address,
Case when o.Order_status = 4 then 'shipped'
	 Else 'Pending'
End Order_status,
o.Order_date,
o.Required_date,
o.Shipped_date,
(st.first_name + ' ' + st.last_name) As Staff_Name,
st.Phone As Staff_Phone,
st.Email As Staff_Email,
st.Active,
sr.Store_name,
sr.Phone As Store_Phone,
sr.Email As Store_Email,
(sr.City + ',' + ' ' + sr.State) As Store_city_state
from Bronze.Orders o
Left join Bronze.Customers c
on o.Customer_Id = c.Customer_id
Left join Bronze.Staffs st
on st.Staff_id = o.Staff_id
Left join Bronze.Stores sr
on sr.Store_id = o.Store_id
);
GO

--Create fact table Gold.fact_order_item

if Object_ID("Gold.fact_order_item", "V") Is not null
    DROP VIEW Gold.fact_order_item;
GO
  
Create View Gold.fact_order_item As (
Select 
Order_id,
Item_id,
Product_id,
Quantity,
List_Price,
(List_Price * Quantity) As Sales_Amount,
Discount
from Bronze.Order_items
);
GO
