use GreenHouse

declare @StartDate Datetime;
declare @EndDate Datetime;
declare @startTemp decimal(5,2);
declare @startHum decimal(5,2);
declare @startCO2 decimal(5,2);



set @StartDate = CONVERT(Datetime, '2022-05-28 08:04:34', 120)
set @EndDate = Dateadd(day, 3, @StartDate)
set @startTemp = 22.15;
set @startHum = 36.86;
set @startCO2 = 515.6;

While @StartDate <= @EndDate
	Begin 
		Insert into dbo.[Logs]
		([co2],
			[temperature],
			[humidity],
			[date],
			[Id_Greenhouse]
		)
		Select 
			@startCO2 as co2,
			@startTemp as temperature,
			@startHum as humidity,
			@StartDate as date,
			1 as Id_Greenhouse
		Set @StartDate = Dateadd(mi, 5, @StartDate)
		set @startTemp = @startTemp + ROUND((rand()*(0.5 - 0))*-1 + rand()*(0.5 - 0), 2)
		set @startHum = @startHum + ROUND((rand()*(0.5 - 0))*-1 + rand()*(0.5 - 0), 2)
		set @startCO2 = @startCO2 + ROUND((rand()*(0.5 - 0))*-1 + rand()*(0.5 - 0), 2)
	END
go 


