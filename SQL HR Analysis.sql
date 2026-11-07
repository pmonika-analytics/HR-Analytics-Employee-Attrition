CREATE DATABASE HR_Analytics;

USE HR_Analytics;

SELECT * 
FROM hr_data
LIMIT 10;

SELECT COUNT(*) 
FROM hr_data;

-- Query 1: Total Employees, Attrition Count & Attrition Rate
SELECT
    COUNT(*) AS Total_Employees,

    SUM(CASE
        WHEN Attrition = 'Yes' THEN 1
        ELSE 0
    END) AS Attrition_Count,

    SUM(CASE
        WHEN Attrition = 'No' THEN 1
        ELSE 0
    END) AS Active_Employees,

    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS Attrition_Rate

FROM hr_data;

-- Query 2: Department-wise Attrition

SELECT
    Department,
    COUNT(*) AS Total_Employees,

    SUM(CASE
        WHEN Attrition = 'Yes' THEN 1
        ELSE 0
    END) AS Employees_Left,

    ROUND(
        AVG(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END)
        * 100, 2
    ) AS Attrition_Rate

FROM hr_data
GROUP BY Department
ORDER BY Attrition_Rate DESC;

-- Query 3: Overtime vs Attrition
SELECT
    OverTime,
    COUNT(*) AS Total_Employees,

    SUM(CASE
        WHEN Attrition = 'Yes' THEN 1
        ELSE 0
    END) AS Employees_Left,

    ROUND(
        AVG(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END)
        * 100, 2
    ) AS Attrition_Rate

FROM hr_data
GROUP BY OverTime;

-- Query 4: Age Group vs Attrition
SELECT
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56-65'
    END AS Age_Group,

    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
    AS Employees_Left,

    ROUND(
        AVG(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END)*100,
        2
    ) AS Attrition_Rate

FROM hr_data
GROUP BY Age_Group
ORDER BY Attrition_Rate DESC;

-- Query 5: Job Satisfaction vs Attrition
SELECT
    JobSatisfaction,
    COUNT(*) AS Total_Employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
    AS Employees_Left,

    ROUND(
        AVG(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END)*100,
        2
    ) AS Attrition_Rate

FROM hr_data
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- Query 6: Salary Comparison
SELECT
    Attrition,
    COUNT(*) AS Employee_Count,
    ROUND(AVG(MonthlyIncome), 2) AS Average_Salary,
    MAX(MonthlyIncome) AS Maximum_Salary,
    MIN(MonthlyIncome) AS Minimum_Salary

FROM hr_data
GROUP BY Attrition;

-- Query 7: Top 5 Job Roles by Attrition
SELECT
    JobRole,
    COUNT(*) AS Employees_Left

FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY JobRole
ORDER BY Employees_Left DESC
LIMIT 5;

-- Query 8: Employee Salary Ranking – Window Function
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,

    RANK() OVER(
        PARTITION BY Department
        ORDER BY MonthlyIncome DESC
    ) AS Salary_Rank

FROM hr_data;

--  Department wise analysis
WITH Department_Analysis AS
(
    SELECT
        Department,
        COUNT(*) AS Total_Employees,

        SUM(
            CASE WHEN Attrition = 'Yes'
            THEN 1 ELSE 0 END
        ) AS Employees_Left

    FROM hr_data
    GROUP BY Department
)

SELECT
    Department,
    Total_Employees,
    Employees_Left,

    ROUND(
        Employees_Left * 100.0 / Total_Employees, 2
    ) AS Attrition_Rate

FROM Department_Analysis
ORDER BY Attrition_Rate DESC;

















