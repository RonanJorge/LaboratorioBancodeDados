USE [agis]
GO

/****** Object:  Table [dbo].[curso]    Script Date: 27/09/2025 01:49:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[curso](
	[codigoCurso] [int] NOT NULL,
	[nome] [varchar](70) NULL,
	[cargaHoraria] [int] NULL,
	[sigla] [varchar](3) NULL,
	[notaEnade] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[codigoCurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


