USE [agis]
GO

/****** Object:  Table [dbo].[aluno]    Script Date: 27/09/2025 01:49:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[aluno](
	[cpf] [bigint] NOT NULL,
	[nome] [varchar](70) NULL,
	[nomeSocial] [varchar](100) NULL,
	[nascimento] [date] NULL,
	[email] [varchar](70) NULL,
	[emailCorporativo] [varchar](70) NULL,
	[conclusaoEM] [date] NULL,
	[anoIngresso] [int] NOT NULL,
	[semestreIngresso] [int] NOT NULL,
	[anoLimite] [int] NULL,
	[semestreLimite] [int] NULL,
	[ra] [varchar](9) NULL,
PRIMARY KEY CLUSTERED 
(
	[cpf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


