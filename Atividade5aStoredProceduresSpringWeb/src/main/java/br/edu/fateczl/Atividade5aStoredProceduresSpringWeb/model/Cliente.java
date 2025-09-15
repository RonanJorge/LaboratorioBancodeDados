package br.edu.fateczl.Atividade5aStoredProceduresSpringWeb.model;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Cliente {

	private String cpf;
	private String nome;
	private String email;
	private Float limiteDeCredito;
	private LocalDate nascimento;
	private String dtNasc;

}
