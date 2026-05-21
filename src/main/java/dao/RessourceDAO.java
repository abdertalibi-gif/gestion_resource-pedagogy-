package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import models.Filiere;
import models.Ressource;
import models.Semestre;
import models.TypeRessource;
import models.Utilisateur;
import models.Module;

public class RessourceDAO {

    private static final String FIND_ALL =
        "SELECT r.*, t.nom_type, m.nom_module, m.code_module, " +
        "f.nom_filiere, s.nom_semestre, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof " +
        "FROM ressources r " +
        "JOIN types_ressources t ON r.id_type = t.id_type " +
        "JOIN modules m ON r.id_module = m.id_module " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "JOIN utilisateurs u ON r.id_professeur = u.id_utilisateur " +
        "ORDER BY r.date_upload DESC";

    private static final String FIND_BY_ID =
        "SELECT r.*, t.nom_type, m.nom_module, m.code_module, " +
        "f.nom_filiere, s.nom_semestre, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof " +
        "FROM ressources r " +
        "JOIN types_ressources t ON r.id_type = t.id_type " +
        "JOIN modules m ON r.id_module = m.id_module " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "JOIN utilisateurs u ON r.id_professeur = u.id_utilisateur " +
        "WHERE r.id_ressource = ?";

    private static final String FIND_BY_PROFESSEUR =
        "SELECT r.*, t.nom_type, m.nom_module, m.code_module, " +
        "f.nom_filiere, s.nom_semestre, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof " +
        "FROM ressources r " +
        "JOIN types_ressources t ON r.id_type = t.id_type " +
        "JOIN modules m ON r.id_module = m.id_module " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "JOIN utilisateurs u ON r.id_professeur = u.id_utilisateur " +
        "WHERE r.id_professeur = ? ORDER BY r.date_upload DESC";

    private static final String FIND_BY_MODULE =
        "SELECT r.*, t.nom_type, m.nom_module, m.code_module, " +
        "f.nom_filiere, s.nom_semestre, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof " +
        "FROM ressources r " +
        "JOIN types_ressources t ON r.id_type = t.id_type " +
        "JOIN modules m ON r.id_module = m.id_module " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "JOIN utilisateurs u ON r.id_professeur = u.id_utilisateur " +
        "WHERE r.id_module = ? AND r.visible = TRUE ORDER BY r.date_upload DESC";

    private static final String SEARCH =
        "SELECT r.*, t.nom_type, m.nom_module, m.code_module, " +
        "f.nom_filiere, s.nom_semestre, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof " +
        "FROM ressources r " +
        "JOIN types_ressources t ON r.id_type = t.id_type " +
        "JOIN modules m ON r.id_module = m.id_module " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "JOIN utilisateurs u ON r.id_professeur = u.id_utilisateur " +
        "WHERE r.visible = TRUE AND (" +
        "r.titre LIKE ? OR r.description LIKE ? OR m.nom_module LIKE ?" +
        ") ORDER BY r.date_upload DESC";

    private static final String INSERT =
        "INSERT INTO ressources (titre, description, nom_fichier, chemin_fichier, " +
        "taille_fichier, visible, id_professeur, id_module, id_type) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String UPDATE =
        "UPDATE ressources SET titre=?, description=?, visible=?, id_module=?, id_type=? " +
        "WHERE id_ressource=?";

    private static final String DELETE = "DELETE FROM ressources WHERE id_ressource=?";
    private static final String COUNT = "SELECT COUNT(*) FROM ressources";
    private static final String COUNT_BY_PROF = "SELECT COUNT(*) FROM ressources WHERE id_professeur=?";
    private static final String FIND_LAST_5 =
        "SELECT r.*, t.nom_type, m.nom_module, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof " +
        "FROM ressources r " +
        "JOIN types_ressources t ON r.id_type = t.id_type " +
        "JOIN modules m ON r.id_module = m.id_module " +
        "JOIN utilisateurs u ON r.id_professeur = u.id_utilisateur " +
        "ORDER BY r.date_upload DESC LIMIT 5";

    private Ressource mapResultSet(ResultSet rs) throws SQLException {
        Ressource r = new Ressource();
        r.setIdRessource(rs.getInt("id_ressource"));
        r.setTitre(rs.getString("titre"));
        r.setDescription(rs.getString("description"));
        r.setNomFichier(rs.getString("nom_fichier"));
        r.setCheminFichier(rs.getString("chemin_fichier"));
        r.setTailleFichier(rs.getLong("taille_fichier"));
        r.setVisible(rs.getBoolean("visible"));

        Timestamp ts = rs.getTimestamp("date_upload");
        if (ts != null) r.setDateUpload(ts.toLocalDateTime());

        TypeRessource type = new TypeRessource();
        type.setNomType(rs.getString("nom_type"));
        r.setType(type);

        Module mod = new Module();
        mod.setNomModule(rs.getString("nom_module"));
        mod.setCodeModule(rs.getString("code_module"));

        // Ces colonnes peuvent ne pas etre presentes dans toutes les requetes
        try {
            Filiere f = new Filiere();
            f.setNomFiliere(rs.getString("nom_filiere"));
            mod.setFiliere(f);
            Semestre s = new Semestre();
            s.setNomSemestre(rs.getString("nom_semestre"));
            mod.setSemestre(s);
        } catch (SQLException ignored) {}

        r.setModule(mod);

        Utilisateur prof = new Utilisateur();
        prof.setNom(rs.getString("nom_prof"));
        r.setProfesseur(prof);

        return r;
    }

    public List<Ressource> findAll() {
        List<Ressource> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSet(rs));
        } catch (SQLException e) {
            System.err.println("RessourceDAO.findAll: " + e.getMessage());
        }
        return list;
    }

    public Ressource findById(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("RessourceDAO.findById: " + e.getMessage());
        }
        return null;
    }

    public List<Ressource> findByProfesseur(int idProf) {
        List<Ressource> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_PROFESSEUR)) {
            ps.setInt(1, idProf);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("RessourceDAO.findByProfesseur: " + e.getMessage());
        }
        return list;
    }

    public List<Ressource> findByModule(int idModule) {
        List<Ressource> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_MODULE)) {
            ps.setInt(1, idModule);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("RessourceDAO.findByModule: " + e.getMessage());
        }
        return list;
    }

    public List<Ressource> search(String keyword) {
        List<Ressource> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(SEARCH)) {
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("RessourceDAO.search: " + e.getMessage());
        }
        return list;
    }

    public List<Ressource> findLast5() {
        List<Ressource> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_LAST_5);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSet(rs));
        } catch (SQLException e) {
            System.err.println("RessourceDAO.findLast5: " + e.getMessage());
        }
        return list;
    }

    public int insert(Ressource r) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, r.getTitre());
            ps.setString(2, r.getDescription());
            ps.setString(3, r.getNomFichier());
            ps.setString(4, r.getCheminFichier());
            ps.setLong(5, r.getTailleFichier());
            ps.setBoolean(6, r.isVisible());
            ps.setInt(7, r.getProfesseur().getIdUtilisateur());
            ps.setInt(8, r.getModule().getIdModule());
            ps.setInt(9, r.getType().getIdType());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("RessourceDAO.insert: " + e.getMessage());
        }
        return -1;
    }

    public boolean update(Ressource r) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE)) {
            ps.setString(1, r.getTitre());
            ps.setString(2, r.getDescription());
            ps.setBoolean(3, r.isVisible());
            ps.setInt(4, r.getModule().getIdModule());
            ps.setInt(5, r.getType().getIdType());
            ps.setInt(6, r.getIdRessource());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("RessourceDAO.update: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("RessourceDAO.delete: " + e.getMessage());
        }
        return false;
    }

    public int count() {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("RessourceDAO.count: " + e.getMessage());
        }
        return 0;
    }

    public int countByProfesseur(int idProf) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_BY_PROF)) {
            ps.setInt(1, idProf);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("RessourceDAO.countByProfesseur: " + e.getMessage());
        }
        return 0;
    }
}