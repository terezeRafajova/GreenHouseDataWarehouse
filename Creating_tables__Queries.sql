
/*CREATING TABLES*/
use GreenhouseDB;

CREATE TABLE Accounts
(
   email varchar (50) PRIMARY KEY,
   password varchar (50)
);

CREATE TABLE Greenhouses
(
    Id_Greenhouse int NOT NULL Identity(1,1) PRIMARY KEY,
    name varchar (50),
    description varchar (200),
    location varchar (50),
    area DECIMAL (3,2),
    co2Preferred DECIMAL (3,2),
    temperaturePreferred DECIMAL (2,1),
    humidityPreferred DECIMAL (3,1),
	actuator BIT DEFAULT 0,
	owner varchar(50)

    FOREIGN KEY (owner) REFERENCES Accounts(email));


CREATE TABLE Logs
(
 Id_Log int NOT NULL Identity(1,1) PRIMARY KEY ,
 co2 DECIMAL (3,1),
 temperature DECIMAL (2,1) ,
 humidity DECIMAL (3,1) ,
 date  DATETIME,
 Id_Greenhouse int

FOREIGN KEY (Id_Greenhouse) REFERENCES Greenhouses(Id_Greenhouse));


CREATE TABLE Plants
(
Id_Plant int NOT NULL Identity(1,1) PRIMARY KEY ,
name varchar (50),
description varchar (200),
type varchar(50),
scientificName varchar (100),
Id_Greenhouse int

FOREIGN KEY (Id_Greenhouse) REFERENCES Greenhouses(Id_Greenhouse));


CREATE TABLE Routines
(
    Id_Rouetine int NOT NULL Identity(1,1) PRIMARY KEY,
	day varchar(10),
	task varchar(50),
	Id_Plant int
FOREIGN KEY (Id_Plant) REFERENCES Plants(Id_Plant));

ALTER TABLE Plants
ADD Type varchar(30);

/*
DROP TABLE dbo.Greenhouses;
DROP TABLE dbo.Accounts, dbo.Checklists, dbo.Logs, dbo.Plants;*/

/*_______________________QUERIES_______________________*/

/*__________________GET ALL GREENHOUSES__________________*/
SELECT * FROM [dbo].[Greenhouses]
WHERE [dbo].[Greenhouses].[owner] = '';

/*GET GREENHOUSE*/
SELECT * FROM [dbo].[Greenhouses]
WHERE [Id_Greenhouse] = '';

/*UPDATE GREENHOUSE*/
UPDATE [Greenhouses]
SET name= '',
	description= '',
	location = '',
	area = '',
	co2Preferred = '',
	temperaturePreferred = '',
	humidityPreferred = ''
	WHERE Id_Greenhouse = '';

/*CREATE GREENHOUSE*/
INSERT INTO [Greenhouses]
VALUES('','','','','','','');

/*REMOVE GREENHOUSE*/
DELETE FROM [Greenhouses]
WHERE [Id_Greenhouse] = '';

/*__________________GET ALL PLANTS FROM GREENHOUSE__________________*/
SELECT * FROM [dbo].[Plants]
WHERE [Plants].[Id_Greenhouse] = '';

/*UPDATE PLANT*/
UPDATE [Plants]
SET name = '',
	description = '',
	scientificName = ''
WHERE [Plants].[Id_Plant] = '';

/*CREATE PLANT*/
INSERT INTO [dbo].[Plants]
VALUES ('','','','','');

/*REMOVE PLANT*/
DELETE FROM [dbo].[Plants]
WHERE [dbo].[Plants].[Id_Plant] = '';

/*__________________GET ALL LOGS FROM GREENHOUSE__________________*/
SELECT * FROM [dbo].[Logs]
WHERE [dbo].[Logs].[Id_Greenhouse] = '';

/*GET LAST LOG FROM GREENHOUSE*/
SELECT TOP 1 * FROM [dbo].[Logs] WHERE Id_Greenhouse = '' ORDER BY [Id_Log] DESC;
/*OR		(idk which one works better)*/
SELECT * FROM  [dbo].[Logs] WHERE [Id_Log] = (SELECT MAX(Id_Log) FROM [dbo].[Logs]) AND Id_Greenhouse = '';

/*GET LOG*/
SELECT * FROM [dbo].[Logs]
WHERE [dbo].[Logs].[Id_Log] = '';

/*__________________SET ACTUATOR TRUE__________________*/
UPDATE [dbo].[Greenhouses]
SET actuator = 1
WHERE [Greenhouses].[Id_Greenhouse] = '';

/*__________________CREATE ROUTINE__________________*/

/*UPDATE ROUTINE*/

/*REMOVE ROUTINE*/
