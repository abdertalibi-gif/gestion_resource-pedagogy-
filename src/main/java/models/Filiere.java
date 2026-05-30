package models;

import java.io.Serializable;

public class Filiere implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idFiliere;
    private String nomFiliere;
    private String description;

    public Filiere() {}

    public Filiere(int idFiliere, String nomFiliere, String description) {
        this.idFiliere = idFiliere;
        this.nomFiliere = nomFiliere;
        this.description = description;
    }

    public int getIdFiliere() { return idFiliere; }
    public void setIdFiliere(int idFiliere) { this.idFiliere = idFiliere; }

    public String getNomFiliere() { return nomFiliere; }
    public void setNomFiliere(String nomFiliere) { this.nomFiliere = nomFiliere; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    @Override
    public String toString() { return nomFiliere; }
}