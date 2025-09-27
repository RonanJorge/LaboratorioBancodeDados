USE [agis]
GO

/****** Object:  StoredProcedure [dbo].[sp_disciplina]    Script Date: 27/09/2025 01:47:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_disciplina](@op CHAR(1), @codigoDisc INT, @codigoCurso INT, @nome VARCHAR(70), 
							@horasSemanais INT, @conteudos VARCHAR(MAX), @saida VARCHAR(100) OUTPUT)
AS
	IF (UPPER(@op) = 'D' AND @codigoDisc IS NOT NULL)
	BEGIN
		DELETE disciplina WHERE codigoDisc = @codigoDisc
		SET @saida = 'Disciplina codigo '+CAST(@codigoDisc AS VARCHAR(7)) + ' exclu�do com sucesso !'
	END
	ELSE
	BEGIN
		IF (UPPER(@op) = 'D' AND @codigoDisc IS NULL)
		BEGIN
			RAISERROR('Opera��o requer #c�digo v�lido', 16, 1)
		END
		ELSE
		BEGIN
			IF (1001 <= @codigoDisc AND @codigoDisc <=99999)
			BEGIN
				IF (UPPER(@op) = 'I')
				BEGIN
					INSERT INTO disciplina VALUES
					(@codigoDisc, @codigoCurso, @nome, @horasSemanais, @conteudos)
 
					SET @saida = @nome + ' inserido(a) com sucesso !'
				END
				ELSE
				BEGIN
					IF (UPPER(@op) = 'U')
					BEGIN
						UPDATE disciplina
						SET codigoCurso = @codigoCurso, nome = @nome, horasSemanais = @horasSemanais, conteudos = @conteudos
						WHERE codigoDisc = @codigoDisc
 
						SET @saida = @nome + ' modificado(a) com sucesso !'
					END
					ELSE
					BEGIN
						RAISERROR('Codigo de opera��o inv�lido', 16, 1)
					END
				END
			END
			ELSE
			BEGIN
				RAISERROR('C�digo de disciplina inv�lido, insira um c�digo entre 1001 e 99999', 16, 1)
			END
		END
	END
GO


