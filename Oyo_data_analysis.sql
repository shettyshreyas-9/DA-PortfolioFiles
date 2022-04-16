Select *
From ['Oyo SQL$']

Select *
From ['city oyo hotels$']

Alter table ['Oyo SQL$'] drop column F11
Alter table ['city oyo hotels$'] drop column F3
sp_rename  ['city oyo hotels$'.Hotel_id] ,hotel_iden

Alter table ['Oyo SQL$'] add stay_days float
update ['Oyo SQL$'] Set stay_days= DATEDIFF(day,check_in,check_out)
Alter table ['Oyo SQL$'] alter column stay_days date
Alter table ['Oyo SQL$'] drop column stay_days

Alter table ['Oyo SQL$'] alter column check_in Date
Update ['city oyo hotels$'] Set F3=1
alter table ['city oyo hotels$'] alter column F3 date






/* combined tables for visualization*/ 
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

Select *
From cte_oyo_merged








/* No. of total hotels */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )
Select count(distinct(hotel_id)) From cte_oyo_merged

/* Avg. hotel rent in RS by city */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden)

Select city, avg(amount-discount) avg_rent
From cte_oyo_merged
group by city
order by avg_rent desc


/* Total bookings split across the cities */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden)

select City,COUNT(*) booking_count
From cte_oyo_merged
Group by City
Order by COUNT(*) desc


/* Count of unique hotels per city with oyo */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

select City,COUNT(distinct hotel_id) hotel_count
From cte_oyo_merged
Group by City
Order by hotel_count desc

/* Bookings by month */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

select city, datename(MM,(date_of_booking)) mnth,COUNT(*) bkings
from cte_oyo_merged
group by City,datename(MM,(date_of_booking))
order by City,mnth

/* Check-in & bookings are made in the same month */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

select city, datename(MM,(date_of_booking)) mnth,COUNT(*) bkings
From cte_oyo_merged
where MONTH(date_of_booking)=MONTH(check_in)
group by City,datename(MM,(date_of_booking))
order by City,mnth


/* How many days prior bookings were made */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

select datediff(day,date_of_booking,check_in) days_diff,count(*) booking,round(count(*)*100/(select COUNT(*) from cte_oyo_merged),3)perc_book
From cte_oyo_merged
group by datediff(day,date_of_booking,check_in)


/* Discount offered */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

select city,sum(amount) price, sum(discount) discount_amt,sum(discount)*100/sum(amount) disc_per
From cte_oyo_merged
group by city

/* stayed, cancelled or not showm numbers out of total bookings */
datename(m,date_of_booking)
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

select status,COUNT(*) cnt
From cte_oyo_merged
Group by status
Order by COUNT(*) desc

/* Cities with highest count of cancelled bookings*/
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

select City,COUNT(*) cancelled_bookings
From cte_oyo_merged
where status='Cancelled'
Group by City
Order by COUNT(*) desc


/* Cities with highest rate of cancellations */

With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

select City, SUM(Case when status='Cancelled' then 1 else 0 end) cancelled,
SUM(Case when status='No Show' then 1 else 0 end) not_shown,
SUM(Case when status='Stayed' then 1 else 0 end) stayed,count(*) total_bookings,
SUM(Case when status='Cancelled' then 1 else 0 end)*100/count(*) cancel_per,
SUM(Case when status='No Show' then 1 else 0 end)*100/count(*) NoShow_per,
SUM(Case when status='Stayed' then 1 else 0 end)*100/count(*) stay_per
From cte_oyo_merged
Group by City
Order by SUM(Case when status='Cancelled' then 1 else 0 end)*100/count(*) desc


/* Average days stayed per hotel by the customers in each city */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

Select City,SUM(stay_days) total_days,COUNT(distinct hotel_id) unique_hotels,SUM(stay_days)/COUNT(distinct hotel_id) avg_days_stayed 
From cte_oyo_merged
Group by city
order by SUM(stay_days)/COUNT(distinct hotel_id) desc

/*  Revenue distribution as per cities */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

Select city,sum(amount) initial_amt,SUM(discount) disc,sum(amount)-SUM(discount) revenue
From cte_oyo_merged
Where status <> 'Cancelled'
Group by city
Order by sum(amount) desc

/* Cities having highest revenue per hotel */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

Select city,count(distinct hotel_id) hotel_count,sum(amount)-SUM(discount) revenue,(sum(amount)-SUM(discount)/count(distinct hotel_id)) revenue_per_hotel
From cte_oyo_merged
Where status <> 'Cancelled'
Group by city
Order by (sum(amount)-SUM(discount)/count(distinct hotel_id)) desc


/* Percentage of potential revenue lost due to cancellations */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

Select City,sum(amount-discount) potential_revenue, SUM(case when status='Cancelled' then (amount-discount) else 0 end) lost_revenue,
(SUM(case when status='Cancelled' then (amount-discount) else 0 end)*100/sum(amount-discount)) lost_revenue_perc
--sum(amount-discount)-SUM(case when status='Cancelled' then (amount-discount) else 0 end) actual revenue
From cte_oyo_merged
group by City
order by (SUM(case when status='Cancelled' then (amount-discount) else 0 end)*100/sum(amount-discount)) desc


/* Total Number of rooms in each city */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

Select City,SUM(no_of_rooms) total_rooms
From cte_oyo_merged
Group by City
Order by SUM(no_of_rooms) desc

/* Average number of rooms per city */
With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

Select City,sum(no_of_rooms),count(distinct hotel_id),sum(no_of_rooms)/count(distinct hotel_id) avg_rooms_per_hotel
From cte_oyo_merged
Group by City
Order by (sum(no_of_rooms)/count(distinct hotel_id)) desc





With cte_oyo_merged as 
(Select *
From ['Oyo SQL$'] O
Join ['city oyo hotels$'] C
On O.hotel_id=C.hotel_iden )

select hotel_id, SUM(Case when status='Cancelled' then 1 else 0 end) cancelled,
SUM(Case when status='No Show' then 1 else 0 end) not_shown,
SUM(Case when status='Stayed' then 1 else 0 end) stayed,count(*) total_bookings,
SUM(Case when status='Cancelled' then 1 else 0 end)*100/count(*) cancel_per,
SUM(Case when status='No Show' then 1 else 0 end)*100/count(*) NoShow_per,
SUM(Case when status='Stayed' then 1 else 0 end)*100/count(*) stay_per
From cte_oyo_merged
Group by hotel_id
Order by SUM(Case when status='Stayed' then 1 else 0 end) desc