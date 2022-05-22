use GreenHouseDW
go

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
FROM [GreenhouseDW].[stage].[DimGreenhouse]


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
from [GreenhouseDW].[stage].[DimDevice] dd
inner join [edw].[DimDate] as d
on d.Date= dd.Date

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
on datepart(minute, t.Time) = datepart(minute, fm.Date);