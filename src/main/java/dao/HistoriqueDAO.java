package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import models.Module;

import models.HistoriqueConsultation;
import models.Ressource;
import models.TypeRessource;

public class HistoriqueDAO {

    private static final String FIND_BY_ETUDIANT =
        "SELECT h.*, r.titre, r.nom_fichier, r.chemin_fichier, " +
        "t.nom_type, m.nom_module " +
        "FROM historique_consultation h " +
        "JOIN ressources r ON h.id_ressource = r.id_ressource " +
        "JOIN types_ressources t ON r.id_type = t.id_type " +
        "JOIN modules m ON r.id_module = m.id_module " +
        "WHERE h.id_etudiant = ? ORDER BY h.date_consultation DESC";

    private static final String INSERT =
        "INSERT INTO historique_consultation (id_etudiant, id_ressource, type_action) " +
        "VALUES (?, ?, ?)";

    private static final String COUNT_BY_ETUDIANT =
        "SELECT COUNT(*) FROM historique_consultation WHERE id_etudiant = ?";

    private static final String COUNT_BY_RESSOURCE =
        "SELECT COUNT(*) FROM historique_consultation WHERE id_ressource = ?";

    public List<HistoriqueConsultation> findByEtudiant(int idEtudiant) {
        List<HistoriqueConsultation> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_ETUDIANT)) {
            ps.setInt(1, idEtudiant);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HistoriqueConsultation h = new HistoriqueConsultation();
                    h.setIdHistorique(rs.getInt("id_historique"));
                    h.setTypeAction(rs.getString("type_action"));
                    Timestamp ts = rs.getTimestamp("date_consultation");
                    if (ts != null) h.setDateConsultation(ts.toLocalDateTime());

                    Ressource r = new Ressource();
                    r.setIdRessource(rs.getInt("id_ressource"));
                    r.setTitre(rs.getString("titre"));
                    r.setNomFichier(rs.getString("nom_fichier"));
                    r.setCheminFichier(rs.getString("chemin_fichier"));

                    TypeRessource type = new TypeRessource();
                    type.setNomType(rs.getString("nom_type"));
                    r.setType(type);

                    Module mod = new Module();
                    mod.setNomModule(rs.getString("nom_module"));
                    r.setModule(mod);

                    h.setRessource(r);
                    list.add(h);
                }
            }
        } catch (SQLException e) {
            System.err.println("HistoriqueDAO.findByEtudiant: " + e.getMessage());
        }
        return list;
    }

    public boolean add(int idEtudiant, int idRessource, String typeAction) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT)) {
            ps.setInt(1, idEtudiant);
            ps.setInt(2, idRessource);
            ps.setString(3, typeAction);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("HistoriqueDAO.add: " + e.getMessage());
        }
        return false;
    }

    public int countByEtudiant(int idEtudiant) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_BY_ETUDIANT)) {
            ps.setInt(1, idEtudiant);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("HistoriqueDAO.countByEtudiant: " + e.getMessage());
        }
        return 0;
    }

    public int countByRessource(int idRessource) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_BY_RESSOURCE)) {
            ps.setInt(1, idRessource);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("HistoriqueDAO.countByRessource: " + e.getMessage());
        }
        return 0;
    }
}