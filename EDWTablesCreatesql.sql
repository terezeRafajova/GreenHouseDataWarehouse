use GreenHouseDW; 

create schema [edw];


/*Creating date dimension*/
If not exists(SELECT * from sys.objects where object_id = OBJECT_ID(N'[edw].[DimDate]') AND type in (N'U'))
CREATE TABLE [edw].[DimDate](
	[D_ID] [int] NOT NULL,
	[Date] [datetime] not null, 
	[Day] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[MonthName] [nvarchar](9) NOT NULL,
	[Week] [int] NOT NULL, 
	[Quarter] [int] NOT NULL,
	[DayOfWeek] [int] NOT NULL, 
	[WeekdayName] [nvarchar](9) NOT NULL
Constraint [PK_DimDate] PRIMARY KEY CLUSTERED
(
	[D_ID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
 
 /*ALTER TABLE [edw].[DimDate] ADD CONSTRAIT PK_DIMDATE PRIMARY KEY(D_ID);
GO*/

/******   Adding data to the table**********/
declare @StartDate Datetime;
declare @EndDate Datetime;

set @StartDate = 1996-01-01
set @EndDate = Dateadd(year, 100, getdate())

While @StartDate <= @EndDate
	Begin 
		Insert into edw.[DimDate]
		([D_ID],
			[Date],
			[Day],
			[Month],
			[MonthName],
			[Week],
			[Quarter],
			[Year], 
			[DayOfWeek],
			[WeekdayName]
		)
		Select 
			CONVERT(Char(8), @StartDate, 112) as D_ID,
			@StartDate as [Date],
			datepart(day, @StartDate) as Day,
			datepart(month, @StartDate) as Month,
			datename(month, @StartDate) as MonthName,
			datepart(year, @StartDate) as Year,
			datepart(week, @StartDate) as Week,
			datepart(QUARTER, @StartDate) as Quarter,
			datepart(WEEKDAY, @StartDate) as DayOfWeek,
			datename(weekday, @StartDate) as WeekdayName

		Set @StartDate = Dateadd(dd, 1, @StartDate)
	END
go 


drop table edw.DimTime
/*Creating time dimension*/
If not exists(SELECT * from sys.objects where object_id = OBJECT_ID(N'[edw].[DimTime]') AND type in (N'U'))
CREATE TABLE [edw].[DimTime](
	[T_ID] [int] NOT NULL,
	[Time] [datetime] not null, 
	[Hour] [int] NOT NULL,
	[Minute] [int] NOT NULL,
	[Quarter] [int] NOT NULL
Constraint [PK_DimTime] PRIMARY KEY CLUSTERED
(
	[T_ID] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
 
 /*ALTER TABLE [edw].[DimTime] ADD CONSTRAIT PK_DimTime PRIMARY KEY(T_ID);
GO*/
truncate table edw.DimTime
/******   Adding data to the table**********/
declare @hour int;
declare @minute int;
declare @defaultTime DateTime; 
declare @QarterNumber int;

set @defaultTime = CONVERT(Datetime, '2022-01-01 00:00:00', 120)
set @minute = datepart(minute, @defaultTime)
set @hour = datepart(hour, @defaultTime)


While datepart(day,@defaultTime) = 1
	Begin
		set @QarterNumber = 
			CASE 
			WHEN (@hour*100+@minute >= 00000 AND @hour*100+@minute <= 559) THEN 0 
			WHEN (@hour*100+@minute >= 600 AND @hour*100+@minute <= 1159) THEN 1 
			WHEN (@hour*100+@minute >= 1200 AND @hour*100+@minute <= 1759) THEN 2 
			WHEN (@hour*100+@minute >= 1800) THEN 3 
			END 
		insert into edw.[DimTime]([T_ID], [Time], [Hour],[Minute], [Quarter])
		select  @hour*100+@minute as [T_ID],
				@defaultTime as [Time],
				@hour as [Hour], 
				@minute as [Minute], 
				@QarterNumber as [Quarter]

		Set @defaultTime = Dateadd(mi, 1, @defaultTime)
		set @minute = datepart(minute, @defaultTime)
		set @hour = datepart(hour, @defaultTime)
	END
go 



CREATE TABLE edw.DimGreenhouse
(
	GH_ID int IDENTITY NOT NULL PRIMARY KEY,
    Greenhouse_Id int NOT NULL,
    Name varchar (50),
    Description varchar (200),
    Location varchar (50),
    CO2Preferred DECIMAL (5,2),
    TemperaturePreferred DECIMAL (5,2),
    HumidityPreferred DECIMAL (5,2)
);
go 

Create table edw.DimDevice
(
	DE_ID int IDENTITY NOT NULL PRIMARY KEY,
	Device_Id int not null, 
	D_ID int not null, 
	Min_Temp decimal(5,2), 
	Max_Temp decimal(5,2), 
	Avrg_Temp decimal(6,3),
	Min_Hum decimal(5,2), 
	Max_Hum decimal(5,2), 
	Avrg_Hum decimal(5,2),
	Min_CO2 decimal(5,2), 
	Max_CO2 decimal(5,2), 
	Avrg_CO2 decimal(5,2)
);
Alter table edw.DimDevice add constraint FK_DimDevice_0 foreign key (D_ID) references edw.DimDate (D_ID);



Create table edw.FactMeasurement
(
	GH_ID INT NOT NULL,
	DE_ID INT NOT NULL,
	D_ID INT NOT NULL,
	Time Time not null, 
	TempValue decimal(5,2),
	HumValue decimal(5,2), 
	CO2Value decimal(5,2)
);
ALTER table edw.FactMeasurement add constraint PK_FactMeasurement primary key (D_ID, Time, GH_ID, DE_ID);
Alter table edw.FactMeasurement add constraint FK_FactMeasurement_0 foreign key (D_ID) references edw.DimDate (D_ID);
Alter table edw.FactMeasurement add constraint FK_FactMeasurement_1 foreign key (GH_ID) references edw.DimGreenhouse (GH_ID);
Alter table edw.FactMeasurement add constraint FK_FactMeasurement_3 foreign key (DE_ID) references edw.DimDevice (DE_ID);
