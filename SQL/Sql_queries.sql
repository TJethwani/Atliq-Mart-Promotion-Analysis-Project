BUSINESS AD-HOC REQUEST

use retail_events_db;
select * from fact_events;
select * from dim_products;
select * from dim_stores;
select * from dim_campaigns;

/*Question 1: Products with base price more than 500 and promotion type BOGOF*/
select DISTINCT dp.product_code, dp.product_name
from dim_products as dp
JOIN fact_events as fte
ON dp.product_code = fte.product_code
where (fte.base_price > 500) and (fte.promo_type = "BOGOF");



/*Question 2 - generate a report that provides number of stores in a city. Arrange it in descending order*/
select city, count(*) as total_stores from dim_stores
group by city
order by total_stores DESC;



/*Question 3 Campaign name and total revenue generation before promotion and after promotion*/ 
SELECT dc.campaign_name,
sum(round(fte.base_price*fte.`quantity_sold(before_promo)`,2))/1000000 as total_revenue_before_promo,
sum(round(fte.base_price*fte.`quantity_sold(after_promo)`,2))/1000000 as total_revenue_after_promo
FROM fact_events as fte
JOIN dim_campaigns as dc
ON fte.campaign_id = dc.campaign_id
GROUP BY dc.campaign_name
ORDER BY dc.campaign_name ASC;





/*Question 4 -Calculation of ISU (Incremental Sold Quantity) for each category.
Ranking category based on ISU% */

SELECT p.category,
(round((SUM(fte.`quantity_sold(after_promo)`)-SUM(fte.`quantity_sold(before_promo)`))/
        SUM(fte.`quantity_sold(before_promo)`)*100,2)) as ISU_percentage,
RANK() OVER (order by ((SUM(fte.`quantity_sold(after_promo)`)-SUM(fte.`quantity_sold(before_promo)`))/
        SUM(fte.`quantity_sold(before_promo)`)*100) DESC) as rank_order
FROM dim_products as p
JOIN fact_events as fte
ON p.product_code = fte.product_code
WHERE fte.campaign_id = 'CAMP_DIW_01'
group by p.category;



/*Question 5 - Generate a query with top 5 products, ranked by IR %. 
Report should have product name, category and ir%*/

SELECT  p.product_name, p.category,
ROUND((SUM(fte.`quantity_sold(after_promo)`* fte.base_price) - 
SUM(fte.`quantity_sold(before_promo)` * fte.base_price))/
SUM(fte.`quantity_sold(before_promo)` * fte.base_price)*100,2) AS IR_Percentage
from dim_products as p
JOIN fact_events as fte
ON p.product_code = fte.product_code
group by p.product_name, p.category
Order by IR_percentage DESC
LIMIT 5;



        
    

