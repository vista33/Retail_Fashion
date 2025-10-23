-- Sales
--1. Which products generated the highest total revenue in 2022?
select 
	product_name, 
	brand,
	SUM(amount) as revenue 
from 
	sales_shoes 
group by
	product_name, brand 
order by 
	revenue desc 
limit 10;
-- file:///C:/Users/user/AppData/Local/Temp/.dbeaver-temp16795458277235134277/data-files/20251022-181107.html

--2. What is the total sales amount by brand?
select
	brand,
	SUM(amount) as revenue
from 
	sales_shoes
group by
	brand 
order by 
	revenue desc;
-- file:///C:/Users/user/AppData/Local/Temp/.dbeaver-temp16795458277235134277/data-files/20251022-181606.html

--3. Which product types (Sneakers, T_Shirt, Hoodies) are performing the best in each country?
with revenue_product_type as(
	select 
		country,
		product_type,
		sum (amount) as revenue
	from sales_shoes
	group by
		product_type,
		country
	),
rank_revenue as (
	select 
		*,
		row_number() over(partition by country order by revenue desc) as sales_rank 
	from 
		revenue_product_type
	)
select * from rank_revenue where sales_rank = 1;
-- file:///C:/Users/user/AppData/Local/Temp/.dbeaver-temp16795458277235134277/data-files/20251022-190857.html

--4. What is the average unit price per product type, and how does it vary by brand?
select
	product_type,
	brand,
	avg (unit_price):: numeric(16,2) as avg_price
from 
	sales_shoes
group by 
	product_type, brand
order by 
	product_type, avg_price desc;
-- file:///C:/Users/user/AppData/Local/Temp/.dbeaver-temp16795458277235134277/data-files/20251022-192000.html

--5. Which sales transactions contributed the most to total revenue per country?
with revenue_payment as (
	select
		country,
		payment_mode,
		sum (amount) as revenue,
		row_number () over (partition by country order by sum(amount) desc) as rank_transaction
	from
		sales_shoes
	group by 
		country,payment_mode
	)
select * from revenue_payment where rank_transaction = 1;
-- file:///C:/Users/user/AppData/Local/Temp/.dbeaver-temp16795458277235134277/data-files/20251022-193550.html

	

