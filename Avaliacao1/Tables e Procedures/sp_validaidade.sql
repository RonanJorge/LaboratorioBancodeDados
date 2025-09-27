USE [agis]
GO

/****** Object:  StoredProcedure [dbo].[sp_validaidade]    Script Date: 27/09/2025 01:48:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_validaidade](@nascimento DATE, 
								@valido BIT OUTPUT)
AS
	DECLARE @idade	INT
	SET @idade = (SELECT DATEDIFF(DAY, @nascimento, GETDATE())) / 365
--	PRINT (@idade)
 
	IF (@idade >= 16)
	BEGIN
		SET @valido = 1
	END
	ELSE
	BEGIN
		SET @valido = 0
	END
GO


