use hr;
select * from hr_1;
select * from hr_2;

ALTER TABLE HR_1
CHANGE COLUMN `ï»¿Age` `Age` INT;
ALTER TABLE HR_2
CHANGE COLUMN `ï»¿Employee ID` `Employee ID` INT;

select *from hr_1;
select * from hr_2;
desc hr_1;
desc hr_2;

CREATE TABLE HR_Merged AS
SELECT
    h1.Age,
    h1.Attrition,
    h1.BusinessTravel,
    h1.DailyRate,
    h1.Department,
    h1.DistanceFromHome,
    h1.Education,
    h1.EducationField,
    h1.EmployeeCount,
    h1.EmployeeNumber,
    h1.EnvironmentSatisfaction,
    h1.Gender,
    h1.HourlyRate,
    h1.JobInvolvement,
    h1.JobLevel,
    h1.JobRole,
    h1.JobSatisfaction,
    h1.MaritalStatus,
    h2.`Employee ID`,
    h2.MonthlyIncome,
    h2.MonthlyRate,
    h2.NumCompaniesWorked,
    h2.Over18,
    h2.OverTime,
    h2.PercentSalaryHike,
    h2.PerformanceRating,
    h2.RelationshipSatisfaction,
    h2.StandardHours,
    h2.StockOptionLevel,
    h2.TotalWorkingYears,
    h2.TrainingTimesLastYear,
    h2.WorkLifeBalance,
    h2.YearsAtCompany,
    h2.YearsInCurrentRole,
    h2.YearsSinceLastPromotion,
    h2.YearsWithCurrManager
FROM hr_1 AS h1
LEFT JOIN hr_2 AS h2
    ON h1.EmployeeNumber = h2.`Employee ID`;
    
select * from hr_merged;
 select * from hr_2;
 ------------  TOTAL EMPLOYEES--------------- It will give u the count of total employees
 Select count(*) as Total_employees      
 from hr_merged;

----------- ACTIVE EMPLOYEES (not attrited) -------------
select count(*)  as Active_employees
from hr_merged 
where lower(attrition)="No"; ----- Lower function will convert the string to lower case


---------- Overall attrition rate -------------- 
SELECT
  CONCAT(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) *100,2),"%")
     AS Attrition_Rate
FROM hr_merged;
/* SUM/COUNT*100 - Percentage of employees who left 
Round - Round the function to 2 decimal
Concat - Append a '%' sign to the number /*//
-------------- Attrition rate by department -------- KPI(1) 

SELECT
  Department,
  COUNT(*) AS total_employees,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited,
  CONCAT(ROUND(SUM(CASE WHEN Attrition = "Yes" THEN 1 ELSE 0 END) / COUNT(*) *100,2),"%")
   AS Attrition_Rate
FROM hr_merged
GROUP BY Department
ORDER BY Attrition_Rate DESC;

------------------ AVG HOURLY RATE --------- (KPI 2)

Select 
CONCAT("₹",(ROUND(AVG(HourlyRate),2))) as Avg_hourly_rate_for_male_reserach_scientist
from hr_merged
where gender = "Male"
and Jobrole like '%Research Scientist%';

----------- ATTRITION VS INCOME STATS ------ KPI(3)
select 
case
when MonthlyIncome < 5000 then "Low"
when MonthlyIncome >=15000 then "Medium"
ELSE "High"
END as Income_slab,
count(*) AS Total,
sum(case when attrition = "Yes" then 1 else 0 end) as Attrition,
CONCAT(ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(EmployeeNumber)) * 100, 2), '%') AS Attrition_rate,
ROUND(AVG(MonthlyIncome), 2) AS avg_income
FROM hr_merged
group by income_slab
order by income_slab;

----------- AVG WORKING YEARS FOR EACH DEPARTMENT------- (KPI -4)
Select 
department,
count(*) as Total,
Round(avg(YearsAtCompany),2) as Avg_year_at_company,
Round(avg(TotalWorkingYears),2) as Total_working_years
from hr_merged
group by department
order by Avg_year_at_company;

------------------ JOB ROLE VS WORK LIFE BALANCE ----------
Select 
JobRole, 
WorkLifeBalance, 
count(*) as cnt,
Concat(ROUND(SUM(CASE when attrition ="Yes" then 1 else 0 end) / count(JobRole)*100,2),'%')
 as Attrition_rate
from hr_merged
group by Jobrole, WorklifeBalance
order by Jobrole,WorklifeBalance;
------------------ OR ----------------------
### Answer 
select JobRole, 
    AVG(WorkLifeBalance) AS Average_WorkLifeBalance from hr_merged
    Group by JobRole;

----------- ATTRITION RATE VS SINCE LAST YEAR PROMOTION ------------ 

SELECT
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN '0 years'
        WHEN YearsSinceLastPromotion BETWEEN 1 AND 2 THEN '1-2 years'
        WHEN YearsSinceLastPromotion BETWEEN 3 AND 5 THEN '3-5 years'
        WHEN YearsSinceLastPromotion BETWEEN 6 AND 10 THEN '6-10 years'
        ELSE '10+ years'
    END AS PromotionGap,
    COUNT(*) AS TotalEmployees,
    concat(ROUND(SUM(CASE when attrition ="Yes" then 1 else 0 end) / count(JobRole)*100,2),'%') AS Attrition_rate
FROM hr_merged
GROUP BY
    PromotionGap
ORDER BY
    MIN(YearsSinceLastPromotion);
    
    
    -----------------------------------------------
    select department,round(avg(department),2) as Avg_Working_department from hr_merged
    group by department;
