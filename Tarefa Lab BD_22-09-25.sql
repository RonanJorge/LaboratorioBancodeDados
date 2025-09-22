CREATE DATABASE empresa

CREATE TABLE pessoa(
	id		INT,
	nome	VARCHAR(70),
	celular INT,
	fixo	INT,
	PRIMARY KEY (id)
)

---- Inserir pessoa ZERO

INSERT INTO pessoa VALUES (0,'',0,0)

------ SP para gerar um ID para inserir nova pessoa
GO
CREATE PROCEDURE sp_gerarId (@id INT OUTPUT)
AS
	SET @id = (SELECT id FROM pessoa
	WHERE id >= ALL(SELECT id FROM pessoa WHERE id > 0)) + 1

----- SP para verificar se um id existe
GO
CREATE PROCEDURE sp_existeId (@id INT, @existe BIT OUTPUT)
AS

	IF(@id IN (SELECT id FROM pessoa))
	BEGIN
		SET @existe = 1
	END
	ELSE
	BEGIN
		SET @existe = 0
	END


------- SP para validar um numero de celular
GO
CREATE PROCEDURE sp_validaCelular(@celular INT, @celularValido BIT OUTPUT )
AS
	IF(LEN(@celular) = 9 OR @celular IS NULL)
	BEGIN
		SET @celularValido = 1
	END
	ELSE
	BEGIN
		SET @celularValido = 0
	END

	-----SP para validar um numero fixo
GO
CREATE PROCEDURE sp_validaFixo(@fixo INT, @fixoValido BIT OUTPUT )
AS
	IF(LEN(@fixo) = 8 OR @fixo IS NULL)
	BEGIN
		SET @fixoValido = 1
	END
	ELSE
	BEGIN
		SET @fixoValido = 0
	END

DECLARE @out BIT
EXEC sp_validaFixo 38637273, @out OUTPUT
PRINT(@out)

DECLARE @out1 BIT
EXEC sp_validaFixo 989095562, @out1 OUTPUT
PRINT(@out1)

---- SP para CRUD de uma pessoa
GO
CREATE PROCEDURE sp_cadastro(@op CHAR(1), @id INT, @nome VARCHAR(70), 
							@celular VARCHAR(9), @fixo VARCHAR(8), @saida VARCHAR(100) OUTPUT)
AS
	DECLARE @existe BIT,
			@celularValido BIT, 
			@fixoValido BIT,
			@novoId INT

	IF (UPPER(@op) = 'D' AND @id IS NOT NULL)
	BEGIN
		EXEC sp_existeId @id, @existe OUTPUT
		IF(@existe = 0)
		BEGIN
			RAISERROR('#Id não existe!', 16, 1)
		END
		ELSE
		BEGIN
			DELETE pessoa WHERE id = @id
			SET @saida = 'Pessoa #id '+CAST(@id AS VARCHAR(5)) + ' excluído com sucesso !'
		END
	END
	ELSE
	BEGIN
		IF (UPPER(@op) = 'D' AND @id IS NULL)
		BEGIN
			RAISERROR('Operação requer #ID válido', 16, 1)
		END
		ELSE
		BEGIN
			IF(@celular IS NULL AND @fixo IS NULL)
			BEGIN
				RAISERROR('Um dos números de telefone deve ser preenchido', 16, 1)
			END
			ELSE
			BEGIN
				EXEC sp_validaCelular @celular, @celularValido OUTPUT
				EXEC sp_validaFixo @fixo, @fixoValido OUTPUT
				IF (@celularValido = 0 OR @fixoValido = 0)
				BEGIN
					RAISERROR('O número de celular deve ter 9 dígitos e o número fixo deve ter 8 dígitos', 16, 1)
				END
				ELSE
				BEGIN
					IF(UPPER(@op) = 'I')
					BEGIN
						EXEC sp_gerarId @novoId OUTPUT
						INSERT INTO pessoa VALUES (@novoId, @nome, @celular, @fixo)
						SET @saida = @nome + ' inserido com sucesso!'
					END
					ELSE
					BEGIN
						IF(UPPER(@op) = 'U')
						BEGIN
							UPDATE pessoa
							SET nome = @nome, celular = @celular, fixo = @fixo
							WHERE id = @id
							SET @saida = @nome + ' atualizado com sucesso!'
						END
						ELSE
						BEGIN
							RAISERROR('Operacao invalida', 16, 1)
						END
					END
				END
			END
		END
	END



---Inserção de Pessoa com sucesso
DECLARE @out2 VARCHAR(100)
EXEC sp_cadastro 'I', NULL, 'Ronan', 989095562, 38436272, @out2 OUTPUT
PRINT(@out2)

---Inserção de Pessoa sem celular com sucesso
DECLARE @out5 VARCHAR(100)
EXEC sp_cadastro 'I', NULL, 'Leandro', NULL, 38436272, @out5 OUTPUT
PRINT(@out5)

---Inserção de Pessoa sem fixo com sucesso
DECLARE @out6 VARCHAR(100)
EXEC sp_cadastro 'I', NULL, 'Leandro', 989095562, NULL, @out6 OUTPUT
PRINT(@out6)

---Atualização de Pessoa com sucesso
DECLARE @out3 VARCHAR(100)
EXEC sp_cadastro 'U', 1, 'Ronan Jorge', 989095561, 38436272, @out3 OUTPUT
PRINT(@out3)

---Exclusão de Pessoa com sucesso
DECLARE @out8 VARCHAR(100)
EXEC sp_cadastro 'D', 2, NULL, NULL, NULL, @out8 OUTPUT
PRINT(@out8)

---Erro de exclusão Id naõ existe
DECLARE @out9 VARCHAR(100)
EXEC sp_cadastro 'D', 1000, NULL, NULL, NULL, @out9 OUTPUT
PRINT(@out9)

---Erro de inserção -- celular invalido
DECLARE @out4 VARCHAR(100)
EXEC sp_cadastro 'I', NULL, 'Jorge', 98909556, 38436272, @out4 OUTPUT
PRINT(@out4)

---Erro de inserção -- fixo invalido
DECLARE @out7 VARCHAR(100)
EXEC sp_cadastro 'I', NULL, 'Jorge', 989095562, 3843627, @out7 OUTPUT
PRINT(@out7)


SELECT * FROM pessoa
DELETE pessoa WHERE id > 0