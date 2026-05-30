package Services;

import dao.DAOFactory;
import dao.UtilisateurDAO;
import models.Utilisateur;
import utils.Constants;
import utils.PasswordUtil;

public class AuthService {

    private final UtilisateurDAO utilisateurDAO;

    public AuthService() {
        this.utilisateurDAO = DAOFactory.getUtilisateurDAO();
    }

    /**
     * Authentifie un utilisateur par email et mot de passe.
     * Retourne l'utilisateur si succes, null sinon.
     * Pour les erreurs specifiques, utiliser authenticateWithStatus().
     */
    public Utilisateur authenticate(String email, String password) {
        AuthResult result = authenticateWithStatus(email, password);
        return result.getUser();
    }

    /**
     * Authentifie et retourne un AuthResult contenant l'utilisateur et son statut.
     * Les codes de retour possibles :
     * - "OK" : authentification reussie
     * - "INVALID" : email ou mot de passe incorrect
     * - "EN_ATTENTE" : compte en attente de validation
     * - "REFUSE" : compte refuse
     */
    public AuthResult authenticateWithStatus(String email, String password) {
        if (email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty()) {
            return new AuthResult(null, "INVALID");
        }

        Utilisateur user = utilisateurDAO.findByEmail(email.trim());
        if (user == null) return new AuthResult(null, "INVALID");

        // Verifier le mot de passe
        boolean passwordOk = PasswordUtil.verify(password, user.getMotDePasse())
                          || password.equals(user.getMotDePasse());
        if (!passwordOk) return new AuthResult(null, "INVALID");

        // Verifier le statut du compte
        if (Constants.STATUT_EN_ATTENTE.equals(user.getStatut())) {
            return new AuthResult(user, "EN_ATTENTE");
        }
        if (Constants.STATUT_REFUSE.equals(user.getStatut())) {
            return new AuthResult(user, "REFUSE");
        }

        return new AuthResult(user, "OK");
    }

    /**
     * Resultat d'authentification contenant l'utilisateur et un code de statut.
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
        public boolean isEnAttente() { return "EN_ATTENTE".equals(status); }
        public boolean isRefuse() { return "REFUSE".equals(status); }
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