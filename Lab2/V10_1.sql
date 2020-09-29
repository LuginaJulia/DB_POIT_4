USE AdventureWorks2012

-- Task 1
SELECT 
	employee.BusinessEntityID,
	employee.JobTitle,
	ROUND(Rate, 0) AS RoundRate,
	Rate
FROM HumanResources.Employee employee
JOIN HumanResources.EmployeePayHistory
	ON employee.BusinessEntityID = HumanResources.EmployeePayHistory.BusinessEntityID;

-- Task 2
SELECT 
	Employee.BusinessEntityID,
	Employee.JobTitle,
	EmployeePayHistory.Rate,
	DENSE_RANK() OVER(ORDER BY EmployeePayHistory.ModifiedDate) AS ChangeNumber,	
	EmployeePayHistory.ModifiedDate
FROM HumanResources.EmployeePayHistory
LEFT JOIN HumanResources.Employee
	ON Employee.BusinessEntityID = EmployeePayHistory.BusinessEntityID
ORDER BY EmployeePayHistory.BusinessEntityID;

-- TASK 3
SELECT 
	Name,
	JobTitle,
	HireDate,
	BirthDate
FROM HumanResources.EmployeeDepartmentHistory AS h
INNER JOIN HumanResources.Employee AS e
	ON e.BusinessEntityID = h.BusinessEntityID
INNER JOIN HumanResources.Department AS d
	ON d.DepartmentID = h.DepartmentID
ORDER BY 
	JobTitle, 
	CASE WHEN CHARINDEX(' ', JobTitle) > 0  THEN
		BirthDate
	ELSE 
		HireDate
	END DESC;