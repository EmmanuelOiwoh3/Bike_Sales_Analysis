/*
Quality Checks
========================================================================
Scripts Purpose
        This script check the data quality of the datasets uploaded from
        the data source.
        This checks for unwanted spaces, checks for null or negative 
        Values, we also did data enrichment.
========================================================================
*/

Select 
first_name,
last_name,
Email,
Phone
From Bronze.Staffs
Where first_name != Trim(first_name) or
	  Email != Trim(Email) or 
      Phone != Trim (Phone)

Select 
List_Price
From Bronze.Products
Where List_Price < 0 or List_Price is null

Select 
Product_name
From Bronze.Products
Where Product_name != Trim(Product_name)

-- Convert Shipped_date to Date and handled the nulls by converting it to Required date
-- Doing Data Enrichment
Select  
Case When Order_status = 4 then 'Shipped'
	 When Order_status = 3 Then 'Processing'
	 Else 'Pending'
End Order_Status,
Required_date,
Case When ISDATE(Shipped_date) = 1 Then Cast(Shipped_date As date)
	 Else null
End Shipped_date
From Bronze.Orders

Select * From Bronze.Order_items 
Select first_name,last_name,Email,Street,City State From Bronze.Customers
Where first_name != Trim(first_name) or last_name != Trim(last_name) or
      Email != Trim(Email) or Street != Trim(Street) or City != Trim(City)
