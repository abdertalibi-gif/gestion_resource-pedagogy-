package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import models.Favori;
import models.Module;
import models.Ressource;
import models.TypeRessource;

public class FavoriDAO {

	private static final String FIND_BY_ETUDIANT = "SELECT f.*, r.titre, r.nom_fichier, r.chemin_fichier, r.date_upload, "
			+ "t.nom_type, m.nom_module " + "FROM favoris f " + "JOIN ressources r ON f.id_ressource = r.id_ressource "
			+ "JOIN types_ressources t ON r.id_type = t.id_type " + "JOIN modules m ON r.id_module = m.id_module "
			+ "WHERE f.id_etudiant = ? ORDER BY f.date_ajout DESC";

	private static final String EXISTS = "SELECT COUNT(*) FROM favoris WHERE id_etudiant = ? AND id_ressource = ?";

	private static final String INSERT = "INSERT INTO favoris (id_etudiant, id_ressource) VALUES (?, ?)";

	private static final String DELETE = "DELETE FROM favoris WHERE id_etudiant = ? AND id_ressource = ?";

	private static final String COUNT_BY_ETUDIANT = "SELECT COUNT(*) FROM favoris WHERE id_etudiant = ?";

	public List<Favori> findByEtudiant(int idEtudiant) {
		List<Favori> list = new ArrayList<>();
		try (Connection conn = DAOFactory.getConnection();
				PreparedStatement ps = conn.prepareStatement(FIND_BY_ETUDIANT)) {
			ps.setInt(1, idEtudiant);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Favori fav = new Favori();
					fav.setIdFavori(rs.getInt("id_favori"));
					Timestamp ts = rs.getTimestamp("date_ajout");
					if (ts != null)
						fav.setDateAjout(ts.toLocalDateTime());

					Ressource r = new Ressource();
					r.setIdRessource(rs.getInt("id_ressource"));
					r.setTitre(rs.getString("titre"));
					r.setNomFichier(rs.getString("nom_fichier"));
					r.setCheminFichier(rs.getString("chemin_fichier"));
					Timestamp ts2 = rs.getTimestamp("date_upload");
					if (ts2 != null)
						r.setDateUpload(ts2.toLocalDateTime());

					TypeRessource type = new TypeRessource();
					type.setNomType(rs.getString("nom_type"));
					r.setType(type);

					Module mod = new Module();
					mod.setNomModule(rs.getString("nom_module"));
					r.setModule(mod);

					fav.setRessource(r);
					list.add(fav);
				}
			}
		} catch (SQLException e) {
			System.err.println("FavoriDAO.findByEtudiant: " + e.getMessage());
		}
		return list;
	}

	public boolean exists(int idEtudiant, int idRessource) {
		try (Connection conn = DAOFactory.getConnection(); PreparedStatement ps = conn.prepareStatement(EXISTS)) {
			ps.setInt(1, idEtudiant);
			ps.setInt(2, idRessource);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return rs.getInt(1) > 0;
			}
		} catch (SQLException e) {
			System.err.println("FavoriDAO.exists: " + e.getMessage());
		}
		return false;
	}

	public boolean add(int idEtudiant, int idRessource) {
		try (Connection conn = DAOFactory.getConnection(); PreparedStatement ps = conn.prepareStatement(INSERT)) {
			ps.setInt(1, idEtudiant);
			ps.setInt(2, idRessource);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			System.err.println("FavoriDAO.add: " + e.getMessage());
		}
		return false;
	}

	public boolean remove(int idEtudiant, int idRessource) {
		try (Connection conn = DAOFactory.getConnection(); PreparedStatement ps = conn.prepareStatement(DELETE)) {
			ps.setInt(1, idEtudiant);
			ps.setInt(2, idRessource);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			System.err.println("FavoriDAO.remove: " + e.getMessage());
		}
		return false;
	}

	public int countByEtudiant(int idEtudiant) {
		try (Connection conn = DAOFactory.getConnection();
				PreparedStatement ps = conn.prepareStatement(COUNT_BY_ETUDIANT)) {
			ps.setInt(1, idEtudiant);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return rs.getInt(1);
			}
		} catch (SQLException e) {
			System.err.println("FavoriDAO.countByEtudiant: " + e.getMessage());
		}
		return 0;
	}
}