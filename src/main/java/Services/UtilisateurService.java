package Services;

import java.util.List;

import dao.DAOFactory;
import dao.UtilisateurDAO;
import models.Utilisateur;
import utils.Constants;
import utils.PasswordUtil;
import utils.ValidationUtil;

public class UtilisateurService {

    private final UtilisateurDAO utilisateurDAO;

    public UtilisateurService() {
        this.utilisateurDAO = DAOFactory.getUtilisateurDAO();
    }

    public Utilisateur findById(int id) {
        return utilisateurDAO.findById(id);
    }

    public Utilisateur findByEmail(String email) {
        return utilisateurDAO.findByEmail(email);
    }

    public List<Utilisateur> findAll() {
        return utilisateurDAO.findAll();
    }

    public List<Utilisateur> findByRole(String role) {
        return utilisateurDAO.findByRole(role);
    }

    public List<Utilisateur> findByStatut(String statut) {
        return utilisateurDAO.findByStatut(statut);
    }

    /**
     * Cree un nouvel utilisateur avec validation et hachage du mot de passe.
     * Utilise par l'admin - le compte est directement actif (ACCEPTE).
     */
    public ServiceResult<Utilisateur> create(Utilisateur u) {
        String role = u.getRole() != null ? u.getRole().getNomRole() : null;
        List<String> erreurs = ValidationUtil.validerUtilisateur(
            u.getNom(), u.getPrenom(), u.getEmail(), u.getMotDePasse(), u.getCne(), role
        );
        if (!erreurs.isEmpty()) {
            return ServiceResult.failure(erreurs);
        }

        // Verifier si l'email existe deja
        if (utilisateurDAO.findByEmail(u.getEmail()) != null) {
            return ServiceResult.failure("Cet email est deja utilise");
        }

        // Hasher le mot de passe
        u.setMotDePasse(PasswordUtil.hash(u.getMotDePasse()));
        u.setStatut(Constants.STATUT_ACCEPTE);

        int id = utilisateurDAO.insert(u);
        if (id > 0) {
            u.setIdUtilisateur(id);
            return ServiceResult.success(u, "Utilisateur cree avec succes");
        }
        return ServiceResult.failure("Erreur lors de la creation de l'utilisateur");
    }

    /**
     * Inscription via le formulaire public - le compte est en attente de validation.
     */
    public ServiceResult<Utilisateur> register(Utilisateur u) {
        String role = u.getRole() != null ? u.getRole().getNomRole() : null;
        List<String> erreurs = ValidationUtil.validerUtilisateur(
            u.getNom(), u.getPrenom(), u.getEmail(), u.getMotDePasse(), u.getCne(), role
        );
        if (!erreurs.isEmpty()) {
            return ServiceResult.failure(erreurs);
        }

        // Verifier si l'email existe deja
        if (utilisateurDAO.findByEmail(u.getEmail()) != null) {
            return ServiceResult.failure("Cet email est deja utilise");
        }

        // Hasher le mot de passe
        u.setMotDePasse(PasswordUtil.hash(u.getMotDePasse()));
        u.setStatut(Constants.STATUT_EN_ATTENTE);

        int id = utilisateurDAO.insert(u);
        if (id > 0) {
            u.setIdUtilisateur(id);
            return ServiceResult.success(u, "Inscription reussie ! Votre compte est en attente de validation par l'administrateur.");
        }
        return ServiceResult.failure("Erreur lors de l'inscription");
    }

    public ServiceResult<Utilisateur> update(Utilisateur u) {
        String role = u.getRole() != null ? u.getRole().getNomRole() : null;
        List<String> erreurs = ValidationUtil.validerUtilisateur(
            u.getNom(), u.getPrenom(), u.getEmail(), null, u.getCne(), role
        );
        if (!erreurs.isEmpty()) {
            return ServiceResult.failure(erreurs);
        }

        if (utilisateurDAO.update(u)) {
            return ServiceResult.success(u, "Utilisateur modifie avec succes");
        }
        return ServiceResult.failure("Erreur lors de la modification");
    }

    public boolean updateStatut(int id, String nouveauStatut) {
        return utilisateurDAO.updateStatut(id, nouveauStatut);
    }

    public boolean toggleStatut(int id) {
        Utilisateur u = utilisateurDAO.findById(id);
        if (u == null) return false;
        String nouveau = Constants.STATUT_ACCEPTE.equals(u.getStatut())
            ? Constants.STATUT_REFUSE : Constants.STATUT_ACCEPTE;
        return utilisateurDAO.updateStatut(id, nouveau);
    }

    public boolean delete(int id) {
        return utilisateurDAO.delete(id);
    }

    public int countByRole(String role) {
        return utilisateurDAO.countByRole(role);
    }

    public int countAll() {
        return utilisateurDAO.countAll();
    }
}