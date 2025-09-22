package br.edu.fateczl.Atividade7.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Entrada {
	
	private String codigoTransacao;
	private String codigoProduto;
	private int quantidade;
	private float valorTotal; 
}
