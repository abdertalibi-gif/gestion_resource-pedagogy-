import fs from 'node:fs';
import { Router } from 'express';
import { dbStore } from '../data/store.js';
import { requireRole } from '../middleware/auth.js';
import { removeUploadedFile, resolvePublicFile, toPublicUploadPath, uploadDisk } from '../utils/upload.js';

export const professeurRouter = Router();
professeurRouter.use(requireRole('PROFESSEUR'));

professeurRouter.get('/dashboard', (req, res) => {
  const user = req.session.utilisateur!;
  const modules = dbStore.findModulesByProfesseur(user.idUtilisateur);
  const nbRessources = dbStore.countRessourcesByProfesseur(user.idUtilisateur);
  const dernieresRessources = dbStore.findRessourcesByProfesseur(user.idUtilisateur).slice(0, 5);

  res.render('professeur/dashboard', {
    pageTitle: 'Tableau de bord Professeur',
    activeMenu: 'dashboard',
    modules,
    nbRessources,
    dernieresRessources,
  });
});

professeurRouter.get('/modules', (req, res) => {
  const user = req.session.utilisateur!;
  res.render('professeur/modules', {
    pageTitle: 'Mes modules',
    activeMenu: 'modules',
    modules: dbStore.findModulesByProfesseur(user.idUtilisateur),
  });
});

professeurRouter.get('/ressources', (req, res) => {
  const user = req.session.utilisateur!;
  const moduleFilter = String(req.query.module ?? '').trim();
  const ressources = moduleFilter
    ? dbStore.findRessourcesByModule(Number.parseInt(moduleFilter, 10), undefined, true)
    : dbStore.findRessourcesByProfesseur(user.idUtilisateur);

  res.render('professeur/resources-list', {
    pageTitle: 'Mes ressources',
    activeMenu: 'ressources',
    moduleFilter,
    ressources,
    modules: dbStore.findModulesByProfesseur(user.idUtilisateur),
  });
});

professeurRouter.get('/ressource/ajouter', (req, res) => {
  const user = req.session.utilisateur!;
  res.render('professeur/resource-upload', {
    pageTitle: 'Déposer une ressource',
    activeMenu: 'upload',
    modules: dbStore.findModulesByProfesseur(user.idUtilisateur),
    types: dbStore.findAllTypes(),
  });
});

professeurRouter.post('/ressource/ajouter', uploadDisk.single('fichier'), (req, res) => {
  const user = req.session.utilisateur!;
  if (!req.file || req.file.size === 0) {
    res.render('professeur/resource-upload', {
      pageTitle: 'Déposer une ressource',
      activeMenu: 'upload',
      msgError: 'Veuillez sélectionner un fichier',
      modules: dbStore.findModulesByProfesseur(user.idUtilisateur),
      types: dbStore.findAllTypes(),
    });
    return;
  }

  const titre = String(req.body.titre ?? '').trim();
  const description = String(req.body.description ?? '') || null;
  const moduleId = Number.parseInt(String(req.body.moduleId || req.body.idModule || '0'), 10);
  const typeId = Number.parseInt(String(req.body.typeId || req.body.idType || '1'), 10);

  if (!titre || !moduleId) {
    removeUploadedFile(toPublicUploadPath(req.file));
    res.render('professeur/resource-upload', {
      pageTitle: 'Déposer une ressource',
      activeMenu: 'upload',
      msgError: 'Le titre et le module sont obligatoires',
      modules: dbStore.findModulesByProfesseur(user.idUtilisateur),
      types: dbStore.findAllTypes(),
    });
    return;
  }

  dbStore.createRessource({
    titre,
    description,
    nomFichier: req.file.originalname,
    cheminFichier: toPublicUploadPath(req.file),
    tailleFichier: req.file.size,
    idProfesseur: user.idUtilisateur,
    idModule: moduleId,
    idType: typeId,
  });

  req.session.msgSuccess = 'Ressource déposée avec succès';
  res.redirect('/professeur/ressources');
});

professeurRouter.get('/ressource/modifier', (req, res) => {
  const user = req.session.utilisateur!;
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const r = Number.isNaN(id) ? null : dbStore.findRessourceById(id);

  if (!r || r.idProfesseur !== user.idUtilisateur) {
    res.status(403).render('error/403');
    return;
  }

  res.render('professeur/ressource-edit', {
    pageTitle: 'Modifier ressource',
    activeMenu: 'ressources',
    ressource: r,
    modules: dbStore.findModulesByProfesseur(user.idUtilisateur),
    types: dbStore.findAllTypes(),
  });
});

professeurRouter.post('/ressource/modifier', (req, res) => {
  const user = req.session.utilisateur!;
  const id = Number.parseInt(String(req.body.id ?? ''), 10);
  const r = Number.isNaN(id) ? null : dbStore.findRessourceById(id);

  if (!r || r.idProfesseur !== user.idUtilisateur) {
    res.status(403).render('error/403');
    return;
  }

  const titre = String(req.body.titre ?? '').trim();
  const description = String(req.body.description ?? '') || null;
  const visible = req.body.visible === 'true' || req.body.visible === 'on';
  const idModule = Number.parseInt(String(req.body.moduleId || req.body.idModule || r.idModule), 10);
  const idType = Number.parseInt(String(req.body.typeId || req.body.idType || r.idType), 10);

  dbStore.updateRessource(id, { titre, description, visible, idModule, idType });
  req.session.msgSuccess = 'Ressource modifiée avec succès';
  res.redirect('/professeur/ressources');
});

professeurRouter.get('/ressource/supprimer', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  if (!Number.isNaN(id)) {
    const existing = dbStore.findRessourceById(id);
    if (existing) removeUploadedFile(existing.cheminFichier);
    dbStore.deleteRessource(id);
  }
  req.session.msgSuccess = 'Ressource supprimée avec succès';
  res.redirect('/professeur/ressources');
});

professeurRouter.get('/statistiques', (req, res) => {
  const user = req.session.utilisateur!;
  res.render('professeur/statistiques', {
    pageTitle: 'Mes statistiques',
    activeMenu: 'statistiques',
    nbRessources: dbStore.countRessourcesByProfesseur(user.idUtilisateur),
    modules: dbStore.findModulesByProfesseur(user.idUtilisateur),
  });
});

professeurRouter.get('/soumissions', (req, res) => {
  const user = req.session.utilisateur!;
  const moduleFilter = String(req.query.module ?? '').trim();
  let soumissions = dbStore.findSoumissionsByProfesseur(user.idUtilisateur);
  if (moduleFilter) {
    soumissions = soumissions.filter((s) => String(s.idModule) === moduleFilter);
  }

  res.render('professeur/soumissions', {
    pageTitle: 'Soumissions des étudiants',
    activeMenu: 'soumissions',
    moduleFilter,
    soumissions,
    modules: dbStore.findModulesByProfesseur(user.idUtilisateur),
  });
});

professeurRouter.get('/soumission/voir', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const s = Number.isNaN(id) ? null : dbStore.findSoumissionById(id);
  if (!s) {
    res.status(404).render('error/404');
    return;
  }
  res.render('professeur/soumission-detail', {
    pageTitle: 'Détail soumission',
    activeMenu: 'soumissions',
    soumission: s,
  });
});

professeurRouter.post('/soumission/evaluer', (req, res) => {
  const id = Number.parseInt(String(req.body.id ?? ''), 10);
  const statut = String(req.body.statut ?? 'EN_ATTENTE') as 'EN_ATTENTE' | 'ACCEPTE' | 'REFUSE';
  const noteRaw = String(req.body.note ?? '').trim();
  const commentaire = String(req.body.commentaire ?? '').trim() || null;

  let note: number | null = null;
  if (noteRaw !== '') {
    const parsed = Number.parseFloat(noteRaw);
    if (Number.isNaN(parsed) || parsed < 0 || parsed > 20) {
      req.session.msgError = 'Note invalide (doit être comprise entre 0 et 20)';
      res.redirect('/professeur/soumissions');
      return;
    }
    note = parsed;
  }

  const updated = dbStore.evaluerSoumission(id, statut, note, commentaire);
  if (updated) {
    req.session.msgSuccess = 'Soumission évaluée avec succès';
  } else {
    req.session.msgError = 'Soumission introuvable';
  }
  res.redirect('/professeur/soumissions');
});

professeurRouter.get('/soumission/telecharger', (req, res) => {
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

professeurRouter.get('/devoirs', (req, res) => {
  const user = req.session.utilisateur!;
  res.render('professeur/devoirs-list', {
    pageTitle: 'Devoirs',
    activeMenu: 'devoirs',
    devoirs: dbStore.findDevoirsByProfesseur(user.idUtilisateur),
  });
});

professeurRouter.get('/devoir/ajouter', (req, res) => {
  const user = req.session.utilisateur!;
  res.render('professeur/devoir-form', {
    pageTitle: 'Nouveau devoir',
    activeMenu: 'devoirs',
    modules: dbStore.findModulesByProfesseur(user.idUtilisateur),
  });
});

professeurRouter.post('/devoir/ajouter', uploadDisk.single('fichier'), (req, res) => {
  const user = req.session.utilisateur!;
  const titre = String(req.body.titre ?? '').trim();
  const description = String(req.body.description ?? '') || null;
  const dateLimiteRaw = String(req.body.dateLimite ?? '').trim();
  const idModule = Number.parseInt(String(req.body.idModule ?? '0'), 10);

  if (!titre || !idModule) {
    if (req.file) removeUploadedFile(toPublicUploadPath(req.file));
    res.render('professeur/devoir-form', {
      pageTitle: 'Nouveau devoir',
      activeMenu: 'devoirs',
      msgError: 'Le titre et le module sont obligatoires',
      modules: dbStore.findModulesByProfesseur(user.idUtilisateur),
    });
    return;
  }

  const dateLimite = dateLimiteRaw ? dateLimiteRaw.replace('T', ' ') : null;
  dbStore.createDevoir({
    titre,
    description,
    dateLimite,
    nomFichier: req.file ? req.file.originalname : null,
    cheminFichier: req.file ? toPublicUploadPath(req.file) : null,
    tailleFichier: req.file ? req.file.size : 0,
    idModule,
    idProfesseur: user.idUtilisateur,
  });

  req.session.msgSuccess = 'Devoir créé avec succès';
  res.redirect('/professeur/devoirs');
});

professeurRouter.get('/devoir/voir', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  const devoir = Number.isNaN(id) ? null : dbStore.findDevoirById(id);
  if (!devoir) {
    res.status(404).render('error/404');
    return;
  }
  res.render('professeur/devoir-detail', {
    pageTitle: devoir.titre,
    activeMenu: 'devoirs',
    devoir,
    soumissions: dbStore.findSoumissionsByDevoir(id),
  });
});

professeurRouter.get('/devoir/supprimer', (req, res) => {
  const id = Number.parseInt(String(req.query.id ?? ''), 10);
  if (!Number.isNaN(id)) {
    const existing = dbStore.findDevoirById(id);
    if (existing?.cheminFichier) removeUploadedFile(existing.cheminFichier);
    dbStore.deleteDevoir(id);
  }
  req.session.msgSuccess = 'Devoir supprimé avec succès';
  res.redirect('/professeur/devoirs');
});
