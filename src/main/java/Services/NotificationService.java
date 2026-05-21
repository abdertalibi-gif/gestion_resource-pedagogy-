package Services;

import java.util.List;

import dao.DAOFactory;
import dao.NotificationDAO;
import models.Notification;

public class NotificationService {

    private final NotificationDAO notificationDAO;

    public NotificationService() {
        this.notificationDAO = DAOFactory.getNotificationDAO();
    }

    public List<Notification> findByUtilisateur(int idUser) {
        return notificationDAO.findByUtilisateur(idUser);
    }

    public List<Notification> findNonLues(int idUser) {
        return notificationDAO.findNonLues(idUser);
    }

    public int countNonLues(int idUser) {
        return notificationDAO.countNonLues(idUser);
    }

    public boolean markAsRead(int idNotif, int idUser) {
        return notificationDAO.markAsRead(idNotif, idUser);
    }

    public boolean markAllAsRead(int idUser) {
        return notificationDAO.markAllAsRead(idUser);
    }

    public boolean create(Notification n) {
        return notificationDAO.insert(n) > 0;
    }
}