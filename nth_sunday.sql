Declare @given_date date;
declare @n int;
set @given_date='2022-01-01'
set @n=3

select dateadd(week,@n-1,dateadd(day,8-DATEPART(WEEKDAY,@given_date),@given_date))