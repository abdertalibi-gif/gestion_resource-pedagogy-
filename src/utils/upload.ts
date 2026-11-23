import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import multer from 'multer';

export const PUBLIC_DIR = path.resolve(process.cwd(), 'public');
export const UPLOADS_ROOT = path.join(PUBLIC_DIR, 'assets', 'uploads');

function getSubfolderForExt(ext: string): string {
  const lower = ext.toLowerCase();
  if (lower === '.pdf') return 'pdf';
  if (['.png', '.jpg', '.jpeg', '.gif', '.webp', '.svg'].includes(lower)) return 'images';
  if (['.mp4', '.webm', '.avi', '.mkv', '.mov'].includes(lower)) return 'videos';
  return 'documents';
}

const diskStorage = multer.diskStorage({
  destination: (_req, file, cb) => {
    const ext = path.extname(file.originalname);
    const sub = getSubfolderForExt(ext);
    const destDir = path.join(UPLOADS_ROOT, sub);
    fs.mkdirSync(destDir, { recursive: true });
    cb(null, destDir);
  },
  filename: (_req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    const id = crypto.randomBytes(16).toString('hex');
    cb(null, `${id}${ext}`);
  },
});

export const uploadDisk = multer({
  storage: diskStorage,
  limits: { fileSize: 50 * 1024 * 1024 },
});

export const uploadMemory = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 20 * 1024 * 1024 },
});

export function toPublicUploadPath(file: Express.Multer.File): string {
  const ext = path.extname(file.originalname);
  const sub = getSubfolderForExt(ext);
  return `/assets/uploads/${sub}/${file.filename}`;
}

export function resolvePublicFile(relativePath: string): string {
  const clean = relativePath.replace(/^\/+/, '');
  return path.join(PUBLIC_DIR, clean);
}

export function removeUploadedFile(relativePath: string | null | undefined): void {
  if (!relativePath) return;
  try {
    const full = resolvePublicFile(relativePath);
    if (fs.existsSync(full)) {
      fs.unlinkSync(full);
    }
  } catch {
    // Ignore file deletion errors
  }
}
