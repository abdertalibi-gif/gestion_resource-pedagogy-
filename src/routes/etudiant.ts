import fs from 'node:fs';
import { Router } from 'express';
import { dbStore } from '../data/store.js';
import { requireRole } from '../middleware/auth.js';
import { removeUploadedFile, resolvePublicFile, toPublicUploadPath, uploadDisk } from '../utils/upload.js';

export const etudiantRouter = Router();
etudiantRouter.use(requireRole('ETUDIANT'));

etudiantRouter.get('/dashboard', (req, res) => {
  const user = req.session.utilisateur!;
  const modules =
    user.idFiliere && user.idSemestre
      ? dbStore.findModulesByFiliereSemestre(user.idFiliere, user.idSemestre)
      : [];

  res.render('etudiant/dashboard', {
    pageTitle: 'Tableau de bord',
    activeMenu: 'dashboard',
    modules,
    recentes: dbStore.findLast5Ressources(),
    nbFavoris: dbStore.countFavorisByEtudiant(user.idUtilisateur),
    nbConsultations: dbStore.countHistoriqueByEtudiant(user.idUtilisateur),
  });
});

etudiantRouter.get('/modules', (req, res) => {
  const user = req.session.utilisateur!;
  const modules =
    user.idFiliere && user.idSemestre
      ? dbStore.findModulesByFiliereSemestre(user.idFiliere, user.idSemestre)
      : [];

  res.render('etudiant/modules', {
    pageTitle: 'Mes modules',
    activeMenu: 'modules',
    modules,
  });
});

etudiantRouter.get('/ressources', (req, res) => {
  const user = req.session.utilisateur!;
  const moduleFilter = String(req.query.module ?? '').trim();
  const typeFilter = String(req.query.type ?? '').trim();

  let ressources = moduleFilter
    ? dbStore.findRessourcesByModule(Number.parseInt(moduleFilter, 10), user.idUtilisateur, false)
    : dbStore.findAllRessources(user.idUtilisateur).filter((r) => r.visible);

  if (typeFilter) {
    ressources = ressources.filter((r) => r.type?.nomType === typeFilter);
  }

  res.render('etudiant/ressources-list', {
    pageTitle: 'Ressources',
    activeMenu: 'ressources',
    moduleFilter,
    typeFilter,
    ressources,
    types: dbStore.findAllTypes(),
  });
});

etudiantRouter.get('/ressource/voir', (req, res) => {
  const user = req.session.utilisateur!;
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const r = Number.isNaN(id) ? null : dbStore.findRessourceById(id, user.idUtilisateur);
  if (!r || !r.visible) {
    res.status(404).render('error/404');
    return;
  }

  dbStore.addHistorique(user.idUtilisateur, r.idRessource, 'CONSULTATION');
  const refreshed = dbStore.findRessourceById(id, user.idUtilisateur)!;

  res.render('etudiant/ressource-view', {
    pageTitle: refreshed.titre,
    activeMenu: 'ressources',
    ressource: refreshed,
  });
});

etudiantRouter.get('/ressource/telecharger', (req, res) => {
  const user = req.session.utilisateur!;
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const r = Number.isNaN(id) ? null : dbStore.findRessourceById(id, user.idUtilisateur);
  if (!r || !r.visible) {
    res.status(404).render('error/404');
    return;
  }

  dbStore.addHistorique(user.idUtilisateur, r.idRessource, 'TELECHARGEMENT');
  const filePath = resolvePublicFile(r.cheminFichier);
  if (!fs.existsSync(filePath)) {
    res.status(404).render('error/404');
    return;
  }

  res.download(filePath, r.nomFichier);
});

etudiantRouter.get('/recherche', (req, res) => {
  const user = req.session.utilisateur!;
  const keyword = String(req.query.q ?? '').trim();
  const resultats = keyword ? dbStore.searchRessources(keyword, user.idUtilisateur) : [];

  res.render('etudiant/recherche', {
    pageTitle: 'Recherche',
    activeMenu: 'recherche',
    resultats,
    keyword,
  });
});

etudiantRouter.get('/favoris', (req, res) => {
  const user = req.session.utilisateur!;
  res.render('etudiant/favoris', {
    pageTitle: 'Mes favoris',
    activeMenu: 'favoris',
    favoris: dbStore.findFavorisByEtudiant(user.idUtilisateur),
  });
});

etudiantRouter.get('/favori/ajouter', (req, res) => {
  const user = req.session.utilisateur!;
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  if (!Number.isNaN(id)) dbStore.addFavori(user.idUtilisateur, id);
  res.redirect(req.get('referer') || '/etudiant/ressources');
});

etudiantRouter.get('/favori/retirer', (req, res) => {
  const user = req.session.utilisateur!;
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  if (!Number.isNaN(id)) dbStore.removeFavori(user.idUtilisateur, id);
  res.redirect(req.get('referer') || '/etudiant/favoris');
});

etudiantRouter.get('/historique', (req, res) => {
  const user = req.session.utilisateur!;
  res.render('etudiant/historique', {
    pageTitle: 'Historique',
    activeMenu: 'historique',
    historique: dbStore.findHistoriqueByEtudiant(user.idUtilisateur),
  });
});

etudiantRouter.get('/profil', (req, res) => {
  const user = dbStore.findUserById(req.session.utilisateur!.idUtilisateur) ?? req.session.utilisateur!;
  res.render('etudiant/profil', {
    pageTitle: 'Mon profil',
    activeMenu: 'profil',
    utilisateur: user,
  });
});

etudiantRouter.post('/profil', (req, res) => {
  const user = req.session.utilisateur!;
  const nouveauMdp = String(req.body.nouveauMdp ?? '');
  const confirmMdp = String(req.body.confirmMdp ?? '');

  if (nouveauMdp.length < 6) {
    req.session.msgError = 'Le mot de passe doit contenir au moins 6 caractères.';
    res.redirect('/etudiant/profil');
    return;
  }
  if (nouveauMdp !== confirmMdp) {
    req.session.msgError = 'Les mots de passe ne correspondent pas.';
    res.redirect('/etudiant/profil');
    return;
  }

  dbStore.updatePassword(user.idUtilisateur, nouveauMdp);
  req.session.msgSuccess = 'Mot de passe modifié avec succès.';
  res.redirect('/etudiant/profil');
});

etudiantRouter.get('/devoirs', (req, res) => {
  const user = req.session.utilisateur!;
  const devoirs =
    user.idFiliere && user.idSemestre
      ? dbStore.findDevoirsByFiliereSemestre(user.idFiliere, user.idSemestre)
      : [];

  res.render('etudiant/mes-devoirs', {
    pageTitle: 'Mes devoirs',
    activeMenu: 'devoirs',
    devoirs,
  });
});

etudiantRouter.get('/soumettre', (req, res) => {
  const user = req.session.utilisateur!;
  const modules =
    user.idFiliere && user.idSemestre
      ? dbStore.findModulesByFiliereSemestre(user.idFiliere, user.idSemestre)
      : [];
  const devoirs =
    user.idFiliere && user.idSemestre
      ? dbStore.findDevoirsByFiliereSemestre(user.idFiliere, user.idSemestre)
      : [];

  res.render('etudiant/soumettre', {
    pageTitle: 'Soumettre un devoir',
    activeMenu: 'soumettre',
    modules,
    devoirs,
    selectedDevoirId: req.query.idDevoir ? String(req.query.idDevoir) : '',
    selectedModuleId: req.query.idModule ? String(req.query.idModule) : '',
  });
});

etudiantRouter.post('/soumettre', uploadDisk.single('fichier'), (req, res) => {
  const user = req.session.utilisateur!;
  const modules =
    user.idFiliere && user.idSemestre
      ? dbStore.findModulesByFiliereSemestre(user.idFiliere, user.idSemestre)
      : [];
  const devoirs =
    user.idFiliere && user.idSemestre
      ? dbStore.findDevoirsByFiliereSemestre(user.idFiliere, user.idSemestre)
      : [];

  if (!req.file || req.file.size === 0) {
    res.render('etudiant/soumettre', {
      pageTitle: 'Soumettre un devoir',
      activeMenu: 'soumettre',
      msgError: 'Veuillez sélectionner un fichier PDF',
      modules,
      devoirs,
      selectedDevoirId: '',
      selectedModuleId: '',
    });
    return;
  }

  const titre = String(req.body.titre ?? '').trim();
  const description = String(req.body.description ?? '') || null;
  const idModule = Number.parseInt(String(req.body.idModule ?? '0'), 10);
  const idDevoir = req.body.idDevoir ? Number.parseInt(String(req.body.idDevoir), 10) : null;

  if (!titre || !idModule) {
    removeUploadedFile(toPublicUploadPath(req.file));
    res.render('etudiant/soumettre', {
      pageTitle: 'Soumettre un devoir',
      activeMenu: 'soumettre',
      msgError: 'Le titre et le module sont obligatoires',
      modules,
      devoirs,
      selectedDevoirId: idDevoir ? String(idDevoir) : '',
      selectedModuleId: idModule ? String(idModule) : '',
    });
    return;
  }

  dbStore.createSoumission({
    idEtudiant: user.idUtilisateur,
    idModule,
    idDevoir,
    titre,
    description,
    nomFichier: req.file.originalname,
    cheminFichier: toPublicUploadPath(req.file),
    tailleFichier: req.file.size,
  });

  req.session.msgSuccess = 'Devoir soumis avec succès';
  res.redirect('/etudiant/mes-soumissions');
});

etudiantRouter.get('/mes-soumissions', (req, res) => {
  const user = req.session.utilisateur!;
  res.render('etudiant/mes-soumissions', {
    pageTitle: 'Mes soumissions',
    activeMenu: 'mes-soumissions',
    soumissions: dbStore.findSoumissionsByEtudiant(user.idUtilisateur),
  });
});

etudiantRouter.get('/soumission/telecharger', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const s = Number.isNaN(id) ? null : dbStore.findSoumissionById(id);
  if (!s) {
    res.status(404).render('error/404');
    return;
  }
  const filePath = resolvePublicFile(s.cheminFichier);
  if (!fs.existsSync(filePath)) {
    res.status(404).render('error/404');
    return;
  }
  res.setHeader('Content-Disposition', `inline; filename="${encodeURIComponent(s.nomFichier)}"`);
  res.sendFile(filePath);
});
