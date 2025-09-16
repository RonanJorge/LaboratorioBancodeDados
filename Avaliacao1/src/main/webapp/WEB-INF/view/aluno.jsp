<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js" integrity="sha384-ndDqU0Gzau9qJ1lfW4pNLlhNTkCfHzAVBReH9diLvGRem5+R9g2FzA8ZGN954O5Q" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<title>Cadastro Aluno</title>
</head>
<body>
	<div align="center">
		<jsp:include page="menu.jsp" />
	</div>
	<br />
	<div class="conteiner" align="center">
		<h1>Cadastro de Alunos</h1>
		<br />
		<form action="aluno" method="post">
			<table>
				<tr>
					<td colspan="3">
						<input type="number" min="1" step="1"
						id="id" name="id" placeholder="#ID"
						value='<c:out value="${aluno.id }"/>'
						class="input-group input-group-lg" >
					</td>
					<td colspan="1">
						<input type="submit"
						id="botao" name="botao" value="Buscar"
						class="btn btn-dark">
					</td>				
				</tr>		
				<tr>
					<td colspan="4">
						<input type="text" 
						id="nome" name="nome" placeholder="Nome"
						value='<c:out value="${aluno.nome }"/>'
						class="input-group input-group-lg">
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<input type="date" 
						id="nascimento" name="nascimento"
						value='<c:out value="${aluno.nascimento }"/>'
						class="input-group input-group-lg">
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<input type="text" 
						id="email" name="email" placeholder="E-mail"
						value='<c:out value="${aluno.email }"/>'
						class="input-group input-group-lg">
					</td>
				</tr>
				<tr>
					<td>
						<input type="submit"
						id="botao" name="botao" value="Inserir"
						class="btn btn-dark">
					</td>								
					<td>
						<input type="submit"
						id="botao" name="botao" value="Atualizar"
						class="btn btn-dark">
					</td>								
					<td>
						<input type="submit"
						id="botao" name="botao" value="Excluir"
						class="btn btn-dark">
					</td>								
					<td>
						<input type="submit"
						id="botao" name="botao" value="Listar"
						class="btn btn-dark">
					</td>								
				</tr>
			</table>
		</form>
	</div>
	<br />
	<div class="conteiner" align="center">
		<c:if test="${not empty saida }">
			<h2 style="color: blue;"><c:out value="${saida }" /></h2>
		</c:if>
	</div>
	<div class="conteiner" align="center">
		<c:if test="${not empty erro }">
			<h2 style="color: red;"><c:out value="${erro }" /></h2>
		</c:if>
	</div>
	<div class="conteiner" align="center">
		<c:if test="${not empty alunos }">
			<table class="table table-dark table-striped">
				<thead>
					<tr>
						<th>#ID</th>
						<th>Nome</th>
						<th>Dt Nasc</th>
						<th>E-mail</th>
						<th></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="a" items="${alunos }">
						<tr>
							<td>${a.id }</td>
							<td>${a.nome }</td>
							<td>${a.dtNasc }</td>
							<td>${a.email }</td>
							<td><a href="aluno?acao=editar&id=${a.id }">EDITAR</a></td>
							<td><a href="aluno?acao=excluir&id=${a.id }">EXCLUIR</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
</body>
</html>