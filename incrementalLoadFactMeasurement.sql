use GreenHouseDW;
go

Declare @LastLoadDate datetime
SET @LastLoadDate = (select [Date] 
	from [DAI].[edw].[DimDate]
	where D_ID in (select MAX([LastLoadDate]) FROM [et1].[LogUpdate] where [Table] = 'FactMeasurement'));



/*Declare @LastLoadDate datetime
SET @LastLoadDate = (select [Date] 
	from [TestDatabase].[edw].[DimDate]
	where D_ID = 19980505);*/ --Just to test


truncate table [stage].[FactMeasurement]
insert into [stage].[FactMeasurement]
(
[Greenhouse_Id],
[Device_Id],
[Date],
[TempValue],
[HumValue],
[CO2Value]
)
SELECT
gh.[Id_Greenhouse],
gh.[Id_Greenhouse],
l.[Date],
l.[temperature],
l.[humidity],
l.[co2]
FROM [GreenhouseDB].[dbo].[Greenhouses] gh
inner join [GreenhouseDB].[dbo].Logs l
on gh.Id_Greenhouse=l.Id_Greenhouse
where l.date > @LastLoadDate; --only new measurements load to FactMeasurement


INSERT INTO [edw].[FactMeasurement]
	([GH_ID]
	,[DE_ID]
	,[D_ID]
	,[T_ID]
	,[TempValue]
	,[HumValue]
	,[CO2Value])
	SELECT
	 [GH_ID]
	,[DE_ID]
	,d.[D_ID]
	,t.[T_ID]
	,[TempValue]
	,[HumValue]
	,[CO2Value]
	from [GreenhouseDW].[stage].FactMeasurement fm
	inner join [GreenhouseDW].[edw].[DimGreenhouse] gh
	on gh.Greenhouse_Id=fm.Greenhouse_Id
	inner join [GreenhouseDW].[edw].[DimDevice] de
	on  de.Device_Id=fm.Device_Id
	inner join [edw].[DimDate] as d
	on d.Date=fm.Date
	inner join [edw].[DimTime] as t
	on datepart(minute, t.Time) = datepart(minute, fm.Date)
	where gh.ValidTo = 99990101
	and de.ValidTo = 99990101;   ---compering with data in other dimension and getting the ones that are up to date 

