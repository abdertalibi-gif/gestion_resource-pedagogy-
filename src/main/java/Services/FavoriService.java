package Services;

import java.util.List;

import dao.DAOFactory;
import dao.FavoriDAO;
import models.Favori;

public class FavoriService {

    private final FavoriDAO favoriDAO;

    public FavoriService() {
        this.favoriDAO = DAOFactory.getFavoriDAO();
    }

    public List<Favori> findByEtudiant(int idEtudiant) {
        return favoriDAO.findByEtudiant(idEtudiant);
    }

    public boolean isFavori(int idEtudiant, int idRessource) {
        return favoriDAO.exists(idEtudiant, idRessource);
    }

    public boolean ajouter(int idEtudiant, int idRessource) {
        if (favoriDAO.exists(idEtudiant, idRessource)) return false;
        return favoriDAO.add(idEtudiant, idRessource);
    }

    public boolean retirer(int idEtudiant, int idRessource) {
        return favoriDAO.remove(idEtudiant, idRessource);
    }

    public int countByEtudiant(int idEtudiant) {
        return favoriDAO.countByEtudiant(idEtudiant);
    }
}