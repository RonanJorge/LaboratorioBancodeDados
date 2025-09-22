package br.edu.fateczl.Atividade7.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import br.edu.fateczl.Atividade7.model.Entrada;
import br.edu.fateczl.Atividade7.persistence.EntradaDao;

@Controller
public class EntradaController {

	@Autowired
	private EntradaDao eDao;
	
	@RequestMapping(name = "entrada", value = "/entrada", method = RequestMethod.GET)
	public ModelAndView entradaGet(
			@RequestParam Map<String, String> params,
			ModelMap model) {
		String acao = params.get("acao");
		String codigoTransacao = params.get("codigoTransacao");
		
		Entrada e = new Entrada();
		String erro = "";
		List<Entrada> entradas = new ArrayList<>();
		
		try {
			if (acao != null) {
				e.setCodigoTransacao(codigoTransacao);
				
				if (acao.equalsIgnoreCase("excluir")) {
					eDao.excluir(e);
					entradas = eDao.listar();
					e = null;
				} else {
					e = eDao.buscar(e);
					entradas = null;
				}
			}
		} catch (SQLException | ClassNotFoundException e1) {
			erro = e1.getMessage();
		} finally {
			model.addAttribute("erro", erro);
			model.addAttribute("entrada", e);
			model.addAttribute("entradas", entradas);
			
		}
		return new ModelAndView("entrada");
	}
	
	@RequestMapping(name = "entrada", value = "/entrada", method = RequestMethod.POST)
	public ModelAndView entradaPost(
			@RequestParam Map<String, String> params,
			ModelMap model) {
		String saida = "";
		String erro = "";
		List<Entrada> entradas = new ArrayList<Entrada>();
		Entrada e = new Entrada();
		String cmd = "";
		
		try {
			String codigoTransacao = params.get("codigoTransacao");
			String codigoProduto = params.get("codigoProduto");
			String quantidade = params.get("quantidade");
			String valorTotal = params.get("valorTotal");
			cmd = params.get("botao");
			
			if (!cmd.equalsIgnoreCase("Listar")) {
				e.setCodigoTransacao(codigoTransacao);
			}
			if (cmd.equalsIgnoreCase("Inserir") || cmd.equalsIgnoreCase("Atualizar")) {
				e.setCodigoProduto(codigoProduto);
				e.setQuantidade(Integer.parseInt(quantidade));
				e.setValorTotal(Float.parseFloat(valorTotal));
			}
		
			if (cmd.equalsIgnoreCase("Inserir")) {
				saida = eDao.inserir(e);
			}
			if (cmd.equalsIgnoreCase("Atualizar")) {
				saida = eDao.atualizar(e);
			}
			if (cmd.equalsIgnoreCase("Excluir")) {
				saida = eDao.excluir(e);
			}
			if (cmd.equalsIgnoreCase("Buscar")) {
				e = eDao.buscar(e);
			}
			if (cmd.equalsIgnoreCase("Listar")) {
				entradas = eDao.listar();
			}

		} catch (SQLException | ClassNotFoundException | NumberFormatException e1) {
			saida = "";
			erro = e1.getMessage();
			if (erro.contains("input string")) {
				erro = "Preencha os campos corretamente";
			}
		} finally {
			if (!cmd.equalsIgnoreCase("Buscar")) {
				e = null;
			}
			if (!cmd.equalsIgnoreCase("Listar")) {
				entradas = null;
			}
			model.addAttribute("erro", erro);
			model.addAttribute("saida", saida);
			model.addAttribute("entrada", e);
			model.addAttribute("entradas", entradas);
		}

		return new ModelAndView("entrada");
	}
}
