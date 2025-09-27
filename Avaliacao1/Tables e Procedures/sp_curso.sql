USE [agis]
GO

/****** Object:  StoredProcedure [dbo].[sp_curso]    Script Date: 27/09/2025 01:47:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_curso](@op CHAR(1), @codigo INT, @nome VARCHAR(70), @cargaHoraria INT,
							@sigla VARCHAR(3), @notaEnade INT, @saida VARCHAR(100) OUTPUT)
AS
	IF (UPPER(@op) = 'D' AND @codigo IS NOT NULL)
	BEGIN
		DELETE curso WHERE codigoCurso = @codigo
		SET @saida = 'Curso codigo '+CAST(@codigo AS VARCHAR(5)) + ' excluído com sucesso !'
	END
	ELSE
	BEGIN
		IF (UPPER(@op) = 'D' AND @codigo IS NULL)
		BEGIN
			RAISERROR('Operação requer #código válido', 16, 1)
		END
		ELSE
		BEGIN
			IF (0 <= @codigo AND @codigo <=100)
			BEGIN
				IF (UPPER(@op) = 'I')
				BEGIN
					INSERT INTO curso VALUES
					(@codigo, @nome, @cargaHoraria, @sigla, @notaEnade)
 
					SET @saida = @nome + ' inserido(a) com sucesso !'
				END
				ELSE
				BEGIN
					IF (UPPER(@op) = 'U')
					BEGIN
						UPDATE curso
						SET nome = @nome, cargaHoraria = @cargaHoraria, sigla= @sigla, notaEnade = @notaEnade
						WHERE codigoCurso = @codigo
 
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
				RAISERROR('Código de curso inválido', 16, 1)
			END
		END
	END
GO


