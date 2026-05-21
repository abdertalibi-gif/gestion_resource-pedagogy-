package dao;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import models.Filiere;
import models.Role;
import models.Semestre;
import models.Utilisateur;

public class UtilisateurDAO {

    private static final String FIND_BY_ID =
        "SELECT u.*, r.nom_role, f.nom_filiere, s.nom_semestre " +
        "FROM utilisateurs u " +
        "JOIN roles r ON u.id_role = r.id_role " +
        "LEFT JOIN filieres f ON u.id_filiere = f.id_filiere " +
        "LEFT JOIN semestres s ON u.id_semestre = s.id_semestre " +
        "WHERE u.id_utilisateur = ?";

    private static final String FIND_BY_EMAIL =
        "SELECT u.*, r.nom_role, f.nom_filiere, s.nom_semestre " +
        "FROM utilisateurs u " +
        "JOIN roles r ON u.id_role = r.id_role " +
        "LEFT JOIN filieres f ON u.id_filiere = f.id_filiere " +
        "LEFT JOIN semestres s ON u.id_semestre = s.id_semestre " +
        "WHERE u.email = ?";

    private static final String FIND_ALL =
        "SELECT u.*, r.nom_role, f.nom_filiere, s.nom_semestre " +
        "FROM utilisateurs u " +
        "JOIN roles r ON u.id_role = r.id_role " +
        "LEFT JOIN filieres f ON u.id_filiere = f.id_filiere " +
        "LEFT JOIN semestres s ON u.id_semestre = s.id_semestre " +
        "ORDER BY u.date_creation DESC";

    private static final String FIND_BY_ROLE =
        "SELECT u.*, r.nom_role, f.nom_filiere, s.nom_semestre " +
        "FROM utilisateurs u " +
        "JOIN roles r ON u.id_role = r.id_role " +
        "LEFT JOIN filieres f ON u.id_filiere = f.id_filiere " +
        "LEFT JOIN semestres s ON u.id_semestre = s.id_semestre " +
        "WHERE r.nom_role = ? ORDER BY u.nom, u.prenom";

    private static final String INSERT =
        "INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe, telephone, " +
        "photo, statut, id_role, id_filiere, id_semestre) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String UPDATE =
        "UPDATE utilisateurs SET nom=?, prenom=?, email=?, telephone=?, " +
        "photo=?, statut=?, id_role=?, id_filiere=?, id_semestre=? " +
        "WHERE id_utilisateur=?";

    private static final String UPDATE_PASSWORD =
        "UPDATE utilisateurs SET mot_de_passe=? WHERE id_utilisateur=?";

    private static final String UPDATE_STATUT =
        "UPDATE utilisateurs SET statut=? WHERE id_utilisateur=?";

    private static final String DELETE =
        "DELETE FROM utilisateurs WHERE id_utilisateur=?";

    private static final String COUNT_BY_ROLE =
        "SELECT COUNT(*) FROM utilisateurs u JOIN roles r ON u.id_role = r.id_role " +
        "WHERE r.nom_role = ?";

    private static final String COUNT_ALL = "SELECT COUNT(*) FROM utilisateurs";

    private Utilisateur mapResultSet(ResultSet rs) throws SQLException {
        Utilisateur u = new Utilisateur();
        u.setIdUtilisateur(rs.getInt("id_utilisateur"));
        u.setNom(rs.getString("nom"));
        u.setPrenom(rs.getString("prenom"));
        u.setEmail(rs.getString("email"));
        u.setMotDePasse(rs.getString("mot_de_passe"));
        u.setPhoto(rs.getString("photo"));
        u.setTelephone(rs.getString("telephone"));

        Timestamp ts = rs.getTimestamp("date_creation");
        if (ts != null) u.setDateCreation(ts.toLocalDateTime());

        u.setStatut(rs.getBoolean("statut"));

        Role role = new Role();
        role.setNomRole(rs.getString("nom_role"));
        u.setRole(role);

        String nomFiliere = rs.getString("nom_filiere");
        if (nomFiliere != null) {
            Filiere f = new Filiere();
            f.setNomFiliere(nomFiliere);
            u.setFiliere(f);
        }

        String nomSemestre = rs.getString("nom_semestre");
        if (nomSemestre != null) {
            Semestre s = new Semestre();
            s.setNomSemestre(nomSemestre);
            u.setSemestre(s);
        }

        return u;
    }

    public Utilisateur findById(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("UtilisateurDAO.findById: " + e.getMessage());
        }
        return null;
    }

    public Utilisateur findByEmail(String email) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_EMAIL)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("UtilisateurDAO.findByEmail: " + e.getMessage());
        }
        return null;
    }

    public List<Utilisateur> findAll() {
        List<Utilisateur> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSet(rs));
        } catch (SQLException e) {
            System.err.println("UtilisateurDAO.findAll: " + e.getMessage());
        }
        return list;
    }

    public List<Utilisateur> findByRole(String nomRole) {
        List<Utilisateur> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_ROLE)) {
            ps.setString(1, nomRole);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("UtilisateurDAO.findByRole: " + e.getMessage());
        }
        return list;
    }

    public int insert(Utilisateur u) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getMotDePasse());
            ps.setString(5, u.getTelephone());
            ps.setString(6, u.getPhoto());
            ps.setBoolean(7, u.isStatut());

            if (u.getRole() != null) {
                // Recuperer l'id_role depuis la base
                int idRole = getRoleIdByName(conn, u.getRole().getNomRole());
                ps.setInt(8, idRole);
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            if (u.getFiliere() != null && u.getFiliere().getIdFiliere() > 0) {
                ps.setInt(9, u.getFiliere().getIdFiliere());
            } else {
                ps.setNull(9, Types.INTEGER);
            }

            if (u.getSemestre() != null && u.getSemestre().getIdSemestre() > 0) {
                ps.setInt(10, u.getSemestre().getIdSemestre());
            } else {
                ps.setNull(10, Types.INTEGER);
            }

            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("UtilisateurDAO.insert: " + e.getMessage());
        }
        return -1;
    }

    public boolean update(Utilisateur u) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE)) {
            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getTelephone());
            ps.setString(5, u.getPhoto());
            ps.setBoolean(6, u.isStatut());

            if (u.getRole() != null) {
                int idRole = getRoleIdByName(conn, u.getRole().getNomRole());
                ps.setInt(7, idRole);
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            if (u.getFiliere() != null && u.getFiliere().getIdFiliere() > 0) {
                ps.setInt(8, u.getFiliere().getIdFiliere());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            if (u.getSemestre() != null && u.getSemestre().getIdSemestre() > 0) {
                ps.setInt(9, u.getSemestre().getIdSemestre());
            } else {
                ps.setNull(9, Types.INTEGER);
            }

            ps.setInt(10, u.getIdUtilisateur());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("UtilisateurDAO.update: " + e.getMessage());
        }
        return false;
    }

    public boolean updatePassword(int id, String hashedPassword) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_PASSWORD)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("UtilisateurDAO.updatePassword: " + e.getMessage());
        }
        return false;
    }

    public boolean updateStatut(int id, boolean statut) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_STATUT)) {
            ps.setBoolean(1, statut);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("UtilisateurDAO.updateStatut: " + e.getMessage());
        }
        return false;
    }

    public boolean delete(int id) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("UtilisateurDAO.delete: " + e.getMessage());
        }
        return false;
    }

    public int countByRole(String nomRole) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_BY_ROLE)) {
            ps.setString(1, nomRole);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("UtilisateurDAO.countByRole: " + e.getMessage());
        }
        return 0;
    }

    public int countAll() {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_ALL);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("UtilisateurDAO.countAll: " + e.getMessage());
        }
        return 0;
    }

    private int getRoleIdByName(Connection conn, String nomRole) throws SQLException {
        String sql = "SELECT id_role FROM roles WHERE nom_role = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nomRole);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id_role");
            }
        }
        return 1; // defaut: ADMIN
    }

	public void updateMotDePasse(int utilisateurId, String nouveauMotDePasse) {
		// TODO Auto-generated method stub
		
	}
}