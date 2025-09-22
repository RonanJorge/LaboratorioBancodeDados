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

import br.edu.fateczl.Atividade7.model.Produto;
import br.edu.fateczl.Atividade7.persistence.ProdutoDao;

@Controller
public class ProdutoController {

	@Autowired
	private ProdutoDao pDao;
	
	@RequestMapping(name = "produto", value = "/produto", method = RequestMethod.GET)
	public ModelAndView produtoGet(
			@RequestParam Map<String, String> params,
			ModelMap model) {
		String acao = params.get("acao");
		String codigoProduto = params.get("codigoProduto");
		
		Produto p = new Produto();
		String erro = "";
		List<Produto> produtos = new ArrayList<>();
		
		try {
			if (acao != null) {
				p.setCodigoProduto(codigoProduto);
				
				if (acao.equalsIgnoreCase("excluir")) {
					pDao.excluir(p);
					produtos = pDao.listar();
					p = null;
				} else {
					p = pDao.buscar(p);
					produtos = null;
				}
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			model.addAttribute("erro", erro);
			model.addAttribute("produto", p);
			model.addAttribute("produtos", produtos);
			
		}
		return new ModelAndView("produto");
	}
	
	@RequestMapping(name = "produto", value = "/produto", method = RequestMethod.POST)
	public ModelAndView produtoPost(
			@RequestParam Map<String, String> params,
			ModelMap model) {
		String saida = "";
		String erro = "";
		List<Produto> produtos = new ArrayList<Produto>();
		Produto p = new Produto();
		String cmd = "";
		
		try {
			String codigoProduto = params.get("codigoProduto");
			String nome = params.get("nome");
			String valor = params.get("valor");
			cmd = params.get("botao");
			
			if (!cmd.equalsIgnoreCase("Listar")) {
				p.setCodigoProduto(codigoProduto);
			}
			if (cmd.equalsIgnoreCase("Inserir") || cmd.equalsIgnoreCase("Atualizar")) {
				p.setNome(nome);
				p.setValor(Integer.parseInt(valor));
			}
		
			if (cmd.equalsIgnoreCase("Inserir")) {
				saida = pDao.inserir(p);
			}
			if (cmd.equalsIgnoreCase("Atualizar")) {
				saida = pDao.atualizar(p);
			}
			if (cmd.equalsIgnoreCase("Excluir")) {
				saida = pDao.excluir(p);
			}
			if (cmd.equalsIgnoreCase("Buscar")) {
				p = pDao.buscar(p);
			}
			if (cmd.equalsIgnoreCase("Listar")) {
				produtos = pDao.listar();
			}

		} catch (SQLException | ClassNotFoundException | NumberFormatException e) {
			saida = "";
			erro = e.getMessage();
			if (erro.contains("input string")) {
				erro = "Preencha os campos corretamente";
			}
		} finally {
			if (!cmd.equalsIgnoreCase("Buscar")) {
				p = null;
			}
			if (!cmd.equalsIgnoreCase("Listar")) {
				produtos = null;
			}
			model.addAttribute("erro", erro);
			model.addAttribute("saida", saida);
			model.addAttribute("produto", p);
			model.addAttribute("produtos", produtos);
		}

		return new ModelAndView("produto");
	}
}
