package Services;

import java.util.List;

import dao.DAOFactory;
import dao.UtilisateurDAO;
import models.Utilisateur;
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

    /**
     * Cree un nouvel utilisateur avec validation et hachage du mot de passe.
     */
    public ServiceResult<Utilisateur> create(Utilisateur u) {
        List<String> erreurs = ValidationUtil.validerUtilisateur(
            u.getNom(), u.getPrenom(), u.getEmail(), u.getMotDePasse()
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
        u.setStatut(true);

        int id = utilisateurDAO.insert(u);
        if (id > 0) {
            u.setIdUtilisateur(id);
            return ServiceResult.success(u, "Utilisateur cree avec succes");
        }
        return ServiceResult.failure("Erreur lors de la creation de l'utilisateur");
    }

    public ServiceResult<Utilisateur> update(Utilisateur u) {
        List<String> erreurs = ValidationUtil.validerUtilisateur(
            u.getNom(), u.getPrenom(), u.getEmail(), "dummy"
        );
        if (!erreurs.isEmpty()) {
            return ServiceResult.failure(erreurs);
        }

        if (utilisateurDAO.update(u)) {
            return ServiceResult.success(u, "Utilisateur modifie avec succes");
        }
        return ServiceResult.failure("Erreur lors de la modification");
    }

    public boolean toggleStatut(int id) {
        Utilisateur u = utilisateurDAO.findById(id);
        if (u == null) return false;
        return utilisateurDAO.updateStatut(id, !u.isStatut());
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