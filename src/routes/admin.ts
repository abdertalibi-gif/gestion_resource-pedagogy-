import { Router } from 'express';
import { dbStore } from '../data/store.js';
import { requireRole } from '../middleware/auth.js';
import { removeUploadedFile, uploadMemory } from '../utils/upload.js';

export const adminRouter = Router();
adminRouter.use(requireRole('ADMIN'));

// Dashboard
adminRouter.get('/dashboard', (_req, res) => {
  res.render('admin/dashboard', {
    pageTitle: 'Tableau de bord Admin',
    activeMenu: 'dashboard',
    nbAdmins: dbStore.countUsersByRole('ADMIN'),
    nbProfs: dbStore.countUsersByRole('PROFESSEUR'),
    nbEtudiants: dbStore.countUsersByRole('ETUDIANT'),
    nbModules: dbStore.countModules(),
    nbRessources: dbStore.countRessources(),
    nbFilieres: dbStore.countFilieres(),
    dernieresRessources: dbStore.findLast5Ressources(),
  });
});

// Etudiants & Professeurs shortcuts
adminRouter.get('/etudiants', (_req, res) => {
  res.render('admin/etudiants', {
    pageTitle: 'Gestion des étudiants',
    activeMenu: 'etudiants',
    etudiants: dbStore.findUsersByRole('ETUDIANT'),
    filieres: dbStore.findAllFilieres(),
  });
});

adminRouter.get('/etudiants/ajouter', (_req, res) => {
  res.redirect('/admin/utilisateur/ajouter?role=ETUDIANT');
});

adminRouter.get('/etudiants/edit', (req, res) => {
  res.redirect(`/admin/utilisateur/modifier?id=${encodeURIComponent(String(req.query.id ?? ''))}`);
});

adminRouter.get('/etudiants/delete', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const admin = req.session.utilisateur!;
  if (Number.isNaN(id)) {
    req.session.msgError = 'Identifiant invalide.';
    res.redirect('/admin/etudiants');
    return;
  }
  if (admin.idUtilisateur === id) {
    req.session.msgError = 'Vous ne pouvez pas supprimer votre propre compte.';
  } else if (dbStore.deleteUser(id)) {
    req.session.msgSuccess = 'Étudiant supprimé avec succès.';
  } else {
    req.session.msgError = 'Impossible de supprimer cet étudiant.';
  }
  res.redirect('/admin/etudiants');
});

adminRouter.get('/professeurs', (_req, res) => {
  res.render('admin/professeurs', {
    pageTitle: 'Gestion des professeurs',
    activeMenu: 'professeurs',
    professeurs: dbStore.findUsersByRole('PROFESSEUR'),
    filieres: dbStore.findAllFilieres(),
  });
});

adminRouter.get('/professeurs/ajouter', (_req, res) => {
  res.redirect('/admin/utilisateur/ajouter?role=PROFESSEUR');
});

adminRouter.get('/professeurs/edit', (req, res) => {
  res.redirect(`/admin/utilisateur/modifier?id=${encodeURIComponent(String(req.query.id ?? ''))}`);
});

adminRouter.get('/professeurs/delete', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const admin = req.session.utilisateur!;
  if (Number.isNaN(id)) {
    req.session.msgError = 'Identifiant invalide.';
    res.redirect('/admin/professeurs');
    return;
  }
  if (admin.idUtilisateur === id) {
    req.session.msgError = 'Vous ne pouvez pas supprimer votre propre compte.';
  } else if (dbStore.deleteUser(id)) {
    req.session.msgSuccess = 'Professeur supprimé avec succès.';
  } else {
    req.session.msgError = 'Impossible de supprimer ce professeur.';
  }
  res.redirect('/admin/professeurs');
});

// Utilisateurs
adminRouter.get('/utilisateurs', (req, res) => {
  const roleFilter = String(req.query.role ?? '').trim();
  const utilisateurs = roleFilter ? dbStore.findUsersByRole(roleFilter) : dbStore.findAllUsers();
  res.render('admin/utilisateurs-list', {
    pageTitle: 'Gestion des utilisateurs',
    activeMenu: 'utilisateurs',
    utilisateurs,
    roleFilter,
  });
});

adminRouter.get('/utilisateur/ajouter', (req, res) => {
  const presetRole = String(req.query.role ?? '').toUpperCase();
  res.render('admin/utilisateur-form', {
    pageTitle: 'Ajouter utilisateur',
    activeMenu: 'utilisateurs',
    editMode: false,
    utilisateurForm: presetRole ? { role: { nomRole: presetRole } } : null,
    filieres: dbStore.findAllFilieres(),
    semestres: dbStore.findAllSemestres(),
  });
});

adminRouter.post('/utilisateur/ajouter', (req, res) => {
  const nom = String(req.body.nom ?? '');
  const prenom = String(req.body.prenom ?? '');
  const email = String(req.body.email ?? '');
  const motDePasse = String(req.body.motDePasse ?? '');
  const telephone = String(req.body.telephone ?? '') || null;
  const cne = String(req.body.cne ?? '').trim() || null;
  const role = String(req.body.role ?? 'ETUDIANT');
  const idFiliere = req.body.idFiliere ? Number.parseInt(String(req.body.idFiliere), 10) : null;
  const idSemestre = req.body.idSemestre ? Number.parseInt(String(req.body.idSemestre), 10) : null;

  const result = dbStore.createUser({
    nom,
    prenom,
    email,
    motDePasse,
    telephone,
    cne,
    role,
    idFiliere,
    idSemestre,
  });

  if (result.success) {
    req.session.msgSuccess = result.message;
    res.redirect('/admin/utilisateurs');
    return;
  }

  res.render('admin/utilisateur-form', {
    pageTitle: 'Ajouter utilisateur',
    activeMenu: 'utilisateurs',
    editMode: false,
    errors: result.errors,
    utilisateurForm: {
      nom,
      prenom,
      email,
      telephone,
      cne,
      role: { nomRole: role },
      filiere: idFiliere ? { idFiliere } : null,
      semestre: idSemestre ? { idSemestre } : null,
    },
    filieres: dbStore.findAllFilieres(),
    semestres: dbStore.findAllSemestres(),
  });
});

adminRouter.get('/utilisateur/modifier', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const u = Number.isNaN(id) ? null : dbStore.findUserById(id);
  if (!u) {
    res.status(404).render('error/404');
    return;
  }
  res.render('admin/utilisateur-form', {
    pageTitle: 'Modifier utilisateur',
    activeMenu: 'utilisateurs',
    editMode: true,
    utilisateurForm: u,
    filieres: dbStore.findAllFilieres(),
    semestres: dbStore.findAllSemestres(),
  });
});

adminRouter.post('/utilisateur/modifier', (req, res) => {
  const id = Number.parseInt(String(req.body.id ?? ''), 10);
  const existing = Number.isNaN(id) ? null : dbStore.findUserById(id);
  if (!existing) {
    res.status(404).render('error/404');
    return;
  }

  const nom = String(req.body.nom ?? '');
  const prenom = String(req.body.prenom ?? '');
  const email = String(req.body.email ?? '');
  const telephone = String(req.body.telephone ?? '') || null;
  const cne = String(req.body.cne ?? '').trim() || null;
  const role = String(req.body.role ?? 'ETUDIANT');
  const idFiliere = req.body.idFiliere ? Number.parseInt(String(req.body.idFiliere), 10) : null;
  const idSemestre = req.body.idSemestre ? Number.parseInt(String(req.body.idSemestre), 10) : null;

  const result = dbStore.updateUser(id, {
    nom,
    prenom,
    email,
    telephone,
    cne,
    role,
    idFiliere,
    idSemestre,
  });

  if (result.success) {
    req.session.msgSuccess = result.message;
    res.redirect('/admin/utilisateurs');
    return;
  }

  res.render('admin/utilisateur-form', {
    pageTitle: 'Modifier utilisateur',
    activeMenu: 'utilisateurs',
    editMode: true,
    errors: result.errors,
    utilisateurForm: {
      idUtilisateur: id,
      nom,
      prenom,
      email,
      telephone,
      cne,
      role: { nomRole: role },
      filiere: idFiliere ? { idFiliere } : null,
      semestre: idSemestre ? { idSemestre } : null,
    },
    filieres: dbStore.findAllFilieres(),
    semestres: dbStore.findAllSemestres(),
  });
});

adminRouter.get('/utilisateur/supprimer', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const currentUser = req.session.utilisateur!;
  if (currentUser.idUtilisateur === id) {
    req.session.msgError = 'Vous ne pouvez pas supprimer votre propre compte';
    res.redirect('/admin/utilisateurs');
    return;
  }
  dbStore.deleteUser(id);
  req.session.msgSuccess = 'Utilisateur supprimé avec succès';
  res.redirect('/admin/utilisateurs');
});

adminRouter.get('/utilisateur/toggle', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  if (!Number.isNaN(id)) dbStore.toggleUserStatut(id);
  res.redirect('/admin/utilisateurs');
});

adminRouter.get('/utilisateur/accepter', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  if (!Number.isNaN(id)) dbStore.setUserStatut(id, 'ACCEPTE');
  req.session.msgSuccess = 'Utilisateur accepté avec succès';
  res.redirect('/admin/utilisateurs');
});

adminRouter.get('/utilisateur/refuser', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  if (!Number.isNaN(id)) dbStore.setUserStatut(id, 'REFUSE');
  req.session.msgSuccess = 'Utilisateur refusé';
  res.redirect('/admin/utilisateurs');
});

// Import Excel
adminRouter.get('/import', (_req, res) => {
  res.render('admin/import', {
    pageTitle: 'Import Excel',
    activeMenu: 'import',
  });
});

adminRouter.post('/import', uploadMemory.single('fichierExcel'), (req, res) => {
  const typeImport = String(req.body.typeImport || 'ETUDIANT');
  if (!req.file || req.file.size === 0) {
    req.session.msgError = 'Veuillez sélectionner un fichier Excel';
    res.redirect('/admin/import');
    return;
  }

  const result = dbStore.importFromExcel(req.file.buffer, typeImport);
  if (result.success) {
    req.session.msgSuccess = result.message;
  } else {
    req.session.msgError = "Rapport d'importation :";
    req.session.errors = result.errors;
  }
  res.redirect('/admin/import');
});

// Modules
adminRouter.get('/modules', (_req, res) => {
  res.render('admin/modules-list', {
    pageTitle: 'Gestion des modules',
    activeMenu: 'modules',
    modules: dbStore.findAllModules(),
  });
});

adminRouter.get('/module/ajouter', (_req, res) => {
  res.render('admin/module-form', {
    pageTitle: 'Ajouter module',
    activeMenu: 'modules',
    editMode: false,
    moduleItem: null,
    filieres: dbStore.findAllFilieres(),
    semestres: dbStore.findAllSemestres(),
  });
});

adminRouter.post('/module/ajouter', (req, res) => {
  const nomModule = String(req.body.nomModule ?? '');
  const codeModule = String(req.body.codeModule ?? '');
  const description = String(req.body.description ?? '') || null;
  const idFiliere = Number.parseInt(String(req.body.idFiliere ?? '0'), 10);
  const idSemestre = Number.parseInt(String(req.body.idSemestre ?? '0'), 10);

  const result = dbStore.createModule({ nomModule, codeModule, description, idFiliere, idSemestre });
  if (result.success) {
    req.session.msgSuccess = result.message;
    res.redirect('/admin/modules');
    return;
  }

  res.render('admin/module-form', {
    pageTitle: 'Ajouter module',
    activeMenu: 'modules',
    editMode: false,
    errors: result.errors,
    moduleItem: { nomModule, codeModule, description, filiere: { idFiliere }, semestre: { idSemestre } },
    filieres: dbStore.findAllFilieres(),
    semestres: dbStore.findAllSemestres(),
  });
});

adminRouter.get('/module/modifier', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const m = Number.isNaN(id) ? null : dbStore.findModuleById(id);
  if (!m) {
    res.status(404).render('error/404');
    return;
  }
  res.render('admin/module-form', {
    pageTitle: 'Modifier module',
    activeMenu: 'modules',
    editMode: true,
    moduleItem: m,
    filieres: dbStore.findAllFilieres(),
    semestres: dbStore.findAllSemestres(),
  });
});

adminRouter.post('/module/modifier', (req, res) => {
  const id = Number.parseInt(String(req.body.id ?? ''), 10);
  const nomModule = String(req.body.nomModule ?? '');
  const codeModule = String(req.body.codeModule ?? '');
  const description = String(req.body.description ?? '') || null;
  const idFiliere = Number.parseInt(String(req.body.idFiliere ?? '0'), 10);
  const idSemestre = Number.parseInt(String(req.body.idSemestre ?? '0'), 10);

  const result = dbStore.updateModule(id, { nomModule, codeModule, description, idFiliere, idSemestre });
  if (result.success) {
    req.session.msgSuccess = result.message;
    res.redirect('/admin/modules');
    return;
  }

  res.render('admin/module-form', {
    pageTitle: 'Modifier module',
    activeMenu: 'modules',
    editMode: true,
    errors: result.errors,
    moduleItem: { idModule: id, nomModule, codeModule, description, filiere: { idFiliere }, semestre: { idSemestre } },
    filieres: dbStore.findAllFilieres(),
    semestres: dbStore.findAllSemestres(),
  });
});

adminRouter.get('/module/supprimer', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  if (!Number.isNaN(id)) dbStore.deleteModule(id);
  req.session.msgSuccess = 'Module supprimé avec succès';
  res.redirect('/admin/modules');
});

// Filieres
adminRouter.get('/filieres', (_req, res) => {
  res.render('admin/filieres-list', {
    pageTitle: 'Gestion des filières',
    activeMenu: 'filieres',
    filieres: dbStore.findAllFilieres(),
  });
});

adminRouter.get('/filiere/ajouter', (_req, res) => {
  res.render('admin/filiere-form', {
    pageTitle: 'Ajouter filière',
    activeMenu: 'filieres',
    editMode: false,
    filiere: null,
  });
});

adminRouter.get('/filiere/modifier', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const filiere = Number.isNaN(id) ? null : dbStore.findFiliereById(id);
  if (!filiere) {
    res.status(404).render('error/404');
    return;
  }
  res.render('admin/filiere-form', {
    pageTitle: 'Modifier filière',
    activeMenu: 'filieres',
    editMode: true,
    filiere,
  });
});

adminRouter.get('/filiere/voir', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const filiere = Number.isNaN(id) ? null : dbStore.findFiliereById(id);
  if (!filiere) {
    res.status(404).render('error/404');
    return;
  }
  res.render('admin/filiere-voir', {
    pageTitle: `Filière - ${filiere.nomFiliere}`,
    activeMenu: 'filieres',
    filiere,
    modules: dbStore.findModulesByFiliere(id),
    semestres: dbStore.findAllSemestres(),
  });
});

adminRouter.post('/filiere/ajouter', (req, res) => {
  const nomFiliere = String(req.body.nomFiliere ?? '');
  const description = String(req.body.description ?? '') || null;
  dbStore.createFiliere(nomFiliere, description);
  req.session.msgSuccess = 'Filière créée avec succès';
  res.redirect('/admin/filieres');
});

adminRouter.post('/filiere/modifier', (req, res) => {
  const id = Number.parseInt(String(req.body.id ?? ''), 10);
  const nomFiliere = String(req.body.nomFiliere ?? '');
  const description = String(req.body.description ?? '') || null;
  dbStore.updateFiliere(id, nomFiliere, description);
  req.session.msgSuccess = 'Filière modifiée avec succès';
  res.redirect('/admin/filieres');
});

adminRouter.get('/filiere/supprimer', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  if (!Number.isNaN(id)) dbStore.deleteFiliere(id);
  req.session.msgSuccess = 'Filière supprimée avec succès';
  res.redirect('/admin/filieres');
});

// Semestres
adminRouter.get('/semestres', (_req, res) => {
  res.render('admin/semestres-list', {
    pageTitle: 'Gestion des semestres',
    activeMenu: 'semestres',
    semestres: dbStore.findAllSemestres(),
  });
});

adminRouter.get('/semestre/ajouter', (_req, res) => {
  res.render('admin/semestre-form', {
    pageTitle: 'Ajouter semestre',
    activeMenu: 'semestres',
    editMode: false,
    semestre: null,
  });
});

adminRouter.get('/semestre/modifier', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const semestre = Number.isNaN(id) ? null : dbStore.findSemestreById(id);
  if (!semestre) {
    res.status(404).render('error/404');
    return;
  }
  res.render('admin/semestre-form', {
    pageTitle: 'Modifier semestre',
    activeMenu: 'semestres',
    editMode: true,
    semestre,
  });
});

adminRouter.post('/semestre/ajouter', (req, res) => {
  const nomSemestre = String(req.body.nomSemestre ?? '');
  const description = String(req.body.description ?? '') || null;
  dbStore.createSemestre(nomSemestre, description);
  req.session.msgSuccess = 'Semestre créé avec succès';
  res.redirect('/admin/semestres');
});

adminRouter.post('/semestre/modifier', (req, res) => {
  const id = Number.parseInt(String(req.body.id ?? ''), 10);
  const nomSemestre = String(req.body.nomSemestre ?? '');
  const description = String(req.body.description ?? '') || null;
  dbStore.updateSemestre(id, nomSemestre, description);
  req.session.msgSuccess = 'Semestre modifié avec succès';
  res.redirect('/admin/semestres');
});

adminRouter.get('/semestre/supprimer', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  if (!Number.isNaN(id)) dbStore.deleteSemestre(id);
  req.session.msgSuccess = 'Semestre supprimé avec succès';
  res.redirect('/admin/semestres');
});

// Affectations
adminRouter.get('/affectations', (_req, res) => {
  res.render('admin/affectations-list', {
    pageTitle: 'Affectations Professeur-Module',
    activeMenu: 'affectations',
    affectations: dbStore.findAllAffectations(),
  });
});

adminRouter.get('/affectation/ajouter', (_req, res) => {
  res.render('admin/affectation-form', {
    pageTitle: 'Nouvelle affectation',
    activeMenu: 'affectations',
    professeurs: dbStore.findUsersByRole('PROFESSEUR'),
    modules: dbStore.findAllModules(),
  });
});

adminRouter.post('/affectation/ajouter', (req, res) => {
  const idProfesseur = Number.parseInt(String(req.body.idProfesseur ?? '0'), 10);
  const idModule = Number.parseInt(String(req.body.idModule ?? '0'), 10);
  const anneeUniversitaire = String(req.body.anneeUniversitaire ?? '');

  const result = dbStore.createAffectation(idProfesseur, idModule, anneeUniversitaire);
  if (result.success) {
    req.session.msgSuccess = result.message;
    res.redirect('/admin/affectations');
  } else {
    req.session.msgError = result.errors?.[0] ?? "Erreur lors de l'affectation";
    res.redirect('/admin/affectation/ajouter');
  }
});

adminRouter.get('/affectation/supprimer', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  if (!Number.isNaN(id)) dbStore.deleteAffectation(id);
  req.session.msgSuccess = 'Affectation supprimée avec succès';
  res.redirect('/admin/affectations');
});

// Ressources
adminRouter.get('/ressources', (_req, res) => {
  res.render('admin/ressources-list', {
    pageTitle: 'Toutes les ressources',
    activeMenu: 'ressources',
    ressources: dbStore.findAllRessources(),
  });
});

adminRouter.get('/ressource/supprimer', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  if (!Number.isNaN(id)) {
    const existing = dbStore.findRessourceById(id);
    if (existing) removeUploadedFile(existing.cheminFichier);
    dbStore.deleteRessource(id);
  }
  req.session.msgSuccess = 'Ressource supprimée avec succès';
  res.redirect('/admin/ressources');
});

// Statistiques
adminRouter.get('/statistiques', (_req, res) => {
  res.render('admin/statistiques', {
    pageTitle: 'Statistiques',
    activeMenu: 'statistiques',
    nbAdmins: dbStore.countUsersByRole('ADMIN'),
    nbProfs: dbStore.countUsersByRole('PROFESSEUR'),
    nbEtudiants: dbStore.countUsersByRole('ETUDIANT'),
    nbModules: dbStore.countModules(),
    nbRessources: dbStore.countRessources(),
    nbFilieres: dbStore.countFilieres(),
  });
});
