USE AdventureWorks2012
GO

-- TASK 1
ALTER TABLE dbo.Employee
ADD Name nvarchar(60);

GO
-- TASK 2
DECLARE @Employee TABLE
	(	
		BusinessEntityID int NOT NULL,
		NationalIDNumber nvarchar(15) NOT NULL,
		LoginID nvarchar(256) NOT NULL,
		JobTitle nvarchar(50) NOT NULL,
		BirthDate date NOT NULL,
		MaritalStatus nvarchar(1) NULL,
		Gender nchar(1) NOT NULL,
		HireDate date NOT NULL,
		VacationHours smallint NOT NULL,
		SickLeaveHours smallint NOT NULL,
		ModifiedDate datetime NOT NULL,
		Name nvarchar(60) NULL
	);

INSERT INTO @Employee
	(
		BusinessEntityID,
		NationalIDNumber,
		LoginID,
		JobTitle,
		BirthDate,
		MaritalStatus,
		Gender,
		HireDate,
		VacationHours,
		SickLeaveHours,
		ModifiedDate,
		Name
	)
SELECT
	dbo.Employee.BusinessEntityID,
	NationalIDNumber,
	LoginID,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	HireDate,
	VacationHours,
	SickLeaveHours,
	dbo.Employee.ModifiedDate,
	CASE WHEN Person.Person.Title IS NULL THEN
		CONCAT('M. ', Person.Person.FirstName)
	ELSE
		CONCAT(Person.Person.Title, ' ', Person.Person.FirstName)
	END
FROM dbo.Employee
INNER JOIN Person.Person
ON Person.BusinessEntityID = dbo.Employee.BusinessEntityID;

-- TASK 3
UPDATE dbo.Employee
SET 
	Name = empl.Name
FROM dbo.Employee
INNER JOIN @Employee empl
ON empl.BusinessEntityID = dbo.Employee.BusinessEntityID;

-- TASK 4
DELETE FROM dbo.Employee
WHERE BusinessEntityID IN 
	(
		SELECT BusinessEntityID 
		FROM HumanResources.EmployeeDepartmentHistory 
		GROUP BY BusinessEntityID 
		HAVING COUNT(*) > 1
	);
	
GO
	
-- TASK 5
ALTER TABLE dbo.Employee
DROP COLUMN Name;
DECLARE @SQL NVARCHAR(200) = '';

SELECT  @SQL += 'ALTER TABLE dbo.Employee DROP CONSTRAINT ' + constraints.CONSTRAINT_NAME + ';'
FROM AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE as constraints
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Employee';

print(@SQL)
execute(@SQL)

