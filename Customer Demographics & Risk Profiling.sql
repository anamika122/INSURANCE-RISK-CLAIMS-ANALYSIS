create database an_insurance;
use an_insurance;

select * from insurance_policies_data;

load Data infile "D:/Projects/insurance_policies_data.csv"
into table insurance_policies_data
CHARACTER SET utf8mb4
fields terminated by ','
enclosed by '"'
lines terminated by'\n'
ignore 1 rows;

alter table insurance_policies_data
modify column BirthDate date;

SHOW CREATE TABLE insurance_policies_data;

select count(*) as total_records
from insurance_policies_data;

-- What is the average age of policyholders, and how does claim frequency vary by age group?

select case 
when timestampdiff (year,BirthDate,curdate()) < 25 then '25'
when timestampdiff (year,BirthDate, curdate()) between 25 and 40 then '25-40'
when timestampdiff  (year,BirthDate, curdate()) between 40 and 60 then '40-60'
else '60+'
end as age_group,
count(*) as policyholders,
avg(`Claim Freq`) as avg_claim_fre,
round(avg(`Claim Amount`),2) as avg_claim_amount
from insurance_policies_data
group by age_group
order by age_group;

-- Do gender or marital status influence claim frequency or claim amount?

select gender,count(*),
avg(`Claim Freq`) as avg_claim_fre,
round(avg(`Claim Amount`),2) as avg_claim_amount
from insurance_policies_data
group by gender;

select `Marital Status`,count(*),
avg(`Claim Freq`) as avg_claim_fre,
round(avg(`Claim Amount`),2) as avg_claim_amount
from insurance_policies_data
group by `Marital Status`;

-- Is there a relationship between education level and claim behavior?

select Education,count(*),
avg(`Claim Freq`) as avg_claim_fre,
round(avg(`Claim Amount`),2) as avg_claim_amount
from insurance_policies_data
group by Education;

-- How do parents vs. non-parents differ in their claims?

select Parent,count(*),
avg(`Claim Freq`) as avg_claim_fre,
round(avg(`Claim Amount`),2) as avg_claim_amount
from insurance_policies_data
group by Parent;

-- Does household income correlate with claim amount or frequency?

select min(`Household Income`)as min_inc,
max(`Household Income`) as max_inc
from insurance_policies_data;

SELECT 
  CASE 
    WHEN `Household Income` < 50000 THEN 'Low Income'
    WHEN `Household Income` BETWEEN 50000 AND 70000 THEN 'Mid Income'
    ELSE 'High Income'
  END AS Income_Group,
  Round(AVG(`Claim Amount`),2) AS Avg_Claim_Amt,
  Round(AVG(`Claim Freq`),2) AS Avg_Claim_Freq
FROM insurance_policies_data
GROUP BY Income_Group;

select round(avg(`Claim Amount`),2) as claim from insurance_policies_data;

-- Vehicle & Usage Analysis
-- .Which car makes/models have the highest claim frequencies or amounts?
SELECT `Car Make`, `Car Model`,
       round(sum(`Claim Amount`),2) AS Total_Claim_Amt,
       round(AVG(`Claim Amount`),2) AS Avg_Claim_Amt
FROM insurance_policies_data
GROUP BY `Car Make`,`Car Model`
ORDER BY Total_Claim_Amt DESC
LIMIT 10;


-- Does car age (new, mid-age, old) affect the likelihood or severity of claims?

select `Car Year`, timestampdiff(year,`Car Year`,curdate()) as car_age from insurance_policies_data;

SELECT 
    CASE
        WHEN (YEAR(CURDATE()) - `Car Year`) < 10 THEN 'New '
        WHEN (YEAR(CURDATE()) - `Car Year`) BETWEEN 10 AND 15 THEN 'Mid-age '
        ELSE 'Old'
    END AS Car_Age_Group,
    COUNT(*) AS Num_Cars,
    Round(SUM(`Claim Freq`),2) AS Total_Claims,
     round(Sum(`Claim Amount`),2) AS Total_Claim_Amt,
    ROUND(SUM(`Claim Freq`) * 1.0 / COUNT(*), 2) AS Claim_Likelihood,
    ROUND(SUM(`Claim Amount`) * 1.0 / NULLIF(SUM(`Claim Freq`),0), 2) AS Claim_Severity
FROM insurance_policies_data
GROUP BY Car_Age_Group
ORDER BY Car_Age_Group;

-- How does car usage type (personal, commercial) impact claims?
select `Car Use`,
Round(SUM(`Claim Amount`),2) AS total_claims,
    SUM(ID) AS total_policies,
    Round(SUM(`Claim Freq`),2)as claim_fre
FROM insurance_policies_data
GROUP BY `Car Use`;
-- Is there any pattern in claims based on car color (e.g., fraud detection, visibility)?
select `Car Color`,
Round(SUM(`Claim Amount`),2) AS total_claims,
    SUM(ID) AS total_policies,
    Round(SUM(`Claim Freq`),2)as claim_fre
FROM insurance_policies_data
GROUP BY `Car Color`
order by `Car Color` desc;

-- Which coverage zones (urban, rural, etc.) have the highest claim rates?

select `Coverage Zone`,
Round(Avg(`Claim Amount`),2) AS total_claims,
  Round(SUM(`Claim Freq`),2)as claim_fre from  insurance_policies_data
group by  `Coverage Zone`
order by claim_fre  desc;

-- 11.What is the average claim amount per customer segment (age, income, vehicle type)?
alter table insurance_policies_data
modify column age varchar(10);

SET SQL_SAFE_UPDATES = 0;

UPDATE insurance_policies_data 
SET age = CASE 
    WHEN TIMESTAMPDIFF(YEAR, BirthDate, CURDATE()) < 25 THEN '25'
    WHEN TIMESTAMPDIFF(YEAR, BirthDate, CURDATE()) BETWEEN 25 AND 40 THEN '25-40'
    WHEN TIMESTAMPDIFF(YEAR, BirthDate, CURDATE()) > 40 THEN '40-60'
    ELSE '60+'
END;

select age,
count(*) as no_of_people,
round(avg(`Household Income`),2) as income_by_age,
Round(Avg(`Claim Amount`),2) AS total_claims,
  Round(SUM(`Claim Freq`),2)as claim_fre from insurance_policies_data
group by AGE
order by  age desc;
 
 
-- Are high claim amounts concentrated in specific customer groups or zones?
select Education,
count(*) as no_of_people,
Round(Avg(`Claim Amount`),2) AS total_claims,
  Round(SUM(`Claim Freq`),2)as claim_fre from insurance_policies_data
group by Education;

-- Who are the high-frequency claimants (top 5% customers)?
WITH claim_rank AS (
    SELECT 
        ID,
        SUM(`Claim Freq`) AS total_claims,
        PERCENT_RANK() OVER (ORDER BY SUM(`Claim Freq`) DESC) AS pr
    FROM insurance_policies_data
    GROUP BY ID
)
SELECT ID, total_claims
FROM claim_rank
WHERE pr <= 0.05
ORDER BY total_claims DESC;
;
-- Which customer segments are most profitable (low claims, high premium potential)?
SELECT `Car Use`,`Coverage Zone`, 
       ROUND(AVG(`Household Income`),0) AS avg_income,
       ROUND(AVG(`Claim Amount`),0) AS avg_claim,
       ROUND(AVG(`Household Income`) - AVG(`Claim Amount`),0) AS profit_potential
FROM insurance_policies_data
GROUP BY `Car Use`, `Coverage Zone`
ORDER BY profit_potential DESC;

-- . Which segments pose the highest risk (high claim frequency/severity)?
SELECT `Car Use`, `Coverage Zone`,
       AVG(`Claim Freq`) AS avg_claim_freq,
       AVG(`Claim Amount`) AS avg_claim_amount
FROM insurance_policies_data
GROUP BY `Car Use`, `Coverage Zone`
ORDER BY avg_claim_freq DESC, avg_claim_amount DESC;

-- Which insights can be used for targeted marketing?
SELECT `Car Use`,`Coverage Zone`, 
       ROUND(AVG(`Household Income`),0) AS avg_income,
       ROUND(AVG(`Claim Freq`),2) AS avg_claim_freq
FROM insurance_policies_data
GROUP BY `Car Use`, `Coverage Zone`
HAVING AVG(`Claim Freq`) < 1  
ORDER BY avg_income DESC;



