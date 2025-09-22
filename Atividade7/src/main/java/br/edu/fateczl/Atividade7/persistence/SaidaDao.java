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

import br.edu.fateczl.Atividade7.model.Saida;

@Repository
public class SaidaDao implements ICrud<Saida> {

	@Autowired
	private GenericDao gDao;

	@Override
	public Saida buscar(Saida saida) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT codigoTransacao, codigoProduto, quantidade, valorTotal FROM saida "
				+ "WHERE codigoTransacao = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1,saida.getCodigoTransacao());
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			saida.setCodigoTransacao(rs.getString("codigoTransacao"));
			saida.setCodigoProduto(rs.getString("codigoProduto"));
			saida.setQuantidade(rs.getInt("quantidade"));
			saida.setValorTotal(rs.getFloat("valorTotal"));
		}
		rs.close();
		ps.close();
		return saida;
	}

	@Override
	public List<Saida> listar() throws SQLException, ClassNotFoundException {
		List<Saida> saidas = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT codigoTransacao, codigoProduto, quantidade, valorTotal FROM saida";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Saida saida = new Saida();
			saida.setCodigoTransacao(rs.getString("codigoTransacao"));
			saida.setCodigoProduto(rs.getString("codigoProduto"));
			saida.setQuantidade(rs.getInt("quantidade"));
			saida.setValorTotal(rs.getFloat("valorTotal"));
			
			saidas.add(saida);
		}
		rs.close();
		ps.close();
		return saidas;
	}

//	Chamada de SP deve estar entre chaves
	@Override
	public String inserir(Saida saida) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_produto(?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "s");
		cs.setString(2, "I");
		cs.setString(3, saida.getCodigoTransacao());
		cs.setString(4, saida.getCodigoProduto());
		cs.setInt(5, saida.getQuantidade());
		cs.registerOutParameter(6, Types.VARCHAR);
		cs.execute();
		
		String saida1 = cs.getString(6);
		cs.close();
		
		return saida1;
	}

	@Override
	public String atualizar(Saida saida) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_produto(?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "s");
		cs.setString(2, "U");
		cs.setString(3, saida.getCodigoTransacao());
		cs.setString(4, saida.getCodigoProduto());
		cs.setInt(5, saida.getQuantidade());
		cs.registerOutParameter(6, Types.VARCHAR);
		cs.execute();
		
		String saida1 = cs.getString(6);
		cs.close();
		
		return saida1;

	}

	@Override
	public String excluir(Saida saida) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_produto(?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "e");
		cs.setString(2, "D");
		cs.setString(3, saida.getCodigoTransacao());
		cs.setNull(4, Types.VARCHAR);
		cs.setNull(5, Types.VARCHAR);
		cs.registerOutParameter(6, Types.VARCHAR);
		cs.execute();
		
		String saida1 = cs.getString(6);
		cs.close();
		
		return saida1;
	}
}
