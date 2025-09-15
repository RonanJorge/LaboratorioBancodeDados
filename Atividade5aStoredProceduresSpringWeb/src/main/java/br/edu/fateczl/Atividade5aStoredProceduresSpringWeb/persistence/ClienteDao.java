package br.edu.fateczl.Atividade5aStoredProceduresSpringWeb.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import br.edu.fateczl.Atividade5aStoredProceduresSpringWeb.model.Cliente;

@Repository
public class ClienteDao implements ICrud<Cliente> {

	@Autowired
	private GenericDao gDao;

	@Override
	public Cliente buscar(Cliente cliente) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT cpf, nome, email, limiteDeCredito, nascimento FROM pessoa WHERE cpf = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1,cliente.getCpf());
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			cliente.setCpf(rs.getString("cpf"));
			cliente.setNome(rs.getString("nome"));
			cliente.setEmail(rs.getString("email"));
			cliente.setLimiteDeCredito(rs.getFloat("limiteDeCredito"));
			cliente.setNascimento(LocalDate.parse(rs.getString("nascimento")));
			
		}
		rs.close();
		ps.close();
		return cliente;
	}

	@Override
	public List<Cliente> listar() throws SQLException, ClassNotFoundException {
		List<Cliente> clientes = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT cpf, nome, email, limiteDeCredito, nascimento,"
				+ " CONVERT(CHAR(10), nascimento, 103) AS dtNasc "
				+ " FROM cliente";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Cliente cliente = new Cliente();
			cliente.setCpf(rs.getString("cpf"));
			cliente.setNome(rs.getString("nome"));
			cliente.setEmail(rs.getString("email"));
			cliente.setNascimento(LocalDate.parse(rs.getString("nascimento")));
			cliente.setDtNasc(rs.getString("dtNasc"));
			clientes.add(cliente);
		}
		rs.close();
		ps.close();
		return clientes;
	}

//	Chamada de SP deve estar entre chaves
	@Override
	public String inserir(Cliente cliente) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_cliente(?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "I");
		cs.setString(2, cliente.getCpf());
		cs.setString(3, cliente.getNome());
		cs.setString(4, cliente.getEmail());
		cs.setString(5, cliente.getLimiteDeCredito().toString());
		cs.setString(6, cliente.getNascimento().toString());
		cs.registerOutParameter(7, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(7);
		cs.close();
		
		return saida;
	}

	@Override
	public String atualizar(Cliente cliente) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_pessoa(?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "U");
		cs.setString(2, cliente.getCpf());
		cs.setString(3, cliente.getNome());
		cs.setString(4, cliente.getEmail());
		cs.setString(5, cliente.getLimiteDeCredito().toString());
		cs.setString(6, cliente.getNascimento().toString());
		cs.registerOutParameter(7, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(7);
		cs.close();
		
		return saida;

	}

	@Override
	public String excluir(Cliente cliente) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_pessoa(?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "D");
		cs.setString(2, cliente.getCpf());
		cs.setNull(3, Types.VARCHAR);
		cs.setNull(4, Types.VARCHAR);
		cs.setNull(5, Types.VARCHAR);
		cs.setNull(6, Types.VARCHAR);
		cs.registerOutParameter(7, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(7);
		cs.close();
		
		return saida;
	}
}
