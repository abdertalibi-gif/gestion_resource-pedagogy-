export interface Role {
  idRole: number;
  nomRole: 'ADMIN' | 'PROFESSEUR' | 'ETUDIANT';
}

export interface Filiere {
  idFiliere: number;
  nomFiliere: string;
  description: string | null;
}

export interface Semestre {
  idSemestre: number;
  nomSemestre: string;
  description: string | null;
}

export interface TypeRessource {
  idType: number;
  nomType: string;
}

export interface Utilisateur {
  idUtilisateur: number;
  nom: string;
  prenom: string;
  email: string;
  motDePasse: string;
  photo: string | null;
  telephone: string | null;
  cne: string | null;
  specialite?: string | null;
  dateCreation: string;
  statut: 'ACCEPTE' | 'EN_ATTENTE' | 'REFUSE';
  idRole: number;
  idFiliere: number | null;
  idSemestre: number | null;
}

export interface ModuleEntity {
  idModule: number;
  nomModule: string;
  codeModule: string;
  description: string | null;
  idSemestre: number;
  idFiliere: number;
}

export interface AffectationModule {
  idAffectation: number;
  idProfesseur: number;
  idModule: number;
  anneeUniversitaire: string;
}

export interface Ressource {
  idRessource: number;
  titre: string;
  description: string | null;
  nomFichier: string;
  cheminFichier: string;
  tailleFichier: number;
  dateUpload: string;
  visible: boolean;
  idProfesseur: number;
  idModule: number;
  idType: number;
}

export interface Devoir {
  idDevoir: number;
  titre: string;
  description: string | null;
  dateLimite: string | null;
  nomFichier: string | null;
  cheminFichier: string | null;
  tailleFichier: number;
  dateCreation: string;
  idModule: number;
  idProfesseur: number;
}

export interface Soumission {
  idSoumission: number;
  idEtudiant: number;
  idModule: number;
  idDevoir: number | null;
  titre: string;
  description: string | null;
  nomFichier: string;
  cheminFichier: string;
  tailleFichier: number;
  dateSoumission: string;
  statut: 'EN_ATTENTE' | 'ACCEPTE' | 'REFUSE';
  note: number | null;
  commentaire: string | null;
}

export interface Favori {
  idFavori: number;
  idEtudiant: number;
  idRessource: number;
  dateAjout: string;
}

export interface HistoriqueConsultation {
  idHistorique: number;
  idEtudiant: number;
  idRessource: number;
  dateConsultation: string;
  typeAction: 'CONSULTATION' | 'TELECHARGEMENT';
}

export interface ResetToken {
  id: number;
  utilisateurId: number;
  token: string;
  dateCreation: string;
  dateExpiration: string;
  utilise: boolean;
}
