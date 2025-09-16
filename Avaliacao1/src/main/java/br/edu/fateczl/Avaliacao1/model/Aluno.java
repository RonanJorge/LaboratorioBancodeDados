package br.edu.fateczl.Avaliacao1.model;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Aluno {

	private int id;
	private String nome;
	private LocalDate nascimento;
	private String dtNasc;
	private String email;

}
