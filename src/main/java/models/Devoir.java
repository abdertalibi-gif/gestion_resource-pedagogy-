package models;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Devoir implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idDevoir;
    private String titre;
    private String description;
    private LocalDateTime dateLimite;
    private LocalDateTime dateCreation;
    private String nomFichier;
    private String cheminFichier;
    private long tailleFichier;
    private Module module;
    private Utilisateur professeur;
    private int nbSoumissions;

    public Devoir() {}

    public int getIdDevoir() { return idDevoir; }
    public void setIdDevoir(int idDevoir) { this.idDevoir = idDevoir; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getDateLimite() { return dateLimite; }
    public void setDateLimite(LocalDateTime dateLimite) { this.dateLimite = dateLimite; }

    public LocalDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDateTime dateCreation) { this.dateCreation = dateCreation; }

    public String getNomFichier() { return nomFichier; }
    public void setNomFichier(String nomFichier) { this.nomFichier = nomFichier; }

    public String getCheminFichier() { return cheminFichier; }
    public void setCheminFichier(String cheminFichier) { this.cheminFichier = cheminFichier; }

    public long getTailleFichier() { return tailleFichier; }
    public void setTailleFichier(long tailleFichier) { this.tailleFichier = tailleFichier; }

    public Module getModule() { return module; }
    public void setModule(Module module) { this.module = module; }

    public Utilisateur getProfesseur() { return professeur; }
    public void setProfesseur(Utilisateur professeur) { this.professeur = professeur; }

    public int getNbSoumissions() { return nbSoumissions; }
    public void setNbSoumissions(int nbSoumissions) { this.nbSoumissions = nbSoumissions; }

    public boolean isDepasse() {
        return dateLimite != null && dateLimite.isBefore(LocalDateTime.now());
    }
}
