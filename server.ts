import path from 'node:path';
import express, { type NextFunction, type Request, type Response } from 'express';
import session from 'express-session';
import { ensureSeededFiles } from './src/data/store.js';
import { attachLocals } from './src/middleware/auth.js';
import { adminRouter } from './src/routes/admin.js';
import { etudiantRouter } from './src/routes/etudiant.js';
import { professeurRouter } from './src/routes/professeur.js';
import { publicRouter } from './src/routes/public.js';
import { PUBLIC_DIR } from './src/utils/upload.js';

const app = express();
const PORT = Number(process.env.PORT) || 3000;
const VIEWS_DIR = path.resolve(process.cwd(), 'views');

// Seed sample downloadable/viewable asset files referenced in initial store
ensureSeededFiles(PUBLIC_DIR);

app.set('view engine', 'ejs');
app.set('views', VIEWS_DIR);
app.set('trust proxy', 1);

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(PUBLIC_DIR));

app.use(
  session({
    secret: process.env.SESSION_SECRET || 'gesped-dev-session-secret-change-me',
    resave: false,
    saveUninitialized: false,
    cookie: {
      httpOnly: true,
      sameSite: 'lax',
      maxAge: 24 * 60 * 60 * 1000,
    },
  })
);

app.use(attachLocals);

app.use('/', publicRouter);
app.use('/admin', adminRouter);
app.use('/professeur', professeurRouter);
app.use('/etudiant', etudiantRouter);

// 404 handler
app.use((_req, res) => {
  res.status(404).render('error/404');
});

// 500 error handler
app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
  console.error('Server error:', err);
  res.status(500).render('error/500', { errorMessage: err?.message || 'Erreur interne du serveur' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`GesPed server listening on http://0.0.0.0:${PORT}`);
});
