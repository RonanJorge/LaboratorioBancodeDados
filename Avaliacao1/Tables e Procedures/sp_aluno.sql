USE [agis]
GO

/****** Object:  StoredProcedure [dbo].[sp_aluno]    Script Date: 27/09/2025 01:46:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_aluno](@op CHAR(1), @cpf BIGINT, @nome VARCHAR(100), @nomeSocial VARCHAR(100),
						   @nascimento DATE, @email VARCHAR(70), @emailCorporativo VARCHAR(70), @conclusaoEM DATE, 
						   @anoIngresso INT, @semestreIngresso INT, @anoLimite INT, @semestreLimite INT,
						   @ra VARCHAR(9),
						   @saida VARCHAR(100) OUTPUT)
AS
	DECLARE @valido_idade	BIT
	DECLARE @valido_cpf BIT
	DECLARE @novoRa VARCHAR(9)
	IF (UPPER(@op) = 'D' AND @cpf IS NOT NULL)
	BEGIN
		DELETE aluno WHERE cpf = @cpf
		SET @saida = 'Aluno cpf '+CAST(@cpf AS VARCHAR(11)) + ' excluído com sucesso !'
	END
	ELSE
	BEGIN
		IF (UPPER(@op) = 'D' AND @cpf IS NULL)
		BEGIN
			RAISERROR('Operação requer CPF válido', 16, 1)
		END
		ELSE
		BEGIN
			EXEC sp_validaidade @nascimento, @valido_idade OUTPUT
			EXEC sp_validarCpf @cpf, @valido_cpf OUTPUT
			EXEC sp_gerarRa @cpf, @anoIngresso, @semestreIngresso, @novoRa OUTPUT
			IF (@valido_idade = 1 AND @valido_cpf = 1)
			BEGIN
				IF(@semestreIngresso = 1)
				BEGIN
					SET @semestreLimite = 2
					SET @anoLimite = @anoIngresso + 4
				END
				ELSE
				BEGIN
					SET @semestreLimite = 1
					SET @anoLimite = @anoIngresso + 5
				END 
				
				IF (UPPER(@op) = 'I')
				BEGIN
					INSERT INTO aluno VALUES
					(@cpf, @nome, @nomeSocial, @nascimento, @email, 
					@emailCorporativo, @conclusaoEM, @anoIngresso, @semestreIngresso,
					@anoLimite, @semestreLimite, @novoRa)

					SET @saida = @nome + ' inserido(a) com sucesso !'
				END
				ELSE
				BEGIN
					IF (UPPER(@op) = 'U')
					BEGIN
						UPDATE aluno
						SET nome = @nome, nomeSocial = @nomeSocial, nascimento = @nascimento, 
							email = @email, emailCorporativo = @emailCorporativo,
							conclusaoEM = @conclusaoEM,
							anoIngresso = @anoIngresso, semestreIngresso = @semestreIngresso,
							anoLimite = @anoLimite, semestreLimite = @semestreLimite,
							ra = @novoRa
						WHERE cpf = @cpf
						SET @saida = @nome + ' modificado(a) com sucesso !'
					END
					ELSE
					BEGIN
						RAISERROR('Codigo de operação inválido', 16, 1)
					END
				END
			END
			ELSE
			BEGIN
				IF(@valido_idade = 0 AND @valido_cpf = 0)
				BEGIN
					RAISERROR('Data de nascimento e cpf inválidos', 16, 1)
				END
				ELSE
				BEGIN
					IF(@valido_idade = 0)
					BEGIN
						RAISERROR('Data de nascimento inválida', 16, 1)
					END
					ELSE
					BEGIN
						RAISERROR ('Cpf inválido', 16, 1)
					END
				END
			END
		END
	END
GO


