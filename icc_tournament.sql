create table icc_tournament(team_1 varchar(50),team_2 varchar(50),winner varchar(50))

insert into icc_tournament values('India','SL','India'),('SL','Aus','Aus'),('SA','Eng','Eng'),('Eng','NZ','NZ'),('Aus','India','India')

select *
From icc_tournament


/* Method 1 */

Select A.teams, COUNT(A.teams) matches_played, SUM(A.wins)total_wins, COUNT(A.teams)-SUM(A.wins) total_losses
From 
(
Select team_1 as teams, case when team_1=winner then 1 else 0 end wins
From icc_tournament
union all
Select team_2 as teams, case when team_2=winner then 1 else 0 end wins
From icc_tournament
) A
Group by A.teams
Order by total_wins desc



/* Method 2 */

select team_1
from icc_tournament
union
select team_2
from icc_tournament

Select tab1.team_1,tab1.matches_played,tab2.num_wins,matches_played-num_wins
From
(
Select tab.team_1, COUNT(tab.team_1) matches_played
From
(
select team_1
from icc_tournament
union all
select team_2
from icc_tournament) tab
Group by tab.team_1
) tab1
full outer Join
(
select winner, COUNT(*) num_wins
From icc_tournament
group by winner
) tab2
On tab1.team_1=tab2.winner

