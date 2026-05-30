package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import models.Semestre;

public class SemestreDAO {

    private static final String FIND_ALL =
        "SELECT * FROM semestres ORDER BY " +
        "CASE nom_semestre " +
        "WHEN 'S1' THEN 1 WHEN 'S2' THEN 2 WHEN 'S3' THEN 3 " +
        "WHEN 'S4' THEN 4 WHEN 'S5' THEN 5 WHEN 'S6' THEN 6 " +
        "ELSE 99 END, id_semestre";

    private static final String FIND_BY_NOM = "SELECT * FROM semestres WHERE nom_semestre = ?";
    private static final String FIND_BY_ID = "SELECT * FROM semestres WHERE id_semestre = ?";
    private static final String INSERT = "INSERT INTO semestres (nom_semestre, description) VALUES (?, ?)";
    private static final String UPDATE = "UPDATE semestres SET nom_semestre=?, description=? WHERE id_semestre=?";
    private static final String DELETE = "DELETE FROM semestres WHERE id_semestre=?";
    private static final String COUNT = "SELECT COUNT(*) FROM semestres";

    public List<Semestre> findAll() {
        List<Semestre> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Semestre s = new Semestre();
                s.setIdSemestre(rs.getInt("id_semestre"));
                s.setNomSemestre(rs.getString("nom_semestre"));
                s.setDescription(rs.getString("description"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.err.println("SemestreDAO.findAll: " + e.getMessage());
        }
        return list;
    }

    public Semestre findByNom(String nom) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_NOM)) {
            ps.setString(1, nom);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Semestre s = new Semestre();
                    s.setIdSemestre(rs.getInt("id_semestre"));
                    s.setNomSemestre(rs.getString("nom_semestre"));
                    s.setDescription(rs.getString("description"));
                    return s;
                }
            }
        } catch (SQLException e) {
            System.err.println("SemestreDAO.findByNom: " + e.getMessage());
        }
        return null;
    }

    public Semestre findById(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Semestre s = new Semestre();
                    s.setIdSemestre(rs.getInt("id_semestre"));
                    s.setNomSemestre(rs.getString("nom_semestre"));
                    s.setDescription(rs.getString("description"));
                    return s;
                }
            }
        } catch (SQLException e) {
            System.err.println("SemestreDAO.findById: " + e.getMessage());
        }
        return null;
    }

    public int insert(Semestre s) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, s.getNomSemestre());
            ps.setString(2, s.getDescription());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("SemestreDAO.insert: " + e.getMessage());
        }
        return -1;
    }

    public boolean update(Semestre s) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE)) {
            ps.setString(1, s.getNomSemestre());
            ps.setString(2, s.getDescription());
            ps.setInt(3, s.getIdSemestre());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SemestreDAO.update: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SemestreDAO.delete: " + e.getMessage());
        }
        return false;
    }

    public int count() {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("SemestreDAO.count: " + e.getMessage());
        }
        return 0;
    }
}