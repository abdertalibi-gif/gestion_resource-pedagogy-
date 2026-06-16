package Services;

import java.util.List;

import dao.DAOFactory;
import dao.UtilisateurDAO;
import models.Utilisateur;
import utils.Constants;
import utils.PasswordUtil;
import utils.ValidationUtil;

public class UtilisateurService {

    private final UtilisateurDAO utilisateurDAO;

    public UtilisateurService() {
        this.utilisateurDAO = DAOFactory.getUtilisateurDAO();
    }

    public Utilisateur findById(int id) {
        return utilisateurDAO.findById(id);
    }

    public Utilisateur findByEmail(String email) {
        return utilisateurDAO.findByEmail(email);
    }

    public List<Utilisateur> findAll() {
        return utilisateurDAO.findAll();
    }

    public List<Utilisateur> findByRole(String role) {
        return utilisateurDAO.findByRole(role);
    }

    public List<Utilisateur> findByStatut(String statut) {
        return utilisateurDAO.findByStatut(statut);
    }

    /**
     * Cree un nouvel utilisateur avec validation et hachage du mot de passe.
     * Utilise par l'admin - le compte est directement actif (ACCEPTE).
     */
    public ServiceResult<Utilisateur> create(Utilisateur u) {
        String role = u.getRole() != null ? u.getRole().getNomRole() : null;
        List<String> erreurs = ValidationUtil.validerUtilisateur(
            u.getNom(), u.getPrenom(), u.getEmail(), u.getMotDePasse(), u.getCne(), role
        );
        if (!erreurs.isEmpty()) {
            return ServiceResult.failure(erreurs);
        }

        // Verifier si l'email existe deja
        if (utilisateurDAO.findByEmail(u.getEmail()) != null) {
            return ServiceResult.failure("Cet email est deja utilise");
        }

        // Hasher le mot de passe
        u.setMotDePasse(PasswordUtil.hash(u.getMotDePasse()));
        u.setStatut(Constants.STATUT_ACCEPTE);

        int id = utilisateurDAO.insert(u);
        if (id > 0) {
            u.setIdUtilisateur(id);
            return ServiceResult.success(u, "Utilisateur cree avec succes");
        }
        return ServiceResult.failure("Erreur lors de la creation de l'utilisateur");
    }

    /**
     * Importe des utilisateurs (etudiants ou professeurs) depuis un fichier Excel.
     * @param role "ETUDIANT" ou "PROFESSEUR"
     * Colonnes ETUDIANT : Nom, Prenom, Email, MotDePasse, Filiere, Niveau, CNE, Telephone
     * Colonnes PROFESSEUR : Nom, Prenom, Email, MotDePasse, Telephone
     */
    public ServiceResult<String> importFromExcel(java.io.InputStream inputStream, String role) {
        List<String> rapport = new java.util.ArrayList<>();
        int success = 0, errors = 0, doublons = 0;
        boolean isEtudiant = Constants.ROLE_ETUDIANT.equals(role);

        // Cache filieres/semestres pour etudiants
        java.util.Map<String, Integer> filiereCache = null;
        java.util.Map<String, Integer> semestreCache = null;
        if (isEtudiant) {
            filiereCache = new java.util.HashMap<>();
            semestreCache = new java.util.HashMap<>();
            var filiereDAO = dao.DAOFactory.getFiliereDAO();
            for (var f : filiereDAO.findAll()) filiereCache.put(f.getNomFiliere().toLowerCase().trim(), f.getIdFiliere());
            var semestreDAO = dao.DAOFactory.getSemestreDAO();
            for (var s : semestreDAO.findAll()) semestreCache.put(s.getNomSemestre().toLowerCase().trim(), s.getIdSemestre());
        }

        try (var workbook = org.apache.poi.ss.usermodel.WorkbookFactory.create(inputStream)) {
            var sheet = workbook.getSheetAt(0);
            var rowIter = sheet.iterator();

            if (!rowIter.hasNext()) return ServiceResult.failure("Le fichier Excel est vide");

            rowIter.next(); // sauter en-tete

            while (rowIter.hasNext()) {
                var row = rowIter.next();
                try {
                    String nom = getCellString(row, 0);
                    String prenom = getCellString(row, 1);
                    String email = getCellString(row, 2);
                    String motDePasse = getCellString(row, 3);

                    if (nom.isEmpty() || prenom.isEmpty() || email.isEmpty() || motDePasse.isEmpty()) {
                        errors++;
                        rapport.add("Ligne " + (row.getRowNum() + 1) + " : champs obligatoires manquants");
                        continue;
                    }

                    if (utilisateurDAO.findByEmail(email) != null) {
                        doublons++;
                        rapport.add("Ligne " + (row.getRowNum() + 1) + " : email '" + email + "' existe deja");
                        continue;
                    }

                    Utilisateur u = new Utilisateur();
                    u.setNom(nom);
                    u.setPrenom(prenom);
                    u.setEmail(email);
                    u.setMotDePasse(PasswordUtil.hash(motDePasse));
                    u.setStatut(Constants.STATUT_ACCEPTE);

                    models.Role r = new models.Role();
                    r.setNomRole(role);
                    u.setRole(r);

                    if (isEtudiant) {
                        String filiereNom = getCellString(row, 4);
                        String niveau = getCellString(row, 5);
                        String cne = getCellString(row, 6);
                        String telephone = getCellString(row, 7);

                        u.setCne(cne.isEmpty() ? null : cne);
                        u.setTelephone(telephone.isEmpty() ? null : telephone);

                        if (!filiereNom.isEmpty()) {
                            Integer idF = filiereCache.get(filiereNom.toLowerCase().trim());
                            if (idF != null) {
                                models.Filiere f = new models.Filiere();
                                f.setIdFiliere(idF);
                                u.setFiliere(f);
                            } else {
                                errors++;
                                rapport.add("Ligne " + (row.getRowNum() + 1) + " : filiere '" + filiereNom + "' introuvable");
                                continue;
                            }
                        }
                        if (!niveau.isEmpty()) {
                            Integer idS = semestreCache.get(niveau.toLowerCase().trim());
                            if (idS != null) {
                                models.Semestre s = new models.Semestre();
                                s.setIdSemestre(idS);
                                u.setSemestre(s);
                            } else {
                                errors++;
                                rapport.add("Ligne " + (row.getRowNum() + 1) + " : niveau/semestre '" + niveau + "' introuvable");
                                continue;
                            }
                        }
                    } else {
                        u.setTelephone(getCellString(row, 4));
                    }

                    int id = utilisateurDAO.insert(u);
                    if (id > 0) success++;
                    else { errors++; rapport.add("Ligne " + (row.getRowNum() + 1) + " : erreur lors de l'insertion"); }
                } catch (Exception e) {
                    errors++;
                    rapport.add("Ligne " + (row.getRowNum() + 1) + " : " + e.getMessage());
                }
            }
        } catch (Exception e) {
            return ServiceResult.failure("Erreur de lecture du fichier Excel : " + e.getMessage());
        }

        String label = isEtudiant ? "etudiant(s)" : "professeur(s)";
        StringBuilder msg = new StringBuilder();
        msg.append(success).append(" ").append(label).append(" importe(s) avec succes.");
        if (doublons > 0) msg.append(" ").append(doublons).append(" doublon(s) ignore(s).");
        if (!rapport.isEmpty()) {
            rapport.add(0, msg.toString());
            return ServiceResult.failure(rapport);
        }
        return ServiceResult.success(null, msg.toString());
    }

    private String getCellString(org.apache.poi.ss.usermodel.Row row, int idx) {
        var cell = row.getCell(idx);
        if (cell == null) return "";
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue().trim();
            case NUMERIC -> {
                double v = cell.getNumericCellValue();
                yield (v == Math.floor(v) && !Double.isInfinite(v)) ? String.valueOf((long) v) : String.valueOf(v);
            }
            case BOOLEAN -> String.valueOf(cell.getBooleanCellValue());
            default -> "";
        };
    }

    public ServiceResult<Utilisateur> update(Utilisateur u) {
        String role = u.getRole() != null ? u.getRole().getNomRole() : null;
        List<String> erreurs = ValidationUtil.validerUtilisateur(
            u.getNom(), u.getPrenom(), u.getEmail(), null, u.getCne(), role
        );
        if (!erreurs.isEmpty()) {
            return ServiceResult.failure(erreurs);
        }

        if (utilisateurDAO.update(u)) {
            return ServiceResult.success(u, "Utilisateur modifie avec succes");
        }
        return ServiceResult.failure("Erreur lors de la modification");
    }

    public boolean updateStatut(int id, String nouveauStatut) {
        return utilisateurDAO.updateStatut(id, nouveauStatut);
    }

    public boolean toggleStatut(int id) {
        Utilisateur u = utilisateurDAO.findById(id);
        if (u == null) return false;
        String nouveau = Constants.STATUT_ACCEPTE.equals(u.getStatut())
            ? Constants.STATUT_REFUSE : Constants.STATUT_ACCEPTE;
        return utilisateurDAO.updateStatut(id, nouveau);
    }

    public boolean delete(int id) {
        return utilisateurDAO.delete(id);
    }

    public int countByRole(String role) {
        return utilisateurDAO.countByRole(role);
    }

    public int countAll() {
        return utilisateurDAO.countAll();
    }
}