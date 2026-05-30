package models;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Soumission implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idSoumission;
    private Utilisateur etudiant;
    private Module module;
    private Devoir devoir;
    private String titre;
    private String description;
    private String nomFichier;
    private String cheminFichier;
    private long tailleFichier;
    private LocalDateTime dateSoumission;
    private String statut;
    private Double note;
    private String commentaire;

    public Soumission() {}

    public int getIdSoumission() { return idSoumission; }
    public void setIdSoumission(int idSoumission) { this.idSoumission = idSoumission; }

    public Utilisateur getEtudiant() { return etudiant; }
    public void setEtudiant(Utilisateur etudiant) { this.etudiant = etudiant; }

    public Module getModule() { return module; }
    public void setModule(Module module) { this.module = module; }

    public Devoir getDevoir() { return devoir; }
    public void setDevoir(Devoir devoir) { this.devoir = devoir; }

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

    public LocalDateTime getDateSoumission() { return dateSoumission; }
    public void setDateSoumission(LocalDateTime dateSoumission) { this.dateSoumission = dateSoumission; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public Double getNote() { return note; }
    public void setNote(Double note) { this.note = note; }

    public String getCommentaire() { return commentaire; }
    public void setCommentaire(String commentaire) { this.commentaire = commentaire; }

    public String getTailleFormatee() {
        if (tailleFichier < 1024) return tailleFichier + " o";
        if (tailleFichier < 1048576) return String.format("%.1f Ko", tailleFichier / 1024.0);
        return String.format("%.1f Mo", tailleFichier / 1048576.0);
    }

    public String getStatutBadge() {
        if (statut == null) return "badge-secondary";
        return switch (statut) {
            case "EN_ATTENTE" -> "badge-warning";
            case "ACCEPTE" -> "badge-success";
            case "REFUSE" -> "badge-danger";
            default -> "badge-secondary";
        };
    }

    public String getStatutLabel() {
        if (statut == null) return "Inconnu";
        return switch (statut) {
            case "EN_ATTENTE" -> "En attente";
            case "ACCEPTE" -> "Accepté";
            case "REFUSE" -> "Refusé";
            default -> statut;
        };
    }
}
