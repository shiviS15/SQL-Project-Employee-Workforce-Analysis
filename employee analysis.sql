CREATE DATABASE Employee_Analysis;

USE Employee_Analysis;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    Department VARCHAR(50),
    JobTitle VARCHAR(50),
    Salary DECIMAL(10,2),
    ExperienceYears INT,
    City VARCHAR(50),
    HireDate DATE,
    PerformanceRating INT,
    Bonus DECIMAL(10,2),
    EmploymentStatus VARCHAR(20)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Downloads/Employee_Dataset.csv"
INTO TABLE Employees
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(EmployeeID,
 FirstName,
 LastName,
 Gender,
 Age,
 Department,
 JobTitle,
 Salary,
 ExperienceYears,
 City,
 HireDate,
 PerformanceRating,
 Bonus,
 EmploymentStatus);

Step 1 : Data Exploration
1 Total Employees
SELECT COUNT(*) AS TotalEmployees
FROM Employees;

-- 2 Number of Columns
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='Employees';

-- 3 Preview Dataset
SELECT *
FROM Employees
LIMIT 10;

-- 4 Distinct Departments
SELECT DISTINCT Department
FROM Employees;

5 Distinct Cities
SELECT DISTINCT City
FROM Employees;

6 Employee Status
SELECT DISTINCT EmploymentStatus
FROM Employees;

Step 2 : Data Cleaning
Missing Values
SELECT *
FROM Employees
WHERE Salary IS NULL
OR Department IS NULL
OR Age IS NULL;

Duplicate Employees
SELECT EmployeeID,
COUNT(*)
FROM Employees
GROUP BY EmployeeID
HAVING COUNT(*)>1;

Negative Salary
SELECT *
FROM Employees
WHERE Salary<0;

Invalid Age
SELECT *
FROM Employees
WHERE Age<18
OR Age>70;

Step 3 : Basic EDA
Employees by Department
SELECT Department,
COUNT(*) Employees
FROM Employees
GROUP BY Department
ORDER BY Employees DESC;

Employees by City
SELECT City,
COUNT(*) Employees
FROM Employees
GROUP BY City
ORDER BY Employees DESC;

Gender Distribution
SELECT Gender,
COUNT(*) Employees
FROM Employees
GROUP BY Gender;

Average Salary
SELECT ROUND(AVG(Salary),2) AverageSalary
FROM Employees;

Highest Salary
SELECT MAX(Salary)
FROM Employees;

Lowest Salary
SELECT MIN(Salary)
FROM Employees;

Second-highest salary
SELECT MAX(Salary) AS SecondHighestSalary
FROM Employees
WHERE Salary < (
    SELECT MAX(Salary)
    FROM Employees
);

Salary Range
SELECT
MIN(Salary),
MAX(Salary)
FROM Employees;

Step 4 : Department Analysis
Average Salary by Department
SELECT Department,
ROUND(AVG(Salary),2) AvgSalary
FROM Employees
GROUP BY Department
ORDER BY AvgSalary DESC;

Highest Paid Employee in Each Department
SELECT Department,
MAX(Salary) HighestSalary
FROM Employees
GROUP BY Department;

Total Salary Expense
SELECT Department,
SUM(Salary) SalaryExpense
FROM Employees
GROUP BY Department;

Average Bonus
SELECT Department,
ROUND(AVG(Bonus),2)
FROM Employees
GROUP BY Department;

Step 5 : Performance Analysis
Average Performance Rating
SELECT ROUND(AVG(PerformanceRating),2)
FROM Employees;

Employees with Rating 5
SELECT *
FROM Employees
WHERE PerformanceRating=5;

Department-wise Performance
SELECT Department,
ROUND(AVG(PerformanceRating),2) AvgRating
FROM Employees
GROUP BY Department
ORDER BY AvgRating DESC;

Step 6 : Experience Analysis
Average Experience
SELECT ROUND(AVG(ExperienceYears),2)
FROM Employees;

Most Experienced Employee
SELECT *
FROM Employees
ORDER BY ExperienceYears DESC
LIMIT 1;

Employees with More Than 10 Years Experience
SELECT *
FROM Employees
WHERE ExperienceYears>10;

Step 7 : Hiring Analysis
Employees Joined Each Year
SELECT YEAR(HireDate) HireYear,
COUNT(*) Employees
FROM Employees
GROUP BY YEAR(HireDate)
ORDER BY HireYear;

Employees Joined Each Month
SELECT MONTH(HireDate) HireMonth,
COUNT(*) Employees
FROM Employees
GROUP BY MONTH(HireDate);

Step 8 : Salary Analysis
Top 10 Highest Paid Employees
SELECT *
FROM Employees
ORDER BY Salary DESC
LIMIT 10;

Bottom 10 Salaries
SELECT *
FROM Employees
ORDER BY Salary
LIMIT 10;

Employees Above Average Salary
SELECT *
FROM Employees
WHERE Salary>(
SELECT AVG(Salary)
FROM Employees);

Second Highest Salary
SELECT MAX(Salary)
FROM Employees
WHERE Salary<
(
SELECT MAX(Salary)
FROM Employees
);

Third Highest Salary
SELECT DISTINCT Salary
FROM Employees
ORDER BY Salary DESC
LIMIT 1 OFFSET 2;

Step 9 : Attrition Analysis
Active vs Resigned
SELECT EmploymentStatus,
COUNT(*) Employees
FROM Employees
GROUP BY EmploymentStatus;

Attrition by Department
SELECT Department,
COUNT(*) Employees
FROM Employees
WHERE EmploymentStatus='Resigned'
GROUP BY Department;

Window Function
SELECT EmployeeID,
Department,
Salary,
RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) SalaryRank
FROM Employees;

Salary Percentage of Department
SELECT EmployeeID,
Department,
Salary,
ROUND(
Salary*100/
SUM(Salary) OVER(PARTITION BY Department),2
) Percentage
FROM Employees;

