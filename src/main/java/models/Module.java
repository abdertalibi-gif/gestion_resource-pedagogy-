package models;

import java.io.Serializable;

public class Module implements Serializable {
  

    private int idModule;
    private String nomModule;
    private String codeModule;
    private String description;
    private Semestre semestre;
    private Filiere filiere;
    private String nomProfesseur;

    // ✅ CONSTRUCTEUR VIDE
    public Module() {}

    // ✅ GETTERS ET SETTERS
    public int getIdModule() { return idModule; }
    public void setIdModule(int idModule) { this.idModule = idModule; }

    public String getNomModule() { return nomModule; }
    public void setNomModule(String nomModule) { this.nomModule = nomModule; }

    public String getCodeModule() { return codeModule; }
    public void setCodeModule(String codeModule) { this.codeModule = codeModule; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Semestre getSemestre() { return semestre; }
    public void setSemestre(Semestre semestre) { this.semestre = semestre; }

    public Filiere getFiliere() { return filiere; }
    public void setFiliere(Filiere filiere) { this.filiere = filiere; }

    public String getNomProfesseur() { return nomProfesseur; }
    public void setNomProfesseur(String nomProfesseur) { this.nomProfesseur = nomProfesseur; }
}