package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import models.AffectationModule;
import models.Filiere;
import models.Module;
import models.Semestre;
import models.Utilisateur;

public class AffectationDAO {

    private static final String FIND_ALL =
        "SELECT am.*, " +
        "CONCAT(u.prenom, ' ', u.nom) AS prof_nom, u.email AS prof_email, " +
        "m.nom_module, m.code_module, f.nom_filiere, s.nom_semestre " +
        "FROM affectations_modules am " +
        "JOIN utilisateurs u ON am.id_professeur = u.id_utilisateur " +
        "JOIN modules m ON am.id_module = m.id_module " +
        "JOIN filieres f ON m.id_filiere = f.id_filiere " +
        "JOIN semestres s ON m.id_semestre = s.id_semestre " +
        "ORDER BY am.annee_universitaire DESC";

    private static final String FIND_BY_ID =
        "SELECT * FROM affectations_modules WHERE id_affectation = ?";

    private static final String INSERT =
        "INSERT INTO affectations_modules (id_professeur, id_module, annee_universitaire) " +
        "VALUES (?, ?, ?)";

    private static final String DELETE = "DELETE FROM affectations_modules WHERE id_affectation = ?";

    private static final String EXISTS =
        "SELECT COUNT(*) FROM affectations_modules " +
        "WHERE id_professeur = ? AND id_module = ? AND annee_universitaire = ?";

    private AffectationModule mapResultSet(ResultSet rs) throws SQLException {
        AffectationModule a = new AffectationModule();
        a.setIdAffectation(rs.getInt("id_affectation"));
        a.setAnneeUniversitaire(rs.getString("annee_universitaire"));

        Utilisateur prof = new Utilisateur();
        prof.setNom(rs.getString("prof_nom"));
        prof.setEmail(rs.getString("prof_email"));
        a.setProfesseur(prof);

        Module mod = new Module();
        mod.setNomModule(rs.getString("nom_module"));
        mod.setCodeModule(rs.getString("code_module"));

        Filiere f = new Filiere();
        f.setNomFiliere(rs.getString("nom_filiere"));
        mod.setFiliere(f);

        Semestre s = new Semestre();
        s.setNomSemestre(rs.getString("nom_semestre"));
        mod.setSemestre(s);

        a.setModule(mod);

        return a;
    }

    public List<AffectationModule> findAll() {
        List<AffectationModule> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSet(rs));
        } catch (SQLException e) {
            System.err.println("AffectationDAO.findAll: " + e.getMessage());
        }
        return list;
    }

    public int insert(AffectationModule a) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, a.getProfesseur().getIdUtilisateur());
            ps.setInt(2, a.getModule().getIdModule());
            ps.setString(3, a.getAnneeUniversitaire());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("AffectationDAO.insert: " + e.getMessage());
        }
        return -1;
    }

    public boolean delete(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AffectationDAO.delete: " + e.getMessage());
        }
        return false;
    }

    public boolean exists(int idProf, int idModule, String annee) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(EXISTS)) {
            ps.setInt(1, idProf);
            ps.setInt(2, idModule);
            ps.setString(3, annee);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("AffectationDAO.exists: " + e.getMessage());
        }
        return false;
    }
}