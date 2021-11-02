With hotels as(
Select *
From dbo.['2018$']
union
Select *
From dbo.['2019$']
union
Select *
From dbo.['2020$'] )

Select *
From hotels
left join dbo.market_segment$
on hotels.market_segment = market_segment$.market_segment

left join dbo.meal_cost$
on hotels.meal = meal_cost$.meal

/*Select round(sum((stays_in_week_nights+ stays_in_week_nights)*adr),2) as revenue,
		arrival_date_year , hotel
from hotels
group by arrival_date_year, hotel */