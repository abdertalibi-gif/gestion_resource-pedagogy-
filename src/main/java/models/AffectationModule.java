package models;

import java.io.Serializable;

public class AffectationModule implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idAffectation;
    private Utilisateur professeur;
    private Module module;
    private String anneeUniversitaire;

    public AffectationModule() {}

    public int getIdAffectation() { return idAffectation; }
    public void setIdAffectation(int idAffectation) { this.idAffectation = idAffectation; }

    public Utilisateur getProfesseur() { return professeur; }
    public void setProfesseur(Utilisateur professeur) { this.professeur = professeur; }

    public Module getModule() { return module; }
    public void setModule(Module module) { this.module = module; }

    public String getAnneeUniversitaire() { return anneeUniversitaire; }
    public void setAnneeUniversitaire(String anneeUniversitaire) {
        this.anneeUniversitaire = anneeUniversitaire;
    }
}