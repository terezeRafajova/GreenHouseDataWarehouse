use GreenHouseDW; 

create schema stage;

CREATE TABLE stage.DimGreenhouse
(
    Greenhouse_Id int NOT NULL PRIMARY KEY,
    Name varchar (50),
    Description varchar (200),
    Location varchar (50),
    CO2Preferred DECIMAL (5,2),
    TemperaturePreferred DECIMAL (5,2),
    HumidityPreferred DECIMAL (5,2)
);

Create table stage.DimDevice
(
	Device_Id int not null, 
	Date date not null, 
	Min_Temp decimal(5,2), 
	Max_Temp decimal(5,2), 
	Avrg_Temp decimal(6,3),
	Min_Hum decimal(5,2), 
	Max_Hum decimal(5,2), 
	Avrg_Hum decimal(5,2),
	Min_CO2 decimal(5,2), 
	Max_CO2 decimal(5,2), 
	Avrg_CO2 decimal(5,2),
	PRIMARY KEY (Device_id, Date)
);


Create table stage.FactMeasurement
(
	Greenhouse_Id int NOT NULL,
	Device_Id int NOT NULL, 
	Date date not null, 
	Time Time not null, 
	TempValue decimal(5,2),
	HumValue decimal(5,2), 
	CO2Value decimal(5,2),
	PRIMARY KEY (GreenHouse_Id, Device_id, Date, Time)
);