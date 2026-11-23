import fs from 'node:fs';
import path from 'node:path';
import * as XLSX from 'xlsx';
import type {
  AffectationModule,
  Devoir,
  Favori,
  Filiere,
  HistoriqueConsultation,
  ModuleEntity,
  ResetToken,
  Ressource,
  Role,
  Semestre,
  Soumission,
  TypeRessource,
  Utilisateur,
} from '../types/models.js';
import {
  formatFileSize,
  getStatutBadge,
  getStatutLabel,
  getTypeColor,
  getTypeIcon,
  hashPassword,
  splitDateTimeParts,
  tempsEcoule,
  validerModule,
  validerUtilisateur,
  verifyPassword,
} from '../utils/helpers.js';

// In-memory store seeded directly from base_donne.sql
const roles: Role[] = [
  { idRole: 1, nomRole: 'ADMIN' },
  { idRole: 2, nomRole: 'PROFESSEUR' },
  { idRole: 3, nomRole: 'ETUDIANT' },
];

const filieres: Filiere[] = [
  { idFiliere: 14, nomFiliere: 'SMI', description: 'Mathématiques Informatique' },
  { idFiliere: 15, nomFiliere: 'SMA', description: 'Mathématiques' },
  { idFiliere: 16, nomFiliere: 'SMP', description: 'Physique' },
  { idFiliere: 17, nomFiliere: 'SMC', description: 'Chimie' },
  { idFiliere: 18, nomFiliere: 'SVI', description: 'Biologie' },
  { idFiliere: 19, nomFiliere: 'STU', description: 'Géologie' },
];

const semestres: Semestre[] = [
  { idSemestre: 1, nomSemestre: 'S1', description: 'Semestre 1' },
  { idSemestre: 2, nomSemestre: 'S2', description: 'Semestre 2' },
  { idSemestre: 3, nomSemestre: 'S3', description: 'Semestre 3' },
  { idSemestre: 4, nomSemestre: 'S4', description: 'Semestre 4' },
  { idSemestre: 5, nomSemestre: 'S5', description: 'Semestre 5' },
  { idSemestre: 6, nomSemestre: 'S6', description: 'Semestre 6' },
];

const typesRessources: TypeRessource[] = [
  { idType: 1, nomType: 'PDF' },
  { idType: 2, nomType: 'VIDEO' },
  { idType: 3, nomType: 'TD' },
  { idType: 4, nomType: 'TP' },
  { idType: 5, nomType: 'PPT' },
  { idType: 19, nomType: 'ZIP' },
  { idType: 20, nomType: 'Excel' },
];

const modules: ModuleEntity[] = [
  { idModule: 143, nomModule: 'Analyse 1', codeModule: 'SMI-S1-M1', description: 'Analyse 1', idSemestre: 1, idFiliere: 14 },
  { idModule: 144, nomModule: 'Algèbre 1', codeModule: 'SMI-S1-M2', description: 'Algèbre 1', idSemestre: 1, idFiliere: 14 },
  { idModule: 145, nomModule: 'Algorithmique 1', codeModule: 'SMI-S1-M3', description: 'Introduction programmation', idSemestre: 1, idFiliere: 14 },
  { idModule: 146, nomModule: 'Physique 1', codeModule: 'SMI-S1-M4', description: 'Mécanique', idSemestre: 1, idFiliere: 14 },
  { idModule: 147, nomModule: 'Analyse 2', codeModule: 'SMI-S2-M1', description: 'Analyse 2', idSemestre: 2, idFiliere: 14 },
  { idModule: 148, nomModule: 'Algèbre 2', codeModule: 'SMI-S2-M2', description: 'Algèbre linéaire', idSemestre: 2, idFiliere: 14 },
  { idModule: 149, nomModule: 'Programmation 2', codeModule: 'SMI-S2-M3', description: 'C / Python', idSemestre: 2, idFiliere: 14 },
  { idModule: 150, nomModule: 'Logique', codeModule: 'SMI-S2-M4', description: 'Logique mathématique', idSemestre: 2, idFiliere: 14 },
  { idModule: 151, nomModule: 'Structures de données', codeModule: 'SMI-S3-M1', description: 'Listes, piles, files', idSemestre: 3, idFiliere: 14 },
  { idModule: 152, nomModule: 'Système d’exploitation', codeModule: 'SMI-S3-M2', description: 'Linux OS', idSemestre: 3, idFiliere: 14 },
  { idModule: 153, nomModule: 'Probabilités', codeModule: 'SMI-S3-M3', description: 'Statistiques', idSemestre: 3, idFiliere: 14 },
  { idModule: 154, nomModule: 'Base de données', codeModule: 'SMI-S4-M1', description: 'SQL & modélisation', idSemestre: 4, idFiliere: 14 },
  { idModule: 155, nomModule: 'Réseaux', codeModule: 'SMI-S4-M2', description: 'Réseaux informatiques', idSemestre: 4, idFiliere: 14 },
  { idModule: 156, nomModule: 'Compilation', codeModule: 'SMI-S5-M1', description: 'Compilation', idSemestre: 5, idFiliere: 14 },
  { idModule: 157, nomModule: 'POO', codeModule: 'SMI-S5-M2', description: 'Java / C++', idSemestre: 5, idFiliere: 14 },
  { idModule: 158, nomModule: 'PFE', codeModule: 'SMI-S6-M1', description: 'Projet fin d’études', idSemestre: 6, idFiliere: 14 },
  { idModule: 159, nomModule: 'Analyse 1', codeModule: 'SMA-S1-M1', description: 'Analyse 1', idSemestre: 1, idFiliere: 15 },
  { idModule: 160, nomModule: 'Algèbre 1', codeModule: 'SMA-S1-M2', description: 'Algèbre 1', idSemestre: 1, idFiliere: 15 },
  { idModule: 161, nomModule: 'Physique 1', codeModule: 'SMA-S1-M3', description: 'Mécanique', idSemestre: 1, idFiliere: 15 },
  { idModule: 162, nomModule: 'Analyse 2', codeModule: 'SMA-S2-M1', description: 'Analyse 2', idSemestre: 2, idFiliere: 15 },
  { idModule: 163, nomModule: 'Algèbre 2', codeModule: 'SMA-S2-M2', description: 'Algèbre linéaire', idSemestre: 2, idFiliere: 15 },
  { idModule: 164, nomModule: 'Analyse 3', codeModule: 'SMA-S3-M1', description: 'Analyse avancée', idSemestre: 3, idFiliere: 15 },
  { idModule: 165, nomModule: 'Algèbre 3', codeModule: 'SMA-S3-M2', description: 'Algèbre avancée', idSemestre: 3, idFiliere: 15 },
  { idModule: 166, nomModule: 'Analyse numérique', codeModule: 'SMA-S4-M1', description: 'Méthodes numériques', idSemestre: 4, idFiliere: 15 },
  { idModule: 167, nomModule: 'Probabilités', codeModule: 'SMA-S4-M2', description: 'Stats', idSemestre: 4, idFiliere: 15 },
  { idModule: 168, nomModule: 'Topologie', codeModule: 'SMA-S5-M1', description: 'Topologie', idSemestre: 5, idFiliere: 15 },
  { idModule: 169, nomModule: 'Équations diff', codeModule: 'SMA-S5-M2', description: 'EDO', idSemestre: 5, idFiliere: 15 },
  { idModule: 170, nomModule: 'PFE', codeModule: 'SMA-S6-M1', description: 'Projet fin d’études', idSemestre: 6, idFiliere: 15 },
  { idModule: 171, nomModule: 'Mécanique', codeModule: 'SMP-S1-M1', description: 'Mécanique classique', idSemestre: 1, idFiliere: 16 },
  { idModule: 172, nomModule: 'Thermodynamique', codeModule: 'SMP-S1-M2', description: 'Thermo', idSemestre: 1, idFiliere: 16 },
  { idModule: 173, nomModule: 'Électricité', codeModule: 'SMP-S2-M1', description: 'Électricité', idSemestre: 2, idFiliere: 16 },
  { idModule: 174, nomModule: 'Optique', codeModule: 'SMP-S2-M2', description: 'Optique', idSemestre: 2, idFiliere: 16 },
  { idModule: 175, nomModule: 'Électromagnétisme', codeModule: 'SMP-S3-M1', description: 'EM', idSemestre: 3, idFiliere: 16 },
  { idModule: 176, nomModule: 'Mécanique avancée', codeModule: 'SMP-S3-M2', description: 'Mécanique', idSemestre: 3, idFiliere: 16 },
  { idModule: 177, nomModule: 'Physique quantique', codeModule: 'SMP-S4-M1', description: 'Quantique', idSemestre: 4, idFiliere: 16 },
  { idModule: 178, nomModule: 'Physique statistique', codeModule: 'SMP-S4-M2', description: 'Statistique', idSemestre: 4, idFiliere: 16 },
  { idModule: 179, nomModule: 'Physique moderne', codeModule: 'SMP-S5-M1', description: 'Relativité', idSemestre: 5, idFiliere: 16 },
  { idModule: 180, nomModule: 'PFE', codeModule: 'SMP-S6-M1', description: 'Projet fin d’études', idSemestre: 6, idFiliere: 16 },
  { idModule: 181, nomModule: 'Chimie générale', codeModule: 'SMC-S1-M1', description: 'Chimie générale', idSemestre: 1, idFiliere: 17 },
  { idModule: 182, nomModule: 'Physique 1', codeModule: 'SMC-S1-M2', description: 'Physique', idSemestre: 1, idFiliere: 17 },
  { idModule: 183, nomModule: 'Chimie organique', codeModule: 'SMC-S2-M1', description: 'Organique', idSemestre: 2, idFiliere: 17 },
  { idModule: 184, nomModule: 'Chimie analytique', codeModule: 'SMC-S2-M2', description: 'Analyse chimique', idSemestre: 2, idFiliere: 17 },
  { idModule: 185, nomModule: 'Thermodynamique', codeModule: 'SMC-S3-M1', description: 'Thermo chimique', idSemestre: 3, idFiliere: 17 },
  { idModule: 186, nomModule: 'Chimie minérale', codeModule: 'SMC-S3-M2', description: 'Minérale', idSemestre: 3, idFiliere: 17 },
  { idModule: 187, nomModule: 'Chimie physique', codeModule: 'SMC-S4-M1', description: 'Physique chimie', idSemestre: 4, idFiliere: 17 },
  { idModule: 188, nomModule: 'Spectroscopie', codeModule: 'SMC-S4-M2', description: 'Analyse spectrale', idSemestre: 4, idFiliere: 17 },
  { idModule: 189, nomModule: 'Chimie avancée', codeModule: 'SMC-S5-M1', description: 'Avancée', idSemestre: 5, idFiliere: 17 },
  { idModule: 190, nomModule: 'PFE', codeModule: 'SMC-S6-M1', description: 'Projet fin d’études', idSemestre: 6, idFiliere: 17 },
  { idModule: 191, nomModule: 'Biologie cellulaire', codeModule: 'SVI-S1-M1', description: 'Cellule', idSemestre: 1, idFiliere: 18 },
  { idModule: 192, nomModule: 'Chimie générale', codeModule: 'SVI-S1-M2', description: 'Chimie', idSemestre: 1, idFiliere: 18 },
  { idModule: 193, nomModule: 'Biologie animale', codeModule: 'SVI-S2-M1', description: 'Animal', idSemestre: 2, idFiliere: 18 },
  { idModule: 194, nomModule: 'Biologie végétale', codeModule: 'SVI-S2-M2', description: 'Plantes', idSemestre: 2, idFiliere: 18 },
  { idModule: 195, nomModule: 'Génétique', codeModule: 'SVI-S3-M1', description: 'ADN', idSemestre: 3, idFiliere: 18 },
  { idModule: 196, nomModule: 'Microbiologie', codeModule: 'SVI-S3-M2', description: 'Microbes', idSemestre: 3, idFiliere: 18 },
  { idModule: 197, nomModule: 'Physiologie animale', codeModule: 'SVI-S4-M1', description: 'Fonction animale', idSemestre: 4, idFiliere: 18 },
  { idModule: 198, nomModule: 'Physiologie végétale', codeModule: 'SVI-S4-M2', description: 'Fonction plantes', idSemestre: 4, idFiliere: 18 },
  { idModule: 199, nomModule: 'Biotechnologie', codeModule: 'SVI-S5-M1', description: 'Tech bio', idSemestre: 5, idFiliere: 18 },
  { idModule: 200, nomModule: 'PFE', codeModule: 'SVI-S6-M1', description: 'Projet fin d’études', idSemestre: 6, idFiliere: 18 },
  { idModule: 201, nomModule: 'Géologie générale', codeModule: 'STU-S1-M1', description: 'Géologie', idSemestre: 1, idFiliere: 19 },
  { idModule: 202, nomModule: 'Physique', codeModule: 'STU-S1-M2', description: 'Physique', idSemestre: 1, idFiliere: 19 },
  { idModule: 203, nomModule: 'Minéralogie', codeModule: 'STU-S2-M1', description: 'Minéraux', idSemestre: 2, idFiliere: 19 },
  { idModule: 204, nomModule: 'Paléontologie', codeModule: 'STU-S2-M2', description: 'Fossiles', idSemestre: 2, idFiliere: 19 },
  { idModule: 205, nomModule: 'Sédimentologie', codeModule: 'STU-S3-M1', description: 'Sédiments', idSemestre: 3, idFiliere: 19 },
  { idModule: 206, nomModule: 'Hydrologie', codeModule: 'STU-S3-M2', description: 'Eau', idSemestre: 3, idFiliere: 19 },
  { idModule: 207, nomModule: 'Tectonique', codeModule: 'STU-S4-M1', description: 'Plaques', idSemestre: 4, idFiliere: 19 },
  { idModule: 208, nomModule: 'Géochimie', codeModule: 'STU-S4-M2', description: 'Chimie Terre', idSemestre: 4, idFiliere: 19 },
  { idModule: 209, nomModule: 'Géologie appliquée', codeModule: 'STU-S5-M1', description: 'Applications', idSemestre: 5, idFiliere: 19 },
  { idModule: 210, nomModule: 'PFE', codeModule: 'STU-S6-M1', description: 'Projet fin d’études', idSemestre: 6, idFiliere: 19 },
  { idModule: 231, nomModule: 'MTU', codeModule: 'SMA-S1-M7', description: '', idSemestre: 5, idFiliere: 15 },
];

const utilisateurs: Utilisateur[] = [
  {
    idUtilisateur: 1,
    nom: 'ADMIN',
    prenom: 'SYSTEM',
    email: 'admin@gmail.com',
    motDePasse: 'admin123',
    photo: null,
    telephone: '0600000000',
    cne: null,
    specialite: null,
    dateCreation: '2026-05-14 22:42:12',
    statut: 'ACCEPTE',
    idRole: 1,
    idFiliere: null,
    idSemestre: null,
  },
  {
    idUtilisateur: 21,
    nom: 'ali',
    prenom: 'ali',
    email: 'ali@gmail.com',
    motDePasse: '9AgJxDrLLDiM9bXeTyGxt+xZuvT6UQIFdlYUAIFszxD6ekjf8z8H1gfNX9KEIsNs',
    photo: null,
    telephone: '06000000',
    cne: null,
    specialite: 'info',
    dateCreation: '2026-05-29 21:10:49',
    statut: 'ACCEPTE',
    idRole: 2,
    idFiliere: null,
    idSemestre: null,
  },
  {
    idUtilisateur: 22,
    nom: 'ali',
    prenom: 'reda',
    email: 'allli@gmail.com',
    motDePasse: 'vHlEPBYiLfshrRkX4a1RkBtPyR3Y0xvdCqJATEZOTqCtq2z26UV6Psnip1O+IShs',
    photo: null,
    telephone: '06000000',
    cne: null,
    specialite: null,
    dateCreation: '2026-05-30 02:11:58',
    statut: 'ACCEPTE',
    idRole: 2,
    idFiliere: null,
    idSemestre: null,
  },
  {
    idUtilisateur: 23,
    nom: 'talibi',
    prenom: 'abder',
    email: 'alllli@gmail.com',
    motDePasse: 'O+qJKoph12FAzkmTopr+bh/eHi6CNUDGum5uwj5IE6VCq5WkBJZiWy675IRh16nf',
    photo: null,
    telephone: '0605368543',
    cne: null,
    specialite: null,
    dateCreation: '2026-05-30 02:12:27',
    statut: 'ACCEPTE',
    idRole: 2,
    idFiliere: null,
    idSemestre: null,
  },
  {
    idUtilisateur: 26,
    nom: 'talibi',
    prenom: 'abder',
    email: 'talibi.abder@gmail.com',
    motDePasse: 'D196D+l8zTznE8vTsgHySoRF+M60pC7iOwVRRI0SnfxyX8XKhpeT1JDfIkAi09y1',
    photo: null,
    telephone: '0605368543',
    cne: 'UB111111',
    specialite: null,
    dateCreation: '2026-05-30 18:18:07',
    statut: 'ACCEPTE',
    idRole: 3,
    idFiliere: 14,
    idSemestre: 5,
  },
  {
    idUtilisateur: 37,
    nom: 'abderrahim',
    prenom: 'abder',
    email: 'talibi@gmail.com',
    motDePasse: 'HKvWORNolSzDvnkKEnbCO0EYgbxeTeaXVlJJqrPnKhbq3TM/y2iwqmN4vcWPOsAE',
    photo: null,
    telephone: '0605368543',
    cne: 'UN1111111111',
    specialite: null,
    dateCreation: '2026-05-31 19:03:30',
    statut: 'ACCEPTE',
    idRole: 3,
    idFiliere: 17,
    idSemestre: 2,
  },
];

const affectations: AffectationModule[] = [
  { idAffectation: 5, idProfesseur: 21, idModule: 170, anneeUniversitaire: '2025-2026' },
  { idAffectation: 6, idProfesseur: 22, idModule: 167, anneeUniversitaire: '2025-2026' },
  { idAffectation: 7, idProfesseur: 23, idModule: 185, anneeUniversitaire: '2025-2026' },
  { idAffectation: 9, idProfesseur: 21, idModule: 183, anneeUniversitaire: '2025-2026' },
];

const ressources: Ressource[] = [
  {
    idRessource: 13,
    titre: 'JAVA',
    description: '',
    nomFichier: 'TP3_JSP.pdf',
    cheminFichier: '/assets/uploads/pdf/11ea2a907af547199c4855d3856781b4.pdf',
    tailleFichier: 1137952,
    dateUpload: '2026-05-31 04:56:23',
    visible: true,
    idProfesseur: 21,
    idModule: 170,
    idType: 1,
  },
  {
    idRessource: 14,
    titre: 'pfe',
    description: '',
    nomFichier: 'bjonesn77-earth-8882368.png',
    cheminFichier: '/assets/uploads/images/be3e48314499475daed9732ee23bcb58.png',
    tailleFichier: 20688862,
    dateUpload: '2026-05-31 05:04:33',
    visible: true,
    idProfesseur: 21,
    idModule: 170,
    idType: 5,
  },
  {
    idRessource: 24,
    titre: 'alins',
    description: '',
    nomFichier: 'Examen_S7_25.pdf',
    cheminFichier: '/assets/uploads/pdf/6ae9a154a65548d2bdefa5d8ae2954ae.pdf',
    tailleFichier: 85052,
    dateUpload: '2026-05-31 18:36:32',
    visible: true,
    idProfesseur: 23,
    idModule: 185,
    idType: 1,
  },
  {
    idRessource: 25,
    titre: 'pfe',
    description: '',
    nomFichier: 'Examen_S7_25.zip',
    cheminFichier: '/assets/uploads/documents/36c44056769449608c8667a4feaef0d0.zip',
    tailleFichier: 81715,
    dateUpload: '2026-05-31 18:36:53',
    visible: true,
    idProfesseur: 23,
    idModule: 185,
    idType: 19,
  },
  {
    idRessource: 26,
    titre: 'pfe',
    description: '',
    nomFichier: 'nnnnn.pdf',
    cheminFichier: '/assets/uploads/pdf/29d9142de14a4d0ca821d24f3db1dbc9.pdf',
    tailleFichier: 850737,
    dateUpload: '2026-05-31 18:40:26',
    visible: true,
    idProfesseur: 23,
    idModule: 185,
    idType: 3,
  },
];

const devoirs: Devoir[] = [
  {
    idDevoir: 2,
    titre: 'pfe',
    description: '',
    dateLimite: '2026-07-07 09:00:00',
    nomFichier: null,
    cheminFichier: null,
    tailleFichier: 0,
    dateCreation: '2026-05-30 20:19:51',
    idModule: 170,
    idProfesseur: 21,
  },
  {
    idDevoir: 3,
    titre: 'algo1',
    description: '',
    dateLimite: '2026-07-29 11:00:00',
    nomFichier: 'examan.pdf',
    cheminFichier: '/assets/uploads/pdf/84c59d4ce9944a21b0a5a0abf287f505.pdf',
    tailleFichier: 1398229,
    dateCreation: '2026-05-31 19:41:04',
    idModule: 185,
    idProfesseur: 23,
  },
  {
    idDevoir: 4,
    titre: 'gggggg',
    description: '',
    dateLimite: '2027-02-13 22:12:00',
    nomFichier: null,
    cheminFichier: null,
    tailleFichier: 0,
    dateCreation: '2026-05-31 20:13:28',
    idModule: 183,
    idProfesseur: 21,
  },
];

const soumissions: Soumission[] = [
  {
    idSoumission: 4,
    idEtudiant: 37,
    idModule: 183,
    idDevoir: 4,
    titre: 'BASE DOENN',
    description: '',
    nomFichier: 'Examen_S7_25.pdf',
    cheminFichier: '/assets/uploads/pdf/17d93521cda1464b87095b59314ab867.pdf',
    tailleFichier: 85052,
    dateSoumission: '2026-05-31 20:14:06',
    statut: 'ACCEPTE',
    note: 18,
    commentaire: 'Bon travail',
  },
];

const favoris: Favori[] = [
  { idFavori: 25, idEtudiant: 37, idRessource: 24, dateAjout: '2026-05-31 19:06:07' },
];

const historiques: HistoriqueConsultation[] = [
  { idHistorique: 125, idEtudiant: 37, idRessource: 24, dateConsultation: '2026-05-31 19:04:17', typeAction: 'CONSULTATION' },
  { idHistorique: 126, idEtudiant: 37, idRessource: 24, dateConsultation: '2026-05-31 19:04:19', typeAction: 'TELECHARGEMENT' },
  { idHistorique: 127, idEtudiant: 37, idRessource: 14, dateConsultation: '2026-05-31 19:05:06', typeAction: 'CONSULTATION' },
  { idHistorique: 130, idEtudiant: 37, idRessource: 26, dateConsultation: '2026-05-31 19:05:29', typeAction: 'CONSULTATION' },
  { idHistorique: 131, idEtudiant: 37, idRessource: 26, dateConsultation: '2026-05-31 19:05:30', typeAction: 'TELECHARGEMENT' },
  { idHistorique: 133, idEtudiant: 37, idRessource: 13, dateConsultation: '2026-05-31 19:05:49', typeAction: 'TELECHARGEMENT' },
];

const resetTokens: ResetToken[] = [];

let nextIds = {
  utilisateur: 38,
  filiere: 20,
  semestre: 11,
  module: 232,
  affectation: 10,
  ressource: 27,
  devoir: 5,
  soumission: 5,
  favori: 26,
  historique: 135,
  resetToken: 1,
};

function nowSql(): string {
  return new Date().toISOString().replace('T', ' ').slice(0, 19);
}

// Create lightweight placeholder files for seeded resources/devoirs/soumissions
export function ensureSeededFiles(publicDir: string): void {
  const samplePdfContent = `%PDF-1.4
1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj
2 0 obj << /Type /Pages /Kids [3 0 R] /Count 1 >> endobj
3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >> endobj
4 0 obj << /Length 68 >> stream
BT /F1 18 Tf 72 700 Td (GesPed - Document Pedagogique) Tj ET
endstream endobj
5 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >> endobj
xref
0 6
0000000000 65535 f 
0000000009 00000 n 
0000000058 00000 n 
0000000115 00000 n 
0000000241 00000 n 
0000000359 00000 n 
trailer << /Size 6 /Root 1 0 R >>
startxref
427
%%EOF`;

  const allPaths = [
    ...ressources.map((r) => r.cheminFichier),
    ...devoirs.map((d) => d.cheminFichier).filter(Boolean) as string[],
    ...soumissions.map((s) => s.cheminFichier),
  ];

  for (const rel of allPaths) {
    const clean = rel.replace(/^\/+/, '');
    const full = path.join(publicDir, clean);
    fs.mkdirSync(path.dirname(full), { recursive: true });
    if (!fs.existsSync(full)) {
      if (clean.endsWith('.pdf')) {
        fs.writeFileSync(full, samplePdfContent, 'utf8');
      } else {
        fs.writeFileSync(full, `GesPed sample asset: ${path.basename(clean)}\n`, 'utf8');
      }
    }
  }
}

// View model enrichment helpers matching JSP template expectations
export function enrichUtilisateur(u: Utilisateur) {
  const role = roles.find((r) => r.idRole === u.idRole) || { idRole: 3, nomRole: 'ETUDIANT' as const };
  const filiere = u.idFiliere ? filieres.find((f) => f.idFiliere === u.idFiliere) || null : null;
  const semestre = u.idSemestre ? semestres.find((s) => s.idSemestre === u.idSemestre) || null : null;
  return {
    ...u,
    nomComplet: `${u.prenom} ${u.nom}`,
    statutLabel: getStatutLabel(u.statut),
    statutBadge: getStatutBadge(u.statut),
    role,
    filiere,
    semestre,
  };
}

export function enrichModule(m: ModuleEntity) {
  const filiere = filieres.find((f) => f.idFiliere === m.idFiliere) || { idFiliere: m.idFiliere, nomFiliere: '-', description: null };
  const semestre = semestres.find((s) => s.idSemestre === m.idSemestre) || { idSemestre: m.idSemestre, nomSemestre: '-', description: null };
  const aff = affectations.find((a) => a.idModule === m.idModule);
  const prof = aff ? utilisateurs.find((u) => u.idUtilisateur === aff.idProfesseur) : undefined;
  return {
    ...m,
    filiere,
    semestre,
    nomProfesseur: prof ? `${prof.prenom} ${prof.nom}` : null,
  };
}

export function enrichRessource(r: Ressource, currentUserId?: number) {
  const mod = modules.find((m) => m.idModule === r.idModule);
  const enrichedMod = mod
    ? enrichModule(mod)
    : {
        idModule: r.idModule,
        nomModule: 'Module inconnu',
        codeModule: '-',
        description: null,
        idSemestre: 0,
        idFiliere: 0,
        filiere: { idFiliere: 0, nomFiliere: '-', description: null },
        semestre: { idSemestre: 0, nomSemestre: '-', description: null },
        nomProfesseur: null,
      };
  const prof = utilisateurs.find((u) => u.idUtilisateur === r.idProfesseur);
  const type = typesRessources.find((t) => t.idType === r.idType) || { idType: r.idType, nomType: 'FILE' };
  const estFavori = currentUserId
    ? favoris.some((f) => f.idEtudiant === currentUserId && f.idRessource === r.idRessource)
    : false;
  const nombreConsultations = historiques.filter((h) => h.idRessource === r.idRessource).length;

  return {
    ...r,
    module: enrichedMod,
    professeur: prof ? enrichUtilisateur(prof) : { nom: 'Professeur', prenom: '', nomComplet: 'Professeur', idUtilisateur: r.idProfesseur },
    type,
    tailleFormatee: formatFileSize(r.tailleFichier),
    iconeType: getTypeIcon(type.nomType),
    couleurType: getTypeColor(type.nomType),
    estFavori,
    nombreConsultations,
  };
}

export function enrichAffectation(a: AffectationModule) {
  const prof = utilisateurs.find((u) => u.idUtilisateur === a.idProfesseur);
  const mod = modules.find((m) => m.idModule === a.idModule);
  return {
    ...a,
    professeur: prof ? enrichUtilisateur(prof) : { nom: 'Inconnu', prenom: '', email: '', nomComplet: 'Inconnu' },
    module: mod ? enrichModule(mod) : { codeModule: '-', nomModule: '-', filiere: { nomFiliere: '-' }, semestre: { nomSemestre: '-' } },
  };
}

export function enrichDevoir(d: Devoir) {
  const mod = modules.find((m) => m.idModule === d.idModule);
  const prof = utilisateurs.find((u) => u.idUtilisateur === d.idProfesseur);
  const nbSoumissions = soumissions.filter((s) => s.idDevoir === d.idDevoir).length;
  const dlParts = splitDateTimeParts(d.dateLimite);
  const depasse = d.dateLimite ? new Date(d.dateLimite.replace(' ', 'T')).getTime() < Date.now() : false;
  return {
    ...d,
    module: mod ? enrichModule(mod) : { codeModule: '-', nomModule: '-' },
    professeur: prof ? enrichUtilisateur(prof) : { nom: 'Professeur', prenom: '', nomComplet: 'Professeur' },
    nbSoumissions,
    depasse,
    dateLimiteDate: dlParts.date,
    dateLimiteTime: dlParts.time,
  };
}

export function enrichSoumission(s: Soumission) {
  const mod = modules.find((m) => m.idModule === s.idModule);
  const etu = utilisateurs.find((u) => u.idUtilisateur === s.idEtudiant);
  const dev = s.idDevoir ? devoirs.find((d) => d.idDevoir === s.idDevoir) || null : null;
  const dtParts = splitDateTimeParts(s.dateSoumission);
  return {
    ...s,
    module: mod ? enrichModule(mod) : { codeModule: '-', nomModule: '-' },
    etudiant: etu ? enrichUtilisateur(etu) : { nom: 'Etudiant', prenom: 'E', nomComplet: 'Etudiant' },
    devoir: dev,
    tailleFormatee: formatFileSize(s.tailleFichier),
    statutBadge: getStatutBadge(s.statut),
    statutLabel: getStatutLabel(s.statut),
    dateSoumissionDate: dtParts.date,
    dateSoumissionTime: dtParts.time,
  };
}

export const dbStore = {
  // Auth
  authenticateWithStatus(email: string, password: string) {
    if (!email || !email.trim() || !password) return { status: 'INVALID' as const, user: null };
    const user = utilisateurs.find((u) => u.email.toLowerCase() === email.trim().toLowerCase());
    if (!user) return { status: 'INVALID' as const, user: null };
    const ok = verifyPassword(password, user.motDePasse) || password === user.motDePasse;
    if (!ok) return { status: 'INVALID' as const, user: null };
    if (user.statut !== 'ACCEPTE') return { status: 'INACTIF' as const, user: enrichUtilisateur(user) };
    return { status: 'OK' as const, user: enrichUtilisateur(user) };
  },

  verifyIdentity(email: string, nom: string, prenom: string, cne?: string) {
    const user = utilisateurs.find((u) => u.email.toLowerCase() === email.trim().toLowerCase());
    if (!user) return null;
    if (user.nom.toLowerCase() !== nom.trim().toLowerCase()) return null;
    if (user.prenom.toLowerCase() !== prenom.trim().toLowerCase()) return null;
    if (user.cne && user.cne.trim()) {
      if (!cne || user.cne.toLowerCase() !== cne.trim().toLowerCase()) return null;
    }
    return enrichUtilisateur(user);
  },

  updatePassword(userId: number, newPlainPassword: string) {
    const user = utilisateurs.find((u) => u.idUtilisateur === userId);
    if (!user) return false;
    user.motDePasse = hashPassword(newPlainPassword);
    return true;
  },

  // Reset tokens
  findResetToken(token: string) {
    const rt = resetTokens.find((t) => t.token === token);
    if (!rt) return null;
    const valide = !rt.utilise && new Date(rt.dateExpiration).getTime() > Date.now();
    return { ...rt, valide };
  },

  markTokenUsed(token: string) {
    const rt = resetTokens.find((t) => t.token === token);
    if (rt) rt.utilise = true;
  },

  // Utilisateurs
  findAllUsers() {
    return utilisateurs.map(enrichUtilisateur);
  },

  findUsersByRole(roleName: string) {
    const r = roles.find((item) => item.nomRole === roleName.toUpperCase());
    if (!r) return [];
    return utilisateurs.filter((u) => u.idRole === r.idRole).map(enrichUtilisateur);
  },

  findUserById(id: number) {
    const u = utilisateurs.find((item) => item.idUtilisateur === id);
    return u ? enrichUtilisateur(u) : null;
  },

  countUsersByRole(roleName: string) {
    const r = roles.find((item) => item.nomRole === roleName.toUpperCase());
    if (!r) return 0;
    return utilisateurs.filter((u) => u.idRole === r.idRole).length;
  },

  createUser(input: {
    nom: string;
    prenom: string;
    email: string;
    motDePasse: string;
    telephone?: string | null;
    cne?: string | null;
    role: string;
    idFiliere?: number | null;
    idSemestre?: number | null;
  }) {
    const errors = validerUtilisateur({
      nom: input.nom,
      prenom: input.prenom,
      email: input.email,
      motDePasse: input.motDePasse,
      cne: input.cne,
      role: input.role,
    });
    if (errors.length > 0) return { success: false, errors };
    if (utilisateurs.some((u) => u.email.toLowerCase() === input.email.trim().toLowerCase())) {
      return { success: false, errors: ['Cet email est deja utilise'] };
    }
    const roleObj = roles.find((r) => r.nomRole === input.role) || roles[2];
    const newUser: Utilisateur = {
      idUtilisateur: nextIds.utilisateur++,
      nom: input.nom.trim(),
      prenom: input.prenom.trim(),
      email: input.email.trim(),
      motDePasse: hashPassword(input.motDePasse),
      photo: null,
      telephone: input.telephone?.trim() || null,
      cne: input.cne?.trim() || null,
      specialite: null,
      dateCreation: nowSql(),
      statut: 'ACCEPTE',
      idRole: roleObj.idRole,
      idFiliere: input.idFiliere || null,
      idSemestre: input.idSemestre || null,
    };
    utilisateurs.push(newUser);
    return { success: true, data: enrichUtilisateur(newUser), message: 'Utilisateur cree avec succes' };
  },

  updateUser(
    id: number,
    input: {
      nom: string;
      prenom: string;
      email: string;
      telephone?: string | null;
      cne?: string | null;
      role: string;
      idFiliere?: number | null;
      idSemestre?: number | null;
    }
  ) {
    const user = utilisateurs.find((u) => u.idUtilisateur === id);
    if (!user) return { success: false, errors: ['Utilisateur introuvable'] };

    const errors = validerUtilisateur({
      nom: input.nom,
      prenom: input.prenom,
      email: input.email,
      motDePasse: null,
      cne: input.cne,
      role: input.role,
    });
    if (errors.length > 0) return { success: false, errors };

    const roleObj = roles.find((r) => r.nomRole === input.role) || roles[2];
    user.nom = input.nom.trim();
    user.prenom = input.prenom.trim();
    user.email = input.email.trim();
    user.telephone = input.telephone?.trim() || null;
    user.cne = input.cne?.trim() || null;
    user.idRole = roleObj.idRole;
    user.idFiliere = input.idFiliere || null;
    user.idSemestre = input.idSemestre || null;

    return { success: true, data: enrichUtilisateur(user), message: 'Utilisateur modifie avec succes' };
  },

  deleteUser(id: number) {
    const idx = utilisateurs.findIndex((u) => u.idUtilisateur === id);
    if (idx === -1) return false;
    utilisateurs.splice(idx, 1);
    return true;
  },

  toggleUserStatut(id: number) {
    const user = utilisateurs.find((u) => u.idUtilisateur === id);
    if (!user) return false;
    user.statut = user.statut === 'ACCEPTE' ? 'REFUSE' : 'ACCEPTE';
    return true;
  },

  setUserStatut(id: number, statut: 'ACCEPTE' | 'REFUSE' | 'EN_ATTENTE') {
    const user = utilisateurs.find((u) => u.idUtilisateur === id);
    if (!user) return false;
    user.statut = statut;
    return true;
  },

  importFromExcel(buffer: Buffer, typeImport: string) {
    const isEtudiant = typeImport === 'ETUDIANT';
    const rapport: string[] = [];
    let success = 0;
    let errors = 0;
    let doublons = 0;

    try {
      const workbook = XLSX.read(buffer, { type: 'buffer' });
      const sheetName = workbook.SheetNames[0];
      if (!sheetName) return { success: false, errors: ['Le fichier Excel est vide'] };
      const rows = XLSX.utils.sheet_to_json<unknown[]>(workbook.Sheets[sheetName], { header: 1 });
      if (rows.length === 0) return { success: false, errors: ['Le fichier Excel est vide'] };

      for (let i = 1; i < rows.length; i++) {
        const row = rows[i] || [];
        const cell = (idx: number) => String(row[idx] ?? '').trim();
        const nom = cell(0);
        const prenom = cell(1);
        const email = cell(2);
        const motDePasse = cell(3);

        if (!nom && !prenom && !email) continue;
        if (!nom || !prenom || !email || !motDePasse) {
          errors++;
          rapport.push(`Ligne ${i + 1} : champs obligatoires manquants`);
          continue;
        }
        if (utilisateurs.some((u) => u.email.toLowerCase() === email.toLowerCase())) {
          doublons++;
          rapport.push(`Ligne ${i + 1} : email '${email}' existe deja`);
          continue;
        }

        let idFiliere: number | null = null;
        let idSemestre: number | null = null;
        let cne: string | null = null;
        let telephone: string | null = null;

        if (isEtudiant) {
          const filiereNom = cell(4);
          const niveau = cell(5);
          cne = cell(6) || null;
          telephone = cell(7) || null;

          if (filiereNom) {
            const f = filieres.find((item) => item.nomFiliere.toLowerCase() === filiereNom.toLowerCase());
            if (!f) {
              errors++;
              rapport.push(`Ligne ${i + 1} : filiere '${filiereNom}' introuvable`);
              continue;
            }
            idFiliere = f.idFiliere;
          }
          if (niveau) {
            const s = semestres.find((item) => item.nomSemestre.toLowerCase() === niveau.toLowerCase());
            if (!s) {
              errors++;
              rapport.push(`Ligne ${i + 1} : niveau/semestre '${niveau}' introuvable`);
              continue;
            }
            idSemestre = s.idSemestre;
          }
        } else {
          telephone = cell(4) || null;
        }

        const roleObj = roles.find((r) => r.nomRole === (isEtudiant ? 'ETUDIANT' : 'PROFESSEUR'))!;
        utilisateurs.push({
          idUtilisateur: nextIds.utilisateur++,
          nom,
          prenom,
          email,
          motDePasse: hashPassword(motDePasse),
          photo: null,
          telephone,
          cne,
          specialite: null,
          dateCreation: nowSql(),
          statut: 'ACCEPTE',
          idRole: roleObj.idRole,
          idFiliere,
          idSemestre,
        });
        success++;
      }

      const label = isEtudiant ? 'etudiant(s)' : 'professeur(s)';
      let msg = `${success} ${label} importe(s) avec succes.`;
      if (doublons > 0) msg += ` ${doublons} doublon(s) ignore(s).`;
      if (rapport.length > 0) {
        return { success: false, errors: [msg, ...rapport] };
      }
      return { success: true, message: msg };
    } catch (e) {
      return {
        success: false,
        errors: [`Erreur de lecture du fichier Excel : ${(e as Error).message}`],
      };
    }
  },

  // Filieres
  findAllFilieres() {
    return [...filieres];
  },
  findFiliereById(id: number) {
    return filieres.find((f) => f.idFiliere === id) || null;
  },
  countFilieres() {
    return filieres.length;
  },
  createFiliere(nomFiliere: string, description: string | null) {
    const f: Filiere = { idFiliere: nextIds.filiere++, nomFiliere: nomFiliere.trim(), description };
    filieres.push(f);
    return f;
  },
  updateFiliere(id: number, nomFiliere: string, description: string | null) {
    const f = filieres.find((item) => item.idFiliere === id);
    if (!f) return false;
    f.nomFiliere = nomFiliere.trim();
    f.description = description;
    return true;
  },
  deleteFiliere(id: number) {
    const idx = filieres.findIndex((f) => f.idFiliere === id);
    if (idx === -1) return false;
    filieres.splice(idx, 1);
    return true;
  },

  // Semestres
  findAllSemestres() {
    return [...semestres];
  },
  findSemestreById(id: number) {
    return semestres.find((s) => s.idSemestre === id) || null;
  },
  createSemestre(nomSemestre: string, description: string | null) {
    const s: Semestre = { idSemestre: nextIds.semestre++, nomSemestre: nomSemestre.trim(), description };
    semestres.push(s);
    return s;
  },
  updateSemestre(id: number, nomSemestre: string, description: string | null) {
    const s = semestres.find((item) => item.idSemestre === id);
    if (!s) return false;
    s.nomSemestre = nomSemestre.trim();
    s.description = description;
    return true;
  },
  deleteSemestre(id: number) {
    const idx = semestres.findIndex((s) => s.idSemestre === id);
    if (idx === -1) return false;
    semestres.splice(idx, 1);
    return true;
  },

  // Modules
  findAllModules() {
    return modules.map(enrichModule).sort((a, b) => a.codeModule.localeCompare(b.codeModule));
  },
  findModuleById(id: number) {
    const m = modules.find((item) => item.idModule === id);
    return m ? enrichModule(m) : null;
  },
  findModulesByFiliere(idFiliere: number) {
    return modules.filter((m) => m.idFiliere === idFiliere).map(enrichModule);
  },
  findModulesByFiliereSemestre(idFiliere: number, idSemestre: number) {
    return modules
      .filter((m) => m.idFiliere === idFiliere && m.idSemestre === idSemestre)
      .map(enrichModule);
  },
  findModulesByProfesseur(idProfesseur: number) {
    const modIds = new Set(affectations.filter((a) => a.idProfesseur === idProfesseur).map((a) => a.idModule));
    return modules.filter((m) => modIds.has(m.idModule)).map(enrichModule);
  },
  countModules() {
    return modules.length;
  },
  createModule(input: {
    nomModule: string;
    codeModule: string;
    description: string | null;
    idFiliere: number;
    idSemestre: number;
  }) {
    const errors = validerModule(input.nomModule, input.codeModule);
    if (errors.length > 0) return { success: false, errors };
    if (modules.some((m) => m.codeModule.toLowerCase() === input.codeModule.trim().toLowerCase())) {
      return { success: false, errors: ['Ce code de module existe deja'] };
    }
    const m: ModuleEntity = {
      idModule: nextIds.module++,
      nomModule: input.nomModule.trim(),
      codeModule: input.codeModule.trim(),
      description: input.description,
      idFiliere: input.idFiliere,
      idSemestre: input.idSemestre,
    };
    modules.push(m);
    return { success: true, data: enrichModule(m), message: 'Module cree avec succes' };
  },
  updateModule(
    id: number,
    input: {
      nomModule: string;
      codeModule: string;
      description: string | null;
      idFiliere: number;
      idSemestre: number;
    }
  ) {
    const m = modules.find((item) => item.idModule === id);
    if (!m) return { success: false, errors: ['Module introuvable'] };
    const errors = validerModule(input.nomModule, input.codeModule);
    if (errors.length > 0) return { success: false, errors };
    m.nomModule = input.nomModule.trim();
    m.codeModule = input.codeModule.trim();
    m.description = input.description;
    m.idFiliere = input.idFiliere;
    m.idSemestre = input.idSemestre;
    return { success: true, data: enrichModule(m), message: 'Module modifie avec succes' };
  },
  deleteModule(id: number) {
    const idx = modules.findIndex((m) => m.idModule === id);
    if (idx === -1) return false;
    modules.splice(idx, 1);
    return true;
  },

  // Affectations
  findAllAffectations() {
    return affectations.map(enrichAffectation);
  },
  createAffectation(idProfesseur: number, idModule: number, anneeUniversitaire: string) {
    const exists = affectations.some(
      (a) =>
        a.idProfesseur === idProfesseur &&
        a.idModule === idModule &&
        a.anneeUniversitaire === anneeUniversitaire
    );
    if (exists) {
      return { success: false, errors: ['Cette affectation existe deja pour cette annee'] };
    }
    const aff: AffectationModule = {
      idAffectation: nextIds.affectation++,
      idProfesseur,
      idModule,
      anneeUniversitaire: anneeUniversitaire.trim(),
    };
    affectations.push(aff);
    return { success: true, data: enrichAffectation(aff), message: 'Affectation creee avec succes' };
  },
  deleteAffectation(id: number) {
    const idx = affectations.findIndex((a) => a.idAffectation === id);
    if (idx === -1) return false;
    affectations.splice(idx, 1);
    return true;
  },

  // Types Ressources
  findAllTypes() {
    return [...typesRessources];
  },

  // Ressources
  findAllRessources(currentUserId?: number) {
    return [...ressources]
      .sort((a, b) => b.dateUpload.localeCompare(a.dateUpload))
      .map((r) => enrichRessource(r, currentUserId));
  },
  findLast5Ressources() {
    return [...ressources]
      .sort((a, b) => b.dateUpload.localeCompare(a.dateUpload))
      .slice(0, 5)
      .map((r) => enrichRessource(r));
  },
  findRessourceById(id: number, currentUserId?: number) {
    const r = ressources.find((item) => item.idRessource === id);
    return r ? enrichRessource(r, currentUserId) : null;
  },
  findRessourcesByProfesseur(idProf: number) {
    return ressources
      .filter((r) => r.idProfesseur === idProf)
      .sort((a, b) => b.dateUpload.localeCompare(a.dateUpload))
      .map((r) => enrichRessource(r));
  },
  findRessourcesByModule(idModule: number, currentUserId?: number, includeHidden = false) {
    return ressources
      .filter((r) => r.idModule === idModule && (includeHidden || r.visible))
      .sort((a, b) => b.dateUpload.localeCompare(a.dateUpload))
      .map((r) => enrichRessource(r, currentUserId));
  },
  searchRessources(keyword: string, currentUserId?: number) {
    const q = keyword.trim().toLowerCase();
    return ressources
      .filter((r) => {
        if (!r.visible) return false;
        const mod = modules.find((m) => m.idModule === r.idModule);
        const prof = utilisateurs.find((u) => u.idUtilisateur === r.idProfesseur);
        return (
          r.titre.toLowerCase().includes(q) ||
          (r.description || '').toLowerCase().includes(q) ||
          (mod?.nomModule || '').toLowerCase().includes(q) ||
          (prof ? `${prof.prenom} ${prof.nom}`.toLowerCase().includes(q) : false)
        );
      })
      .sort((a, b) => b.dateUpload.localeCompare(a.dateUpload))
      .map((r) => enrichRessource(r, currentUserId));
  },
  countRessources() {
    return ressources.length;
  },
  countRessourcesByProfesseur(idProf: number) {
    return ressources.filter((r) => r.idProfesseur === idProf).length;
  },
  createRessource(input: {
    titre: string;
    description: string | null;
    nomFichier: string;
    cheminFichier: string;
    tailleFichier: number;
    idProfesseur: number;
    idModule: number;
    idType: number;
  }) {
    const r: Ressource = {
      idRessource: nextIds.ressource++,
      titre: input.titre.trim(),
      description: input.description,
      nomFichier: input.nomFichier,
      cheminFichier: input.cheminFichier,
      tailleFichier: input.tailleFichier,
      dateUpload: nowSql(),
      visible: true,
      idProfesseur: input.idProfesseur,
      idModule: input.idModule,
      idType: input.idType,
    };
    ressources.push(r);
    return enrichRessource(r);
  },
  updateRessource(
    id: number,
    input: { titre: string; description: string | null; visible: boolean; idModule: number; idType: number }
  ) {
    const r = ressources.find((item) => item.idRessource === id);
    if (!r) return false;
    r.titre = input.titre.trim();
    r.description = input.description;
    r.visible = input.visible;
    r.idModule = input.idModule;
    r.idType = input.idType;
    return true;
  },
  deleteRessource(id: number) {
    const idx = ressources.findIndex((r) => r.idRessource === id);
    if (idx === -1) return false;
    ressources.splice(idx, 1);
    return true;
  },

  // Favoris
  findFavorisByEtudiant(idEtudiant: number) {
    return favoris
      .filter((f) => f.idEtudiant === idEtudiant)
      .sort((a, b) => b.dateAjout.localeCompare(a.dateAjout))
      .map((f) => {
        const res = ressources.find((r) => r.idRessource === f.idRessource);
        return res
          ? {
              ...f,
              ressource: enrichRessource(res, idEtudiant),
            }
          : null;
      })
      .filter(Boolean);
  },
  countFavorisByEtudiant(idEtudiant: number) {
    return favoris.filter((f) => f.idEtudiant === idEtudiant).length;
  },
  addFavori(idEtudiant: number, idRessource: number) {
    if (favoris.some((f) => f.idEtudiant === idEtudiant && f.idRessource === idRessource)) return;
    favoris.push({
      idFavori: nextIds.favori++,
      idEtudiant,
      idRessource,
      dateAjout: nowSql(),
    });
  },
  removeFavori(idEtudiant: number, idRessource: number) {
    const idx = favoris.findIndex((f) => f.idEtudiant === idEtudiant && f.idRessource === idRessource);
    if (idx !== -1) favoris.splice(idx, 1);
  },

  // Historique
  addHistorique(idEtudiant: number, idRessource: number, typeAction: 'CONSULTATION' | 'TELECHARGEMENT') {
    historiques.push({
      idHistorique: nextIds.historique++,
      idEtudiant,
      idRessource,
      dateConsultation: nowSql(),
      typeAction,
    });
  },
  findHistoriqueByEtudiant(idEtudiant: number) {
    return historiques
      .filter((h) => h.idEtudiant === idEtudiant)
      .sort((a, b) => b.dateConsultation.localeCompare(a.dateConsultation))
      .map((h) => {
        const res = ressources.find((r) => r.idRessource === h.idRessource);
        return res
          ? {
              ...h,
              ressource: enrichRessource(res, idEtudiant),
              tempsEcoule: tempsEcoule(h.dateConsultation),
            }
          : null;
      })
      .filter(Boolean);
  },
  countHistoriqueByEtudiant(idEtudiant: number) {
    return historiques.filter((h) => h.idEtudiant === idEtudiant).length;
  },

  // Devoirs
  findDevoirsByProfesseur(idProfesseur: number) {
    const modIds = new Set(affectations.filter((a) => a.idProfesseur === idProfesseur).map((a) => a.idModule));
    return devoirs
      .filter((d) => modIds.has(d.idModule) || d.idProfesseur === idProfesseur)
      .sort((a, b) => b.dateCreation.localeCompare(a.dateCreation))
      .map(enrichDevoir);
  },
  findDevoirsByFiliereSemestre(idFiliere: number, idSemestre: number) {
    const modIds = new Set(
      modules.filter((m) => m.idFiliere === idFiliere && m.idSemestre === idSemestre).map((m) => m.idModule)
    );
    return devoirs
      .filter((d) => modIds.has(d.idModule))
      .sort((a, b) => b.dateCreation.localeCompare(a.dateCreation))
      .map(enrichDevoir);
  },
  findDevoirById(id: number) {
    const d = devoirs.find((item) => item.idDevoir === id);
    return d ? enrichDevoir(d) : null;
  },
  createDevoir(input: {
    titre: string;
    description: string | null;
    dateLimite: string | null;
    nomFichier: string | null;
    cheminFichier: string | null;
    tailleFichier: number;
    idModule: number;
    idProfesseur: number;
  }) {
    const d: Devoir = {
      idDevoir: nextIds.devoir++,
      titre: input.titre.trim(),
      description: input.description,
      dateLimite: input.dateLimite,
      nomFichier: input.nomFichier,
      cheminFichier: input.cheminFichier,
      tailleFichier: input.tailleFichier,
      dateCreation: nowSql(),
      idModule: input.idModule,
      idProfesseur: input.idProfesseur,
    };
    devoirs.push(d);
    return enrichDevoir(d);
  },
  deleteDevoir(id: number) {
    const idx = devoirs.findIndex((d) => d.idDevoir === id);
    if (idx === -1) return false;
    devoirs.splice(idx, 1);
    return true;
  },

  // Soumissions
  findSoumissionsByProfesseur(idProfesseur: number) {
    const modIds = new Set(affectations.filter((a) => a.idProfesseur === idProfesseur).map((a) => a.idModule));
    return soumissions
      .filter((s) => modIds.has(s.idModule))
      .sort((a, b) => b.dateSoumission.localeCompare(a.dateSoumission))
      .map(enrichSoumission);
  },
  findSoumissionsByEtudiant(idEtudiant: number) {
    return soumissions
      .filter((s) => s.idEtudiant === idEtudiant)
      .sort((a, b) => b.dateSoumission.localeCompare(a.dateSoumission))
      .map(enrichSoumission);
  },
  findSoumissionsByDevoir(idDevoir: number) {
    return soumissions
      .filter((s) => s.idDevoir === idDevoir)
      .sort((a, b) => b.dateSoumission.localeCompare(a.dateSoumission))
      .map(enrichSoumission);
  },
  findSoumissionById(id: number) {
    const s = soumissions.find((item) => item.idSoumission === id);
    return s ? enrichSoumission(s) : null;
  },
  createSoumission(input: {
    idEtudiant: number;
    idModule: number;
    idDevoir: number | null;
    titre: string;
    description: string | null;
    nomFichier: string;
    cheminFichier: string;
    tailleFichier: number;
  }) {
    const s: Soumission = {
      idSoumission: nextIds.soumission++,
      idEtudiant: input.idEtudiant,
      idModule: input.idModule,
      idDevoir: input.idDevoir,
      titre: input.titre.trim(),
      description: input.description,
      nomFichier: input.nomFichier,
      cheminFichier: input.cheminFichier,
      tailleFichier: input.tailleFichier,
      dateSoumission: nowSql(),
      statut: 'EN_ATTENTE',
      note: null,
      commentaire: null,
    };
    soumissions.push(s);
    return enrichSoumission(s);
  },
  evaluerSoumission(id: number, statut: 'EN_ATTENTE' | 'ACCEPTE' | 'REFUSE', note: number | null, commentaire: string | null) {
    const s = soumissions.find((item) => item.idSoumission === id);
    if (!s) return null;
    s.statut = statut;
    s.note = note;
    s.commentaire = commentaire;
    return enrichSoumission(s);
  },
};
