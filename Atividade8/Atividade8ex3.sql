CREATE DATABASE atividade8_3

DROP TABLE cliente
CREATE TABLE cliente(
	codigoCliente INT,
	nomeCliente VARCHAR(70)
	PRIMARY KEY (codigoCliente)
)

CREATE TABLE produto(
	codigoProduto INT,
	nomeProduto VARCHAR(30),
	valor DECIMAL(7,2)
	PRIMARY KEY (codigoProduto)
)


INSERT INTO	cliente VALUES
(1, 'Cliente 1'),
(2, 'Cliente 2'),
(3, 'Cliente 3'),
(4, 'Cliente 4'),
(5, 'Cliente 5')


INSERT INTO produto VALUES
(101, 'Produto 1', 45.50),
(102, 'Produto 2', 5.00),
(103, 'Produto 3', 10.90),
(104, 'Produto 4', 100.45),
(105, 'Produto 5', 9.99),
(106, 'Produto 6', 15.70),
(107, 'Produto 7', 55.60)



GO
CREATE FUNCTION fn_compra(@codigoCliente INT, @codigoProduto INT, @quantidade INT)
RETURNS @tabela TABLE(
	nomeCliente VARCHAR(70),
	nomeProduto VARCHAR(30),
	quantidade INT,
	valorTotal DECIMAL(7,2),
	dataHoje DATE
)
AS
BEGIN
	INSERT INTO @tabela (nomeCliente, nomeProduto, quantidade, valorTotal)
		SELECT c.nomeCliente, p.nomeProduto, @quantidade , @quantidade * p.valor 
		FROM cliente c JOIN produto p ON c.codigoCliente = @codigoCliente AND p.codigoProduto = @codigoProduto
	
	UPDATE @tabela
	SET dataHoje = GETDATE()
	RETURN
END
GO

SELECT * FROM cliente
SELECT * FROM produto
SELECT * FROM fn_compra(1,101,23) 
SELECT * FROM fn_compra(2,101,120) 