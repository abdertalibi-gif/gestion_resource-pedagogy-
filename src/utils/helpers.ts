import crypto from 'node:crypto';

export function hashPassword(password: string, salt?: Buffer): string {
  const actualSalt = salt ?? crypto.randomBytes(16);
  const hash = crypto.createHash('sha256').update(actualSalt).update(password, 'utf8').digest();
  return Buffer.concat([actualSalt, hash]).toString('base64');
}

export function verifyPassword(password: string, storedHash: string): boolean {
  if (!password || !storedHash) return false;
  try {
    const combined = Buffer.from(storedHash, 'base64');
    if (combined.length >= 16) {
      const salt = combined.subarray(0, 16);
      const computed = hashPassword(password, salt);
      if (computed === storedHash) {
        return true;
      }
    }
  } catch {
    // Fallback to direct comparison below
  }
  return password === storedHash;
}

export function formatFileSize(bytes: number): string {
  if (!bytes || bytes < 1024) return `${bytes || 0} o`;
  if (bytes < 1048576) return `${(bytes / 1024).toFixed(1).replace('.', ',')} Ko`;
  return `${(bytes / 1048576).toFixed(1).replace('.', ',')} Mo`;
}

export function getTypeIcon(nomType?: string | null): string {
  switch (nomType) {
    case 'PDF': return 'fa-file-pdf';
    case 'VIDEO': return 'fa-file-video';
    case 'TD': return 'fa-file-alt';
    case 'TP': return 'fa-file-code';
    case 'PPT': return 'fa-file-powerpoint';
    case 'Excel': return 'fa-file-excel';
    case 'ZIP': return 'fa-file-archive';
    default: return 'fa-file';
  }
}

export function getTypeColor(nomType?: string | null): string {
  switch (nomType) {
    case 'PDF': return '#e74c3c';
    case 'VIDEO': return '#9b59b6';
    case 'TD': return '#3498db';
    case 'TP': return '#2ecc71';
    case 'PPT': return '#f39c12';
    case 'Excel': return '#16a34a';
    case 'ZIP': return '#64748b';
    default: return '#6c757d';
  }
}

export function getStatutLabel(statut?: string | null): string {
  switch (statut) {
    case 'EN_ATTENTE': return 'En attente';
    case 'ACCEPTE': return 'Accepté';
    case 'REFUSE': return 'Refusé';
    default: return statut || 'Inconnu';
  }
}

export function getStatutBadge(statut?: string | null): string {
  switch (statut) {
    case 'EN_ATTENTE': return 'badge-warning';
    case 'ACCEPTE': return 'badge-success';
    case 'REFUSE': return 'badge-danger';
    default: return 'badge-secondary';
  }
}

export function tempsEcoule(isoDate?: string | null): string {
  if (!isoDate) return '';
  const dt = new Date(isoDate.replace(' ', 'T'));
  if (Number.isNaN(dt.getTime())) return isoDate;
  const diffMs = Date.now() - dt.getTime();
  const minutes = Math.floor(diffMs / 60000);
  if (minutes < 1) return "A l'instant";
  if (minutes < 60) return `Il y a ${minutes} min`;
  const heures = Math.floor(minutes / 60);
  if (heures < 24) return `Il y a ${heures}h`;
  const jours = Math.floor(heures / 24);
  if (jours < 30) return `Il y a ${jours}j`;
  const mois = Math.floor(jours / 30);
  if (mois < 12) return `Il y a ${mois} mois`;
  return `Il y a ${Math.floor(mois / 12)} ans`;
}

export function splitDateTimeParts(dtStr?: string | null): { date: string; time: string } {
  if (!dtStr) return { date: '', time: '' };
  const normalized = dtStr.replace('T', ' ');
  const [datePart, timePart] = normalized.split(' ');
  return {
    date: datePart || '',
    time: timePart ? timePart.slice(0, 8) : '',
  };
}

const EMAIL_REGEX = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

export function validerUtilisateur(params: {
  nom?: string;
  prenom?: string;
  email?: string;
  motDePasse?: string | null;
  cne?: string | null;
  role?: string;
}): string[] {
  const erreurs: string[] = [];
  const nom = (params.nom ?? '').trim();
  const prenom = (params.prenom ?? '').trim();
  const email = (params.email ?? '').trim();

  if (!nom) erreurs.push('Le nom est obligatoire');
  else if (nom.length < 2) erreurs.push('Le nom doit contenir au moins 2 caracteres');

  if (!prenom) erreurs.push('Le prenom est obligatoire');

  if (!email) erreurs.push("L'email est obligatoire");
  else if (!EMAIL_REGEX.test(email)) erreurs.push("Format d'email invalide");

  if (params.motDePasse !== null && params.motDePasse !== undefined) {
    if (!params.motDePasse) erreurs.push('Le mot de passe est obligatoire');
    else if (params.motDePasse.length < 6) erreurs.push('Le mot de passe doit contenir au moins 6 caracteres');
  }

  if (params.role === 'ETUDIANT') {
    const cne = (params.cne ?? '').trim();
    if (!cne) {
      erreurs.push("Le CNE est obligatoire pour l'inscription. Veuillez le saisir avant de continuer.");
    } else if (cne.length < 8 || cne.length > 20) {
      erreurs.push('Le CNE doit contenir entre 8 et 20 caracteres');
    }
  }

  return erreurs;
}

export function validerModule(nom?: string, code?: string): string[] {
  const erreurs: string[] = [];
  if (!nom || !nom.trim()) erreurs.push('Le nom du module est obligatoire');
  if (!code || !code.trim()) erreurs.push('Le code du module est obligatoire');
  return erreurs;
}
