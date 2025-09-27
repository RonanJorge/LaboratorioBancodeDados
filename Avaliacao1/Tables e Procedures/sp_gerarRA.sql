USE [agis]
GO

/****** Object:  StoredProcedure [dbo].[sp_gerarRa]    Script Date: 27/09/2025 01:48:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_gerarRa] (@cpf BIGINT, @anoIngresso INT, 
							@semestreIngresso INT, @ra VARCHAR(9) OUTPUT)
AS
	SET @ra = CAST(@anoIngresso AS VARCHAR(4))
			+CAST(@semestreIngresso AS VARCHAR(1))
			+CAST(CAST(RAND()*8999 +1000 AS INT) AS VARCHAR(4))
GO


