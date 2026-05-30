package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import models.Notification;
import models.Utilisateur;

public class NotificationDAO {

    private static final String FIND_BY_USER =
        "SELECT * FROM notifications WHERE id_utilisateur = ? ORDER BY date_notification DESC";

    private static final String FIND_NON_LUES =
        "SELECT * FROM notifications WHERE id_utilisateur = ? AND lu = FALSE " +
        "ORDER BY date_notification DESC";

    private static final String INSERT =
        "INSERT INTO notifications (titre, message, id_utilisateur) VALUES (?, ?, ?)";

    private static final String MARK_AS_READ =
        "UPDATE notifications SET lu = TRUE WHERE id_notification = ? AND id_utilisateur = ?";

    private static final String MARK_ALL_AS_READ =
        "UPDATE notifications SET lu = TRUE WHERE id_utilisateur = ? AND lu = FALSE";

    private static final String COUNT_NON_LUES =
        "SELECT COUNT(*) FROM notifications WHERE id_utilisateur = ? AND lu = FALSE";

    public List<Notification> findByUtilisateur(int idUser) {
        List<Notification> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_BY_USER)) {
            ps.setInt(1, idUser);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            System.err.println("NotificationDAO.findByUtilisateur: " + e.getMessage());
        }
        return list;
    }

    public List<Notification> findNonLues(int idUser) {
        List<Notification> list = new ArrayList<>();
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(FIND_NON_LUES)) {
            ps.setInt(1, idUser);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            System.err.println("NotificationDAO.findNonLues: " + e.getMessage());
        }
        return list;
    }

    public int insert(Notification n) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, n.getTitre());
            ps.setString(2, n.getMessage());
            ps.setInt(3, n.getUtilisateur().getIdUtilisateur());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("NotificationDAO.insert: " + e.getMessage());
        }
        return -1;
    }

    public boolean markAsRead(int idNotif, int idUser) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(MARK_AS_READ)) {
            ps.setInt(1, idNotif);
            ps.setInt(2, idUser);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("NotificationDAO.markAsRead: " + e.getMessage());
        }
        return false;
    }

    public boolean markAllAsRead(int idUser) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(MARK_ALL_AS_READ)) {
            ps.setInt(1, idUser);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("NotificationDAO.markAllAsRead: " + e.getMessage());
        }
        return false;
    }

    public int countNonLues(int idUser) {
        try (Connection conn = DAOFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_NON_LUES)) {
            ps.setInt(1, idUser);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("NotificationDAO.countNonLues: " + e.getMessage());
        }
        return 0;
    }

    private Notification map(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setIdNotification(rs.getInt("id_notification"));
        n.setTitre(rs.getString("titre"));
        n.setMessage(rs.getString("message"));
        n.setLu(rs.getBoolean("lu"));
        Timestamp ts = rs.getTimestamp("date_notification");
        if (ts != null) n.setDateNotification(ts.toLocalDateTime());
        Utilisateur u = new Utilisateur();
        u.setIdUtilisateur(rs.getInt("id_utilisateur"));
        n.setUtilisateur(u);
        return n;
    }
}