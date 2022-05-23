use GreenHouse

declare @StartDate Datetime;
declare @EndDate Datetime;

set @StartDate = getdate()
set @EndDate = Dateadd(day, 1, getdate())

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
			ROUND(rand()*(420-380)+380, 2) as co2,
			ROUND(rand()*(27-22)+22, 2) as temperature,
			ROUND(rand()*(45-35)+35, 2) as humidity,
			@StartDate as date,
			1 as Id_Greenhouse
		Set @StartDate = Dateadd(mi, 5, @StartDate)
	END
go 