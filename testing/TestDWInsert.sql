use TestDW
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
FROM [TestDB].[dbo].[Greenhouses]

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
FROM [TestDB].[dbo].[Logs]
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
FROM [TestDB].[dbo].[Greenhouses] gh
inner join [TestDB].[dbo].Logs l
on gh.Id_Greenhouse=l.Id_Greenhouse




insert into [edw].[DimGreenhouse]
([Greenhouse_Id]
,[Name]
,[Description]
,[Location]
,[CO2Preferred]
,[TemperaturePreferred]
,[HumidityPreferred])
SELECT 
 [Greenhouse_Id]
,[Name]
,[Description]
,[Location]
,[CO2Preferred]
,[TemperaturePreferred]
,[HumidityPreferred]
FROM [TestDW].[stage].[DimGreenhouse]

truncate table [edw].[DimDevice]
insert into [edw].[DimDevice]
([Device_Id]
,[D_ID]
,[Min_Temp]
,[Max_Temp]
,[Avrg_Temp]
,[Min_Hum]
,[Max_Hum]
,[Avrg_Hum]
,[Min_CO2]
,[Max_CO2]
,[Avrg_CO2])
SELECT
[Device_Id],
d.[D_ID],
[Min_Temp],
[Max_Temp],
[Avrg_Temp],
[Min_Hum],
[Max_Hum],
[Avrg_Hum],
[Min_CO2],
[Max_CO2],
[Avrg_CO2]
from [TestDW].[stage].[DimDevice] dd
inner join [edw].[DimDate] as d
on d.Date= dd.Date

truncate table [edw].[FactMeasurement]
insert into [edw].[FactMeasurement]
([GH_ID]
,[DE_ID]
,[D_ID]
,[T_ID]
,[TempValue]
,[HumValue]
,[CO2Value])
SELECT
 [GH_ID]
,de.[DE_ID]
,d.[D_ID]
,t.[T_ID]
,[TempValue]
,[HumValue]
,[CO2Value]
from [TestDW].[stage].FactMeasurement fm
inner join [TestDW].[edw].[DimGreenhouse] gh
on gh.Greenhouse_Id = fm.Greenhouse_Id
inner join [TestDW].[edw].[DimDate] as d
on d.Date = CONVERT(DATE, fm.[Date])
inner join [TestDW].[edw].[DimTime] as t
on (datepart(minute, t.Time) = datepart(minute, fm.Date)) and (datepart(hour, t.Time) = datepart(hour, fm.Date))
inner join [TestDW].[edw].[DimDevice] de
on  de.Device_Id=fm.Device_Id and de.D_Id = CONVERT(Char(8), fm.Date, 112)