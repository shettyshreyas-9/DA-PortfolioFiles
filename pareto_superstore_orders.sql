/* Pareto: 80% of results comes from 20% of causes */
select *
From superstore_orders$

select Customer_Name, COUNT(order_id)
From superstore_orders$
Group by Customer_Name
order by COUNT(order_id) desc

select sum(sales)*0.8
From superstore_orders$

with cte_superstore as (
select Product_ID, sum(sales) as prod_sales
From superstore_orders$
group by Product_ID
)

Select *
From
(
Select product_id,prod_sales,sum(prod_sales) over(order by prod_sales desc) running_tot
From cte_superstore
) A
where A.running_tot<=(select sum(sales)*0.8 From superstore_orders$)

