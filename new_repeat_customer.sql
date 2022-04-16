create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000)
;

select * 
from customer_orders


with cte_customer_merged as
(
Select *
From
(select * 
from customer_orders) co
inner join
(select customer_id as cust_id, MIN(order_date) first_visit
from customer_orders
group by customer_id) fv
On co.customer_id=fv.cust_id)

select order_date, sum(case when order_date=first_visit then 1 else 0 end) new_customers,
sum(case when order_date=first_visit then order_amount else 0 end) revenue_new_customers,
sum(case when order_date<>first_visit then 1 else 0 end) repeat_customers,
sum(case when order_date<>first_visit then order_amount else 0 end) revenue_repeat_customers
from cte_customer_merged
group by order_date
