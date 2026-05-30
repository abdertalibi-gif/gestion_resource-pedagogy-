package Services;

import java.util.List;

import dao.DAOFactory;
import dao.SoumissionDAO;
import jakarta.servlet.http.Part;
import models.Soumission;
import utils.FileUploadUtil;

public class SoumissionService {

    private final SoumissionDAO soumissionDAO;

    public SoumissionService() {
        this.soumissionDAO = DAOFactory.getSoumissionDAO();
    }

    public List<Soumission> findByEtudiant(int idEtudiant) {
        return soumissionDAO.findByEtudiant(idEtudiant);
    }

    public List<Soumission> findByProfesseur(int idProfesseur) {
        return soumissionDAO.findByProfesseur(idProfesseur);
    }

    public List<Soumission> findByDevoir(int idDevoir) {
        return soumissionDAO.findByDevoir(idDevoir);
    }

    public Soumission findById(int id) {
        return soumissionDAO.findById(id);
    }

    public ServiceResult<Soumission> soumettre(Soumission s, Part filePart, String realUploadPath) {
        try {
            String chemin = FileUploadUtil.saveFile(filePart, realUploadPath);
            s.setNomFichier(filePart.getSubmittedFileName());
            s.setCheminFichier(chemin);
            s.setTailleFichier(filePart.getSize());

            int id = soumissionDAO.insert(s);
            if (id > 0) {
                s.setIdSoumission(id);
                return ServiceResult.success(s, "Devoir soumis avec succès");
            }
            FileUploadUtil.deleteFile(chemin, realUploadPath);
            return ServiceResult.failure("Erreur lors de l'enregistrement en base");
        } catch (Exception e) {
            return ServiceResult.failure(e.getMessage());
        }
    }

    public ServiceResult<Soumission> evaluer(int idSoumission, String statut, Double note, String commentaire) {
        if (soumissionDAO.updateStatut(idSoumission, statut, note, commentaire)) {
            Soumission s = soumissionDAO.findById(idSoumission);
            return ServiceResult.success(s, "Soumission évaluée avec succès");
        }
        return ServiceResult.failure("Erreur lors de l'évaluation");
    }
}
