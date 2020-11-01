USE AdventureWorks2012
GO

-- TASK 1
CREATE VIEW Sales.vReason(
	ReasonID,
	salesReasonName,
	salesReasonReasonType,
	salesReasonModifiedDate,
	SalesOrderID,
	headerSalesReasonModifiedDate,
	customerID
)
WITH SCHEMABINDING,
ENCRYPTION
AS
SELECT
	salesReason.SalesReasonID AS ReasonID,
	salesReason.Name AS salesReasonName,
	salesReason.ReasonType AS salesReasonReasonType,
	salesReason.ModifiedDate AS salesReasonModifiedDate,
	headerSalesReason.SalesOrderID AS SalesOrderID,
	headerSalesReason.ModifiedDate AS headerSalesReasonModifiedDate,
	salesOrderHeader.CustomerID AS customerID
FROM Sales.SalesReason AS salesReason
JOIN Sales.SalesOrderHeaderSalesReason AS headerSalesReason
ON salesReason.SalesReasonId = headerSalesReason.SalesReasonId
JOIN Sales.SalesOrderHeader AS salesOrderHeader
ON headerSalesReason.SalesOrderID = salesOrderHeader.SalesOrderID;

CREATE UNIQUE CLUSTERED INDEX IX_vReason
ON Sales.vReason(ReasonID, SalesOrderID);