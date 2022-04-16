create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR')


Select *
From entries


Select c.name,c.no_of_visits,d.floor,e.all_resour
From
(
Select name, COUNT(email) no_of_visits
From entries
group by name
) c
Join 
(
Select B.name,B.floor
From
(
Select A.*,ROW_NUMBER()Over(partition by A.name order by A.cnt desc)row_n
From
(
Select name,floor,(count(floor))cnt
from entries
group by name,floor) A
) B
Where B.row_n=1
) d
On c.name=d.name
Inner join
(
select name, STRING_AGG(resources,',') all_resour
from entries
group by name
) e
On c.name=e.name