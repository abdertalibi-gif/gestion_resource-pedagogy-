package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import models.TypeRessource;

public class TypeRessourceDAO {

    private static final String FIND_ALL = "SELECT * FROM types_ressources ORDER BY nom_type";
    private static final String FIND_BY_ID = "SELECT * FROM types_ressources WHERE id_type = ?";
    private static final String FIND_BY_NOM = "SELECT * FROM types_ressources WHERE nom_type = ?";

    public List<TypeRessource> findAll() {
        List<TypeRessource> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                TypeRessource t = new TypeRessource();
                t.setIdType(rs.getInt("id_type"));
                t.setNomType(rs.getString("nom_type"));
                list.add(t);
            }
        } catch (SQLException e) {
            System.err.println("TypeRessourceDAO.findAll: " + e.getMessage());
        }
        return list;
    }

    public TypeRessource findById(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TypeRessource t = new TypeRessource();
                    t.setIdType(rs.getInt("id_type"));
                    t.setNomType(rs.getString("nom_type"));
                    return t;
                }
            }
        } catch (SQLException e) {
            System.err.println("TypeRessourceDAO.findById: " + e.getMessage());
        }
        return null;
    }

    public TypeRessource findByNom(String nom) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_NOM)) {
            ps.setString(1, nom);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TypeRessource t = new TypeRessource();
                    t.setIdType(rs.getInt("id_type"));
                    t.setNomType(rs.getString("nom_type"));
                    return t;
                }
            }
        } catch (SQLException e) {
            System.err.println("TypeRessourceDAO.findByNom: " + e.getMessage());
        }
        return null;
    }
}