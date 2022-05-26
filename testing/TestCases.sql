  -------------------------- count all Logs in FactMeasurement
  SELECT COUNT(*) AS sumDBLogs
 FROM TestDB.dbo.Logs

 SELECT COUNT(*) AS sumDWLogs
 FROM TestDW.edw.FactMeasurement

 ----------------------------------------- count all Greenhouses
 SELECT COUNT(*) AS simDBGreenhouses
 FROM TestDB.dbo.Greenhouses

 SELECT COUNT(*) AS simDWGreenhouses
 FROM TestDW.edw.DimGreenhouse

 --------------------------------------- count MaxTemperature Per Device Per Day
 SELECT avg(max_temperature)
 FROM (select max(logs.temperature) AS max_temperature 
 from TestDB.dbo.Logs  
 group by CONVERT(DATE, [date]), Id_Greenhouse) as countMaxTemperatureDB;

 SELECT AVG(Max_Temp) AS countMaxTemperatureDW
 FROM TestDW.edw.DimDevice AS fm
-------------------------------------------------------- count MinTemperature Per Device Per Day
  SELECT avg(min_temperature)
 FROM (select min(logs.temperature) AS min_temperature 
 from TestDB.dbo.Logs  
 group by CONVERT(DATE, [date]), Id_Greenhouse) as countMinTemperatureDB;

 SELECT AVG(Min_Temp) AS countMinTemperatureDW
 FROM TestDW.edw.DimDevice AS fm

 -------------------------------------------------------- count AvgTemperature Per Device Per Day
  SELECT avg(avg_temperature)
 FROM (select avg(logs.temperature) AS avg_temperature 
 from TestDB.dbo.Logs  
 group by CONVERT(DATE, [date]), Id_Greenhouse) as countAvgTemperatureDB;

 SELECT AVG(Avrg_Temp) AS countAvgTemperatureDW
 FROM TestDW.edw.DimDevice AS fm

  --------------------------------------- count MaxHumidity Per Device Per Day
 SELECT avg(max_humidity)
 FROM (select max(logs.humidity) AS max_humidity 
 from TestDB.dbo.Logs  
 group by CONVERT(DATE, [date]), Id_Greenhouse) as countMaxHumidityDB;

 SELECT AVG(Max_Hum) AS countMaxHumudityDW
 FROM TestDW.edw.DimDevice AS fm
-------------------------------------------------------- count MinHumudity Per Device Per Day
 SELECT avg(min_humidity)
 FROM (select min(logs.humidity) AS min_humidity 
 from TestDB.dbo.Logs  
 group by CONVERT(DATE, [date]), Id_Greenhouse) as countMinHumidityDB;


 SELECT avg(Min_Hum) AS countMinHumidityDW
 FROM TestDW.edw.DimDevice AS fm

 -------------------------------------------------------- count AvgHumidity Per Device Per Day
   SELECT avg(avg_humidity)
 FROM (select avg(logs.humidity) AS avg_humidity 
 from TestDB.dbo.Logs  
 group by CONVERT(DATE, [date]), Id_Greenhouse) as countAvgHumidityDB;


 SELECT avg(Avrg_Hum) AS countAvgHumidityDW
 FROM TestDW.edw.DimDevice AS fm

   --------------------------------------- count MaxCo2 Per Device Per Day
  SELECT avg(max_co2)
 FROM (select max(logs.co2) AS max_co2 
 from TestDB.dbo.Logs  
 group by CONVERT(DATE, [date]), Id_Greenhouse) as countMaxCo2DB;


 SELECT avg(Max_CO2) AS countMaxCo2Dw
 FROM TestDW.edw.DimDevice AS fm
-------------------------------------------------------- count MinCo2 Per Device Per Day
 SELECT avg(min_co2)
 FROM (select min(logs.co2) AS min_co2 
 from TestDB.dbo.Logs  
 group by CONVERT(DATE, [date]), Id_Greenhouse) as countMinCo2DB;

 SELECT avg(Min_CO2) AS countMinCo2DW
 FROM TestDW.edw.DimDevice AS fm
 -------------------------------------------------------- count AvgCo2 Per Device Per Day
  SELECT avg(avg_co2)
 FROM (select avg(logs.co2) AS avg_co2 
 from TestDB.dbo.Logs  
 group by CONVERT(DATE, [date]), Id_Greenhouse) as countAvgCo2DB;


 SELECT avg(Avrg_CO2) AS countAvgCo2DW
 FROM TestDW.edw.DimDevice AS fm

 -------------------------------------------------- avg temeprature in FactMeasure vs Logs
  SELECT AVG(logs.temperature) AS avgTemperatureLogsDB
 FROM TestDB.dbo.Logs AS logs

 SELECT AVG(fm.TempValue) AS avgTemperatureLogsDw
 FROM TestDW.edw.FactMeasurement AS fm

 -------------------------------------------------- avg himidity in FactMeasure vs Logs
  SELECT AVG(logs.humidity) AS avgHumidityLogsDB
 FROM TestDB.dbo.Logs AS logs

 SELECT AVG(fm.HumValue) AS avgHumidityLogsDw
 FROM TestDW.edw.FactMeasurement AS fm

-------------------------------------------------- avg CO2 in FactMeasure vs Logs
  SELECT AVG(logs.co2) AS avgCo2LogsDB
 FROM TestDB.dbo.Logs AS logs

 SELECT AVG(fm.CO2Value) AS avgCo2LogsDw
 FROM TestDW.edw.FactMeasurement AS fm

 ----------------------------------------------------