USE [agis]
GO

/****** Object:  StoredProcedure [dbo].[sp_validarCpf]    Script Date: 27/09/2025 01:48:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_validarCpf](@cpf CHAR(11), @valido INT OUTPUT)
AS
BEGIN
	DECLARE @cont INT
	DECLARE @soma INT
	DECLARE @digito CHAR(1)
	DECLARE @resto INT
	DECLARE @primeiro INT
	DECLARE @segundo INT
	DECLARE @numeroCpf INT

	SET @valido = 1
	SET @cont = 2
	WHILE(@cont <= 11)
	BEGIN
		IF(CAST(SUBSTRING(@cpf, 1, 1) AS INT) = CAST(SUBSTRING(@cpf, @cont, 1) AS INT))
		BEGIN
			IF(@cont = 11)
			BEGIN
				SET @valido = 0
			END
			SET @cont = @cont + 1
		END
		ELSE
		BEGIN
			SET @cont = 12
		END	
	END

	IF(@valido = 1)
	BEGIN
		SET @cont = 10
		SET @soma = 0
		WHILE (@cont >=2)
		BEGIN
			SET @digito = CAST(SUBSTRING(@cpf, 11 - @cont, 1) AS INT)
			SET @soma = @soma + @digito * @cont
			SET @cont = @cont - 1
		END
		SET @resto = @soma % 11
		IF(@resto < 2)
		BEGIN
			SET @primeiro = CAST(0 AS CHAR(1))
		END
		ELSE
		BEGIN
			SET @primeiro = CAST(11 - @resto AS CHAR(1))
		END
		IF(@primeiro = SUBSTRING(@cpf, 10, 1)) 
		BEGIN
			SET @cont = 11
			SET @soma = 0
			WHILE (@cont >=2)
			BEGIN
				SET @digito = CAST(SUBSTRING(@cpf, 12 - @cont, 1) AS INT)
				SET @soma = @soma + @digito * @cont
				SET @cont = @cont - 1
			END

			SET @resto = @soma % 11
			IF(@resto < 2)
			BEGIN
				SET @segundo = CAST(0 AS CHAR(1))
			END
			ELSE
			BEGIN
				SET @segundo = CAST(11 - @resto AS CHAR(1))
			END

			IF(@segundo = SUBSTRING(@cpf, 11, 1))
			BEGIN
				SET @valido = 1
			END
			ELSE
			BEGIN
				SET @valido = 0
			END
		END
		ELSE
		BEGIN
			SET @valido = 0
		END
	END
END
GO


