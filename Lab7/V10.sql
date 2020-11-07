USE AdventureWorks2012
GO

DECLARE @xml XML

SET @xml = (
    SELECT	TOP(100)
			person.FirstName AS FirstName,
			person.LastName AS LastName,
			[password].ModifiedDate AS 'Password/Date',
			[password].BusinessEntityID AS 'Password/ID'
    FROM	Person.Person AS person
	JOIN	Person.[Password] AS [password]
	ON		[password].BusinessEntityID = person.BusinessEntityID
    FOR XML
        PATH ('Person'),
		ROOT ('Persons')
)

SELECT @xml

GO

CREATE TABLE dbo.#PasswordXML
(
	[sql] xml
);

INSERT INTO dbo.#PasswordXML
SELECT
	MY_XML.[Password].query('.')
FROM @xml.nodes('Persons/Person/Password') AS MY_XML ([Password])
SELECT * FROM dbo.#PasswordXML;