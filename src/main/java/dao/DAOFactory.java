package dao;


import java.sql.Connection;
import java.sql.SQLException;

import utils.DatabaseConnection;

public final class DAOFactory {

    private DAOFactory() {}

    public static Connection getConnection() throws SQLException {
        return DatabaseConnection.getConnection();
    }

    public static UtilisateurDAO getUtilisateurDAO() {
        return new UtilisateurDAO();
    }
    public static ModuleDAO getModuleDAO() {
        return new ModuleDAO();
    }
    public static RessourceDAO getRessourceDAO() {
        return new RessourceDAO();
    }
    public static FiliereDAO getFiliereDAO() {
        return new FiliereDAO();
    }
    public static SemestreDAO getSemestreDAO() {
        return new SemestreDAO();
    }
    public static AffectationDAO getAffectationDAO() {
        return new AffectationDAO();
    }
    public static TypeRessourceDAO getTypeRessourceDAO() {
        return new TypeRessourceDAO();
    }
    public static NotificationDAO getNotificationDAO() {
        return new NotificationDAO();
    }
    public static FavoriDAO getFavoriDAO() {
        return new FavoriDAO();
    }
    public static HistoriqueDAO getHistoriqueDAO() {
        return new HistoriqueDAO();
    }
}
