package Services;

import java.util.List;

import dao.DAOFactory;
import dao.ModuleDAO;
import models.Module;
import utils.ValidationUtil;

public class ModuleService {

    private final ModuleDAO moduleDAO;

    public ModuleService() {
        this.moduleDAO = DAOFactory.getModuleDAO();
    }

    public List<Module> findAll() {
        return moduleDAO.findAll();
    }

    public Module findById(int id) {
        return moduleDAO.findById(id);
    }

    public List<Module> findByFiliereSemestre(int idFiliere, int idSemestre) {
        return moduleDAO.findByFiliereSemestre(idFiliere, idSemestre);
    }
    public List<Module> findByFiliere(int idFiliere) {
        return moduleDAO.findByFiliere(idFiliere);
    }

    public List<Module> findByProfesseur(int idProf) {
        return moduleDAO.findByProfesseur(idProf);
    }

    public ServiceResult<Module> create(Module m) {
        List<String> erreurs = ValidationUtil.validerModule(m.getNomModule(), m.getCodeModule());
        if (!erreurs.isEmpty()) {
            return ServiceResult.failure(erreurs);
        }

        int id = moduleDAO.insert(m);
        if (id > 0) {
            m.setIdModule(id);
            return ServiceResult.success(m, "Module cree avec succes");
        }
        return ServiceResult.failure("Erreur lors de la creation du module");
    }

    public ServiceResult<Module> update(Module m) {
        List<String> erreurs = ValidationUtil.validerModule(m.getNomModule(), m.getCodeModule());
        if (!erreurs.isEmpty()) {
            return ServiceResult.failure(erreurs);
        }

        if (moduleDAO.update(m)) {
            return ServiceResult.success(m, "Module modifie avec succes");
        }
        return ServiceResult.failure("Erreur lors de la modification");
    }

    public boolean delete(int id) {
        return moduleDAO.delete(id);
    }

    public int count() {
        return moduleDAO.count();
    }

    public int countByFiliereSemestre(int idFiliere, int idSemestre) {
        return moduleDAO.countByFiliereSemestre(idFiliere, idSemestre);
    }
}