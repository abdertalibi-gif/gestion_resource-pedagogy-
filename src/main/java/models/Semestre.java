package models;

import java.io.Serializable;

public class Semestre implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idSemestre;
    private String nomSemestre;
    private String description;

    public Semestre() {}

    public Semestre(int idSemestre, String nomSemestre, String description) {
        this.idSemestre = idSemestre;
        this.nomSemestre = nomSemestre;
        this.description = description;
    }

    public int getIdSemestre() { return idSemestre; }
    public void setIdSemestre(int idSemestre) { this.idSemestre = idSemestre; }

    public String getNomSemestre() { return nomSemestre; }
    public void setNomSemestre(String nomSemestre) { this.nomSemestre = nomSemestre; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    @Override
    public String toString() { return nomSemestre; }
}