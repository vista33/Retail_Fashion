-- Customer & Market Insights
--1. Which countries are the largest markets in terms of sales quantity and revenue?
select
	country,
	sum (amount) as revenue,
	sum (quantity) as total_sold
from 
	sales_shoes
group by
	country
order by 
	revenue desc,
	total_sold desc;


--2. How does gender affect product preference (Men, Women, Unisex)?
select 
	gender,
	product_type,
	sum(quantity) as total_sold
from 
	sales_shoes
group by
	gender, product_type 
order by
	gender, total_sold desc;


--3. Which categories (Limited Edition, Casual, Streetwear, Sportswear) are most popular in each region?
with rank_category as (
	select
		country,
		category,
		sum (quantity) as total_sold,
		row_number() over (partition by country order by sum (quantity) desc) as rank_category_country
	from 
		sales_shoes
	group by
		country, category
	)
select
	country,
	category,
	total_sold
from 
	rank_category
where 
	rank_category_country = 1
order by
	total_sold desc;


--4. Are certain brands more popular among men or women?
with men_preference as(
	select
		brand,
		gender,
		sum(quantity) as total_sold,
		row_number () over (partition by gender order by sum(quantity) desc) as rank_brand
	from 
		sales_shoes
	where 
		gender = 'Men'
	group by
		gender, brand
	),
women_preference as (
	select
		brand,
		gender,
		sum(quantity) as total_sold,
		row_number () over (partition by gender order by sum(quantity) desc) as rank_brand
	from 
		sales_shoes
	where 
		gender = 'Women'
	group by
		gender, brand 
	)
select 
	 m.total_sold, m.rank_brand as men_rank,m.brand,
	 w.rank_brand as women_rank, w.total_sold 
from
	men_preference m
left join
	women_preference w
using (brand);


--5. Which payment modes are most frequently used by customers?
select
	payment_mode,
	count (payment_mode) as total_transaction
from 
	sales_shoes
group by
	payment_mode
order by 
	total_transaction desc
limit 1;



