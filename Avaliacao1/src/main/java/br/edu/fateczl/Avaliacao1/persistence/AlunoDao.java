package br.edu.fateczl.Avaliacao1.persistence;

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

import br.edu.fateczl.Avaliacao1.model.Aluno;

@Repository
public class AlunoDao implements ICrud<Aluno> {

	@Autowired
	private GenericDao gDao;

	@Override
	public Aluno buscar(Aluno aluno) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT id, nome, nascimento, email FROM aluno WHERE id = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1,aluno.getId());
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			aluno.setId(rs.getInt("id"));
			aluno.setNome(rs.getString("nome"));
			aluno.setNascimento(LocalDate.parse(rs.getString("nascimento")));
			aluno.setEmail(rs.getString("email"));
		}
		rs.close();
		ps.close();
		return aluno;
	}

	@Override
	public List<Aluno> listar() throws SQLException, ClassNotFoundException {
		List<Aluno> alunos = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT id, nome, nascimento,"
				+ " CONVERT(CHAR(10), nascimento, 103) AS dtNasc, email "
				+ " FROM aluno";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Aluno aluno = new Aluno();
			aluno.setId(rs.getInt("id"));
			aluno.setNome(rs.getString("nome"));
			aluno.setNascimento(LocalDate.parse(rs.getString("nascimento")));
			aluno.setDtNasc(rs.getString("dtNasc"));
			aluno.setEmail(rs.getString("email"));
			
			alunos.add(aluno);
		}
		rs.close();
		ps.close();
		return alunos;
	}

//	Chamada de SP deve estar entre chaves
	@Override
	public String inserir(Aluno aluno) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_aluno(?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "I");
		cs.setInt(2, aluno.getId());
		cs.setString(3, aluno.getNome());
		cs.setString(4, aluno.getNascimento().toString());
		cs.setString(5, aluno.getEmail());
		cs.registerOutParameter(6, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(6);
		cs.close();
		
		return saida;
	}

	@Override
	public String atualizar(Aluno aluno) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_aluno(?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "U");
		cs.setInt(2, aluno.getId());
		cs.setString(3, aluno.getNome());
		cs.setString(4, aluno.getNascimento().toString());
		cs.setString(5, aluno.getEmail());
		cs.registerOutParameter(6, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(6);
		cs.close();
		
		return saida;

	}

	@Override
	public String excluir(Aluno aluno) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_aluno(?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "D");
		cs.setInt(2, aluno.getId());
		cs.setNull(3, Types.VARCHAR);
		cs.setNull(4, Types.VARCHAR);
		cs.setNull(5, Types.VARCHAR);
		cs.registerOutParameter(6, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(6);
		cs.close();
		
		return saida;
	}
}
