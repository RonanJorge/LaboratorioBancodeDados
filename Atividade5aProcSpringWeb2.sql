CREATE DATABASE loja

CREATE TABLE cliente(
	cpf		CHAR(11),
	nome	VARCHAR(100),
	email	VARCHAR(200),
	limiteDeCredito DECIMAL(7,2),
	nascimento DATE
	PRIMARY KEY (cpf)
)

GO
CREATE PROCEDURE sp_validarCpf(@cpf CHAR(11), @valido INT OUTPUT)
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
CREATE PROCEDURE sp_cliente(@op CHAR(1), @cpf CHAR(11), @nome VARCHAR(100),
						   @email VARCHAR(200), @limiteDeCredito DECIMAL (7,2), @nascimento DATE,
						   @saida VARCHAR(100) OUTPUT)
AS
	DECLARE @validoCpf	BIT
	IF (UPPER(@op) = 'D' AND @cpf IS NOT NULL)
	BEGIN
		DELETE cliente WHERE cpf = @cpf
		SET @saida = 'Pessoa #cpf '+CAST(@cpf AS VARCHAR(11)) + ' excluído com sucesso !'
	END
	ELSE
	BEGIN
		IF (UPPER(@op) = 'D' AND @cpf IS NULL)
		BEGIN
			RAISERROR('Operação requer #cpf válido', 16, 1)
		END
		ELSE
		BEGIN
			EXEC sp_validarCpf @cpf, @validoCpf OUTPUT
			IF (@validoCpf = 1)
			BEGIN
				IF (UPPER(@op) = 'I')
				BEGIN
					INSERT INTO cliente VALUES
					(@cpf, @nome, @email, @limiteDeCredito, @nascimento)
 
					SET @saida = @nome + ' inserido(a) com sucesso !'
				END
				ELSE
				BEGIN
					IF (UPPER(@op) = 'U')
					BEGIN
						UPDATE cliente
						SET nome = @nome, nascimento = @nascimento, email = @email
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
				RAISERROR('Data de nascimento inválida', 16, 1)
			END
		END
	END
GO

DECLARE @testevalido BIT
EXEC sp_validarCpf 18815164820, @testevalido OUTPUT
PRINT @testevalido