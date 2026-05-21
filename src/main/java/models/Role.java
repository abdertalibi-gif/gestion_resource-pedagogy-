package models;

import java.io.Serializable;

public class Role implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idRole;
    private String nomRole;

    public Role() {}

    public Role(int idRole, String nomRole) {
        this.idRole = idRole;
        this.nomRole = nomRole;
    }

    // Getters et Setters
    public int getIdRole() { return idRole; }
    public void setIdRole(int idRole) { this.idRole = idRole; }

    public String getNomRole() { return nomRole; }
    public void setNomRole(String nomRole) { this.nomRole = nomRole; }

    // Methodes utilitaires
    public boolean isAdmin() { return "ADMIN".equals(nomRole); }
    public boolean isProfesseur() { return "PROFESSEUR".equals(nomRole); }
    public boolean isEtudiant() { return "ETUDIANT".equals(nomRole); }

    @Override
    public String toString() { return nomRole; }
}