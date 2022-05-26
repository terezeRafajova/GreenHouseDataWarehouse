use [TestDB]
go

/****** Object:  Table [dbo].[Greenhouses]    Script Date: 26/05/2022 10:25:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Greenhouses](
	[Id_Greenhouse] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[description] [varchar](200) NULL,
	[location] [varchar](50) NULL,
	[area] [decimal](5, 2) NULL,
	[co2Preferred] [decimal](5, 2) NULL,
	[temperaturePreferred] [decimal](5, 2) NULL,
	[humidityPreferred] [decimal](5, 2) NULL,
	[actuator] [bit] NULL,
	[owner] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Greenhouse] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Logs]    Script Date: 26/05/2022 10:25:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Logs](
	[Id_Log] [int] IDENTITY(1,1) NOT NULL,
	[co2] [decimal](5, 2) NULL,
	[temperature] [decimal](5, 2) NULL,
	[humidity] [decimal](5, 2) NULL,
	[date] [datetime] NULL,
	[Id_Greenhouse] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Log] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO