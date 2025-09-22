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

import br.edu.fateczl.Atividade7.model.Entrada;

@Repository
public class EntradaDao implements ICrud<Entrada> {

	@Autowired
	private GenericDao gDao;

	@Override
	public Entrada buscar(Entrada entrada) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT codigoTransacao, codigoProduto, quantidade, valorTotal FROM entrada "
				+ "WHERE codigoTransacao = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1,entrada.getCodigoTransacao());
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			entrada.setCodigoTransacao(rs.getString("codigoTransacao"));
			entrada.setCodigoProduto(rs.getString("codigoProduto"));
			entrada.setQuantidade(rs.getInt("quantidade"));
			entrada.setValorTotal(rs.getFloat("valorTotal"));
		}
		rs.close();
		ps.close();
		return entrada;
	}

	@Override
	public List<Entrada> listar() throws SQLException, ClassNotFoundException {
		List<Entrada> entradas = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT codigoTransacao, codigoProduto, quantidade, valorTotal FROM entrada";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Entrada entrada = new Entrada();
			entrada.setCodigoTransacao(rs.getString("codigoTransacao"));
			entrada.setCodigoProduto(rs.getString("codigoProduto"));
			entrada.setQuantidade(rs.getInt("quantidade"));
			entrada.setValorTotal(rs.getFloat("valorTotal"));
			
			entradas.add(entrada);
		}
		rs.close();
		ps.close();
		return entradas;
	}

//	Chamada de SP deve estar entre chaves
	@Override
	public String inserir(Entrada entrada) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_produto(?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "e");
		cs.setString(2, "I");
		cs.setString(3, entrada.getCodigoTransacao());
		cs.setString(4, entrada.getCodigoProduto());
		cs.setInt(5, entrada.getQuantidade());
		cs.registerOutParameter(6, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(6);
		cs.close();
		
		return saida;
	}

	@Override
	public String atualizar(Entrada entrada) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_produto(?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "e");
		cs.setString(2, "U");
		cs.setString(3, entrada.getCodigoTransacao());
		cs.setString(4, entrada.getCodigoProduto());
		cs.setInt(5, entrada.getQuantidade());
		cs.registerOutParameter(6, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(6);
		cs.close();
		
		return saida;

	}

	@Override
	public String excluir(Entrada entrada) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_produto(?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "e");
		cs.setString(2, "D");
		cs.setString(3, entrada.getCodigoTransacao());
		cs.setNull(4, Types.VARCHAR);
		cs.setNull(5, Types.VARCHAR);
		cs.registerOutParameter(6, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(6);
		cs.close();
		
		return saida;
	}
}
