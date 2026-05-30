package models;

import java.io.Serializable;

public class TypeRessource implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idType;
    private String nomType;

    public TypeRessource() {}

    public TypeRessource(int idType, String nomType) {
        this.idType = idType;
        this.nomType = nomType;
    }

    public int getIdType() { return idType; }
    public void setIdType(int idType) { this.idType = idType; }

    public String getNomType() { return nomType; }
    public void setNomType(String nomType) { this.nomType = nomType; }

    @Override
    public String toString() { return nomType; }
}