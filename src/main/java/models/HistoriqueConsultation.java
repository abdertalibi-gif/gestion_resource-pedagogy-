package models;



import java.io.Serializable;
import java.time.LocalDateTime;

public class HistoriqueConsultation implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idHistorique;
    private Utilisateur etudiant;
    private Ressource ressource;
    private LocalDateTime dateConsultation;
    private String typeAction;

    public HistoriqueConsultation() {}

    public int getIdHistorique() { return idHistorique; }
    public void setIdHistorique(int idHistorique) { this.idHistorique = idHistorique; }

    public Utilisateur getEtudiant() { return etudiant; }
    public void setEtudiant(Utilisateur etudiant) { this.etudiant = etudiant; }

    public Ressource getRessource() { return ressource; }
    public void setRessource(Ressource ressource) { this.ressource = ressource; }

    public LocalDateTime getDateConsultation() { return dateConsultation; }
    public void setDateConsultation(LocalDateTime dateConsultation) {
        this.dateConsultation = dateConsultation;
    }

    public String getTypeAction() { return typeAction; }
    public void setTypeAction(String typeAction) { this.typeAction = typeAction; }
}