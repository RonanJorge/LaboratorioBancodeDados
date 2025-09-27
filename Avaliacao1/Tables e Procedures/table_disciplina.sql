USE [agis]
GO

/****** Object:  Table [dbo].[disciplina]    Script Date: 27/09/2025 01:49:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[disciplina](
	[codigoDisc] [int] NOT NULL,
	[codigoCurso] [int] NULL,
	[nome] [varchar](70) NULL,
	[horasSemanais] [int] NULL,
	[conteudos] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[codigoDisc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[disciplina]  WITH CHECK ADD FOREIGN KEY([codigoCurso])
REFERENCES [dbo].[curso] ([codigoCurso])
GO


