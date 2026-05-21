package Services;

import dao.DAOFactory;
import dao.UtilisateurDAO;
import models.Utilisateur;
import utils.PasswordUtil;

public class AuthService {

    private final UtilisateurDAO utilisateurDAO;

    public AuthService() {
        this.utilisateurDAO = DAOFactory.getUtilisateurDAO();
    }

    /**
     * Authentifie un utilisateur par email et mot de passe.
     * Retourne l'utilisateur si succes, null sinon.
     */
    public Utilisateur authenticate(String email, String password) {
        if (email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty()) {
            return null;
        }

        Utilisateur user = utilisateurDAO.findByEmail(email.trim());
        if (user == null) return null;
        if (!user.isStatut()) return null; // compte desactive

        // Verifier le mot de passe
        // Pour les comptes par defaut (non haches), verification directe
        if (PasswordUtil.verify(password, user.getMotDePasse())) {
            return user;
        }
        // Fallback pour les mots de passe en clair (donnees initiales)
        if (password.equals(user.getMotDePasse())) {
            return user;
        }
        return null;
    }

    /**
     * Change le mot de passe d'un utilisateur.
     */
    public boolean changePassword(int idUser, String oldPassword, String newPassword) {
        Utilisateur user = utilisateurDAO.findById(idUser);
        if (user == null) return false;

        // Verifier l'ancien mot de passe
        boolean valid = PasswordUtil.verify(oldPassword, user.getMotDePasse())
                      || oldPassword.equals(user.getMotDePasse());
        if (!valid) return false;

        String hashed = PasswordUtil.hash(newPassword);
        return utilisateurDAO.updatePassword(idUser, hashed);
    }

    /**
     * Reinitialise le mot de passe d'un utilisateur (forgot password).
     */
    public boolean resetPassword(String email, String newPassword) {
        Utilisateur user = utilisateurDAO.findByEmail(email);
        if (user == null) return false;

        String hashed = PasswordUtil.hash(newPassword);
        return utilisateurDAO.updatePassword(user.getIdUtilisateur(), hashed);
    }

	public void sendResetToken(String email) {
		// TODO Auto-generated method stub
		
	}
}