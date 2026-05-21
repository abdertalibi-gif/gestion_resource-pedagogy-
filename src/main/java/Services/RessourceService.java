package Services;

import java.util.List;

import dao.DAOFactory;
import dao.RessourceDAO;
import jakarta.servlet.http.Part;
import models.Ressource;
import utils.FileUploadUtil;

public class RessourceService {

    private final RessourceDAO ressourceDAO;

    public RessourceService() {
        this.ressourceDAO = DAOFactory.getRessourceDAO();
    }

    public List<Ressource> findAll() { return ressourceDAO.findAll(); }
    public Ressource findById(int id) { return ressourceDAO.findById(id); }
    public List<Ressource> findByProfesseur(int idProf) { return ressourceDAO.findByProfesseur(idProf); }
    public List<Ressource> findByModule(int idModule) { return ressourceDAO.findByModule(idModule); }
    public List<Ressource> search(String keyword) { return ressourceDAO.search(keyword); }
    public List<Ressource> findLast5() { return ressourceDAO.findLast5(); }
    public int count() { return ressourceDAO.count(); }
    public int countByProfesseur(int idProf) { return ressourceDAO.countByProfesseur(idProf); }

    /**
     * Upload et creation d'une ressource.
     */
    public ServiceResult<Ressource> upload(Ressource r, Part filePart, String realUploadPath) {
        try {
            String chemin = FileUploadUtil.saveFile(filePart, realUploadPath);
            r.setNomFichier(filePart.getSubmittedFileName());
            r.setCheminFichier(chemin);
            r.setTailleFichier(filePart.getSize());
            r.setVisible(true);

            int id = ressourceDAO.insert(r);
            if (id > 0) {
                r.setIdRessource(id);
                return ServiceResult.success(r, "Ressource uploadee avec succes");
            }
            // En cas d'erreur, supprimer le fichier uploade
            FileUploadUtil.deleteFile(chemin, realUploadPath);
            return ServiceResult.failure("Erreur lors de l'enregistrement en base");
        } catch (Exception e) {
            return ServiceResult.failure(e.getMessage());
        }
    }

    public ServiceResult<Ressource> update(Ressource r) {
        if (ressourceDAO.update(r)) {
            return ServiceResult.success(r, "Ressource modifiee avec succes");
        }
        return ServiceResult.failure("Erreur lors de la modification");
    }

    public boolean delete(int id, String realUploadPath) {
        Ressource r = ressourceDAO.findById(id);
        if (r == null) return false;
        FileUploadUtil.deleteFile(r.getCheminFichier(), realUploadPath);
        return ressourceDAO.delete(id);
    }
}