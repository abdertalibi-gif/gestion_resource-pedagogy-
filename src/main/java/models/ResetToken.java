package models;

import java.time.LocalDateTime;

public class ResetToken {

    private int id;
    private int utilisateurId;
    private String token;
    private LocalDateTime dateCreation;
    private LocalDateTime dateExpiration;
    private boolean utilise;

    public ResetToken() {}

    public ResetToken(int utilisateurId, String token, LocalDateTime dateExpiration) {
        this.utilisateurId = utilisateurId;
        this.token = token;
        this.dateCreation = LocalDateTime.now();
        this.dateExpiration = dateExpiration;
        this.utilise = false;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUtilisateurId() { return utilisateurId; }
    public void setUtilisateurId(int utilisateurId) { this.utilisateurId = utilisateurId; }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    public LocalDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDateTime dateCreation) { this.dateCreation = dateCreation; }

    public LocalDateTime getDateExpiration() { return dateExpiration; }
    public void setDateExpiration(LocalDateTime dateExpiration) { this.dateExpiration = dateExpiration; }

    public boolean isUtilise() { return utilise; }
    public void setUtilise(boolean utilise) { this.utilise = utilise; }

    /**
     * Vérifie si le token est encore valide (non expiré et non utilisé)
     */
    public boolean isValide() {
        return !utilise && dateExpiration.isAfter(LocalDateTime.now());
    }
}