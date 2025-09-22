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

import br.edu.fateczl.Atividade7.model.Saida;
import br.edu.fateczl.Atividade7.persistence.SaidaDao;

@Controller
public class SaidaController {

	@Autowired
	private SaidaDao sDao;
	
	@RequestMapping(name = "saida", value = "/saida", method = RequestMethod.GET)
	public ModelAndView saidaGet(
			@RequestParam Map<String, String> params,
			ModelMap model) {
		String acao = params.get("acao");
		String codigoTransacao = params.get("codigoTransacao");
		
		Saida s = new Saida();
		String erro = "";
		List<Saida> saidas = new ArrayList<>();
		
		try {
			if (acao != null) {
				s.setCodigoTransacao(codigoTransacao);
				
				if (acao.equalsIgnoreCase("excluir")) {
					sDao.excluir(s);
					saidas = sDao.listar();
					s = null;
				} else {
					s = sDao.buscar(s);
					saidas = null;
				}
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			model.addAttribute("erro", erro);
			model.addAttribute("saida", s);
			model.addAttribute("saidas", saidas);
			
		}
		return new ModelAndView("saida");
	}
	
	@RequestMapping(name = "saida", value = "/saida", method = RequestMethod.POST)
	public ModelAndView saidaPost(
			@RequestParam Map<String, String> params,
			ModelMap model) {
		String saida1 = "";
		String erro = "";
		List<Saida> saidas = new ArrayList<Saida>();
		Saida s = new Saida();
		String cmd = "";
		
		try {
			String codigoTransacao = params.get("codigoTransacao");
			String codigoProduto = params.get("codigoProduto");
			String quantidade = params.get("quantidade");
			String valorTotal = params.get("valorTotal");
			cmd = params.get("botao");
			
			if (!cmd.equalsIgnoreCase("Listar")) {
				s.setCodigoTransacao(codigoTransacao);
			}
			if (cmd.equalsIgnoreCase("Inserir") || cmd.equalsIgnoreCase("Atualizar")) {
				s.setCodigoProduto(codigoProduto);
				s.setQuantidade(Integer.parseInt(quantidade));
				s.setValorTotal(Float.parseFloat(valorTotal));
			}
		
			if (cmd.equalsIgnoreCase("Inserir")) {
				saida1 = sDao.inserir(s);
			}
			if (cmd.equalsIgnoreCase("Atualizar")) {
				saida1 = sDao.atualizar(s);
			}
			if (cmd.equalsIgnoreCase("Excluir")) {
				saida1 = sDao.excluir(s);
			}
			if (cmd.equalsIgnoreCase("Buscar")) {
				s = sDao.buscar(s);
			}
			if (cmd.equalsIgnoreCase("Listar")) {
				saidas = sDao.listar();
			}

		} catch (SQLException | ClassNotFoundException | NumberFormatException e) {
			saida1 = "";
			erro = e.getMessage();
			if (erro.contains("input string")) {
				erro = "Preencha os campos corretamente";
			}
		} finally {
			if (!cmd.equalsIgnoreCase("Buscar")) {
				s = null;
			}
			if (!cmd.equalsIgnoreCase("Listar")) {
				saidas = null;
			}
			model.addAttribute("erro", erro);
			model.addAttribute("saida", saida1);
			model.addAttribute("saida", s);
			model.addAttribute("saidas", saidas);
		}

		return new ModelAndView("saida");
	}
}