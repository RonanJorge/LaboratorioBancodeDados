package br.edu.fateczl.Atividade7.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Produto {

	private String codigoProduto;
	private String nome;
	private float valor;
}
