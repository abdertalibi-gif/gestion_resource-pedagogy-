package Services;

import dao.DAOFactory;
import dao.ResetTokenDAO;
import dao.UtilisateurDAO;
import models.ResetToken;
import models.Utilisateur;
import utils.Constants;
import utils.PasswordUtil;

import java.time.LocalDateTime;
import java.util.UUID;

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
        AuthResult result = authenticateWithStatus(email, password);
        return result.getUser();
    }

    /**
     * Authentifie et retourne un AuthResult avec statut.
     * - "OK" : authentification reussie
     * - "INACTIF" : compte désactivé
     * - "INVALID" : email ou mot de passe incorrect
     */
    public AuthResult authenticateWithStatus(String email, String password) {
        if (email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty()) {
            return new AuthResult(null, "INVALID");
        }

        Utilisateur user = utilisateurDAO.findByEmail(email.trim());
        if (user == null) return new AuthResult(null, "INVALID");

        boolean passwordOk = PasswordUtil.verify(password, user.getMotDePasse())
                          || password.equals(user.getMotDePasse());
        if (!passwordOk) return new AuthResult(null, "INVALID");

        if (!Constants.STATUT_ACCEPTE.equals(user.getStatut())) {
            return new AuthResult(user, "INACTIF");
        }

        return new AuthResult(user, "OK");
    }

    /**
     * Resultat d'authentification.
     */
    public static class AuthResult {
        private final Utilisateur user;
        private final String status;

        public AuthResult(Utilisateur user, String status) {
            this.user = user;
            this.status = status;
        }

        public Utilisateur getUser() { return user; }
        public String getStatus() { return status; }
        public boolean isSuccess() { return "OK".equals(status); }
        public boolean isInactif() { return "INACTIF".equals(status); }
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

	public boolean sendResetToken(String email) {
		Utilisateur user = utilisateurDAO.findByEmail(email);
		if (user == null) {
			return false;
		}

		String tokenValue = UUID.randomUUID().toString().replace("-", "");
		LocalDateTime expiration = LocalDateTime.now().plusMinutes(15);
		ResetToken resetToken = new ResetToken(user.getIdUtilisateur(), tokenValue, expiration);

		ResetTokenDAO tokenDAO = DAOFactory.getResetTokenDAO();
		try {
			tokenDAO.save(resetToken);
		} catch (Exception e) {
			System.err.println("AuthService.sendResetToken: " + e.getMessage());
			return false;
		}

		String lien = Constants.APP_URL + "/reset-password?token=" + tokenValue;
		EmailService emailService = new EmailService();
		emailService.envoyerResetPassword(email, lien);

		return true;
	}

	/**
	 * Vérifie l'identité d'un utilisateur à partir de son email, nom, prénom et CNE.
	 * Le CNE est obligatoire si l'utilisateur en possède un en base, ignoré sinon.
	 * Retourne l'utilisateur si vérifié, null sinon.
	 */
	public Utilisateur verifyIdentity(String email, String nom, String prenom, String cne) {
		if (email == null || nom == null || prenom == null) return null;
		Utilisateur user = utilisateurDAO.findByEmail(email.trim());
		if (user == null) return null;
		if (!user.getNom().equalsIgnoreCase(nom.trim())) return null;
		if (!user.getPrenom().equalsIgnoreCase(prenom.trim())) return null;
		String cneUser = user.getCne();
		if (cneUser != null && !cneUser.isEmpty()) {
			if (cne == null || !cneUser.equalsIgnoreCase(cne.trim())) return null;
		}
		return user;
	}
}