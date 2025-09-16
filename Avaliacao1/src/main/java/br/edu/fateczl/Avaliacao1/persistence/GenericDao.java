package br.edu.fateczl.Avaliacao1.persistence;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.springframework.stereotype.Repository;

@Repository
public class GenericDao {

	private Connection c;

	public Connection getConnection() throws ClassNotFoundException, SQLException {

		String hostName = "DESKTOP-4U19BKL";
		String dbName = "agis";
		String user = "ronanjorge";
		String senha = "12345678";
		Class.forName("net.sourceforge.jtds.jdbc.Driver");
		c = DriverManager.getConnection(String.format(
				"jdbc:jtds:sqlserver://%s:1433;databaseName=%s;user=%s;password=%s;", 
				hostName, dbName, user, senha));

		return c;
	}

}