package dao;

import models.ResetToken;
import java.sql.*;
import java.time.LocalDateTime;

public class ResetTokenDAO {

    private final String jdbcURL;
    private final String jdbcUsername;
    private final String jdbcPassword;

    public ResetTokenDAO(String jdbcURL, String jdbcUsername, String jdbcPassword) {
        this.jdbcURL = jdbcURL;
        this.jdbcUsername = jdbcUsername;
        this.jdbcPassword = jdbcPassword;
    }

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver MySQL non trouvé", e);
        }
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    /**
     * Enregistre un nouveau token en base
     */
    public boolean save(ResetToken resetToken) throws SQLException {
        String sql = "INSERT INTO reset_tokens (utilisateur_id, token, date_creation, date_expiration, utilise) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, resetToken.getUtilisateurId());
            ps.setString(2, resetToken.getToken());
            ps.setTimestamp(3, Timestamp.valueOf(resetToken.getDateCreation()));
            ps.setTimestamp(4, Timestamp.valueOf(resetToken.getDateExpiration()));
            ps.setBoolean(5, resetToken.isUtilise());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Cherche un token par sa valeur
     */
    public ResetToken findByToken(String token) throws SQLException {
        String sql = "SELECT * FROM reset_tokens WHERE token = ? ORDER BY date_creation DESC LIMIT 1";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ResetToken rt = new ResetToken();
                    rt.setId(rs.getInt("id"));
                    rt.setUtilisateurId(rs.getInt("utilisateur_id"));
                    rt.setToken(rs.getString("token"));
                    rt.setDateCreation(rs.getTimestamp("date_creation").toLocalDateTime());
                    rt.setDateExpiration(rs.getTimestamp("date_expiration").toLocalDateTime());
                    rt.setUtilise(rs.getBoolean("utilise"));
                    return rt;
                }
            }
        }
        return null;
    }

    /**
     * Marque un token comme utilisé
     */
    public boolean marquerUtilise(String token) throws SQLException {
        String sql = "UPDATE reset_tokens SET utilise = true WHERE token = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, token);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Supprime tous les tokens expirés (nettoyage)
     */
    public int nettoyerExpire() throws SQLException {
        String sql = "DELETE FROM reset_tokens WHERE date_expiration < NOW()";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            return ps.executeUpdate();
        }
    }
}