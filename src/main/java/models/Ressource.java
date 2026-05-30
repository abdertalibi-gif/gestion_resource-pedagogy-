package models;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Ressource implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idRessource;
    private String titre;
    private String description;
    private String nomFichier;
    private String cheminFichier;
    private long tailleFichier;
    private LocalDateTime dateUpload;
    private boolean visible;
    private Utilisateur professeur;
    private Module module;
    private TypeRessource type;
    private boolean estFavori;
    private int nombreConsultations;

    public Ressource() {}

    public int getIdRessource() { return idRessource; }
    public void setIdRessource(int idRessource) { this.idRessource = idRessource; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getNomFichier() { return nomFichier; }
    public void setNomFichier(String nomFichier) { this.nomFichier = nomFichier; }

    public String getCheminFichier() { return cheminFichier; }
    public void setCheminFichier(String cheminFichier) { this.cheminFichier = cheminFichier; }

    public long getTailleFichier() { return tailleFichier; }
    public void setTailleFichier(long tailleFichier) { this.tailleFichier = tailleFichier; }

    public LocalDateTime getDateUpload() { return dateUpload; }
    public void setDateUpload(LocalDateTime dateUpload) { this.dateUpload = dateUpload; }

    public boolean isVisible() { return visible; }
    public void setVisible(boolean visible) { this.visible = visible; }

    public Utilisateur getProfesseur() { return professeur; }
    public void setProfesseur(Utilisateur professeur) { this.professeur = professeur; }

    public Module getModule() { return module; }
    public void setModule(Module module) { this.module = module; }

    public TypeRessource getType() { return type; }
    public void setType(TypeRessource type) { this.type = type; }

    public boolean isEstFavori() { return estFavori; }
    public void setEstFavori(boolean estFavori) { this.estFavori = estFavori; }

    public int getNombreConsultations() { return nombreConsultations; }
    public void setNombreConsultations(int nombreConsultations) {
        this.nombreConsultations = nombreConsultations;
    }

    public String getTailleFormatee() {
        if (tailleFichier < 1024) return tailleFichier + " o";
        if (tailleFichier < 1048576) return String.format("%.1f Ko", tailleFichier / 1024.0);
        return String.format("%.1f Mo", tailleFichier / 1048576.0);
    }

    public String getIconeType() {
        if (type == null) return "fa-file";
        return switch (type.getNomType()) {
            case "PDF" -> "fa-file-pdf";
            case "VIDEO" -> "fa-file-video";
            case "TD" -> "fa-file-alt";
            case "TP" -> "fa-file-code";
            case "PPT" -> "fa-file-powerpoint";
            default -> "fa-file";
        };
    }

    public String getCouleurType() {
        if (type == null) return "#6c757d";
        return switch (type.getNomType()) {
            case "PDF" -> "#e74c3c";
            case "VIDEO" -> "#9b59b6";
            case "TD" -> "#3498db";
            case "TP" -> "#2ecc71";
            case "PPT" -> "#f39c12";
            default -> "#6c757d";
        };
    }
}