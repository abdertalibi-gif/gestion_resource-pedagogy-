package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import models.Filiere;
import models.Module;
import models.Semestre;

public class ModuleDAO {

    private static final String FIND_ALL =
        "SELECT m.*, f.nom_filiere, s.nom_semestre, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof " +
        "FROM modules m " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "LEFT JOIN affectations_modules am ON m.id_module = am.id_module " +
        "LEFT JOIN utilisateurs u ON am.id_professeur = u.id_utilisateur " +
        "ORDER BY m.code_module";

    private static final String FIND_BY_ID =
        "SELECT m.*, f.nom_filiere, s.nom_semestre, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof " +
        "FROM modules m " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "LEFT JOIN affectations_modules am ON m.id_module = am.id_module " +
        "LEFT JOIN utilisateurs u ON am.id_professeur = u.id_utilisateur " +
        "WHERE m.id_module = ?";

    private static final String FIND_BY_FILIERE_SEMESTRE =
        "SELECT m.*, f.nom_filiere, s.nom_semestre, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof " +
        "FROM modules m " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "LEFT JOIN affectations_modules am ON m.id_module = am.id_module " +
        "LEFT JOIN utilisateurs u ON am.id_professeur = u.id_utilisateur " +
        "WHERE m.id_filiere = ? AND m.id_semestre = ? " +
        "ORDER BY m.code_module";

    private static final String FIND_BY_PROFESSEUR =
        "SELECT m.*, f.nom_filiere, s.nom_semestre, " +
        "CONCAT(u.prenom, ' ', u.nom) AS nom_prof " +
        "FROM modules m " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "JOIN affectations_modules am ON m.id_module = am.id_module " +
        "LEFT JOIN utilisateurs u ON am.id_professeur = u.id_utilisateur " +
        "WHERE am.id_professeur = ? " +
        "ORDER BY m.code_module";

    private static final String INSERT =
        "INSERT INTO modules (nom_module, code_module, description, id_semestre, id_filiere) " +
        "VALUES (?, ?, ?, ?, ?)";

    private static final String UPDATE =
        "UPDATE modules SET nom_module=?, code_module=?, description=?, " +
        "id_semestre=?, id_filiere=? WHERE id_module=?";

    private static final String DELETE = "DELETE FROM modules WHERE id_module=?";
    private static final String COUNT = "SELECT COUNT(*) FROM modules";

    private static final String COUNT_BY_FILIERE_SEMESTRE =
        "SELECT COUNT(*) FROM modules WHERE id_filiere = ? AND id_semestre = ?";

    private Module mapResultSet(ResultSet rs) throws SQLException {
        Module m = new Module();
        m.setIdModule(rs.getInt("id_module"));
        m.setNomModule(rs.getString("nom_module"));
        m.setCodeModule(rs.getString("code_module"));
        m.setDescription(rs.getString("description"));

        Filiere f = new Filiere();
        f.setIdFiliere(rs.getInt("id_filiere"));
        f.setNomFiliere(rs.getString("nom_filiere"));
        m.setFiliere(f);

        Semestre s = new Semestre();
        s.setIdSemestre(rs.getInt("id_semestre"));
        s.setNomSemestre(rs.getString("nom_semestre"));
        m.setSemestre(s);

        m.setNomProfesseur(rs.getString("nom_prof"));

        return m;
    }

    public List<Module> findAll() {
        List<Module> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSet(rs));
        } catch (SQLException e) {
            System.err.println("ModuleDAO.findAll: " + e.getMessage());
        }
        return list;
    }

    public Module findById(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("ModuleDAO.findById: " + e.getMessage());
        }
        return null;
    }

    public List<Module> findByFiliereSemestre(int idFiliere, int idSemestre) {
        List<Module> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_FILIERE_SEMESTRE)) {
            ps.setInt(1, idFiliere);
            ps.setInt(2, idSemestre);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("ModuleDAO.findByFiliereSemestre: " + e.getMessage());
        }
        return list;
    }

    public List<Module> findByProfesseur(int idProfesseur) {
        List<Module> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_PROFESSEUR)) {
            ps.setInt(1, idProfesseur);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("ModuleDAO.findByProfesseur: " + e.getMessage());
        }
        return list;
    }

    public int insert(Module m) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, m.getNomModule());
            ps.setString(2, m.getCodeModule());
            ps.setString(3, m.getDescription());
            ps.setInt(4, m.getSemestre().getIdSemestre());
            ps.setInt(5, m.getFiliere().getIdFiliere());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("ModuleDAO.insert: " + e.getMessage());
        }
        return -1;
    }

    public boolean update(Module m) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE)) {
            ps.setString(1, m.getNomModule());
            ps.setString(2, m.getCodeModule());
            ps.setString(3, m.getDescription());
            ps.setInt(4, m.getSemestre().getIdSemestre());
            ps.setInt(5, m.getFiliere().getIdFiliere());
            ps.setInt(6, m.getIdModule());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ModuleDAO.update: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ModuleDAO.delete: " + e.getMessage());
        }
        return false;
    }

    public int count() {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("ModuleDAO.count: " + e.getMessage());
        }
        return 0;
    }

    public int countByFiliereSemestre(int idFiliere, int idSemestre) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_BY_FILIERE_SEMESTRE)) {
            ps.setInt(1, idFiliere);
            ps.setInt(2, idSemestre);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("ModuleDAO.countByFiliereSemestre: " + e.getMessage());
        }
        return 0;
    }
}