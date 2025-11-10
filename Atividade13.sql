CREATE DATABASE aulacursor

CREATE TABLE curso(
	codigo_curso	INT NOT NULL,
	nome			VARCHAR(50) NOT NULL,
	duracao			INT NOT NULL,
	PRIMARY KEY (codigo_curso)
)

CREATE TABLE disciplina(
	codigo_disc		VARCHAR(6) NOT NULL,
	nome			VARCHAR(50) NOT NULL,
	carga_horaria	INT NOT NULL, 
	PRIMARY KEY (codigo_disc)
)

CREATE TABLE disciplina_curso(
	codigo_disc			VARCHAR(6) NOT NULL,
	codigo_curso		INT NOT NULL,
	FOREIGN KEY (codigo_disc) REFERENCES disciplina(codigo_disc),
	FOREIGN KEY (codigo_curso) REFERENCES curso(codigo_curso)
)

INSERT INTO curso VALUES
(48, 'Análise e Desenvolvimento de Sistemas', 2880),
(51, 'Logistica', 2880),
(67, 'Polímeros', 2880),
(73, 'Comércio Exterior', 2600),
(94, 'Gestão Empresarial', 2600)

INSERT INTO disciplina VALUES
('ALG001', 'Algoritmos', 80),
('ADM001', 'Administração', 80),
('LHW010', 'Laboratório de Hardware', 40),
('LPO001', 'Pesquisa Operacional', 80),
('FIS003', 'Física I', 80),
('FIS007', 'Físico Química', 80),
('CMX001', 'Comércio Exterior', 80),
('MKT002', 'Fundamentos de Marketing', 80),
('INF001', 'Informática', 40),
('ASI001', 'Sistemas de Informação', 80)

INSERT INTO disciplina_curso VALUES
('ALG001', 48),
('ADM001', 48),
('ADM001', 51),
('ADM001', 73),
('ADM001', 94),
('LHW010', 48),
('LPO001', 51),
('FIS003', 67),
('FIS007', 67),
('CMX001', 51),
('CMX001', 73),
('MKT002', 51),
('MKT002', 94),
('INF001', 51),
('INF001', 73),
('ASI001', 48),
('ASI001', 94)

SELECT * FROM curso
SELECT * FROM disciplina
SELECT * FROM disciplina_curso

GO
CREATE FUNCTION fn_curso(@curso INT)
RETURNS @tabela TABLE(
	codigo_disc					VARCHAR(6),
	nome_disciplina				VARCHAR(50),
	carga_horaria_disciplina	INT,
	nome_curso					VARCHAR(50)
)
AS
BEGIN
	DECLARE	@codigo_disc				VARCHAR(6),
			@codigo_curso				INT,
			@nome_disciplina			VARCHAR(50),
			@carga_horaria_disciplina	INT,
			@nome_curso					VARCHAR(50)
	DECLARE c CURSOR
		FOR SELECT codigo_disc, codigo_curso 
		FROM disciplina_curso 
	OPEN c
	FETCH NEXT FROM c
		INTO @codigo_disc, @codigo_curso
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(@curso = @codigo_curso)
		BEGIN
			SET @nome_disciplina = (SELECT nome FROM disciplina WHERE codigo_disc = @codigo_disc)
			SET @carga_horaria_disciplina = (SELECT carga_horaria FROM disciplina WHERE codigo_disc = @codigo_disc)
			SET @nome_curso = (SELECT nome FROM curso WHERE codigo_curso = @codigo_curso)
			INSERT INTO @tabela VALUES (@codigo_disc, @nome_disciplina, @carga_horaria_disciplina, @nome_curso)
		END
		FETCH NEXT FROM c
			INTO @codigo_disc, @codigo_curso
	END
	CLOSE c
	DEALLOCATE C
	RETURN
END
GO

--- ads
SELECT * FROM fn_curso(48)

--- log
SELECT * FROM fn_curso(51)

