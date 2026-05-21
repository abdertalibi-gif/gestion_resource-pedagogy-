package Services;

import java.util.List;

import dao.AffectationDAO;
import dao.DAOFactory;
import models.AffectationModule;

public class AffectationService {

    private final AffectationDAO affectationDAO;

    public AffectationService() {
        this.affectationDAO = DAOFactory.getAffectationDAO();
    }

    public List<AffectationModule> findAll() { return affectationDAO.findAll(); }

    public ServiceResult<AffectationModule> create(AffectationModule a) {
        if (affectationDAO.exists(
            a.getProfesseur().getIdUtilisateur(),
            a.getModule().getIdModule(),
            a.getAnneeUniversitaire()
        )) {
            return ServiceResult.failure("Cette affectation existe deja");
        }
        int id = affectationDAO.insert(a);
        if (id > 0) {
            a.setIdAffectation(id);
            return ServiceResult.success(a, "Affectation creee avec succes");
        }
        return ServiceResult.failure("Erreur lors de la creation");
    }

    public boolean delete(int id) { return affectationDAO.delete(id); }
}