package models;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Utilisateur implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idUtilisateur;
    private String nom;
    private String prenom;
    private String email;
    private String motDePasse;
    private String photo;
    private String telephone;
    private LocalDateTime dateCreation;
    private String statut;
    private Role role;
    private Filiere filiere;
    private Semestre semestre;

    // Alias pour faciliter l'affichage JSP
    public String getNomComplet() {
        return prenom + " " + nom;
    }

    public Utilisateur() {}

    // Getters et Setters
    public int getIdUtilisateur() { return idUtilisateur; }
    public void setIdUtilisateur(int idUtilisateur) { this.idUtilisateur = idUtilisateur; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public LocalDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDateTime dateCreation) { this.dateCreation = dateCreation; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

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

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public Filiere getFiliere() { return filiere; }
    public void setFiliere(Filiere filiere) { this.filiere = filiere; }

    public Semestre getSemestre() { return semestre; }
    public void setSemestre(Semestre semestre) { this.semestre = semestre; }
}