package Services;

import java.util.List;

import dao.DAOFactory;
import dao.FiliereDAO;
import models.Filiere;

public class FiliereService {

    private final FiliereDAO filiereDAO;

    public FiliereService() {
        this.filiereDAO = DAOFactory.getFiliereDAO();
    }

    public List<Filiere> findAll() { return filiereDAO.findAll(); }
    public Filiere findById(int id) { return filiereDAO.findById(id); }

    public boolean create(Filiere f) { return filiereDAO.insert(f) > 0; }
    public boolean update(Filiere f) { return filiereDAO.update(f); }
    public boolean delete(int id) { return filiereDAO.delete(id); }
    public int count() { return filiereDAO.count(); }
}