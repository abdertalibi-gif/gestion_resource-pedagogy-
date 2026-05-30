package Services;

import java.util.List;

import dao.DAOFactory;
import dao.HistoriqueDAO;
import models.HistoriqueConsultation;

public class HistoriqueService {

    private final HistoriqueDAO historiqueDAO;

    public HistoriqueService() {
        this.historiqueDAO = DAOFactory.getHistoriqueDAO();
    }

    public List<HistoriqueConsultation> findByEtudiant(int idEtudiant) {
        return historiqueDAO.findByEtudiant(idEtudiant);
    }

    public boolean ajouter(int idEtudiant, int idRessource, String typeAction) {
        return historiqueDAO.add(idEtudiant, idRessource, typeAction);
    }

    public int countByEtudiant(int idEtudiant) {
        return historiqueDAO.countByEtudiant(idEtudiant);
    }

    public int countByRessource(int idRessource) {
        return historiqueDAO.countByRessource(idRessource);
    }
}