import { Router } from 'express';
import { dbStore } from '../data/store.js';

export const publicRouter = Router();

function redirectByRole(roleName: string): string {
  switch (roleName.toUpperCase()) {
    case 'ADMIN':
      return '/admin/dashboard';
    case 'PROFESSEUR':
      return '/professeur/dashboard';
    case 'ETUDIANT':
      return '/etudiant/dashboard';
    default:
      return '/login';
  }
}

publicRouter.get('/', (_req, res) => {
  res.render('index', {
    nbEtudiants: dbStore.countUsersByRole('ETUDIANT'),
    nbProfs: dbStore.countUsersByRole('PROFESSEUR'),
    nbModules: dbStore.countModules(),
    nbRessources: dbStore.countRessources(),
    dernieresRessources: dbStore.findLast5Ressources(),
  });
});

publicRouter.get('/login', (req, res) => {
  if (req.session?.utilisateur) {
    res.redirect(redirectByRole(req.session.utilisateur.role.nomRole));
    return;
  }
  res.render('login', {
    error: null,
    email: '',
    logout: req.query.logout !== undefined,
    resetSuccess: req.query.reset === 'success',
  });
});

publicRouter.post('/login', (req, res) => {
  const email = String(req.body.email ?? '');
  const password = String(req.body.password ?? '');

  const result = dbStore.authenticateWithStatus(email, password);
  if (result.status === 'OK' && result.user) {
    req.session.utilisateur = result.user;
    req.session.role = result.user.role.nomRole;
    req.session.msgSuccess = `Bienvenue, ${result.user.nomComplet} !`;
    res.redirect(redirectByRole(result.user.role.nomRole));
    return;
  }

  if (result.status === 'INACTIF') {
    res.render('login', {
      error: "Votre compte est désactivé. Veuillez contacter l'administrateur.",
      email,
      logout: false,
      resetSuccess: false,
    });
    return;
  }

  res.render('login', {
    error: 'Email ou mot de passe incorrect',
    email,
    logout: false,
    resetSuccess: false,
  });
});

publicRouter.get('/logout', (req, res) => {
  req.session.destroy(() => {
    res.redirect('/login?logout=1');
  });
});

publicRouter.get('/forgot-password', (req, res) => {
  res.render('auth/forgot-password', {
    error: req.query.error !== undefined
      ? req.query.error === 'expired'
        ? 'Lien expiré ou invalide. Veuillez réessayer.'
        : 'Veuillez vérifier vos informations.'
      : null,
    verified: false,
    userId: null,
    userName: null,
  });
});

publicRouter.post('/forgot-password', (req, res) => {
  const action = String(req.body.action ?? '');

  if (action === 'reset') {
    const userIdStr = String(req.body.userId ?? '');
    const password = String(req.body.password ?? '');
    const confirm = String(req.body.confirm ?? '');

    if (!userIdStr || !password || !confirm) {
      res.render('auth/forgot-password', {
        error: 'Données invalides.',
        verified: false,
        userId: null,
        userName: null,
      });
      return;
    }

    if (password.length < 6) {
      res.render('auth/forgot-password', {
        error: 'Le mot de passe doit contenir au moins 6 caractères.',
        verified: true,
        userId: userIdStr,
        userName: req.body.userName || null,
      });
      return;
    }

    if (password !== confirm) {
      res.render('auth/forgot-password', {
        error: 'Les mots de passe ne correspondent pas.',
        verified: true,
        userId: userIdStr,
        userName: req.body.userName || null,
      });
      return;
    }

    const userId = Number.parseInt(userIdStr, 10);
    if (Number.isNaN(userId) || !dbStore.updatePassword(userId, password)) {
      res.render('auth/forgot-password', {
        error: 'Erreur lors de la mise à jour.',
        verified: true,
        userId: userIdStr,
        userName: req.body.userName || null,
      });
      return;
    }

    res.redirect('/login?reset=success');
    return;
  }

  const email = String(req.body.email ?? '').trim();
  const nom = String(req.body.nom ?? '').trim();
  const prenom = String(req.body.prenom ?? '').trim();
  const cne = String(req.body.cne ?? '').trim();

  if (!email || !nom || !prenom) {
    res.render('auth/forgot-password', {
      error: 'Veuillez remplir tous les champs d’identification.',
      verified: false,
      userId: null,
      userName: null,
    });
    return;
  }

  const user = dbStore.verifyIdentity(email, nom, prenom, cne);
  if (!user) {
    res.render('auth/forgot-password', {
      error: 'Aucun compte ne correspond à ces informations.',
      verified: false,
      userId: null,
      userName: null,
    });
    return;
  }

  res.render('auth/forgot-password', {
    error: null,
    verified: true,
    userId: user.idUtilisateur,
    userName: user.nomComplet,
  });
});

publicRouter.get('/reset-password', (req, res) => {
  const token = String(req.query.token ?? '').trim();
  if (!token) {
    res.redirect('/forgot-password?error');
    return;
  }

  const rt = dbStore.findResetToken(token);
  if (!rt || !rt.valide) {
    res.redirect('/forgot-password?error=expired');
    return;
  }

  res.render('reset-password', {
    token,
    errorField: null,
  });
});

publicRouter.post('/reset-password', (req, res) => {
  const token = String(req.body.token ?? '').trim();
  const newPassword = String(req.body.newPassword ?? '');
  const confirmPassword = String(req.body.confirmPassword ?? '');

  if (!token) {
    res.redirect('/forgot-password?error');
    return;
  }

  if (newPassword.length < 6) {
    res.render('reset-password', {
      token,
      errorField: 'Le mot de passe doit contenir au moins 6 caractères.',
    });
    return;
  }

  if (newPassword !== confirmPassword) {
    res.render('reset-password', {
      token,
      errorField: 'Les mots de passe ne sont pas identiques.',
    });
    return;
  }

  const rt = dbStore.findResetToken(token);
  if (!rt || !rt.valide) {
    res.redirect('/forgot-password?error=expired');
    return;
  }

  dbStore.updatePassword(rt.utilisateurId, newPassword);
  dbStore.markTokenUsed(token);
  res.redirect('/login?reset=success');
});
