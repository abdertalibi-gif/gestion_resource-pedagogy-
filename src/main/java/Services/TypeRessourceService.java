package Services;

import java.util.List;

import dao.DAOFactory;
import dao.TypeRessourceDAO;
import models.TypeRessource;

public class TypeRessourceService {

    private final TypeRessourceDAO typeRessourceDAO;

    public TypeRessourceService() {
        this.typeRessourceDAO = DAOFactory.getTypeRessourceDAO();
    }

    public List<TypeRessource> findAll() { return typeRessourceDAO.findAll(); }
    public TypeRessource findById(int id) { return typeRessourceDAO.findById(id); }
    public TypeRessource findByNom(String nom) { return typeRessourceDAO.findByNom(nom); }
}