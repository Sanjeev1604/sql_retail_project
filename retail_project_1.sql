create database sales_project;
use sales_project;
drop table if exists retail_sales;
create table retail_sales
	(
      transactions_id int primary key,	
      sale_date date,	
      sale_time time,	
      customer_id int,
      gender varchar(15),
      age int,
      category varchar(25),	
      quantiy int,
      price_per_unit float,	
      cogs float,
      total_sale float
	);
select * from retail_sales; 
-- data export from csv file
-- data cleaning 
select 
  count(*) 
	from retail_sales;
-- find null value in transaction id and other columns
select * from retail_sales
where transactions_id is null;    
 
select * from retail_sales
where transactions_id is null
 OR  sale_date is null
 or sale_time is null
 or customer_id is null
 or gender is null
 or age is null
 or category is null
 or quantiy is null
 or price_per_unit is null
 or cogs is null
 or total_sale is null;
 
-- delete row if null exist
delete from retail_sales
where transactions_id is null
 OR  sale_date is null
 or sale_time is null
 or customer_id is null
 or gender is null
 or age is null
 or category is null
 or quantiy is null
 or price_per_unit is null
 or cogs is null
 or total_sale is null;

-- Data Exploration

-- How many sales we have 
 select count(*) as total_sale from retail_sales;
 
 -- how many unique customer we have
 select count(distinct customer_id) as total_customer from retail_sales;

-- business key problem

-- **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
select * from retail_sales
where 
 sale_date='2022-11-05';    
 --  **Write a SQL query to retrieve all transactions where the category is 'Clothing' 
 -- and the quantity sold is more than 4 in the month of Nov-2022**:
select * from retail_sales
where category ='Clothing'
and quantiy >='4'
and sale_date >='2022-11-01'
and sale_date<='2022-11-30' ;

-- Write a SQL query to calculate the total sales (total_sale) for each category.**:

SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS orders
FROM retail_sales
GROUP BY category;

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;


-- 4. **Write a SQL query to find the average age of customers 
-- who purchased items from the 'Beauty' category.**:
select round(avg(age),2) as avg_age from retail_sales
where category='Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
select transactions_id from retail_Sales
where total_sale > 1000;

-- 6. **Write a SQL query to find the total number of 
-- transactions (transaction_id) made by each gender in each category.*
select gender,category,count(transactions_id) as transaction from retail_sales
group by gender,category
order by gender;

-- Write a SQL query to calculate the average sale for each month.
-- Find out best selling month in each year

select * 
from 
(
	select extract(year from sale_date) as year,
	   extract(month from sale_date) as month,
       row_number() over(partition by EXTRACT(YEAR FROM sale_date) 
       order by avg(total_sale) desc) as rankwise,
       round(avg(total_sale),2) avg_sale
       from retail_sales
       group by year, month
)t  where rankwise = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales **:

select customer_id,sum(total_sale) as total_sale from retail_sales
group by 1 order by total_sale desc
limit 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct customer_id) as uniq_id from retail_sales
group by category;

-- *Write a SQL query to create each shift and number of orders
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

select 
shift,count(transactions_id) as total_order from (select *,
	case 
    when extract(hour from sale_time)  <12  then 'morning'
    when extract(hour from sale_time) between 12 and 17 then 'afternoon'
    else 'evening'
    end as shift
from retail_sales) as sh
group by shift;

-- alternate cet
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
