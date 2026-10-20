-- Question 1: Overall Business Performance

select round(sum(Revenue_USD),2) as total_revenue ,
 round(sum(Cost_USD),2) as total_cost , 
 round(sum(Profit_USD),2) as total_profit ,
 round(sum(Profit_USD) / sum(Revenue_USD) * 100 , 2 ) as total_profit_margin , 
 count(distinct Order_Number) as total_orders ,  
 sum(Quantity) as total_quantity_sold ,
 round(sum(Revenue_USD) / count(distinct Order_Number) ,2 ) as avg_order_value  
from  sales;



# Question 2 — Monthly Revenue Trend
select date_format(Order_Date , '%Y-%m')  as month , round(sum(Revenue_USD),2) as total_revenue from sales
group by date_format(Order_Date , '%Y-%m')
order by date_format(Order_Date , '%Y-%m') ;

# Question 3 - Top 5 Countries by Revenue

select Country , round(sum(Revenue_USD),2) as total_revenue  , round(sum(Profit_USD),2) as total_profit from sales
group by Country
order by total_revenue desc
limit 5 ;

# Question 4 — Best-Selling Product Categories 

select p.category , round(sum(s.Revenue_USD),2) as total_revenue  , round(sum(Profit_USD),2) as total_profit , sum(quantity) as total_unit_sold  from sales as s
left join products as p
on p.Product_Key = s.ProductKey
group by p.category 
order by total_revenue desc ;

-- Question 5 — Most Profitable Products
#top 10 individual products contributing the most profit.
select p.Product_Name , p.Brand , round(sum(s.Revenue_USD),2) as total_revenue  , round(sum(Profit_USD),2) as total_profit , sum(quantity) as total_unit_sold  from sales as s
left join products as p
on p.Product_Key = s.ProductKey
group by p.Product_Name , p.Brand
order by total_profit desc 
limit 10 ;

-- Question 6 — Customer Analysis
-- the top 10 customers who generate the highest revenue.

select c.Name , c.Country , count(distinct s.Order_Number) as total_orders , round(sum(s.Revenue_USD),2) as total_revenue , round(sum(s.Profit_USD),2) as total_profit
from sales as s
left join customers as c
on s.CustomerKey = c.CustomerKey
group by c.Name , c.Country
order by total_revenue desc 
limit 10 ;

-- Question 7 — Monthly Profit Trend
-- how profitability changes over time to identify strong and weak months.

select date_format(Order_Date , '%Y-%m') as month , round(sum(Revenue_USD),2) as total_revenue , round(sum(Profit_USD),2) as total_profit ,
round(sum(Profit_USD) / sum(Revenue_USD) * 100 ,2) as Profit_margin_percentage from sales 
group by date_format(Order_Date , '%Y-%m')
order by month ;

-- Question 8 — Store Performance Analysis
-- Compare store performance and identify the strongest physical stores.
select st.StoreKey , s.country  ,round(sum(s.Revenue_USD),2) as total_Revenue , sum(s.quantity) as total_quantity_sold , round(sum(s.Profit_USD),2) as total_profit 
from sales as s
left join stores as st
on st.StoreKey = s.StoreKey
where s.country !='Online' 
group by st.StoreKey , s.country
order by total_Revenue desc
limit 10;

-- Question 9 — Store Profit Margin
-- identify stores that generate the highest profit margin, not merely the highest revenue.
select st.StoreKey , s.country  ,round(sum(s.Revenue_USD),2) as total_Revenue , sum(s.quantity) as total_quantity_sold , 
round(sum(s.Profit_USD),2) as total_profit , round(sum(s.Profit_USD) / sum(s.Revenue_USD) * 100 ,2 ) as profit_margin_pct
from sales as s
left join stores as st
on st.StoreKey = s.StoreKey
where s.country !='Online' 
group by st.StoreKey , s.country
order by  profit_margin_pct desc
limit 10;


-- Question 10 — Customer Segmentation by Country
-- customer base and the revenue generated in each country.

select count(distinct c.CustomerKey)  as total_customers , c.Country , count(distinct s.Order_Number) as total_orders , round(sum(Revenue_USD),2) as total_revenue , 
round(sum(Profit_USD),2) as total_profit  from sales as s
left join customers as c
on c.CustomerKey = s.CustomerKey
group by  c.Country
order by total_revenue desc
limit 10 ;

-- Question 11 — Year-over-Year Revenue Growth
-- Compare annual revenue and understand whether the business is growing or declining year over year.
select date_format( Order_Date , '%Y') as year , round(sum(Revenue_USD),2) as total_revenue , round(sum(Profit_USD),2) as total_profit from sales 
group by date_format( Order_Date , '%Y') 
order by year;

-- Question 12 — Year-over-Year Revenue Growth %
-- how much revenue increased or decreased compared with the previous year.

with yoy_growth as (
select date_format(order_date , '%Y') as year , round(sum(Revenue_USD),2) as total_revenue  from sales 
group by date_format(order_date , '%Y')
) ,
previous_year_growth as (
select  year , total_revenue ,
lag(total_revenue) over( order by year ) as previous_year_revenue
from yoy_growth 
)
select year , total_revenue , previous_year_revenue ,
round((total_revenue - previous_year_revenue) / previous_year_revenue  * 100,2) as revenue_growth_pct 
from previous_year_growth
order by year ;

-- Question 13: Five-year revenue forecast
-- “Using historical annual revenue and an assumed annual growth rate of 8%, estimate revenue for the next five years.”
WITH RECURSIVE yearly_revenue AS (
    SELECT YEAR(Order_Date) AS year, SUM(Revenue_USD) AS total_revenue FROM sales
    GROUP BY YEAR(Order_Date)
) ,
latest_year AS ( 
SELECT year, total_revenue FROM yearly_revenue
    ORDER BY year DESC
    LIMIT 1
),
forecast AS (
    SELECT year + 1 AS year, total_revenue * 1.08 AS forecast_revenue, 1 AS forecast_year FROM latest_year
	UNION ALL
	SELECT year + 1, forecast_revenue * 1.08, forecast_year + 1
    FROM forecast
    WHERE forecast_year < 5
)
SELECT year, ROUND(forecast_revenue, 2) AS forecast_revenue FROM forecast
ORDER BY year;

-- 14 — Monthly Revenue and Profit Analysis
-- Identify which months generate the highest revenue and profit, helping with sales planning and seasonal business decisions.

select  date_format(Order_date , "%Y-%m") as month  , round(sum(Revenue_USD),2) as total_revenue , round(sum(Profit_USD),2) as total_profit ,
round(sum(Profit_USD) / sum(Revenue_USD) * 100 ,2) as profit_margin_pct
from sales 
group by date_format(Order_date , "%Y-%m")
order by total_revenue desc
limit 10 ;

-- Question 15 — Customer repeat-purchase analysis
-- Identify customers who placed more than one distinct order, and determine how much revenue those repeat customers generated.
select c.CustomerKey , c.Name , count(distinct Order_Number) as total_orders , round(sum(s.Revenue_USD),2) as total_revenue from sales as s
join customers as c
on c.CustomerKey = s.CustomerKey
group by c.CustomerKey , c.Name 
having total_orders > 1
order by total_revenue desc
limit 10 ;

-- Question 16 — Delivery Performance Analysis
-- How long does the retailer take to deliver orders, and which orders have the longest delivery times?
WITH order_delivery AS (
SELECT Order_Number, MAX(DATEDIFF(Delivery_Date, Order_Date)) AS Delivery_time FROM sales
WHERE Delivery_Date IS NOT NULL
GROUP BY Order_Number
),
delivery_table AS (
SELECT Delivery_time, COUNT(*) AS no_of_orders FROM order_delivery
GROUP BY Delivery_time
),
avg_orders_table AS (
SELECT ROUND(SUM(Delivery_time * no_of_orders) / NULLIF(SUM(no_of_orders), 0), 2) AS avg_delivery_time,
MAX(Delivery_time) AS longest_delivery, SUM(no_of_orders) AS total_delivered_orders FROM delivery_table
)
SELECT d.Delivery_time, d.no_of_orders, a.avg_delivery_time, a.longest_delivery, a.total_delivered_orders FROM delivery_table AS d
CROSS JOIN avg_orders_table AS a
ORDER BY d.Delivery_time;

# Find the orders with the longest delivery times
WITH order_delivery AS (
SELECT Order_Number, MAX(DATEDIFF(Delivery_Date, Order_Date)) AS Delivery_time FROM sales
WHERE Delivery_Date IS NOT NULL
GROUP BY Order_Number
)
SELECT Order_Number, Delivery_time FROM order_delivery
WHERE Delivery_time = ( SELECT MAX(Delivery_time) FROM order_delivery
)
ORDER BY Order_Number;

-- Question 17 — Delivery Time by Country
-- Management wants to compare delivery performance across countries to identify which markets experience slower deliveries.
-- Your task: Write a SQL query to find the average delivery time in days for each country.
-- What is the average delivery time for online orders, and how does delivery duration vary?
select  st.Country , round(avg(s.Delivery_Days),2) as avg_delivery_time from sales as s
join stores as st
on st.StoreKey = s.StoreKey
where Delivery_Days is not null
group by country
order by avg_delivery_time desc ;


-- Question 18 — Top 10 Products by Revenue
-- Identify the top 10 products generating the highest revenue to understand which products contribute most to business performance.

select p.Product_Name , round(sum(s.Revenue_USD),2) as total_revenue , sum(Quantity) as total_quantity_sold from sales as s
join products as p
on p.Product_Key = s.ProductKey
group by p.Product_Name
order by total_revenue desc
limit 10;


-- Question 19 — Most Profitable Products
-- Identify the top 10 products generating the highest total profit, rather than the highest revenue.
select p.Product_Name , round(sum(Profit_USD),2) as total_profit , sum(Quantity) as total_quantity_sold  from sales as s
join products as p
on p.Product_Key = s.ProductKey
group by p.Product_Name
order by total_profit desc
limit 10;


-- Question 20 — Product Category Profitability
-- Which product categories generate the highest profit, and which categories have the strongest profit margins?

select p.category , round(sum(s.Profit_USD),2) as total_profit , round(sum(Revenue_USD),2) as total_revenue ,
round((sum(Profit_USD) / sum(Revenue_USD) ) * 100 , 2) as profit_margin from sales as s
inner join products as p
on p.Product_Key = s.ProductKey
group by p.Category
order by total_profit desc 
limit 10;

-- Question 21 :Brand Performance Analysis
-- Which product brands generate the highest revenue and profit, and do the most profitable brands also have the strongest profit margins?
select p.Brand , round(sum(Revenue_USD),2) as total_revenue , round(sum(Profit_USD),2) as total_profit , 
round(sum(Profit_USD) / sum(Revenue_USD) * 100 ) as profit_margin_pct from sales as s
inner join products as p
on p.Product_Key = s.ProductKey
group by p.Brand
order by total_revenue desc;

-- Question 22 — Product Subcategory Analysis
-- Which product subcategories contribute the most revenue and profit within each product category?
select p.category , p.Subcategory_Key , p.Subcategory , round(sum(s.Revenue_USD),2) as total_revenue , round(sum(Profit_USD),2) as total_profit ,
sum(quantity) as total_quantity_sold from sales as s 
inner join products as p
on p.Product_Key = s.ProductKey
group by p.category , p.Subcategory_Key , p.Subcategory 
order by total_profit  desc
limit 10;

-- Question 23 — Customer Age-Group Analysis
-- Which customer age groups generate the highest revenue and profit?
select Customer_Age_Group , round(sum(Revenue_USD),2) as total_revenue , round(sum(Profit_USD),2) as total_profit from sales 
group by Customer_Age_Group 
order by total_revenue desc;

with age_table as (
select CustomerKey ,  Birthday , timestampdiff(year , Birthday , curdate()) as age , 
case
WHEN TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) < 18 THEN 'Under 18'
WHEN TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) BETWEEN 18 AND 25 THEN '18-25'
WHEN TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) BETWEEN 26 AND 35 THEN '26-35'
WHEN TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) BETWEEN 36 AND 50 THEN '36-50'
ELSE 'Above 50'
END AS Age_Group
FROM customers
WHERE Birthday IS NOT NULL )
select  a.Age_Group , round(sum(s.Revenue_USD),2) as total_revenue , round(sum(s.Profit_USD),2) as total_profit 
from age_table as a 
inner join sales as s
on a.CustomerKey = s.CustomerKey
group by a.Age_Group
order by total_revenue desc;

-- Question 24 — Customer Count and Revenue by Age Group
-- Does the 66+ age group lead because it contains more customers, or because its customers spend more?
select  s.Customer_Age_Group , count(distinct c.CustomerKey) as total_customers , round(sum(s.Revenue_USD),2) as total_revenue 
from sales as s
inner join customers as c
on c.CustomerKey = s.CustomerKey
group by s.Customer_Age_Group 
order by total_revenue desc  ;


-- Question 25 — Customer Value by Age Group
-- Which customer age group has the highest average revenue per customer?
select  s.Customer_Age_Group , count(distinct c.CustomerKey) as total_customers , round(sum(s.Revenue_USD),2) as total_revenue , 
round(sum(s.Revenue_USD) / count(distinct c.CustomerKey),2) as revenue_per_customer
from sales as s
inner join customers as c
on c.CustomerKey = s.CustomerKey
group by s.Customer_Age_Group 
order by total_revenue desc  ;

-- Question 26 — One-time vs Repeat Customers
-- How do one-time customers compare with repeat customers in terms of customer count, revenue, and average revenue per customer?

with customer_table as (
select  customerkey , count(distinct Order_Number ) as total_orders
from sales
group by customerkey 
) ,
category_table as (
select customerkey , total_orders , 
(case
when total_orders > 1 then 'Repeated Customers'
else 'One-Time Customer'
end ) as cust_category  from customer_table )
select c.cust_category ,
count(distinct s.customerkey) as no_of_customers , round(sum(s.Revenue_USD),2) as total_revenue , 
round(sum(s.Revenue_USD) / count(distinct s.customerkey),2) as avg_revenue_per_customers from sales as s 
inner join category_table as c
on c.customerkey = s.customerkey 
group by c.cust_category 
order by total_revenue desc;

-- Question 27 — Customer master validation
-- Find customers who never purchased
-- How many customers in the customers table have never placed a recorded order?

select count(distinct c.CustomerKey) as customer_count from customers as c
left join sales as s
on c.CustomerKey = s.CustomerKey
where s.CustomerKey is null

 -- Question 28 — Customer Retention by Country
-- Which countries have the highest percentage of repeat customers, and which countries may need better customer-retention strategies?

WITH customer_orders AS (
    SELECT
        CustomerKey,
        COUNT(DISTINCT Order_Number) AS total_orders
    FROM sales
    GROUP BY CustomerKey
),
customer_categories AS (
    SELECT
        CustomerKey,
        total_orders,
        CASE
            WHEN total_orders > 1 THEN 'Repeated Customers'
            ELSE 'One time'
        END AS customer_category
    FROM customer_orders
)
SELECT
    c.Country,
    COUNT(DISTINCT cc.CustomerKey) AS total_customers,
    COUNT(DISTINCT CASE
        WHEN cc.customer_category = 'Repeated Customers'
        THEN cc.CustomerKey
    END) AS repeated_customers,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN cc.customer_category = 'Repeated Customers'
            THEN cc.CustomerKey
        END) * 100.0
        / COUNT(DISTINCT cc.CustomerKey),
        2
    ) AS repeat_customer_rate_pct
FROM customer_categories AS cc
INNER JOIN customers AS c
    ON c.CustomerKey = cc.CustomerKey
GROUP BY c.Country
ORDER BY repeat_customer_rate_pct DESC;

-- Question 29 — Average Order Value by Country
-- Which countries generate the highest average revenue per order, and which generate the lowest?
select st.country , count(distinct s.Order_Number) as total_orders , round(sum(s.Revenue_USD),1) as total_revenue ,
round(sum(s.Revenue_USD) / count(distinct s.Order_Number),2) as avg_order_value from sales as s
inner join stores as st
on st.StoreKey = s.StoreKey
where st.country !='Online'
group by country 
order by avg_order_value desc;

-- Question 30 — Revenue Contribution by Country
-- What percentage of total company revenue does each country contribute?
with country_category as (
select st.country , round(sum(s.Revenue_USD),2) as total_revenue  from sales as s
inner join stores as st
on st.StoreKey = s.StoreKey
group by country ) ,
business_revenue as (
select round(sum(Revenue_USD),2) as business_revenue from sales
)
select  c.country , c.total_revenue , round(c.total_revenue / b.business_revenue * 100 ,2) as contribution from country_category as c
cross join business_revenue as b
order by contribution desc ;

-- Question 31 — Profit Contribution by Country
-- Which physical-store countries contribute the most to total company profit?
with country_category as (
select st.country , round(sum(Profit_USD),2) as total_profit from sales as s
inner join stores as st
on st.StoreKey = s.StoreKey
group by country ) ,
business_revenue as (
select round(sum(Profit_USD),2) as business_profit from sales
)
select  c.country , c.total_profit  , round(c.total_profit / b.business_profit * 100 ,2) as contribution from country_category as c
cross join business_revenue as b
where c.country != 'Online'
order by contribution desc ;


-- Question 32 — Profit Margin by Country
-- Which countries have the highest and lowest profit margins?
with country_category as (
select st.country ,round(sum(s.Revenue_USD),2) as total_revenue ,  round(sum(s.Profit_USD),2) as total_profit  from sales as s
inner join stores as st
on st.StoreKey = s.StoreKey
group by country )
select  country , total_profit  , total_revenue  , round(total_profit /  total_revenue * 100 ,2) as profit_margin_pct from country_category 
where country != 'Online'
order by profit_margin_pct desc 
limit 1 ;

with country_category as (
select st.country ,round(sum(s.Revenue_USD),2) as total_revenue ,  round(sum(s.Profit_USD),2) as total_profit  from sales as s
inner join stores as st
on st.StoreKey = s.StoreKey
group by country )
select  country , total_profit  , total_revenue  , round(total_profit /  total_revenue * 100 ,2) as profit_margin_pct from country_category 
where country != 'Online'
order by profit_margin_pct 
limit 1 ;

-- Question 33 — Revenue and Profit by Product Category
-- Which product categories generate the highest revenue and profit, and do the rankings differ?
select p.category , round(sum(Revenue_USD),2) as total_revenue , round(sum(Profit_USD),2) as total_profit ,
round(sum(Profit_USD) / sum(Revenue_USD) * 100  ,2 ) as profit_margin_pct , 
rank() over( order by sum(Revenue_USD)  desc ) as revenue_rank ,
rank() over (order by sum(Profit_USD) desc ) as profit_rank
from sales as s 
join products as p
on p.Product_Key = s.ProductKey
group by p.category 
order by profit_margin_pct desc;

-- question — Q34
-- Which product brands generate the highest profit margins, and do the most profitable brands also have the highest revenue?
select p.Brand , round(sum(Revenue_USD),2) as total_revenue , round(sum(Profit_USD),2) as total_profit ,
round(sum(Profit_USD) / sum(Revenue_USD) * 100  ,2 ) as profit_margin_pct 
from sales as s 
join products as p
on p.Product_Key = s.ProductKey
group by p.Brand
order by profit_margin_pct desc;

-- question — Q35
-- Which brands rank highest by total profit, and how does that compare with their profit-margin ranking?
select p.Brand , round(sum(Revenue_USD),2) as total_revenue , round(sum(Profit_USD),2) as total_profit ,
round(sum(Profit_USD) / sum(Revenue_USD) * 100  ,2 ) as profit_margin_pct  ,
rank() over (order by sum(Profit_USD) desc ) as profit_rank ,
rank() over(order by round(sum(Profit_USD) / sum(Revenue_USD) * 100  ,2 ) desc  ) as margin_rank
from sales as s 
join products as p
on p.Product_Key = s.ProductKey
group by p.Brand
order by profit_margin_pct desc;


-- Q36 — Product subcategory profitability
-- Which product subcategories have the highest profit margins, and do they also generate high total profits?
select p.Subcategory_Key , p.Subcategory , round(sum(Revenue_USD),2) as total_revenue , round(sum(Profit_USD),2) as total_profit ,
round(sum(Profit_USD) / sum(Revenue_USD) * 100  ,2 ) as profit_margin_pct  ,
rank() over(order by round(sum(Profit_USD) / sum(Revenue_USD) * 100  ,2 ) desc  ) as margin_rank
from sales as s 
join products as p
on p.Product_Key = s.ProductKey
group by p.Subcategory_Key , p.Subcategory 
order by profit_margin_pct desc
limit 10 ;

-- Q37 — 
-- Which product subcategories generate the highest total profit, and how does their ranking compare with their profit-margin ranking?

select p.Subcategory_Key , p.Subcategory , round(sum(Revenue_USD),2) as total_revenue , round(sum(Profit_USD),2) as total_profit ,
round(sum(Profit_USD) / sum(Revenue_USD) * 100  ,2 ) as profit_margin_pct  ,
rank() over (order by sum(Profit_USD) desc ) as profit_rank ,
rank() over(order by round(sum(Profit_USD) / sum(Revenue_USD) * 100  ,2 ) desc  ) as margin_rank
from sales as s 
join products as p
on p.Product_Key = s.ProductKey
group by p.Subcategory_Key , p.Subcategory 
order by total_profit desc
limit 10 ;



-- Q38 — Customer purchasing behaviour
-- Which customer countries have the highest average number of orders per purchasing customer?
with customer_purchasing_behaviour as (
select c.CustomerKey , c.Country ,  count(distinct Order_Number) as total_orders  from sales as s 
join customers as c
on c.CustomerKey = s.CustomerKey
group by c.CustomerKey  , c.Country
)
select country , round(sum(total_orders) / count(distinct customerkey) ,2 ) as avg_orders_per_customer from customer_purchasing_behaviour
group by country 
order by avg_orders_per_customer desc ;

-- Q39 — Customer profitability  (over all customers one time and repeated)
-- Which customers generate the highest profit per order?  
with customer_purchasing_behaviour as (
select c.CustomerKey , c.Name, c.Country , round(sum(Revenue_USD),2) as total_revenue , count(distinct Order_Number) as total_orders ,
round(sum(Profit_USD),2) as total_profit  from sales as s 
join customers as c
on c.CustomerKey = s.CustomerKey
group by c.CustomerKey ,c.Name ,  c.Country
)
select customerkey , Name , country ,  total_profit ,  total_revenue ,
round(total_profit /total_orders,2) as profit_per_order 
from customer_purchasing_behaviour
order by profit_per_order desc 
limit 10;


# Repeated customers
with customer_purchasing_behaviour as (
select c.CustomerKey , c.Name, c.Country , round(sum(Revenue_USD),2) as total_revenue ,  count(distinct Order_Number) as total_orders ,
round(sum(Profit_USD),2) as total_profit  from sales as s 
join customers as c
on c.CustomerKey = s.CustomerKey
group by c.CustomerKey ,c.Name ,  c.Country
)
select customerkey , Name , country , total_revenue ,  total_profit ,  
round(total_profit /total_orders,2) as profit_per_order 
from customer_purchasing_behaviour
where total_orders > 1
order by profit_per_order desc 
limit 10;

# One Time 
with customer_purchasing_behaviour as (
select c.CustomerKey , c.Name, c.Country ,round(sum(Revenue_USD),2) as total_revenue,  count(distinct Order_Number) as total_orders ,
round(sum(Profit_USD),2) as total_profit  from sales as s 
join customers as c
on c.CustomerKey = s.CustomerKey
group by c.CustomerKey ,c.Name ,  c.Country
)
select customerkey , Name , country ,total_revenue,  total_profit ,  
round(total_profit /total_orders,2) as profit_per_order 
from customer_purchasing_behaviour
where total_orders <= 1
order by profit_per_order desc 
limit 10;

-- Q40 — Customer lifetime value (CLV) proxy.
-- Which customers generate the highest total profit across all their purchases?
select s.CustomerKey , c.Name , c.Country ,  round(sum(Revenue_USD),2) as total_revenue , round(sum(Profit_USD),2) as total_profit ,
count(distinct Order_Number) as total_orders from sales as s
join customers as c
on c.customerkey = s.customerkey
group by s.CustomerKey , c.Name , c.Country
order by total_profit desc 
limit 10 ;

-- Q41 — Customer revenue versus profit
-- Which customers have high revenue but comparatively low profit margins?
select s.CustomerKey , c.Name , c.Country ,  round(sum(s.Revenue_USD),2) as total_revenue , round(sum(s.Profit_USD),2) as total_profit ,
count(distinct s.Order_Number) as total_orders , round(sum(s.Profit_USD) /nullif(sum(s.Revenue_USD),0) * 100 , 2 ) as profit_margin   from sales as s
join customers as c
on c.customerkey = s.customerkey
group by s.CustomerKey , c.Name , c.Country
order by profit_margin asc 
limit 10 ;


-- Q42 — Compare profit margins by customer type
-- Do repeat customers have a higher average profit margin than one-time customers?
with customers_table as (
select CustomerKey , count(distinct Order_Number) as total_orders , round(sum(Revenue_USD),2) as total_revenue ,
round(sum(Profit_USD),2) as total_profit from sales
group by CustomerKey), 
customer_segment as (
select CustomerKey , total_orders ,total_revenue , total_profit ,
(case
when total_orders > 1 then "Repeated"
else "One Time "
end ) as cus_category ,
round(total_profit /nullif(total_revenue,0) *100,2) as profit_margin
from customers_table
)
select cus_category ,
count(*) as total_customers ,
sum(total_orders) as total_orders,
round(sum(total_revenue),2) as total_revenue ,
round(sum(total_profit),2) as total_profit , 
round(avg(profit_margin),2) as avg_profit_margin
from customer_segment
group by cus_category
order by avg_profit_margin desc;


-- Q43 — 
-- What percentage of total company revenue comes from repeat customers versus one-time customers?
with customers_table as (
select CustomerKey , count(distinct Order_Number) as total_orders , round(sum(Revenue_USD),2) as total_revenue ,
round(sum(Profit_USD),2) as total_profit from sales
group by CustomerKey), 
customer_segment as (
select CustomerKey , total_orders ,total_revenue , total_profit ,
(case
when total_orders > 1 then "Repeated"
else "One Time "
end ) as cus_category ,
round(total_profit /nullif(total_revenue,0) *100,2) as profit_margin
from customers_table
) , 
avg_profit as (
select cus_category ,
count(*) as total_customers ,
sum(total_orders) as total_orders,
round(sum(total_revenue),2) as total_revenue ,
round(sum(total_profit),2) as total_profit , 
round(avg(profit_margin),2) as avg_profit_margin
from customer_segment
group by cus_category
order by avg_profit_margin desc
) ,
business_rev as (
select sum(Revenue_USD) as business_revenue from sales
)
select c.cus_category , c.total_customers , c.total_orders ,
c.total_revenue , c.total_profit , c.avg_profit_margin , 
round(c.total_revenue / b.business_revenue * 100 ,2 ) as contribution from avg_profit  as c 
cross join business_rev as b
order by contribution desc;


-- Q44 — Customer repeat-purchase rate by country
-- Which countries have the highest percentage of purchasing customers who place more than one order?
with customers_table as (
select CustomerKey ,Country , count(distinct Order_Number) as total_orders , round(sum(Revenue_USD),2) as total_revenue ,
round(sum(Profit_USD),2) as total_profit from sales
group by CustomerKey , country ) ,
customer_segment as (
select CustomerKey , country , total_orders ,total_revenue , total_profit ,
(case
when total_orders > 1 then "Repeated"
else "One Time "
end ) as cus_category ,
round(total_profit /nullif(total_revenue,0) *100,2) as profit_margin
from customers_table
) 
select country ,
count(*) as total_customers ,
sum(case
when cus_category = "Repeated" then 1 else 0 end ) as repeated_customer_count,
sum(total_orders) as total_orders,
round(sum(case
when cus_category = "Repeated" then 1 else 0 end ) / count(*) * 100 , 2 ) as repeated_purchase_rate
from customer_segment
group by country 
order by repeated_purchase_rate desc


-- Q45 Repeat customers by country and revenue contribution
-- In each physical country, what percentage of revenue comes from repeat customers?
with customers_table as (
select CustomerKey ,Country , count(distinct Order_Number) as total_orders , round(sum(Revenue_USD),2) as total_revenue  from sales
group by CustomerKey , country ) ,
customer_segment as (
select CustomerKey , country , total_orders ,total_revenue ,
(case
when total_orders > 1 then "Repeated"
else "One Time "
end ) as cus_category 
from customers_table
) 
select country , 
round(sum(total_revenue),2) as total_country_revenue,
count(*) as total_customers ,
round(sum(case
when cus_category = 'Repeated' then total_revenue else 0  end ) ,2 ) as repeat_customer_revenue,
round(sum(case
when cus_category = 'Repeated' then total_revenue else 0  end ) / nullif(sum(total_revenue),0) * 100 , 2) as repeat_revenue_contribution_pct
from customer_segment 
where country != "Online"
group by country
order by repeat_revenue_contribution_pct desc;

-- Q46 Average revenue per customer by country
-- Which physical countries have the highest average revenue per purchasing customer?
with customers_table as (
select CustomerKey ,Country , count(distinct Order_Number) as total_orders , round(sum(Revenue_USD),2) as total_revenue  from sales
where country != "Online"
group by CustomerKey , country )
select country ,
count(*) as total_customers ,
 round(sum(total_orders),2) as total_orders,
round(sum(total_revenue),2) as total_revenue ,
round(sum(total_revenue)/count(*),2 ) as avg_revenue_per_customer from customers_table
group by country
order by  avg_revenue_per_customer Desc;

-- Q47
-- Which countries have the highest average profit per purchasing customer?
with customers_table as (
select CustomerKey ,Country , count(distinct Order_Number) as total_orders , round(sum(Profit_USD),2) as total_profit  from sales
where country != "Online"
group by CustomerKey , country )
select country ,
count(*) as total_customers ,
 round(sum(total_orders),2) as total_orders,
round(sum(total_profit),2) as total_profit ,
round(sum(total_profit)/count(*),2 ) as avg_profit_per_customer from customers_table
group by country
order by avg_profit_per_customer desc;

-- Q48 — Which countries have the highest average order value (AOV) among repeat customers?
with customer_table as (
select customerkey ,country , count(distinct Order_Number) as total_orders , round(sum(Revenue_USD),2) as total_revenue from sales 
where country != "Online"
group by customerkey , country 
) ,
repeated_customer as (
select customerkey  , country , total_orders , total_revenue from customer_table 
where total_orders > 1
)

select country , count(*) as repeated_customers , 
sum(total_orders) as total_repeated_orders , 
round(sum(total_revenue),2) as repeated_customer_revenue ,
round(sum(total_revenue) / sum(total_orders) ,2)  as avg_order_value from repeated_customer
group by country 
order by avg_order_value desc;

-- Q49 Which countries have the highest repeat-customer profit margin?
with customer_table as (
select customerkey ,country , count(distinct Order_Number) as total_orders , round(sum(Revenue_USD),2) as total_revenue ,
round(sum(Profit_USD),2) as total_profit  from sales 
where country != "Online"
group by customerkey , country 
) ,
repeated_customer as (
select customerkey  , country , total_orders , total_revenue , total_profit  from customer_table 
where total_orders > 1
)

select country , count(*) as repeated_customers , 
sum(total_orders) as total_repeated_orders , 
round(sum(total_revenue),2) as repeated_customer_revenue ,
round(sum(total_profit),2) as repeated_customer_profit ,
round(sum(total_profit)/sum(total_revenue) * 100 ,2)  as profit_margin from repeated_customer
group by country 
order by profit_margin desc;


-- Q50 Which countries have the highest percentage of total revenue generated by repeat customers?
with customer_table as (
select customerkey ,country , count(distinct Order_Number) as total_orders , round(sum(Revenue_USD),2) as total_revenue  from sales 
where country != "Online"
group by customerkey , country
), 
repeated_customers as (
select customerkey  , country , total_orders , total_revenue   from customer_table 
where total_orders > 1
) ,
revenue_table as (
select country , count(*) as repeated_customers ,
round(sum(total_revenue),2) as repeated_customers_revenue  from repeated_customers
group by country 
),
business_revenue as (
select country , round(sum(Revenue_USD),2) as total_country_revenue  from sales 
where country != "Online"
group by country 
)
select r.country , r.repeated_customers , r.repeated_customers_revenue ,round( r.repeated_customers_revenue / b.total_country_revenue * 100 ,2 ) as revenue_pct
from revenue_table  as r 
inner join business_revenue as b
on r.country = b.country
order by revenue_pct desc;


with customer_table as (
select CustomerKey, Country, count(distinct Order_Number) as total_orders, sum(Revenue_USD) as total_revenue from sales
where Country != 'Online'
group by CustomerKey, Country
),
country_revenue as (
select Country, sum(total_revenue) as total_country_revenue,
sum(case when total_orders > 1 then total_revenue else 0 end) as repeat_revenue,
sum(case when total_orders > 1 then 1 else 0 end) as repeat_customers
from customer_table
group by Country
)
select Country, repeat_customers,
round(repeat_revenue, 2) as repeat_customer_revenue,
round(total_country_revenue, 2) as total_country_revenue,
round(repeat_revenue / total_country_revenue * 100, 2) as revenue_pct
from country_revenue
order by revenue_pct desc;

-- Q51: Identify customers who have not purchased recently, using their last order date.
-- Which customers have not made a purchase in the last 6 months, and how much revenue have they generated historically?
with customer_activity as (
select customerkey , max(Order_Date) as  last_order_date,  count(distinct Order_Number) as total_orders ,
round(sum(Revenue_USD),2) as lifetime_revenue  from sales
where country != "Online"
group by customerkey
),
dataset_date as (
select max(order_date) as latest_order_date from sales
where country != "Online"  
)
select  ca.CustomerKey, ca.last_order_date, ca.total_orders,  ca.lifetime_revenue,  dd.latest_order_date
from customer_activity as ca
cross join dataset_date as dd
where ca.last_order_date < date_sub(dd.latest_order_date, INTERVAL 6 MONTH)
order by  ca.last_order_date asc;


-- Q52: Analyse customer purchase frequency and identify high-value repeat customers.
-- Who are the top 10 repeat customers by average revenue per order?

select c.CustomerKey, c.Name , count(distinct s.Order_Number) as total_orders, round(sum(s.Revenue_USD),2) as total_revenue ,
round(sum(s.Revenue_USD) / count(distinct s.Order_Number) ,2) as avg_revenue_per_order
from sales as s
inner join customers as c
on c.customerkey = s.CustomerKey
group by c.CustomerKey, c.Name
having total_orders > 1
order by avg_revenue_per_order desc
limit 10 ;


-- Q53: Which product categories generate the highest revenue, and what percentage of total company revenue does each category contribute?
with product_category as (
select p.Category , round(sum(s.Revenue_USD),2) as total_revenue from sales as s
inner join products as p
on p.Product_Key = s.ProductKey
group by p.Category
),
business_revenue as (
select sum(Revenue_USD) AS total_company_revenue from sales
)
select  pc.Category, pc.total_revenue,
round(pc.total_revenue / br.total_company_revenue * 100, 2) as revenue_contribution_pct
from product_category as pc
cross join business_revenue as br
order by  pc.total_revenue desc;
