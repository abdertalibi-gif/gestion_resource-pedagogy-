-- Migration: Changement du champ statut de boolean à VARCHAR pour le système d'inscription
-- Avant d'exécuter ce script, les données existantes avec statut=1 (actif) seront migrées vers 'ACCEPTE'

ALTER TABLE utilisateurs MODIFY statut VARCHAR(20) NOT NULL DEFAULT 'EN_ATTENTE';

-- Migrer les comptes existants : ceux qui étaient actifs (true) deviennent ACCEPTE
UPDATE utilisateurs SET statut = 'ACCEPTE' WHERE statut = '1' OR statut = 'true';

-- Migrer les comptes inactifs (false) vers REFUSE
UPDATE utilisateurs SET statut = 'REFUSE' WHERE statut = '0' OR statut = 'false';

-- Par défaut, les nouveaux comptes créés via l'interface admin seront ACCEPTE
-- Les comptes créés via le formulaire d'inscription public seront EN_ATTENTE
