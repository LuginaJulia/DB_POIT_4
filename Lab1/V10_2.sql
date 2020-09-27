USE AdventureWorks2012

-- Task 1
SELECT SUM(OrganizationLevel) as 'EmpCount'
FROM HumanResources.Employee
WHERE OrganizationLevel = 3;

-- Task 2
SELECT DISTINCT GroupName
FROM HumanResources.Department;

-- Task 3
SELECT DISTINCT TOP 10 
	JobTitle,
	CASE WHEN PATINDEX('% %', JobTitle) != ' ' THEN 
		REVERSE(SUBSTRING(REVERSE(JobTitle), 1, PATINDEX('% %', REVERSE(JobTitle)) - 1)) 
	ELSE JobTitle 
	END AS LastWord
FROM HumanResources.Employee
ORDER BY JobTitle