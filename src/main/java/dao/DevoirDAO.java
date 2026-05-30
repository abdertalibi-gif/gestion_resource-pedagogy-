package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import models.Devoir;
import models.Filiere;
import models.Module;
import models.Semestre;
import models.Utilisateur;

public class DevoirDAO {

    private static final String FIND_BY_ID =
        "SELECT d.*, m.nom_module, m.code_module, f.nom_filiere, s.nom_semestre, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof, " +
        "(SELECT COUNT(*) FROM soumissions WHERE id_devoir = d.id_devoir) AS nb_soumissions " +
        "FROM devoirs d " +
        "JOIN modules m ON d.id_module = m.id_module " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "JOIN utilisateurs u ON d.id_professeur = u.id_utilisateur " +
        "WHERE d.id_devoir = ?";

    private static final String FIND_BY_MODULE =
        "SELECT d.*, m.nom_module, m.code_module, f.nom_filiere, s.nom_semestre, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof, " +
        "(SELECT COUNT(*) FROM soumissions WHERE id_devoir = d.id_devoir) AS nb_soumissions " +
        "FROM devoirs d " +
        "JOIN modules m ON d.id_module = m.id_module " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "JOIN utilisateurs u ON d.id_professeur = u.id_utilisateur " +
        "WHERE d.id_module = ? ORDER BY d.date_creation DESC";

    private static final String FIND_BY_PROFESSEUR =
        "SELECT d.*, m.nom_module, m.code_module, f.nom_filiere, s.nom_semestre, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof, " +
        "(SELECT COUNT(*) FROM soumissions WHERE id_devoir = d.id_devoir) AS nb_soumissions " +
        "FROM devoirs d " +
        "JOIN modules m ON d.id_module = m.id_module " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "JOIN utilisateurs u ON d.id_professeur = u.id_utilisateur " +
        "JOIN affectations_modules am ON d.id_module = am.id_module " +
        "WHERE am.id_professeur = ? ORDER BY d.date_creation DESC";

    private static final String FIND_BY_FILIERE_SEMESTRE =
        "SELECT d.*, m.nom_module, m.code_module, f.nom_filiere, s.nom_semestre, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof, " +
        "(SELECT COUNT(*) FROM soumissions WHERE id_devoir = d.id_devoir) AS nb_soumissions " +
        "FROM devoirs d " +
        "JOIN modules m ON d.id_module = m.id_module " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "JOIN utilisateurs u ON d.id_professeur = u.id_utilisateur " +
        "WHERE m.id_filiere = ? AND m.id_semestre = ? ORDER BY d.date_creation DESC";

    private static final String INSERT =
        "INSERT INTO devoirs (titre, description, date_limite, nom_fichier, " +
        "chemin_fichier, taille_fichier, id_module, id_professeur) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String DELETE = "DELETE FROM devoirs WHERE id_devoir = ?";

    private Devoir mapResultSet(ResultSet rs) throws SQLException {
        Devoir d = new Devoir();
        d.setIdDevoir(rs.getInt("id_devoir"));
        d.setTitre(rs.getString("titre"));
        d.setDescription(rs.getString("description"));
        d.setNomFichier(rs.getString("nom_fichier"));
        d.setCheminFichier(rs.getString("chemin_fichier"));
        d.setTailleFichier(rs.getLong("taille_fichier"));
        d.setNbSoumissions(rs.getInt("nb_soumissions"));

        Timestamp ts = rs.getTimestamp("date_creation");
        if (ts != null) d.setDateCreation(ts.toLocalDateTime());

        Timestamp dl = rs.getTimestamp("date_limite");
        if (dl != null) d.setDateLimite(dl.toLocalDateTime());

        Module mod = new Module();
        mod.setNomModule(rs.getString("nom_module"));
        mod.setCodeModule(rs.getString("code_module"));
        Filiere f = new Filiere();
        f.setNomFiliere(rs.getString("nom_filiere"));
        mod.setFiliere(f);
        Semestre s = new Semestre();
        s.setNomSemestre(rs.getString("nom_semestre"));
        mod.setSemestre(s);
        d.setModule(mod);

        Utilisateur prof = new Utilisateur();
        prof.setNom(rs.getString("nom_prof"));
        d.setProfesseur(prof);

        return d;
    }

    public Devoir findById(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("DevoirDAO.findById: " + e.getMessage());
        }
        return null;
    }

    public List<Devoir> findByModule(int idModule) {
        List<Devoir> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_MODULE)) {
            ps.setInt(1, idModule);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("DevoirDAO.findByModule: " + e.getMessage());
        }
        return list;
    }

    public List<Devoir> findByProfesseur(int idProfesseur) {
        List<Devoir> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_PROFESSEUR)) {
            ps.setInt(1, idProfesseur);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("DevoirDAO.findByProfesseur: " + e.getMessage());
        }
        return list;
    }

    public List<Devoir> findByFiliereSemestre(int idFiliere, int idSemestre) {
        List<Devoir> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_FILIERE_SEMESTRE)) {
            ps.setInt(1, idFiliere);
            ps.setInt(2, idSemestre);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("DevoirDAO.findByFiliereSemestre: " + e.getMessage());
        }
        return list;
    }

    public int insert(Devoir d) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, d.getTitre());
            ps.setString(2, d.getDescription());
            ps.setTimestamp(3, d.getDateLimite() != null ? Timestamp.valueOf(d.getDateLimite()) : null);
            ps.setString(4, d.getNomFichier());
            ps.setString(5, d.getCheminFichier());
            ps.setLong(6, d.getTailleFichier());
            ps.setInt(7, d.getModule().getIdModule());
            ps.setInt(8, d.getProfesseur().getIdUtilisateur());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("DevoirDAO.insert: " + e.getMessage());
        }
        return -1;
    }

    public boolean delete(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("DevoirDAO.delete: " + e.getMessage());
        }
        return false;
    }
}
