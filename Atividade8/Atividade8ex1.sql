CREATE DATABASE empresa
USE empresa
CREATE TABLE funcionario (
	codigoFunc INT,
	nomeFunc VARCHAR(70),
	salarioFunc DECIMAL(7,2)
	PRIMARY KEY (codigoFunc)
)

CREATE TABLE dependente(
	codigoDep INT,
	codigoFunc INT,
	nomeDep VARCHAR(70),
	salarioDep DECIMAL(7,2),
	PRIMARY KEY (codigoDep),
	FOREIGN KEY (codigoFunc) REFERENCES funcionario(codigoFunc)
)


INSERT INTO funcionario VALUES
(1, 'Funcionário 1', 3456.00),
(2, 'Funcionário 2', 1800.00),
(3, 'Funcionário 3', 3422.50),
(4, 'Funcionário 4', 9888.90),
(5, 'Funcionário 5', 12000.00)

DELETE FROM dependente WHERE codigoFunc > 0
INSERT INTO dependente VALUES
(101, 1, 'Dependente 1', 2345.70),
(102, 1, 'Dependente 2', 3421.60),
(103, 1, 'Dependente 3', 10000.70),
(104, 3, 'Dependente 4', 5099.00),
(105, 4, 'Dependente 5', 2341.99),
(106, 4, 'Dependente 6', 8960.00)

SELECT * FROM funcionario

SELECT * FROM dependente


----ITEM 1A----
GO
CREATE FUNCTION fn_tabela()
RETURNS @tabela TABLE(
	nomeFunc VARCHAR(70),
	nomeDep VARCHAR(70),
	salarioFunc DECIMAL(7,2),
	salarioDep DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @tabela (nomeFunc, nomeDep, salarioFunc, salarioDep)
		SELECT f.nomeFunc, d.nomeDep, f.salarioFunc, d.salarioDep
		FROM funcionario f JOIN dependente d ON f.codigoFunc = d.codigoFunc
	RETURN
END
GO

SELECT * FROM fn_tabela()


---- ITEM 1B ----
GO
CREATE FUNCTION fn_somaSalario(@codigoFunc INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @soma			DECIMAL(7,2),
			@somaDep		DECIMAL(7,2),
			@salarioFunc	DECIMAL(7,2)
	SET @soma = 0
	IF(@codigoFunc > 0)
	BEGIN
		SELECT @somaDep = SUM(salarioDep) FROM dependente WHERE codigoFunc = @codigoFunc
		SELECT @salarioFunc = salarioFunc FROM funcionario WHERE codigoFunc = @codigoFunc
	END
	SET @soma = @somaDep + @salarioFunc
	RETURN @soma
END
GO

SELECT * FROM fn_tabela()
SELECT dbo.fn_somaSalario(1) AS Soma
SELECT dbo.fn_somaSalario(2) AS Soma
SELECT dbo.fn_somaSalario(3) AS Soma
SELECT dbo.fn_somaSalario(4) AS Soma
SELECT dbo.fn_somaSalario(5) AS Soma
SELECT dbo.fn_somaSalario(-6) AS Soma