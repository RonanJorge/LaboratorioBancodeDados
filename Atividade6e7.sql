CREATE TABLE produto(
	codigoProduto VARCHAR(5),
	nome VARCHAR(100),
	valor DECIMAL(7,2),
	PRIMARY KEY (codigoProduto)
)

INSERT INTO produto VALUES(1,'Produto 1', 10)
INSERT INTO produto VALUES(2,'Produto 2', 15)
INSERT INTO produto VALUES(3,'Produto 3', 20)
INSERT INTO produto VALUES(4,'Produto 4', 25.45)

GO
CREATE TABLE entrada(
	codigoTransacao VARCHAR(5),
	codigoProduto VARCHAR(5),
	quantidade INT,
	valorTotal DECIMAL(9,2),
	FOREIGN KEY (codigoProduto) REFERENCES produto(codigoProduto)
)

CREATE TABLE saida(
	codigoTransacao VARCHAR(5),
	codigoProduto VARCHAR(5),
	quantidade INT,
	valorTotal DECIMAL(9,2),
	FOREIGN KEY (codigoProduto) REFERENCES produto(codigoProduto)
)


SELECT * FROM produto
SELECT * FROM entrada
SELECT * FROM saida




-- Não fazer insert para a tabela produto, só nas tabelas entrada e saída
GO
ALTER PROCEDURE sp_produto(@codigoOp VARCHAR(1), @op VARCHAR(1), @codigoTransacao VARCHAR(5), 
				@codigoProduto VARCHAR(5), @quantidade INT, 
				@saida VARCHAR(MAX) OUTPUT)
AS
	DECLARE @tabela VARCHAR(10),
			@query VARCHAR(MAX),
			@erro VARCHAR(MAX),
			@valorProduto INT,
			@valorTotal DECIMAL(9,2)
	
	SET @tabela = 'entrada'
	IF (@codigoOp = 's')
	BEGIN
		SET @tabela = 'saida'
	END
	ELSE
	BEGIN
		IF(@codigoOp = 'e')
		BEGIN
			SET @tabela = 'entrada'
		END
		ELSE
		BEGIN
			SET @tabela = ''
		END
	END
	
	SET @valorTotal = @quantidade * (SELECT valor FROM produto WHERE codigoProduto = @codigoProduto)

	IF(@tabela = 'entrada' AND UPPER(@op) = 'I')
	BEGIN
		SET @query = 'INSERT INTO '+@tabela+' VALUES ('
				+@codigoTransacao+ ','
				+@codigoProduto+ ','
				+CAST(@quantidade AS VARCHAR(6))+ ','
				+CAST(@valorTotal AS VARCHAR(10))+')'

		PRINT (@query)

		BEGIN TRY
			EXEC (@query)
			SET @saida = UPPER(@tabela) + ' inserida com sucesso'
		END TRY
		BEGIN CATCH
			RAISERROR('Operaçao Inválida',16,1)
		END CATCH
	END
	
	IF(@tabela = 'entrada' AND UPPER(@op) = 'U')
	BEGIN
		UPDATE entrada
		SET	codigoProduto = @codigoProduto,
			quantidade = @quantidade,
			valorTotal = @valorTotal
		WHERE codigoTransacao = @codigoTransacao
		SET @saida = UPPER(@tabela) + ' alterada com sucesso'
	END
	IF(@tabela = 'entrada' AND UPPER(@op) = 'D')
	BEGIN
		DELETE entrada
		WHERE codigoTransacao = @codigoTransacao
		SET @saida = UPPER(@tabela) + ' deletada com sucesso'
	END

	IF(@tabela = 'saida' AND UPPER(@op) = 'I')
	BEGIN
		SET @query = 'INSERT INTO '+@tabela+' VALUES ('
				+@codigoTransacao+ ','
				+@codigoProduto+ ','
				+CAST(@quantidade AS VARCHAR(6))+ ','
				+CAST(@valorTotal AS VARCHAR(10))+')'

		PRINT (@query)

		BEGIN TRY
			EXEC (@query)
			SET @saida = UPPER(@tabela) + ' inserida com sucesso'
		END TRY
		BEGIN CATCH
			RAISERROR('Operaçao Inválida',16,1)
		END CATCH
	END

	IF(@tabela = 'saida' AND UPPER(@op) = 'U')
	BEGIN
		UPDATE saida
		SET	codigoProduto = @codigoProduto,
			quantidade = @quantidade,
			valorTotal = @valorTotal
		WHERE codigoTransacao = @codigoTransacao
		SET @saida = UPPER(@tabela) + ' alterada com sucesso'
	END
	IF(@tabela = 'saida' AND UPPER(@op) = 'D')
	BEGIN
		DELETE saida
		WHERE codigoTransacao = @codigoTransacao
		SET @saida = UPPER(@tabela) + ' deletada com sucesso'
	END



--- Inserir na tabela entrada
DECLARE @out1 VARCHAR(200)
EXEC sp_produto e, I, 33, 2, 80, @out1 
PRINT(@out1)


--Inserir na tabela saída
DECLARE @out2 VARCHAR(200)
EXEC sp_produto s, 555, 3, 20, @out2 
PRINT(@out2)

DECLARE @out4 VARCHAR(200)
EXEC sp_produto s, 555, 4, 22, @out4 
PRINT(@out4)

---Operação inválida
DECLARE @out3 VARCHAR(200)
EXEC sp_produto	x, 122, 1, 100, @out3 
PRINT(@out3)


SELECT * FROM entrada
SELECT * FROM saida