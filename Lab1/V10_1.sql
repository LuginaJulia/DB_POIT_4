CREATE DATABASE Julia_Lugina;

USE Julia_Lugina;
GO
CREATE SCHEMA sales;
GO
CREATE SCHEMA persons;
GO
CREATE TABLE sales.Orders(OrderNum INT NULL);

BACKUP DATABASE Julia_Lugina TO DISK='F:\Julia_Lugina.bak';

USE master;
DROP DATABASE Julia_Lugina;

RESTORE DATABASE Julia_Lugina FROM DISK='F:\Julia_Lugina.bak';