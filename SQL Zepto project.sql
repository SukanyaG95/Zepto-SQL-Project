drop table if exists zepto;
drop table zepto;

create table zepto(
sku_id Serial primary key,
Category Varchar(120),
name Varchar(150) not null,
mrp NUMERIC(8,2),
discountPercent Numeric(5,2),
availableQuantity INTEGER,
discountedSellingPrice Numeric(8,2),
weightInGms INTEGER,
outOfStock Boolean,
quantity INT
);

--data exploration

--count of rows
Select count (*) From Zepto;

--sample data
select * from zepto
Limit 10;

--null values
select * from Zepto
where name is null
or
category is null
or
mrp is null
or
discountpercent is null
or
availablequantity is null
or
discountedsellingprice is null
or
weightingms is null
or
outofstock is null
or
quantity is null;

--different product categories
select distinct category
from zepto
order By category;

--products in stock vs outof stock

select outofstock, count(sku_id)
from zepto
Group By outofstock;

--product name present multiple times
Select name,count(sku_id) as "Number of skus"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) DESC;

---Data cleaning
--products with price=0

select * from zepto
where mrp = 0 or discountedsellingprice=0;


Delete from zepto
where mrp = 0;

--convert paise to rupees
update zepto
set mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

select mrp,discountedsellingprice from zepto;

--questions

--1)Find the top 10 best-value products based on the discount percentage.
select distinct name,mrp,discountpercent from zepto
order by discountpercent desc
limit 10 ;

--2)what are the products with high mrp but out of stock

select Distinct name,mrp
from zepto
where outofStock = True and mrp>300
order by mrp DESC;

--3)Calculate Estimated Revenue for each category
select category,
SUM(discountedsellingprice * availableQuantity) AS total_revenue
from zepto
Group By Category
order by total_revenue ;

--4)Find all product where mrp is greater than $500 and discount is less than 10%
select distinct name,mrp,discountpercent from Zepto 
where mrp > 500 and 
discountpercent<10
order by mrp desc,discountpercent desc;

--5)Identify the top 5 categories offering the highest average discount percentage
select category,
round(avg(discountpercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

--6)Find the price per gram for products above 100g and sort by best value.
select distinct name,weightingms,discountedsellingprice,
round(discountedsellingprice/weightingms,2)as price_per_gram
from zepto
where weightingms >=100
order by price_per_gram;

--7)Group the products into categories like Low,Medium,Bulk

select distinct name,weightingms,
case when weightingms <1000 then 'low'
     when weightingms <5000 then 'Medium'
	 else 'bulk'
	 end as weight_category
from zepto;

--8)what is the Total Inventory weight per category

select category,
sum(weightingms * availablequantity) as total_weight
from zepto
group by category
order by total_weight;
