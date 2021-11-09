-- Display the entire data
Select *
From dbo.['STEM salaries$']


--Trim any unwanted spaces
Select TRIM (tag)
FROM dbo.['STEM salaries$']

--Modifying pressent tables to add column/ insert data into column or remove column

/*ALTER TABLE dbo.['STEM salaries$']
ADD 

INSERT INTO dbo.['STEM salaries$'] */

ALTER TABLE dbo.['STEM salaries$']
DROP COLUMN F2

--Remove specific rows from the table
DELETE FROM dbo.['STEM salaries$']
WHERE Year_new is NULL 

/* Checking the data type of columns in table) */ 
SELECT 
TABLE_CATALOG,
TABLE_SCHEMA,
TABLE_NAME, 
COLUMN_NAME, 
DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 


-- Job title wise distribution & compensation
Select title, SUM(totalyearlycompensation) as Total_compensation, AVG(totalyearlycompensation) as Avg_compensation,COUNT(title) AS Num_jobs, (COUNT(title)*0.00154) as job_title_percent --title, totalyearlycompensation,company-- 
From dbo.['STEM salaries$']
GROUP BY title
ORDER BY Total_compensation DESC

-- (In India)
Select DISTINCT(title),COUNT(title) AS Num_jobs, AVG(totalyearlycompensation) as Avg_compensation, (COUNT(title)*0.00154) as job_title_percent 
From dbo.['STEM salaries$']
WHERE country like '%india%'
GROUP BY title
ORDER BY Num_jobs DESC

--( Year on Year growth of jobs in India)
SELECT  Year_new, COUNT(*) as Num_jobs,LAG(COUNT(*)) OVER (ORDER BY Year_new) as Lag_count,
((COUNT(*) -LAG(COUNT(*)) OVER (ORDER BY Year_new))*100)/(LAG(COUNT(*)) OVER (ORDER BY Year_new)) as YoYPercent_change
FROM dbo.['STEM salaries$']
WHERE country LIKE '%India%'
GROUP BY Year_new




-- Gender wise distribution & compensation
Select gender, SUM(totalyearlycompensation) as Tot_comp, AVG(totalyearlycompensation) as Avg_compensation,COUNT(title) AS Num_jobs, (COUNT(title)*0.00154) as gender_percent
From dbo.['STEM salaries$']
GROUP BY gender

--( Year on Year growth of jobs in India for females)
SELECT  Year_new, COUNT(*) as Num_jobs,LAG(COUNT(*)) OVER (ORDER BY Year_new) as Lag_count,
((COUNT(*) -LAG(COUNT(*)) OVER (ORDER BY Year_new))*100)/(LAG(COUNT(*)) OVER (ORDER BY Year_new)) as YoYPercent_change
FROM dbo.['STEM salaries$']
WHERE country LIKE '%India%' AND gender LIKE '%female%' 
GROUP BY Year_new


--  wise distribution & compensation
Select Race, SUM(totalyearlycompensation) as Tot_comp, AVG(totalyearlycompensation) as Avg_compensation,COUNT(title) AS Num_jobs, (COUNT(title)*0.00154) as race_percent
From dbo.['STEM salaries$']
GROUP BY Race

--( Year on Year growth of jobs in India for hispanic community)
SELECT  Year_new, COUNT(*) as Num_jobs,LAG(COUNT(*)) OVER (ORDER BY Year_new) as Lag_count,
((COUNT(*) -LAG(COUNT(*)) OVER (ORDER BY Year_new))*100)/(LAG(COUNT(*)) OVER (ORDER BY Year_new)) as YoYPercent_change
FROM dbo.['STEM salaries$'] 
WHERE Race LIKE '%hispanic%' 
GROUP BY Year_new


-- Education wise distribution & compensation
Select Education, SUM(totalyearlycompensation) as Tot_comp, AVG(totalyearlycompensation) as Avg_compensation,COUNT(title) AS Num_jobs, (COUNT(title)*0.00154) as education_percent
From dbo.['STEM salaries$']
GROUP BY Education

-- Year wise distribution & compensation
Select Year_new, SUM(totalyearlycompensation) as Tot_comp, AVG(totalyearlycompensation) as Avg_compensation,COUNT(title) AS Num_jobs, (COUNT(title)*0.00154) as education_percent
From dbo.['STEM salaries$']
GROUP BY Year_new
ORDER BY Year_new

--year on year change in number of jobs
SELECT  Year_new, COUNT(*) as Num_jobs,LAG(COUNT(*)) OVER (ORDER BY Year_new) as Lag_count,
((COUNT(*) -LAG(COUNT(*)) OVER (ORDER BY Year_new))*100)/(LAG(COUNT(*)) OVER (ORDER BY Year_new)) as YoYPercent_change
FROM dbo.['STEM salaries$']
GROUP BY Year_new