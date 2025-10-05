CREATE DATABASE atividade8

CREATE TABLE produtos(
	codigo			INT,
	nome			VARCHAR(30),
	valorUnitario	DECIMAL(7,2),
	qtdEstoque		INT,
	PRIMARY KEY (codigo)
)

INSERT INTO produtos VALUES
(1, 'Produto 1', 34.50, 23),
(2, 'Produto 2', 10.00, 20),
(3, 'Produto 3', 9.90, 3),
(4, 'Produto 4', 25.56, 100),
(5, 'Produto 5', 11.00, 9)

SELECT * FROM produtos

GO
CREATE FUNCTION fn_qtdProdutosAbaixo(@valor INT)
RETURNS INT
AS
BEGIN
	DECLARE @quantidade INT
	SELECT @quantidade = COUNT(nome)
		FROM produtos
		WHERE qtdEstoque < @valor
	RETURN @quantidade
END
GO

SELECT dbo.fn_qtdProdutosAbaixo(101) AS Quantidade

GO
CREATE FUNCTION fn_tabelaProdutosAbaixo(@valor INT)
RETURNS @tabela TABLE(
	codigo INT,
	nome VARCHAR(30),
	qtdEstoque INT
)
AS
BEGIN
	INSERT INTO @tabela (codigo, nome, qtdEstoque)
	SELECT codigo, nome, qtdEstoque 
		FROM produtos
		WHERE qtdEstoque < @valor
	RETURN
END
GO

SELECT * FROM fn_tabelaProdutosAbaixo(150)

