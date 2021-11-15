/* Visualize entire data  */
SELECT *
FROM dbo.Donation_data$

ALTER TABLE dbo.Donation_data$
ADD ID INT IDENTITY


ALTER TABLE dbo.Donation_data$
DROP COLUMN don_id

/* Distinct type checking*/
SELECT DISTINCT (Name)
FROM dbo.Donation_data$

SELECT DISTINCT (Party)
FROM dbo.Donation_data$

SELECT DISTINCT (Type)
FROM dbo.Donation_data$

SELECT DISTINCT ([Financial Year ])
FROM dbo.Donation_data$

/* Sorting by group*/
SELECT Party, SUM(Amount) as Total_amount
FROM dbo.Donation_data$
GROUP BY Party
ORDER BY SUM(Amount) DESC


SELECT Type, SUM(Amount)
FROM dbo.Donation_data$
GROUP BY Type

 /* Year on Year change in amount of total donation received */
SELECT [Financial Year ], SUM(Amount) as total,
((SUM(Amount) - LAG(SUM(Amount)) OVER (ORDER BY [Financial Year ]))/SUM(Amount))*100
FROM dbo.Donation_data$
GROUP BY [Financial Year ]
ORDER BY [Financial Year ]

/* Year on Year change in amount of donation received by each party*/
SELECT [Financial Year ], SUM(Amount) as total,Party,LAG(SUM(Amount)) OVER (ORDER BY [Financial Year ] ),
((SUM(Amount) - LAG(SUM(Amount)) OVER (ORDER BY [Financial Year ]))/SUM(Amount))*100 as per_chng
FROM dbo.Donation_data$
GROUP BY  Party, [Financial Year ]
HAVING Party='BJP'
ORDER BY [Financial Year ],Party

SELECT [Financial Year ], SUM(Amount) as total,Party,LAG(SUM(Amount)) OVER (ORDER BY [Financial Year ] ),
((SUM(Amount) - LAG(SUM(Amount)) OVER (ORDER BY [Financial Year ]))/SUM(Amount))*100 as per_chng
FROM dbo.Donation_data$
GROUP BY  Party, [Financial Year ]
HAVING Party='CPI'
ORDER BY [Financial Year ],Party

SELECT [Financial Year ], SUM(Amount) as total,Party,LAG(SUM(Amount)) OVER (ORDER BY [Financial Year ] ),
((SUM(Amount) - LAG(SUM(Amount)) OVER (ORDER BY [Financial Year ]))/SUM(Amount))*100 as per_chng
FROM dbo.Donation_data$
GROUP BY  Party, [Financial Year ]
HAVING Party='CPI(M)'
ORDER BY [Financial Year ],Party

SELECT [Financial Year ], SUM(Amount) as total,Party,LAG(SUM(Amount)) OVER (ORDER BY [Financial Year ] ),
((SUM(Amount) - LAG(SUM(Amount)) OVER (ORDER BY [Financial Year ]))/SUM(Amount))*100 as per_chng
FROM dbo.Donation_data$
GROUP BY  Party, [Financial Year ]
HAVING Party='INC'
ORDER BY [Financial Year ],Party

SELECT [Financial Year ], SUM(Amount) as total,Party,LAG(SUM(Amount)) OVER (ORDER BY [Financial Year ] ),
((SUM(Amount) - LAG(SUM(Amount)) OVER (ORDER BY [Financial Year ]))/SUM(Amount))*100 as per_chng
FROM dbo.Donation_data$
GROUP BY  Party, [Financial Year ]
HAVING Party='NCP'
ORDER BY [Financial Year ],Party



/* Amount of money donated to each party based on PAN status */


SELECT M.Party,M.[PAN Given],N.[PAN Given],pan_amount+ nonpan_amount as total_amount, pan_amount,(pan_amount*100/(pan_amount+ nonpan_amount)) as pan_per_tot ,nonpan_amount,pan_amount- nonpan_amount as diff, (nonpan_amount*100/(pan_amount+ nonpan_amount)) as nonpan_per_tot
FROM
	(SELECT PARTY, SUM(Amount) as pan_amount , [PAN Given]
	FROM dbo.Donation_data$ 
	Where [PAN Given] like '%Y%'
	GROUP BY [PAN Given], Party
	) as M
INNER JOIN	
	(SELECT PARTY, SUM(Amount) as nonpan_amount , [PAN Given]
	FROM dbo.Donation_data$ 
	Where [PAN Given] like '%n%'
	GROUP BY [PAN Given], Party
	) as N
ON M.Party= N.Party


/*SELECT A.Party,A.[PAN Given], B.[PAN Given],B.Party
FROM dbo.Donation_data$ A
INNER join dbo.Donation_data$ B
ON A.ID = B.ID
Where A.[PAN Given] like '%Y%' AND B.[PAN Given] like '%n%'
GROUP BY A.Party, A.[PAN Given],B.[PAN Given], B.Party
--,B.[PAN Given] HAVING [PAN Given] like '%n%'  */


