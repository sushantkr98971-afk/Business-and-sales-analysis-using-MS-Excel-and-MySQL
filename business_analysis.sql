create database Pan_State;
use Pan_State;

create table details(
ID	int primary key,
Date date,
Month	varchar(50),
Customer_Age int,
Customer_Gender	varchar(50),
Country	varchar(50),
State varchar(50),
Product_Category varchar(50),
Sub_Category	varchar(50),
Quantity  int ,
Unit_Cost	int,
Unit_Price	int,
Total_Cost	int,
Total_Revenue	int,
Profit int,
profit_margin int
);


# Q1 Find margin per months in percentage
select month, sum(total_revenue) as total_revenue,sum(profit) as total_profit,
round(sum(profit)*100/sum(total_revenue),2) as margin_as_month
from details
group by month;

# Q2 Find highest margin as per sub category
select	sub_category,sum(profit) as profit, sum(total_revenue) as revenue,
round(sum(profit)*100/sum(total_revenue),2) as margin_as_sub_category
from details
group by sub_category
order by profit desc;

# Q3 Find Performance by months
select month, sub_category,sum(profit)
from details
group by  month,sub_category
order by sub_category;

# Q4 (i) compare revenue and profit by country, profit margin by country
select country,
sum(total_revenue) as revenue, 
sum(profit) as profit, 
round(sum(profit)*100/sum(total_revenue),2) as profit_margin_by_country
from details
group by country
order by profit_margin;

# (ii)margin by state
select state,
sum(total_revenue) as revenue, 
sum(profit) as profit, 
round(sum(profit)*100/sum(total_revenue),2) as profit_margin_by_state
from details
group by state
order by profit_margin desc;


# Q5 (i)analyze revenue and profit by age group and market share by each age group
select 
  case 
    when customer_age between 17 and 25
 then "18-25"
    when customer_age between 26 and 35
 then "26-35"
    when customer_age between 36 and 45
 then "36-45"
    else "45+"
    end as age_group,
    sum(total_revenue) as total_revenue,
	sum(profit) as total_profit,
    round(sum(total_revenue)*100/(select sum(total_revenue) from details),2) as market_share_by_age_group
 from details
 group by age_group
 order by age_group;

# (ii) compare performance by gender
select customer_gender,
sum(quantity) as quantity,
sum(total_revenue) as total_revenue,
sum(profit) as total_profit,
round(sum(profit)*100/sum(total_revenue),2) as profit_margin_by_gender
from details
group by customer_gender
order by customer_gender;

#(iii) identify high margin customer segments 
select
    case 
      when customer_age  between 17 and 25
  then "17-25"
    when customer_age  between 26 and 35
  then "26-35"
    when customer_age  between 36 and 45
  then "36-45"
    else "45+"
  end as age_group,
  product_category,
  sum(total_revenue) as revenue,
  sum(profit) as profit
  from details
  group by age_group,product_category
  order by age_group;

# Q6 (i)compare unit cost and unit price,evaluate markup price
select product_category,
sum(unit_cost), 
sum(unit_price),
sum(unit_price)-sum(unit_cost) as markup_price
from details
group by product_category
order by markup_price;

#(ii) category with low profit margins
select product_category, sub_category,
round(sum(profit)*100/sum(total_revenue),2) as profit_margin_by_category
from details
group by product_category,sub_category
order by product_category asc ;

#(iii) overpriced category with low quantity sold
select product_category,
 sub_category,
quantity,
sum(unit_price)-sum(unit_cost) as markup_price
from details
group by product_category, sub_category,quantity
order by markup_price;

# Q7 (i) analyse monthly revenue trend, identify low and peak month demand month
select 
month,
sum(total_revenue),
round(sum(total_revenue)*100/(select sum(total_revenue) from details),2) as revenue_in_percentage
from details
group by month
order by revenue_in_percentage desc;

#(ii) check for category and month wise revenue and quantity
SELECT 
    MONTH,
    sub_category,
    SUM(total_revenue) AS monthly_revenue,
    SUM(quantity) AS monthly_quantity
FROM details
GROUP BY MONTH, sub_category
ORDER BY sub_category, month;

# Q8 (i) identify loss making transactions
select *
from details
where profit<0;

#(ii) detect negetive margin sub_categories
select id,product_category,
round(sum(profit)*100/sum(total_revenue),2) as profit_margin
from details
group by id,product_category
having round(sum(profit)*100/sum(total_revenue),2)<0
;

#(iii) find states with weak profitability
select state, sum(profit)
from details
group by state
order by sum(profit);

#(iv) spot abnormal high cost transactions
select * from details
where unit_cost>(select avg(unit_cost)*2 from details);