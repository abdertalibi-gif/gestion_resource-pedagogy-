package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import models.Devoir;
import models.Module;
import models.Soumission;
import models.Utilisateur;

public class SoumissionDAO {

    private static final String SELECT_BASE =
        "SELECT s.*, m.nom_module, m.code_module, " +
        "u.prenom, u.nom AS nom_etudiant, " +
        "d.id_devoir, d.titre AS devoir_titre " +
        "FROM soumissions s " +
        "JOIN modules m ON s.id_module = m.id_module " +
        "JOIN utilisateurs u ON s.id_etudiant = u.id_utilisateur " +
        "LEFT JOIN devoirs d ON s.id_devoir = d.id_devoir ";

    private static final String FIND_BY_ETUDIANT = SELECT_BASE +
        "WHERE s.id_etudiant = ? ORDER BY s.date_soumission DESC";

    private static final String FIND_BY_DEVOIR = SELECT_BASE +
        "WHERE s.id_devoir = ? ORDER BY s.date_soumission DESC";

    private static final String FIND_BY_MODULE = SELECT_BASE +
        "WHERE s.id_module = ? ORDER BY s.date_soumission DESC";

    private static final String FIND_BY_PROFESSEUR = SELECT_BASE +
        "JOIN affectations_module am ON m.id_module = am.id_module " +
        "WHERE am.id_professeur = ? ORDER BY s.date_soumission DESC";

    private static final String FIND_BY_ID = SELECT_BASE +
        "WHERE s.id_soumission = ?";

    private static final String INSERT =
        "INSERT INTO soumissions (id_etudiant, id_module, id_devoir, titre, description, " +
        "nom_fichier, chemin_fichier, taille_fichier, statut) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'EN_ATTENTE')";

    private static final String UPDATE_STATUT =
        "UPDATE soumissions SET statut=?, note=?, commentaire=? WHERE id_soumission=?";

    private Soumission mapResultSet(ResultSet rs) throws SQLException {
        Soumission s = new Soumission();
        s.setIdSoumission(rs.getInt("id_soumission"));
        s.setTitre(rs.getString("titre"));
        s.setDescription(rs.getString("description"));
        s.setNomFichier(rs.getString("nom_fichier"));
        s.setCheminFichier(rs.getString("chemin_fichier"));
        s.setTailleFichier(rs.getLong("taille_fichier"));
        s.setStatut(rs.getString("statut"));

        Timestamp ts = rs.getTimestamp("date_soumission");
        if (ts != null) s.setDateSoumission(ts.toLocalDateTime());

        double noteVal = rs.getDouble("note");
        if (!rs.wasNull()) s.setNote(noteVal);
        s.setCommentaire(rs.getString("commentaire"));

        Module mod = new Module();
        mod.setNomModule(rs.getString("nom_module"));
        mod.setCodeModule(rs.getString("code_module"));
        s.setModule(mod);

        Utilisateur etu = new Utilisateur();
        etu.setPrenom(rs.getString("prenom"));
        etu.setNom(rs.getString("nom_etudiant"));
        s.setEtudiant(etu);

        int idDevoir = rs.getInt("id_devoir");
        if (!rs.wasNull()) {
            Devoir d = new Devoir();
            d.setIdDevoir(idDevoir);
            d.setTitre(rs.getString("devoir_titre"));
            s.setDevoir(d);
        }

        return s;
    }

    public List<Soumission> findByDevoir(int idDevoir) {
        List<Soumission> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_DEVOIR)) {
            ps.setInt(1, idDevoir);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("SoumissionDAO.findByDevoir: " + e.getMessage());
        }
        return list;
    }

    public List<Soumission> findByEtudiant(int idEtudiant) {
        List<Soumission> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_ETUDIANT)) {
            ps.setInt(1, idEtudiant);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("SoumissionDAO.findByEtudiant: " + e.getMessage());
        }
        return list;
    }

    public List<Soumission> findByModule(int idModule) {
        List<Soumission> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_MODULE)) {
            ps.setInt(1, idModule);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("SoumissionDAO.findByModule: " + e.getMessage());
        }
        return list;
    }

    public List<Soumission> findByProfesseur(int idProfesseur) {
        List<Soumission> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_PROFESSEUR)) {
            ps.setInt(1, idProfesseur);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("SoumissionDAO.findByProfesseur: " + e.getMessage());
        }
        return list;
    }

    public Soumission findById(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("SoumissionDAO.findById: " + e.getMessage());
        }
        return null;
    }

    public int insert(Soumission s) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, s.getEtudiant().getIdUtilisateur());
            ps.setInt(2, s.getModule().getIdModule());
            if (s.getDevoir() != null && s.getDevoir().getIdDevoir() > 0) {
                ps.setInt(3, s.getDevoir().getIdDevoir());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            ps.setString(4, s.getTitre());
            ps.setString(5, s.getDescription());
            ps.setString(6, s.getNomFichier());
            ps.setString(7, s.getCheminFichier());
            ps.setLong(8, s.getTailleFichier());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("SoumissionDAO.insert: " + e.getMessage());
        }
        return -1;
    }

    public boolean updateStatut(int id, String statut, Double note, String commentaire) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_STATUT)) {
            ps.setString(1, statut);
            if (note != null) {
                ps.setDouble(2, note);
            } else {
                ps.setNull(2, java.sql.Types.DOUBLE);
            }
            ps.setString(3, commentaire);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SoumissionDAO.updateStatut: " + e.getMessage());
        }
        return false;
    }
}
