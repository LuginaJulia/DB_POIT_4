/*
Создайте хранимую процедуру, которая будет возвращать сводную таблицу 
(оператор PIVOT), 
отображающую данные об итоговой сумме продаж за каждый год 
(Sales.SalesOrderHeader.OrderDate)
 по определенному региону (Sales.SalesTerritory.CountryRegionCode). 
 Список регионов передайте в процедуру через входной параметр.
*/

USE AdventureWorks2012;
GO

CREATE PROCEDURE dbo.SalesByRegions(@Regions NVARCHAR(255)) AS
	DECLARE @Query AS NVARCHAR(1024);
	SET @Query= '
	SELECT OrderYear, ' +
		@Regions
	+ 'FROM 
	(
		SELECT
			t.CountryRegionCode AS region,
			YEAR(header.OrderDate) AS OrderYear,
			header.TotalDue
		FROM Sales.SalesOrderHeader AS header
		JOIN Sales.SalesTerritory AS t ON header.TerritoryID = t.TerritoryID
		JOIN Sales.SalesOrderDetail AS d ON header.SalesOrderID = d.SalesOrderID
	) AS data
	PIVOT
	(
		SUM(data.TotalDue) FOR data.region in (' + @Regions + ')
	) AS pvt
	'
	EXECUTE sp_executesql @Query;
GO

EXECUTE dbo.SalesByRegions'[AU],[CA],[DE],[FR],[GB],[US]'