USE TestDB
GO

set identity_insert [dbo].[Greenhouses] on
TRUNCATE TABLE dbo.Greenhouses;
INSERT INTO [dbo].[Greenhouses]
           ([Id_Greenhouse],
			[name],
			[description],
			[location],
			[area],
			[co2Preferred],
			[temperaturePreferred],
			[humidityPreferred],
			[actuator],
			[owner])
SELECT [Id_Greenhouse],
			[name],
			[description],
			[location],
			[area],
			[co2Preferred],
			[temperaturePreferred],
			[humidityPreferred],
			[actuator],
			[owner]
FROM GreenHouse.dbo.Greenhouses
WHERE Id_Greenhouse = 1
GO
set identity_insert [dbo].[Greenhouses] off


set identity_insert [dbo].[Logs] on
TRUNCATE TABLE dbo.Logs
INSERT INTO [dbo].[Logs]
           ([Id_Log],
			[co2],
			[temperature],
			[humidity],
			[date],
			[Id_Greenhouse])
SELECT [Id_Log],
			[co2],
			[temperature],
			[humidity],
			[date],
			[Id_Greenhouse]
			3+
FROM GreenHouse.dbo.Logs
WHERE Id_Greenhouse = 1 and Id_Log%6 = 2
GO
set identity_insert [dbo].[Logs] off
