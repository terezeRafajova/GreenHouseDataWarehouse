use GreenhouseDW
go

create schema et1
go

----Create table to know which data is valid ----
create TABLE et1.[LogUpdate](
    [Table] [nvarchar](50) null,
    [LastLoadDate] int null
) on [PRIMARY]

-- just one time, since log table wasnt craetd during initial load, using last date of transaction records in fact sales--
insert into [et1].[LogUpdate] ([Table], [LastLoadDate]) values ('DimGreenhouse', 20220520);
insert into [et1].[LogUpdate] ([Table], [LastLoadDate]) values ('DimDevice', 20220520);
insert into [et1].[LogUpdate] ([Table], [LastLoadDate]) values ('FactMeasurement', 20220520);

--add validfrom and validto into already existing dimensions
alter table [edw].[DimGreenhouse] add ValidFrom int, ValidTo int;
alter table [edw].[DimDevice] add ValidFrom int, ValidTo int;

-- update dimension with validfrom and valitdo(indefinitely in the future because it is still valid)
update [edw].[DimGreenhouse] set ValidFrom = 20220520, ValidTo = 99990101;
update [edw].[DimDevice] set ValidFrom = 20220520, ValidTo = 99990101

/* first we need to update data in stage table so we can compare it with data in edw tables */
/* Load to stage DimGreenhouse */
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

/* Load to stage DimDevice */
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


--Incremental load-----------
---DimGreenhouse--------------------------------------------------------------------------------------------------------------------------------------------
---when just adding ----
declare @LastLoadDate int
set @LastLoadDate = (Select max([LastLoadDate]) FROM [et1].[LogUpdate] where [Table] = 'DimGreenhouse')
declare @NewLoadDate int
set @NewLoadDate = CONVERT(char(8), getdate(),112)
declare @FutureDate int
set @FutureDate = 99990101

insert into [edw].[DimGreenhouse] 
	([Greenhouse_Id]
	,[Name]
	,[Description]
	,[Location]
	,[CO2Preferred]
	,[TemperaturePreferred]
	,[HumidityPreferred]
	,[ValidFrom]
	,[ValidTo])
	SELECT 
	 [Greenhouse_Id]
	,[Name]
	,[Description]
	,[Location]
	,[CO2Preferred]
	,[TemperaturePreferred]
	,[HumidityPreferred]
	,@NewLoadDate
	,@FutureDate
  FROM [GreenhouseDW].[stage].[DimGreenhouse]
  where Greenhouse_Id in (select [Greenhouse_Id]
  from [stage].[DimGreenhouse] except select [Greenhouse_Id]
  from [edw].[DimGreenhouse]
  where validTo = 99990101);

  --when smth changed--
SELECT  --get all records in stage
     [Greenhouse_Id]
	,[Name]
	,[Description]
	,[Location]
	,[CO2Preferred]
	,[TemperaturePreferred]
	,[HumidityPreferred]
	  into #tmp
  FROM [stage].[DimGreenhouse] except select --except the ones already exists 
	  [Greenhouse_Id]
	,[Name]
	,[Description]
	,[Location]
	,[CO2Preferred]
	,[TemperaturePreferred]
	,[HumidityPreferred]
from [edw].[DimGreenhouse]
where validTo = 99990101
-- until here we look for everything that changed, if we want only records that changed and are not new
--we need to add the next part
-- then except new records 
except select   [Greenhouse_Id]
	,[Name]
	,[Description]
	,[Location]
	,[CO2Preferred]
	,[TemperaturePreferred]
	,[HumidityPreferred]
  FROM [stage].[DimGreenhouse]
  where Greenhouse_Id in (select [Greenhouse_Id]
  from [stage].[DimGreenhouse] except select [Greenhouse_Id]
  from [edw].[DimGreenhouse]
  where validTo = 99990101);

 insert into [edw].[DimGreenhouse] 
([Greenhouse_Id]
	,[Name]
	,[Description]
	,[Location]
	,[CO2Preferred]
	,[TemperaturePreferred]
	,[HumidityPreferred]
	,[ValidFrom]
	,[ValidTo])
SELECT [Greenhouse_Id]
	,[Name]
	,[Description]
	,[Location]
	,[CO2Preferred]
	,[TemperaturePreferred]
	,[HumidityPreferred]
	  ,@NewLoadDate
	  ,@FutureDate
  FROM #tmp

  update [edw].[DimGreenhouse]
  set ValidTo = @NewLoadDate-1
  where Greenhouse_Id in (
	select [Greenhouse_Id]
	from #tmp) and [edw].[DimGreenhouse].ValidFrom < @NewLoadDate
	drop table if exists #tmp

--when record was deleted 
update [edw].[DimGreenhouse]
set ValidTo = @NewLoadDate-1
where Greenhouse_Id in (
select [Greenhouse_Id]
from [edw].[DimGreenhouse]
where [Greenhouse_Id] in (select [Greenhouse_Id] from [edw].[DimGreenhouse]
except select [Greenhouse_Id]
from [stage].[DimGreenhouse])) and ValidTo = 99990101;


-- when you update the whole table with add, change and delete
insert into [et1].[LogUpdate] ([Table],[LastLoadDate]) values ('DimGreenhouse', @NewLoadDate)



-----DimDevice----------------------------------------------------------------------------------------------------------------------
---when just adding ----
set @LastLoadDate = (Select max([LastLoadDate]) FROM [et1].[LogUpdate] where [Table] = 'DimDevice')

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
	,[Avrg_CO2]
	,[ValidFrom]
	,[ValidTo])
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
	,@NewLoadDate
	,@FutureDate
from [GreenhouseDW].[stage].[DimDevice] dd
	inner join [edw].[DimDate] as d
	on d.Date = dd.Date
	where Device_Id in (select [Device_Id]
	from [stage].[DimDevice] except select [Device_Id]
	from [edw].[DimDevice]
	where validTo = 99990101);

  --when smth changed--
SELECT [Device_Id]
	,[D_ID]
	,[Min_Temp]
	,[Max_Temp]
	,[Avrg_Temp]
	,[Min_Hum]
	,[Max_Hum]
	,[Avrg_Hum]
	,[Min_CO2]
	,[Max_CO2]
	,[Avrg_CO2]
	  into #tmp
from [GreenhouseDW].[stage].[DimDevice] dd
	inner join [edw].[DimDate] as d
	on d.Date = dd.Date except select [Device_Id]--except the ones already exists 
	,[D_ID]
	,[Min_Temp]
	,[Max_Temp]
	,[Avrg_Temp]
	,[Min_Hum]
	,[Max_Hum]
	,[Avrg_Hum]
	,[Min_CO2]
	,[Max_CO2]
	,[Avrg_CO2]
from [edw].[DimDevice]
where validTo = 99990101
-- until here we look for everything that changed, if we want only records that changed and are not new
--we need to add the next part
-- then except new records 
except select  [Device_Id]
	,[D_ID]
	,[Min_Temp]
	,[Max_Temp]
	,[Avrg_Temp]
	,[Min_Hum]
	,[Max_Hum]
	,[Avrg_Hum]
	,[Min_CO2]
	,[Max_CO2]
	,[Avrg_CO2]
  from [GreenhouseDW].[stage].[DimDevice] dd
	inner join [edw].[DimDate] as d
	on d.Date = dd.Date
  where Device_Id in (select [Device_Id]
  from [stage].[DimDevice] except select [Device_Id]
  from [edw].[DimDevice]
  where validTo = 99990101);

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
	,[Avrg_CO2]
	,[ValidFrom]
	,[ValidTo])
SELECT[Device_Id]
	,[D_ID]
	,[Min_Temp]
	,[Max_Temp]
	,[Avrg_Temp]
	,[Min_Hum]
	,[Max_Hum]
	,[Avrg_Hum]
	,[Min_CO2]
	,[Max_CO2]
	,[Avrg_CO2]
	  ,@NewLoadDate
	  ,@FutureDate
  FROM #tmp

  update [edw].[DimDevice]
  set ValidTo = @NewLoadDate-1
  where Device_Id in (
	select [Device_Id]
	from #tmp) and [edw].[DimDevice].ValidFrom < @NewLoadDate
	drop table if exists #tmp

--when record was deleted 
update [edw].[DimDevice]
set ValidTo = @NewLoadDate-1
where Device_Id in (
select [Device_Id]
from [edw].[DimDevice]
where [Device_Id] in (select [Device_Id] from [edw].[DimDevice]
except select [Device_Id]
from [stage].[DimDevice])) and ValidTo = 99990101;


-- when you update the whole table with add, change and delete
insert into [et1].[LogUpdate] ([Table],[LastLoadDate]) values ('DimDevice', @NewLoadDate)