/*
Создайте scalar-valued функцию, которая будет принимать 
в качестве входного параметра id для типа телефонного номера
 (Person.PhoneNumberType.PhoneNumberTypeID) 
и возвращать количество телефонов указанного типа 
(Person.PersonPhone).

*/

USE AdventureWorks2012;
GO

CREATE FUNCTION Person.GetPersonPhoneCountByPhoneType(@TypeID INT)
RETURNS INT AS
BEGIN
	DECLARE @returnValue INT;
	SELECT @returnValue = COUNT(*) FROM Person.PersonPhone WHERE Person.PersonPhone.PhoneNumberTypeID = @TypeID;
	RETURN (@returnValue);
END;
GO

SELECT Person.GetPersonPhoneCountByPhoneType(2);

/*
Создайте inline table-valued функцию, которая будет принимать 
в качестве входного параметра id для типа телефонного номера
 (Person.PhoneNumberType.PhoneNumberTypeID),
а возвращать список сотрудников из Person.Person 
(сотрудники обозначены как PersonType = ‘EM’),
 телефонный номер которых принадлежит к указанному типу.
*/

CREATE FUNCTION Person.GetEmployesByPhoneType(@TypeID INT)
RETURNS TABLE AS
RETURN
(
	SELECT Person.Person.* 
	FROM Person.Person
	JOIN Person.PersonPhone ON Person.BusinessEntityID = PersonPhone.BusinessEntityID
	WHERE (Person.Person.PersonType = 'EM') AND (Person.PersonPhone.PhoneNumberTypeID = @TypeID)
);
GO

SELECT * FROM Person.GetEmployesByPhoneType(1)

/*
Вызовите функцию для каждого типа телефонного номера,
 применив оператор CROSS APPLY. 
Вызовите функцию для каждого типа телефонного номера,
 применив оператор OUTER APPLY.
*/

SELECT * FROM Person.PhoneNumberType AS numberType 
CROSS APPLY Person.GetEmployesByPhoneType(numberType.PhoneNumberTypeID);

SELECT * FROM Person.PhoneNumberType AS numberType 
OUTER APPLY Person.GetEmployesByPhoneType(numberType.PhoneNumberTypeID);

/*
Измените созданную inline table-valued функцию, сделав ее multistatement table-valued 
(предварительно сохранив для проверки код создания inline table-valued функции).
*/

DROP FUNCTION Person.GetEmployesByPhoneType;
GO

CREATE FUNCTION Person.GetEmployeesByPhoneType(@TypeID INT)
RETURNS @result TABLE (
	[BusinessEntityID] [int] NOT NULL,
	[PersonType] [nvarchar](2) NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Suffix] [nvarchar](10) NULL,
	[EmailPromotion] [int] NOT NULL) AS
BEGIN
	INSERT INTO @result
	SELECT 
		e.BusinessEntityID,
		e.PersonType,
		e.Title,
		e.FirstName,
		e.MiddleName,
		e.LastName,
		e.Suffix,
		e.EmailPromotion
	FROM Person.Person AS e
	JOIN Person.PersonPhone ON e.BusinessEntityID = PersonPhone.BusinessEntityID
	WHERE (e.PersonType = 'EM') AND (Person.PersonPhone.PhoneNumberTypeID = @TypeID)
	RETURN
END;
GO

SELECT * FROM  Person.GetEmployeesByPhoneType(1)
GO