package Services;

import java.util.List;

import dao.DAOFactory;
import dao.DevoirDAO;
import jakarta.servlet.http.Part;
import models.Devoir;
import utils.FileUploadUtil;

public class DevoirService {

    private final DevoirDAO devoirDAO;

    public DevoirService() {
        this.devoirDAO = DAOFactory.getDevoirDAO();
    }

    public List<Devoir> findByProfesseur(int idProfesseur) {
        return devoirDAO.findByProfesseur(idProfesseur);
    }

    public List<Devoir> findByFiliereSemestre(int idFiliere, int idSemestre) {
        return devoirDAO.findByFiliereSemestre(idFiliere, idSemestre);
    }

    public Devoir findById(int id) {
        return devoirDAO.findById(id);
    }

    public ServiceResult<Devoir> creer(Devoir d, Part filePart, String realUploadPath) {
        try {
            if (filePart != null && filePart.getSize() > 0) {
                String chemin = FileUploadUtil.saveFile(filePart, realUploadPath);
                d.setNomFichier(filePart.getSubmittedFileName());
                d.setCheminFichier(chemin);
                d.setTailleFichier(filePart.getSize());
            }

            int id = devoirDAO.insert(d);
            if (id > 0) {
                d.setIdDevoir(id);
                return ServiceResult.success(d, "Devoir créé avec succès");
            }
            if (d.getCheminFichier() != null) {
                FileUploadUtil.deleteFile(d.getCheminFichier(), realUploadPath);
            }
            return ServiceResult.failure("Erreur lors de la création du devoir");
        } catch (Exception e) {
            return ServiceResult.failure(e.getMessage());
        }
    }

    public boolean delete(int id, String realUploadPath) {
        Devoir d = devoirDAO.findById(id);
        if (d == null) return false;
        if (d.getCheminFichier() != null) {
            FileUploadUtil.deleteFile(d.getCheminFichier(), realUploadPath);
        }
        return devoirDAO.delete(id);
    }
}
