-- Marketing & Promotions
--1. Which regions show the highest revenue growth potential for marketing campaigns?
select 
	country,
	sum (amount) as total_revenue
from
	sales_shoes
group by
	country
order by 
	total_revenue desc;



--2. Are Limited Edition or Streetwear products more sensitive to promotion or sales spikes?
with weekly_trend as (
	select
		extract (week from date) as week,
		category,
		sum(amount) as total_revenue,
		row_number() over (partition by extract (week from date) order by sum(amount) desc) as rank_category_weekly	
	from
		sales_shoes
	group by 
		week,
		category
	order by 
		week
		),
prev_week as (
	select
		*,
		lag (rank_category_weekly,1,0) over (partition by category order by week) as prev_weekly_rank
	from 
		weekly_trend
	where
		category in ('Limited Edition', 'Sportswear')
	order by 
		category,week
	)
select
	*,
	rank_category_weekly - prev_weekly_rank as diff_rank,
	case
		when abs (rank_category_weekly - prev_weekly_rank) in (2,3) then 'sensitive'
		else 'not sensitive'
	end as sensitivity
from 
	prev_week;


--3. How do payment modes correlate with high-value purchases?
-- Assumption high purchase value is more than 1000 euro
select
	payment_mode,
	count (payment_mode) as transaction_high_value
from
	sales_shoes
where 
	amount >= 1000
group by
	payment_mode
order by
	transaction_high_value desc;


--4. Which products could benefit from targeted campaigns based on gender, country, or category?
-- Assumption top 5 products with highest sold qty
with gender as (
	select
		gender,
		product_name,
		sum (quantity) as total_sold,
		row_number () over (partition by gender order by sum (quantity) desc) as rank_sold_qty
	from 
		sales_shoes
	group by 
		gender, product_name
	)
select 
	*
from
	gender
where 
	rank_sold_qty <=5;


	
with country as (
	select
		country,
		product_name,
		sum (quantity) as total_sold,
		row_number () over (partition by country order by sum (quantity) desc) as rank_sold_qty
	from 
		sales_shoes
	group by 
		country, product_name
	)
select 
	*
from
	country
where 
	rank_sold_qty <=5;


with category as (
	select
		category,
		product_name,
		sum (quantity) as total_sold,
		row_number () over (partition by category order by sum (quantity) desc) as rank_sold_qty
	from 
		sales_shoes
	group by 
		category, product_name
	)
select 
	*
from
	category
where 
	rank_sold_qty <=5;


--5. Are there trends indicating emerging popular products that Nike could push in campaigns?
with nike_products as(
	select
		extract (month from date) as month_sales,
		product_name,
		brand,
		sum (quantity) as cur_sold
	from
		sales_shoes
	where 
		brand = 'Nike'
	group by 
		month_sales,
		product_name,
		brand
	order by 
		product_name, month_sales
	),
prev_sold as (
	select
		*,
		lag (cur_sold,1,0) over (partition by product_name order by month_sales) as prev_sold
	from 
		nike_products
	)
select 
	*,
	round((cur_sold - prev_sold)/nullif(prev_sold,0) * 100,2) as percent_growth
from
	prev_sold;