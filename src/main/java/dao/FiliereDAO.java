package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import models.Filiere;

public class FiliereDAO {

    private static final String FIND_ALL = "SELECT * FROM filieres ORDER BY nom_filiere";
    private static final String FIND_BY_ID = "SELECT * FROM filieres WHERE id_filiere = ?";
    private static final String INSERT = "INSERT INTO filieres (nom_filiere, description) VALUES (?, ?)";
    private static final String UPDATE = "UPDATE filieres SET nom_filiere=?, description=? WHERE id_filiere=?";
    private static final String DELETE = "DELETE FROM filieres WHERE id_filiere=?";
    private static final String COUNT = "SELECT COUNT(*) FROM filieres";

    public List<Filiere> findAll() {
        List<Filiere> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Filiere f = new Filiere();
                f.setIdFiliere(rs.getInt("id_filiere"));
                f.setNomFiliere(rs.getString("nom_filiere"));
                f.setDescription(rs.getString("description"));
                list.add(f);
            }
        } catch (SQLException e) {
            System.err.println("FiliereDAO.findAll: " + e.getMessage());
        }
        return list;
    }

    public Filiere findById(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Filiere f = new Filiere();
                    f.setIdFiliere(rs.getInt("id_filiere"));
                    f.setNomFiliere(rs.getString("nom_filiere"));
                    f.setDescription(rs.getString("description"));
                    return f;
                }
            }
        } catch (SQLException e) {
            System.err.println("FiliereDAO.findById: " + e.getMessage());
        }
        return null;
    }

    public int insert(Filiere f) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, f.getNomFiliere());
            ps.setString(2, f.getDescription());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("FiliereDAO.insert: " + e.getMessage());
        }
        return -1;
    }

    public boolean update(Filiere f) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE)) {
            ps.setString(1, f.getNomFiliere());
            ps.setString(2, f.getDescription());
            ps.setInt(3, f.getIdFiliere());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("FiliereDAO.update: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("FiliereDAO.delete: " + e.getMessage());
        }
        return false;
    }

    public int count() {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("FiliereDAO.count: " + e.getMessage());
        }
        return 0;
    }
}