-- Inventory & Supply Planning
--1.  Which products are sold in high quantities and might need more stock? Top 3
select
	product_name,
	sum(quantity) as total_sold
from
	sales_shoes
group by
	product_name
order by
	total_sold desc
limit 3;
-- file:///C:/Users/user/AppData/Local/Temp/.dbeaver-temp16795458277235134277/data-files/20251022-203530.html

--2. Are there products with low sales that could be discounted or removed from inventory? (based on revenue)
select
	product_name,
	sum (amount) as total_revenue
from
	sales_shoes
group by
	product_name
order by
	total_revenue
limit 3;
-- file:///C:/Users/user/AppData/Local/Temp/.dbeaver-temp16795458277235134277/data-files/20251022-203942.html

--3. How does seasonality affect product sales (e.g., monthly or quarterly trends)?
with monthly_trend as (
	select 
		extract (month from date) as month,
		extract (year from date) as year,
		extract (quarter from date) as quarter,
		sum(amount) as monthly_revenue
	from 
		sales_shoes
	group by 
		month,
		year,
		quarter
	order by 
		month,
		year,
		quarter
	)
select
	*,
	sum (monthly_revenue) over (partition by quarter order by quarter) as quarterly_revenue
from 
	monthly_trend
group by 
	month,
	year,
	quarter,
	monthly_revenue;
-- file:///C:/Users/user/AppData/Local/Temp/.dbeaver-temp16795458277235134277/data-files/20251022-210201.html

--4. Which combinations of product type, brand, and country show consistent high demand?
select
	product_type,
	brand,
	country,
	sum (amount) as total_revenue
from 
	sales_shoes
group by 
	product_type,
	brand,
	country 
order by 
	total_revenue desc;
-- file:///C:/Users/user/AppData/Local/Temp/.dbeaver-temp16795458277235134277/data-files/20251022-210820.html
	
	


