USE AdventureWorks2012;
GO

-- TASK 1
ALTER TABLE dbo.Employee
ADD SumSubTotal MONEY;

ALTER TABLE dbo.Employee
ADD LeaveHours AS VacationHours + SickLeaveHours;

-- TASK 2
CREATE TABLE #Employee
	(
		ID INT IDENTITY PRIMARY KEY,
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
		ModifiedDate datetime NOT NULL,
		SumSubTotal MONEY
	);

-- TASK 3
WITH Purchasing_CTE(EmployeeID, SubTotal)
AS
(
	SELECT EmployeeID, COUNT(*) SubTotal
	FROM Purchasing.PurchaseOrderHeader
	GROUP BY EmployeeID
)
INSERT INTO #Employee
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
		SumSubTotal
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
	Purchasing_CTE.SubTotal
FROM dbo.Employee
JOIN Purchasing_CTE 
	ON Purchasing_CTE.EmployeeID = Employee.ID;


-- TASK 4
DELETE FROM dbo.Employee
WHERE LeaveHours > 160


-- TASK 5
MERGE dbo.Employee AS t_target
USING #Employee AS t_source
ON t_target.ID = t_source.ID
WHEN MATCHED THEN UPDATE SET
	t_target.SumSubTotal = t_source.SumSubTotal
WHEN NOT MATCHED BY TARGET THEN INSERT
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
		SumSubTotal
	)
VALUES
	(
		t_source.BusinessEntityID,
		t_source.NationalIDNumber,
		t_source.LoginID,
		t_source.JobTitle,
		t_source.BirthDate,
		t_source.MaritalStatus,
		t_source.Gender,
		t_source.HireDate,
		t_source.VacationHours,
		t_source.SickLeaveHours,
		t_source.ModifiedDate,
		t_source.SumSubTotal
	)
WHEN NOT MATCHED BY SOURCE THEN DELETE;