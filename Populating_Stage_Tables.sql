use GreenhouseDW
go

truncate table [stage].[DimGreenhouse]
insert into [stage].[DimGreenhouse]
(Greenhouse_Id
,[Name]
,[Description]
,[Location]
,[CO2Preferred]
,[TemperaturePreferred]
,[HumidityPreferred])
SELECT
[Id_Greenhouse]
      ,[name]
      ,[description]
      ,[location]
      ,[co2Preferred]
      ,[temperaturePreferred]
      ,[humidityPreferred]
FROM [GreenHouse].[dbo].[Greenhouses]

truncate table [stage].[DimDevice]
insert into [stage].[DimDevice]
(
[Device_Id],
[Date],
[Min_Temp],
[Max_Temp],
[Avrg_Temp],
[Min_Hum],
[Max_Hum],
[Avrg_Hum],
[Min_CO2],
[Max_CO2],
[Avrg_CO2])
SELECT
[Id_Greenhouse],
CONVERT(DATE, [date]),
MIN(temperature),
MAX(temperature),
AVG(temperature),
MIN(humidity),
MAX(humidity),
AVG(humidity),
MIN(co2),
MAX(co2),
AVG(co2)
FROM [GreenHouse].[dbo].[Logs]
group by CONVERT(DATE, [date]), Id_Greenhouse;


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
FROM [GreenHouse].[dbo].[Greenhouses] gh
inner join [GreenHouse].[dbo].Logs l
on gh.Id_Greenhouse=l.Id_Greenhouse