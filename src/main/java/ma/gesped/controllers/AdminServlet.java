package ma.gesped.controllers;

import java.io.IOException;
import java.util.List;

import Services.AffectationService;
import Services.FiliereService;
import Services.ModuleService;
import Services.RessourceService;
import Services.SemestreService;
import Services.ServiceResult;
import Services.TypeRessourceService;
import Services.UtilisateurService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.AffectationModule;
import models.Filiere;
import models.Module;
import models.Ressource;
import models.Role;
import models.Semestre;
import models.Utilisateur;
import utils.Constants;

@WebServlet("/admin/*")
@MultipartConfig(maxFileSize = 52428800, maxRequestSize = 52428800)
public class AdminServlet extends HttpServlet {

    private final UtilisateurService utilisateurService = new UtilisateurService();
    private final ModuleService moduleService = new ModuleService();
    private final RessourceService ressourceService = new RessourceService();
    private final FiliereService filiereService = new FiliereService();
    private final SemestreService semestreService = new SemestreService();
    private final AffectationService affectationService = new AffectationService();
    private final TypeRessourceService typeRessourceService = new TypeRessourceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/dashboard";

        switch (path) {
            case "/dashboard" -> showDashboard(req, resp);
            case "/etudiants" -> showEtudiants(req, resp);
            case "/etudiants/ajouter" -> resp.sendRedirect(req.getContextPath() + "/admin/utilisateur/ajouter?role=ETUDIANT");
            case "/etudiants/edit" -> resp.sendRedirect(req.getContextPath() + "/admin/utilisateur/modifier?id=" + req.getParameter("id"));
            case "/professeurs" -> showProfesseurs(req, resp);
            case "/professeurs/ajouter" -> resp.sendRedirect(req.getContextPath() + "/admin/utilisateur/ajouter?role=PROFESSEUR");
            case "/professeurs/edit" -> resp.sendRedirect(req.getContextPath() + "/admin/utilisateur/modifier?id=" + req.getParameter("id"));
            case "/utilisateurs" -> showUtilisateurs(req, resp);
            case "/utilisateur/ajouter" -> showUtilisateurForm(req, resp, null);
            case "/utilisateur/modifier" -> showUtilisateurForm(req, resp, req.getParameter("id"));
            case "/utilisateur/supprimer" -> deleteUtilisateur(req, resp);
            case "/utilisateur/toggle" -> toggleUtilisateur(req, resp);
            case "/import" -> showImportReq(req, resp);
            case "/modules" -> showModules(req, resp);
            case "/module/ajouter" -> showModuleForm(req, resp, null);
            case "/module/modifier" -> showModuleForm(req, resp, req.getParameter("id"));
            case "/module/supprimer" -> deleteModule(req, resp);
            case "/filieres" -> showFilieres(req, resp);
            case "/filiere/ajouter" -> showFiliereForm(req, resp);
            case "/filiere/voir" -> showFiliereVoir(req, resp);
            case "/filiere/modifier" -> showFiliereForm(req, resp);
            case "/filiere/supprimer" -> deleteFiliere(req, resp);
            case "/semestres" -> showSemestres(req, resp);
            case "/semestre/ajouter" -> showSemestreForm(req, resp);
            case "/semestre/modifier" -> showSemestreForm(req, resp);
            case "/semestre/supprimer" -> deleteSemestre(req, resp);
            case "/affectations" -> showAffectations(req, resp);
            case "/affectation/ajouter" -> showAffectationForm(req, resp);
            case "/affectation/supprimer" -> deleteAffectation(req, resp);
            case "/ressources" -> showRessources(req, resp);
            case "/ressource/supprimer" -> deleteRessource(req, resp);
            case "/statistiques" -> showStatistiques(req, resp);
            default -> resp.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/dashboard";

        switch (path) {
            case "/utilisateur/ajouter" -> createUtilisateur(req, resp);
            case "/utilisateur/modifier" -> updateUtilisateur(req, resp);
            case "/module/ajouter" -> createModule(req, resp);
            case "/module/modifier" -> updateModule(req, resp);
            case "/filiere/ajouter" -> createFiliere(req, resp);
            case "/filiere/modifier" -> updateFiliere(req, resp);
            case "/semestre/ajouter" -> createSemestre(req, resp);
            case "/semestre/modifier" -> updateSemestre(req, resp);
            case "/affectation/ajouter" -> createAffectation(req, resp);
            case "/import" -> importExcel(req, resp);
            default -> resp.sendError(404);
        }
    }
    
    // ========================================================
    // ETUDIANTS / PROFESSEURS (listes admin)
    // ========================================================
    private void showEtudiants(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur admin = (Utilisateur) req.getSession().getAttribute(Constants.SESSION_USER);
        req.setAttribute("etudiants", utilisateurService.findByRole(Constants.ROLE_ETUDIANT));
        req.setAttribute("filieres", filiereService.findAll());
        req.setAttribute("pageTitle", "Étudiants");
        req.setAttribute("activeMenu", "etudiants");
        req.setAttribute("nomComplet", admin != null ? admin.getNomComplet() : "Admin");
        req.setAttribute("role", Constants.ROLE_ADMIN);
        forwardFlashMessages(req);
        req.getRequestDispatcher(Constants.VIEW_ADMIN_ETUDIANTS).forward(req, resp);
    }

    private void showProfesseurs(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur admin = (Utilisateur) req.getSession().getAttribute(Constants.SESSION_USER);
        req.setAttribute("professeurs", utilisateurService.findByRole(Constants.ROLE_PROFESSEUR));
        req.setAttribute("filieres", filiereService.findAll());
        req.setAttribute("pageTitle", "Professeurs");
        req.setAttribute("activeMenu", "professeurs");
        req.setAttribute("nomComplet", admin != null ? admin.getNomComplet() : "Admin");
        req.setAttribute("role", Constants.ROLE_ADMIN);
        forwardFlashMessages(req);
        req.getRequestDispatcher(Constants.VIEW_ADMIN_PROFESSEURS).forward(req, resp);
    }

    private void forwardFlashMessages(HttpServletRequest req) {
        var session = req.getSession();
        Object success = session.getAttribute(Constants.FLASH_SUCCESS);
        if (success != null) {
            req.setAttribute(Constants.FLASH_SUCCESS, success);
            session.removeAttribute(Constants.FLASH_SUCCESS);
        }
        Object error = session.getAttribute(Constants.FLASH_ERROR);
        if (error != null) {
            req.setAttribute(Constants.FLASH_ERROR, error);
            session.removeAttribute(Constants.FLASH_ERROR);
        }
    }

    // ========================================================
    // DASHBOARD
    // ========================================================
    private void showDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int nbAdmins = utilisateurService.countByRole("ADMIN");
        int nbProfs = utilisateurService.countByRole("PROFESSEUR");
        int nbEtudiants = utilisateurService.countByRole("ETUDIANT");
        int nbModules = moduleService.count();
        int nbRessources = ressourceService.count();
        int nbFilieres = filiereService.count();
        List<Ressource> dernieresRessources = ressourceService.findLast5();

        req.setAttribute("nbAdmins", nbAdmins);
        req.setAttribute("nbProfs", nbProfs);
        req.setAttribute("nbEtudiants", nbEtudiants);
        req.setAttribute("nbModules", nbModules);
        req.setAttribute("nbRessources", nbRessources);
        req.setAttribute("nbFilieres", nbFilieres);
        req.setAttribute("dernieresRessources", dernieresRessources);

        req.getRequestDispatcher(Constants.VIEW_ADMIN_DASHBOARD).forward(req, resp);
    }

    // ========================================================
    // UTILISATEURS
    // ========================================================
    private void showUtilisateurs(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String roleFilter = req.getParameter("role");
        List<Utilisateur> utilisateurs;
        if (roleFilter != null && !roleFilter.isEmpty()) {
            utilisateurs = utilisateurService.findByRole(roleFilter);
            req.setAttribute("roleFilter", roleFilter);
        } else {
            utilisateurs = utilisateurService.findAll();
        }
        req.setAttribute("utilisateurs", utilisateurs);
        req.getRequestDispatcher(Constants.VIEW_ADMIN_UTILISATEURS).forward(req, resp);
    }

    private void showUtilisateurForm(HttpServletRequest req, HttpServletResponse resp,
                                      String idStr) throws ServletException, IOException {
        List<Filiere> filieres = filiereService.findAll();
        List<Semestre> semestres = semestreService.findAll();
        req.setAttribute("filieres", filieres);
        req.setAttribute("semestres", semestres);

        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            Utilisateur u = utilisateurService.findById(id);
            req.setAttribute("utilisateur", u);
            req.setAttribute("editMode", true);
        } else {
            req.setAttribute("editMode", false);
        }
        req.getRequestDispatcher(Constants.VIEW_ADMIN_UTILISATEUR_FORM).forward(req, resp);
    }

    private void createUtilisateur(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur u = extractUtilisateur(req);
        ServiceResult<Utilisateur> result = utilisateurService.create(u);

        if (result.isSuccess()) {
            req.getSession().setAttribute("msgSuccess", result.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/utilisateurs");
        } else {
            req.setAttribute("errors", result.getErrors());
            req.setAttribute("utilisateur", u);
            req.setAttribute("filieres", filiereService.findAll());
            req.setAttribute("semestres", semestreService.findAll());
            req.setAttribute("editMode", false);
            req.getRequestDispatcher(Constants.VIEW_ADMIN_UTILISATEUR_FORM).forward(req, resp);
        }
    }

    private void updateUtilisateur(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Utilisateur u = utilisateurService.findById(id);
        if (u == null) {
            resp.sendError(404);
            return;
        }

        u.setNom(req.getParameter("nom"));
        u.setPrenom(req.getParameter("prenom"));
        u.setEmail(req.getParameter("email"));
        u.setTelephone(req.getParameter("telephone"));
        String cne = req.getParameter("cne");
        u.setCne(cne != null && !cne.isEmpty() ? cne : null);

        String roleNom = req.getParameter("role");
        Role role = new Role();
        role.setNomRole(roleNom);
        u.setRole(role);

        String filiereStr = req.getParameter("idFiliere");
        if (filiereStr != null && !filiereStr.isEmpty()) {
            Filiere f = new Filiere();
            f.setIdFiliere(Integer.parseInt(filiereStr));
            u.setFiliere(f);
        } else {
            u.setFiliere(null);
        }

        String semestreStr = req.getParameter("idSemestre");
        if (semestreStr != null && !semestreStr.isEmpty()) {
            Semestre s = new Semestre();
            s.setIdSemestre(Integer.parseInt(semestreStr));
            u.setSemestre(s);
        } else {
            u.setSemestre(null);
        }

        ServiceResult<Utilisateur> result = utilisateurService.update(u);
        if (result.isSuccess()) {
            req.getSession().setAttribute("msgSuccess", result.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/utilisateurs");
        } else {
            req.setAttribute("errors", result.getErrors());
            req.setAttribute("utilisateur", u);
            req.setAttribute("filieres", filiereService.findAll());
            req.setAttribute("semestres", semestreService.findAll());
            req.setAttribute("editMode", true);
            req.getRequestDispatcher(Constants.VIEW_ADMIN_UTILISATEUR_FORM).forward(req, resp);
        }
    }

    private void deleteUtilisateur(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Utilisateur currentUser = (Utilisateur) req.getSession().getAttribute(Constants.SESSION_USER);
        if (currentUser.getIdUtilisateur() == id) {
            req.getSession().setAttribute("msgError", "Vous ne pouvez pas supprimer votre propre compte");
            resp.sendRedirect(req.getContextPath() + "/admin/utilisateurs");
            return;
        }
        utilisateurService.delete(id);
        req.getSession().setAttribute("msgSuccess", "Utilisateur supprime avec succes");
        resp.sendRedirect(req.getContextPath() + "/admin/utilisateurs");
    }

    private void toggleUtilisateur(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        utilisateurService.toggleStatut(id);
        resp.sendRedirect(req.getContextPath() + "/admin/utilisateurs");
    }

    // ========================================================
    // IMPORT EXCEL
    // ========================================================
    private void showImportReq(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur admin = (Utilisateur) req.getSession().getAttribute(Constants.SESSION_USER);
        req.setAttribute("pageTitle", "Import Excel");
        req.setAttribute("activeMenu", "import");
        req.setAttribute("nomComplet", admin != null ? admin.getNomComplet() : "Admin");
        req.setAttribute("role", Constants.ROLE_ADMIN);
        forwardFlashMessages(req);
        req.getRequestDispatcher(Constants.VIEW_ADMIN_IMPORT).forward(req, resp);
    }

    private void importExcel(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        var part = req.getPart("fichierExcel");
        String typeImport = req.getParameter("typeImport");
        if (typeImport == null || typeImport.isEmpty()) typeImport = Constants.ROLE_ETUDIANT;

        if (part == null || part.getSize() == 0) {
            req.getSession().setAttribute("msgError", "Veuillez selectionner un fichier Excel");
            resp.sendRedirect(req.getContextPath() + "/admin/import");
            return;
        }
        ServiceResult<String> result = utilisateurService.importFromExcel(part.getInputStream(), typeImport);
        if (result.isSuccess()) {
            req.getSession().setAttribute("msgSuccess", result.getMessage());
        } else {
            req.getSession().setAttribute("msgError", "Rapport d'importation :");
            req.getSession().setAttribute("errors", result.getErrors());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/import");
    }

    private Utilisateur extractUtilisateur(HttpServletRequest req) {
        Utilisateur u = new Utilisateur();
        u.setNom(req.getParameter("nom"));
        u.setPrenom(req.getParameter("prenom"));
        u.setEmail(req.getParameter("email"));
        u.setMotDePasse(req.getParameter("motDePasse"));
        u.setTelephone(req.getParameter("telephone"));
        String cne = req.getParameter("cne");
        u.setCne(cne != null && !cne.isEmpty() ? cne : null);

        Role role = new Role();
        role.setNomRole(req.getParameter("role"));
        u.setRole(role);

        String filiereStr = req.getParameter("idFiliere");
        if (filiereStr != null && !filiereStr.isEmpty()) {
            Filiere f = new Filiere();
            f.setIdFiliere(Integer.parseInt(filiereStr));
            u.setFiliere(f);
        }

        String semestreStr = req.getParameter("idSemestre");
        if (semestreStr != null && !semestreStr.isEmpty()) {
            Semestre s = new Semestre();
            s.setIdSemestre(Integer.parseInt(semestreStr));
            u.setSemestre(s);
        }

        return u;
    }

    // ========================================================
    // MODULES
    // ========================================================
    private void showModules(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("modules", moduleService.findAll());
        req.getRequestDispatcher(Constants.VIEW_ADMIN_MODULES).forward(req, resp);
    }

    private void showModuleForm(HttpServletRequest req, HttpServletResponse resp,
                                 String idStr) throws ServletException, IOException {
        req.setAttribute("filieres", filiereService.findAll());
        req.setAttribute("semestres", semestreService.findAll());

        if (idStr != null && !idStr.isEmpty()) {
            Module m = moduleService.findById(Integer.parseInt(idStr));
            req.setAttribute("module", m);
            req.setAttribute("editMode", true);
        } else {
            req.setAttribute("editMode", false);
        }
        req.getRequestDispatcher(Constants.VIEW_ADMIN_MODULE_FORM).forward(req, resp);
    }

    private void createModule(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Module m = extractModule(req);
        ServiceResult<Module> result = moduleService.create(m);

        if (result.isSuccess()) {
            req.getSession().setAttribute("msgSuccess", result.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/modules");
        } else {
            req.setAttribute("errors", result.getErrors());
            req.setAttribute("module", m);
            req.setAttribute("filieres", filiereService.findAll());
            req.setAttribute("semestres", semestreService.findAll());
            req.setAttribute("editMode", false);
            req.getRequestDispatcher(Constants.VIEW_ADMIN_MODULE_FORM).forward(req, resp);
        }
    }

    private void updateModule(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Module m = extractModule(req);
        m.setIdModule(Integer.parseInt(req.getParameter("id")));
        ServiceResult<Module> result = moduleService.update(m);

        if (result.isSuccess()) {
            req.getSession().setAttribute("msgSuccess", result.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/modules");
        } else {
            req.setAttribute("errors", result.getErrors());
            req.setAttribute("module", m);
            req.setAttribute("filieres", filiereService.findAll());
            req.setAttribute("semestres", semestreService.findAll());
            req.setAttribute("editMode", true);
            req.getRequestDispatcher(Constants.VIEW_ADMIN_MODULE_FORM).forward(req, resp);
        }
    }

    private void deleteModule(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        moduleService.delete(id);
        req.getSession().setAttribute("msgSuccess", "Module supprime avec succes");
        resp.sendRedirect(req.getContextPath() + "/admin/modules");
    }

    private Module extractModule(HttpServletRequest req) {
        Module m = new Module();
        m.setNomModule(req.getParameter("nomModule"));
        m.setCodeModule(req.getParameter("codeModule"));
        m.setDescription(req.getParameter("description"));

        Filiere f = new Filiere();
        f.setIdFiliere(Integer.parseInt(req.getParameter("idFiliere")));
        m.setFiliere(f);

        Semestre s = new Semestre();
        s.setIdSemestre(Integer.parseInt(req.getParameter("idSemestre")));
        m.setSemestre(s);

        return m;
    }

    // ========================================================
    // FILIERES
    // ========================================================
    private void showFilieres(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("filieres", filiereService.findAll());
        req.getRequestDispatcher(Constants.VIEW_ADMIN_FILIERES).forward(req, resp);
    }

    private void showFiliereForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        boolean editMode = idStr != null && !idStr.isEmpty();
        if (editMode) {
            req.setAttribute("filiere", filiereService.findById(Integer.parseInt(idStr)));
        }
        req.setAttribute("editMode", editMode);
        req.getRequestDispatcher(Constants.VIEW_ADMIN_FILIERE_FORM).forward(req, resp);
    }

    private void showFiliereVoir(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Filiere f = filiereService.findById(id);
        List<models.Module> modules = moduleService.findByFiliere(id);
        List<models.Semestre> semestres = semestreService.findAll();
        req.setAttribute("filiere", f);
        req.setAttribute("modules", modules);
        req.setAttribute("semestres", semestres);
        req.setAttribute("pageTitle", "Filiere - " + f.getNomFiliere());
        req.setAttribute("activeMenu", "filieres");
        req.getRequestDispatcher(Constants.VIEW_ADMIN_FILIERE_VOIR).forward(req, resp);
    }

    private void createFiliere(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Filiere f = new Filiere();
        f.setNomFiliere(req.getParameter("nomFiliere"));
        f.setDescription(req.getParameter("description"));
        filiereService.create(f);
        req.getSession().setAttribute("msgSuccess", "Filiere creee avec succes");
        resp.sendRedirect(req.getContextPath() + "/admin/filieres");
    }

    private void updateFiliere(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Filiere f = new Filiere();
        f.setIdFiliere(Integer.parseInt(req.getParameter("id")));
        f.setNomFiliere(req.getParameter("nomFiliere"));
        f.setDescription(req.getParameter("description"));
        filiereService.update(f);
        req.getSession().setAttribute("msgSuccess", "Filiere modifiee avec succes");
        resp.sendRedirect(req.getContextPath() + "/admin/filieres");
    }

    private void deleteFiliere(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        filiereService.delete(id);
        req.getSession().setAttribute("msgSuccess", "Filiere supprimee avec succes");
        resp.sendRedirect(req.getContextPath() + "/admin/filieres");
    }

    // ========================================================
    // SEMESTRES
    // ========================================================
    private void showSemestres(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("semestres", semestreService.findAll());
        req.getRequestDispatcher(Constants.VIEW_ADMIN_SEMESTRES).forward(req, resp);
    }

    private void showSemestreForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        boolean editMode = idStr != null && !idStr.isEmpty();
        if (editMode) {
            req.setAttribute("semestre", semestreService.findById(Integer.parseInt(idStr)));
        }
        req.setAttribute("editMode", editMode);
        req.getRequestDispatcher(Constants.VIEW_ADMIN_SEMESTRE_FORM).forward(req, resp);
    }

    private void createSemestre(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Semestre s = new Semestre();
        s.setNomSemestre(req.getParameter("nomSemestre"));
        s.setDescription(req.getParameter("description"));
        semestreService.create(s);
        req.getSession().setAttribute("msgSuccess", "Semestre cree avec succes");
        resp.sendRedirect(req.getContextPath() + "/admin/semestres");
    }

    private void updateSemestre(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Semestre s = new Semestre();
        s.setIdSemestre(Integer.parseInt(req.getParameter("id")));
        s.setNomSemestre(req.getParameter("nomSemestre"));
        s.setDescription(req.getParameter("description"));
        semestreService.update(s);
        req.getSession().setAttribute("msgSuccess", "Semestre modifie avec succes");
        resp.sendRedirect(req.getContextPath() + "/admin/semestres");
    }

    private void deleteSemestre(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        semestreService.delete(id);
        req.getSession().setAttribute("msgSuccess", "Semestre supprime avec succes");
        resp.sendRedirect(req.getContextPath() + "/admin/semestres");
    }

    // ========================================================
    // AFFECTATIONS
    // ========================================================
    private void showAffectations(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("affectations", affectationService.findAll());
        req.getRequestDispatcher(Constants.VIEW_ADMIN_AFFECTATIONS).forward(req, resp);
    }

    private void showAffectationForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("professeurs", utilisateurService.findByRole("PROFESSEUR"));
        req.setAttribute("modules", moduleService.findAll());
        req.getRequestDispatcher(Constants.VIEW_ADMIN_AFFECTATION_FORM).forward(req, resp);
    }

    private void createAffectation(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        AffectationModule a = new AffectationModule();

        Utilisateur prof = new Utilisateur();
        prof.setIdUtilisateur(Integer.parseInt(req.getParameter("idProfesseur")));
        a.setProfesseur(prof);

        Module mod = new Module();
        mod.setIdModule(Integer.parseInt(req.getParameter("idModule")));
        a.setModule(mod);

        a.setAnneeUniversitaire(req.getParameter("anneeUniversitaire"));

        ServiceResult<AffectationModule> result = affectationService.create(a);
        if (result.isSuccess()) {
            req.getSession().setAttribute("msgSuccess", result.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/affectations");
        } else {
            req.getSession().setAttribute("msgError", result.getErrors().get(0));
            resp.sendRedirect(req.getContextPath() + "/admin/affectation/ajouter");
        }
    }

    private void deleteAffectation(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        affectationService.delete(id);
        req.getSession().setAttribute("msgSuccess", "Affectation supprimee avec succes");
        resp.sendRedirect(req.getContextPath() + "/admin/affectations");
    }

    // ========================================================
    // RESSOURCES (Admin)
    // ========================================================
    private void showRessources(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("ressources", ressourceService.findAll());
        req.getRequestDispatcher(Constants.VIEW_ADMIN_RESSOURCES).forward(req, resp);
    }

    private void deleteRessource(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String realPath = utils.FileUploadUtil.getExternalUploadPath();
        ressourceService.delete(id, realPath);
        req.getSession().setAttribute("msgSuccess", "Ressource supprimee avec succes");
        resp.sendRedirect(req.getContextPath() + "/admin/ressources");
    }

    // ========================================================
    // STATISTIQUES
    // ========================================================
    private void showStatistiques(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int nbAdmins = utilisateurService.countByRole("ADMIN");
        int nbProfs = utilisateurService.countByRole("PROFESSEUR");
        int nbEtudiants = utilisateurService.countByRole("ETUDIANT");
        int nbModules = moduleService.count();
        int nbRessources = ressourceService.count();
        int nbFilieres = filiereService.count();

        req.setAttribute("nbAdmins", nbAdmins);
        req.setAttribute("nbProfs", nbProfs);
        req.setAttribute("nbEtudiants", nbEtudiants);
        req.setAttribute("nbModules", nbModules);
        req.setAttribute("nbRessources", nbRessources);
        req.setAttribute("nbFilieres", nbFilieres);

        req.getRequestDispatcher(Constants.VIEW_ADMIN_STATS).forward(req, resp);
    }
}