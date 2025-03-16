-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

select * from retail_sales
select * from retail_sales
LIMIT 10

-- ROW SAYİSİ
select count(*) from retail_sales

----  transactions_id değeri NULL olan satırları getirir.
select * from retail_sales
where transactions_id is null
-- sale_date null değer arama
select * from retail_sales
where sale_date is null

select * from retail_sales
where sale_time is null

--genel null araması
select * from retail_sales
where
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

--
delete from retail_sales
where
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

--data  exploration
-- satış sayısı kontrolü
select count(*) as total_sale  from retail_sales
--uniuque müşteri sayısı
select count(distinct customer_id) as total_sale from retail_sales
--how many category do we have
select distinct category from retail_sales
-- sales made on 2022-11-05
select * from retail_sales where sale_date='2022-11-05'
--the category=clothing,quantity sold is more than 4 in month of nov 2022
select* from retail_sales where category= 'Clothing' and quantiy>=4 and TO_CHAR(sale_date,'YYYY-MM')='2022-11'


--calculate the total sales (total_sale) for each category.
select
category,
sum(total_sale) as net_sale,
count(*) as total_orders 
from retail_sales 
group by 1

-- find the average age of customers who purchased items from the 'Beauty' category.
select 
round(avg(age),2) as avg_age
from retail_sales
where category='Beauty'

--find all transactions where the total_sale is greater than 1000.
select *
from retail_sales
where total_sale>=1000 

 --find the total number of transactions (transaction_id) made by each gender in each category.
 select category,
 gender,
 count(*) as total_trans
 from retail_sales
 group 
 by 
 category,
 gender
 order by 1


 --calculate the average sale for each month. Find out best selling month in each year
 select year,
 month,
 avg_sale
 from(
select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sale,
rank() over (partition by extract(year from sale_date)order by avg(total_sale)desc)as rank
from retail_sales
group by 1,2
) as t1
where rank=1

--find the top 5 customers based on the highest total sales 
select customer_id ,
sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5


--find the number of unique customers who purchased items from each category.

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category



--create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift




 

