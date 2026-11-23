import type { NextFunction, Request, Response } from 'express';
import 'express-session';
import type { EnrichedUtilisateur } from '../types/session.js';

declare module 'express-session' {
  interface SessionData {
    utilisateur?: EnrichedUtilisateur;
    role?: string;
    msgSuccess?: string;
    msgError?: string;
    errors?: string[];
  }
}

export function attachLocals(req: Request, res: Response, next: NextFunction): void {
  const user = req.session?.utilisateur;
  res.locals.ctx = '';
  res.locals.utilisateur = user ?? null;
  res.locals.nomComplet = user ? user.nomComplet : '';
  res.locals.role = req.session?.role ?? (user ? user.role.nomRole : '');
  res.locals.activeMenu = '';
  res.locals.pageTitle = 'GesPed';

  // Consume flash messages on GET renders (or let explicit routes use them)
  res.locals.msgSuccess = req.session?.msgSuccess ?? null;
  res.locals.msgError = req.session?.msgError ?? null;
  res.locals.errors = req.session?.errors ?? null;
  if (req.session) {
    delete req.session.msgSuccess;
    delete req.session.msgError;
    delete req.session.errors;
  }

  next();
}

export function requireAuth(req: Request, res: Response, next: NextFunction): void {
  if (!req.session?.utilisateur) {
    res.redirect('/login');
    return;
  }
  next();
}

export function requireRole(expectedRole: 'ADMIN' | 'PROFESSEUR' | 'ETUDIANT') {
  return (req: Request, res: Response, next: NextFunction): void => {
    const user = req.session?.utilisateur;
    if (!user) {
      res.redirect('/login');
      return;
    }
    const actualRole = (req.session.role || user.role?.nomRole || '').toUpperCase();
    if (actualRole !== expectedRole) {
      res.status(403).render('error/403');
      return;
    }
    res.locals.role = expectedRole;
    res.locals.nomComplet = user.nomComplet;
    next();
  };
}
