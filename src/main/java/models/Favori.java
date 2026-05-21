package models;



import java.io.Serializable;
import java.time.LocalDateTime;

public class Favori implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idFavori;
    private Utilisateur etudiant;
    private Ressource ressource;
    private LocalDateTime dateAjout;

    public Favori() {}

    public int getIdFavori() { return idFavori; }
    public void setIdFavori(int idFavori) { this.idFavori = idFavori; }

    public Utilisateur getEtudiant() { return etudiant; }
    public void setEtudiant(Utilisateur etudiant) { this.etudiant = etudiant; }

    public Ressource getRessource() { return ressource; }
    public void setRessource(Ressource ressource) { this.ressource = ressource; }

    public LocalDateTime getDateAjout() { return dateAjout; }
    public void setDateAjout(LocalDateTime dateAjout) { this.dateAjout = dateAjout; }
}