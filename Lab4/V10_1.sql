USE AdventureWorks2012
GO

-- TASK 1
CREATE TABLE Sales.SalesReasonHst(
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	Action CHAR(6) NOT NULL CHECK (Action IN('INSERT', 'UPDATE', 'DELETE')),
	ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
	SourceID INT NOT NULL,
	UserName VARCHAR(50) NOT NULL
);

--TASK 2
CREATE TRIGGER Sales.SalesReason_INSERT_UPDATE_DELETE
ON Sales.SalesReason
AFTER UPDATE, INSERT, DELETE AS
	if exists(SELECT * from inserted) and exists (SELECT * from deleted)
	begin
		INSERT INTO Sales.SalesReasonHst(Action, ModifiedDate, SourceID, UserName)
		SELECT 'UPDATE', GETDATE(), upd.SalesReasonID, USER_NAME()
		FROM inserted AS upd;
	end

	If exists (Select * from inserted) and not exists(Select * from deleted)
	begin
		INSERT INTO Sales.SalesReasonHst(Action, ModifiedDate, SourceID, UserName)
		SELECT 'INSERT', GETDATE(), ins.SalesReasonID, USER_NAME()
		FROM inserted AS ins;
	end

	If exists(select * from deleted) and not exists(Select * from inserted)
	begin 
		INSERT INTO Sales.SalesReasonHst(Action, ModifiedDate, SourceID, UserName)
		SELECT 'DELETE', GETDATE(), del.SalesReasonID, USER_NAME()
		FROM deleted AS del;
	end

--TASK 3
CREATE VIEW Sales.vSalesReason
WITH ENCRYPTION
AS 
	SELECT * FROM Sales.SalesReason;
GO

--TASK 4
INSERT INTO Sales.vSalesReason (
	Name,
	ReasonType
)
VALUES ('Example 1', 'Reason Type 1');
GO

UPDATE Sales.vSalesReason SET Name = 'Example 2' WHERE Name = 'Example 1';
GO

DELETE Sales.vSalesReason WHERE Name = 'Example 2';
GO

SELECT * 
FROM Sales.SalesReasonHst;