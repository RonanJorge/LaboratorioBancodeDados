package br.edu.fateczl.Atividade7.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import br.edu.fateczl.Atividade7.model.Produto;

@Repository
public class ProdutoDao implements ICrud<Produto> {

	@Autowired
	private GenericDao gDao;

	@Override
	public Produto buscar(Produto produto) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT codigoProduto, nome, valor FROM produto WHERE codigoProduto = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1,produto.getCodigoProduto());
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			produto.setCodigoProduto(rs.getString("codigoProduto"));
			produto.setNome(rs.getString("nome"));
			produto.setValor(rs.getFloat("valor"));
		}
		rs.close();
		ps.close();
		return produto;
	}

	@Override
	public List<Produto> listar() throws SQLException, ClassNotFoundException {
		List<Produto> produtos = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT codigoProduto, nome, valor FROM produto";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Produto produto = new Produto();
			produto.setCodigoProduto(rs.getString("codigoProduto"));
			produto.setNome(rs.getString("nome"));
			produto.setValor(rs.getFloat("valor"));
			
			produtos.add(produto);
		}
		rs.close();
		ps.close();
		return produtos;
	}

//	Chamada de SP deve estar entre chaves
	@Override
	public String inserir(Produto produto) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_produto(?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "I");
		cs.setString(2, produto.getCodigoProduto());
		cs.setString(3, produto.getNome());
		cs.setFloat(4, produto.getValor());
		cs.registerOutParameter(5, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(5);
		cs.close();
		
		return saida;
	}

	@Override
	public String atualizar(Produto produto) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_produto(?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "U");
		cs.setString(2, produto.getCodigoProduto());
		cs.setString(3, produto.getNome());
		cs.setFloat(4, produto.getValor());
		cs.registerOutParameter(5, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(7);
		cs.close();
		
		return saida;

	}

	@Override
	public String excluir(Produto produto) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_produto(?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "D");
		cs.setString(2, produto.getCodigoProduto());
		cs.setNull(3, Types.VARCHAR);
		cs.setNull(4, Types.VARCHAR);
		cs.registerOutParameter(5, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(7);
		cs.close();
		
		return saida;
	}
}
