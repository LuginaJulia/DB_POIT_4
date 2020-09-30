USE AdventureWorks2012;
GO

-- TASK 1
CREATE TABLE dbo.Employee
	(
		BusinessEntityID int NOT NULL,
		NationalIDNumber nvarchar(15) NOT NULL,
		LoginID nvarchar(256) NOT NULL,
		JobTitle nvarchar(50) NOT NULL,
		BirthDate date NOT NULL,
		MaritalStatus nchar(1) NOT NULL,
		Gender nchar(1) NOT NULL,
		HireDate date NOT NULL,
		VacationHours smallint NOT NULL,
		SickLeaveHours smallint NOT NULL,
		ModifiedDate datetime NOT NULL
	);

-- TASK 2
ALTER TABLE dbo.Employee
	ADD ID bigint IDENTITY(0,2)
		CONSTRAINT PK_Employee PRIMARY KEY(ID);

-- TASK 3
ALTER TABLE dbo.Employee
	ADD CONSTRAINT ch_BirthDate 
		CHECK(BirthDate <= GETDATE() AND BirthDate >= '1900-01-01');

-- TASK 4
ALTER TABLE dbo.Employee
	ADD CONSTRAINT df_HireDate 
		DEFAULT GETDATE() FOR HireDate;

-- TASK 5

INSERT INTO dbo.Employee(
	BusinessEntityID,
	NationalIDNumber,
	LoginID,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	VacationHours,
	SickLeaveHours,
	ModifiedDate)
SELECT
	HumanResources.Employee.BusinessEntityID,
	NationalIDNumber,
	LoginID,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	VacationHours,
	SickLeaveHours,
	HumanResources.Employee.ModifiedDate
FROM HumanResources.Employee
	JOIN Person.Person
	ON HumanResources.Employee.BusinessEntityID = Person.Person.BusinessEntityID
WHERE Person.Person.EmailPromotion = 0;

-- TASK 6
ALTER TABLE dbo.Employee
ALTER COLUMN MaritalStatus nvarchar(1) NULL;