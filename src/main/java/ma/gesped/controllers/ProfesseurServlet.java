package ma.gesped.controllers;

import java.io.IOException;
import java.util.List;

import Services.DevoirService;
import Services.HistoriqueService;
import Services.ModuleService;
import Services.RessourceService;
import Services.ServiceResult;
import Services.SoumissionService;
import Services.TypeRessourceService;
import Services.UtilisateurService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import models.Devoir;
import models.Module;
import models.Ressource;
import models.Soumission;
import models.TypeRessource;
import models.Utilisateur;
import utils.Constants;

@WebServlet("/professeur/*")
@MultipartConfig(maxFileSize = Constants.MAX_FILE_SIZE, maxRequestSize = Constants.MAX_FILE_SIZE)
public class ProfesseurServlet extends HttpServlet {

    private final RessourceService ressourceService = new RessourceService();
    private final ModuleService moduleService = new ModuleService();
    private final TypeRessourceService typeRessourceService = new TypeRessourceService();
    private final UtilisateurService utilisateurService = new UtilisateurService();
    private final SoumissionService soumissionService = new SoumissionService();
    private final DevoirService devoirService = new DevoirService();

    private Utilisateur getCurrentUser(HttpServletRequest req) {
        return (Utilisateur) req.getSession().getAttribute(Constants.SESSION_USER);
    }

    private boolean checkProfesseurAccess(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Utilisateur user = getCurrentUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        if (!Constants.ROLE_PROFESSEUR.equalsIgnoreCase(user.getRole().getNomRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        req.setAttribute("role", Constants.ROLE_PROFESSEUR);
        req.setAttribute("nomComplet", user.getNomComplet());
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!checkProfesseurAccess(req, resp)) return;
        String path = req.getPathInfo();
        if (path == null) path = "/dashboard";

        switch (path) {
            case "/dashboard" -> showDashboard(req, resp);
            case "/modules" -> showModules(req, resp);
            case "/ressources" -> showRessources(req, resp);
            case "/ressource/ajouter" -> showUploadForm(req, resp);
            case "/ressource/modifier" -> showEditForm(req, resp);
            case "/ressource/supprimer" -> deleteRessource(req, resp);
            case "/statistiques" -> showStatistiques(req, resp);
            case "/soumissions" -> showSoumissions(req, resp);
            case "/soumission/voir" -> voirSoumission(req, resp);
            case "/soumission/telecharger" -> downloadSoumission(req, resp);
            case "/devoirs" -> showDevoirs(req, resp);
            case "/devoir/ajouter" -> showDevoirForm(req, resp);
            case "/devoir/voir" -> voirDevoir(req, resp);
            case "/devoir/supprimer" -> deleteDevoir(req, resp);
            default -> resp.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!checkProfesseurAccess(req, resp)) return;
        String path = req.getPathInfo();
        if (path == null) path = "/dashboard";

        switch (path) {
            case "/ressource/ajouter" -> uploadRessource(req, resp);
            case "/ressource/modifier" -> updateRessource(req, resp);
            case "/soumission/evaluer" -> evaluerSoumission(req, resp);
            case "/devoir/ajouter" -> creerDevoir(req, resp);
            default -> resp.sendError(404);
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        List<Module> modules = moduleService.findByProfesseur(user.getIdUtilisateur());
        int nbRessources = ressourceService.countByProfesseur(user.getIdUtilisateur());
        List<Ressource> dernieresRessources = ressourceService.findByProfesseur(user.getIdUtilisateur())
                .stream().limit(5).toList();

        req.setAttribute("modules", modules);
        req.setAttribute("nbRessources", nbRessources);
        req.setAttribute("dernieresRessources", dernieresRessources);

        req.getRequestDispatcher(Constants.VIEW_PROF_DASHBOARD).forward(req, resp);
    }

    private void showModules(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        req.setAttribute("modules", moduleService.findByProfesseur(user.getIdUtilisateur()));
        req.getRequestDispatcher(Constants.VIEW_PROF_MODULES).forward(req, resp);
    }

    private void showRessources(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        String moduleFilter = req.getParameter("module");

        List<Ressource> ressources;
        if (moduleFilter != null && !moduleFilter.isEmpty()) {
            ressources = ressourceService.findByModule(Integer.parseInt(moduleFilter));
            req.setAttribute("moduleFilter", moduleFilter);
        } else {
            ressources = ressourceService.findByProfesseur(user.getIdUtilisateur());
        }

        req.setAttribute("ressources", ressources);
        req.setAttribute("modules", moduleService.findByProfesseur(user.getIdUtilisateur()));
        req.getRequestDispatcher(Constants.VIEW_PROF_RESSOURCES).forward(req, resp);
    }

    private void showUploadForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        req.setAttribute("modules", moduleService.findByProfesseur(user.getIdUtilisateur()));
        req.setAttribute("types", typeRessourceService.findAll());
        req.getRequestDispatcher(Constants.VIEW_PROF_UPLOAD).forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Ressource r = ressourceService.findById(id);
        Utilisateur user = getCurrentUser(req);

        if (r == null || r.getProfesseur().getIdUtilisateur() != user.getIdUtilisateur()) {
            resp.sendError(403, "Acces refuse");
            return;
        }

        req.setAttribute("ressource", r);
        req.setAttribute("modules", moduleService.findByProfesseur(user.getIdUtilisateur()));
        req.setAttribute("types", typeRessourceService.findAll());
        req.getRequestDispatcher(Constants.VIEW_PROF_EDIT_RESSOURCE).forward(req, resp);
    }

    private void uploadRessource(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Part filePart = req.getPart("fichier");
            if (filePart == null || filePart.getSize() == 0) {
                req.setAttribute("msgError", "Veuillez selectionner un fichier");
                showUploadForm(req, resp);
                return;
            }

            Ressource r = new Ressource();
            r.setTitre(req.getParameter("titre"));
            r.setDescription(req.getParameter("description"));

            Utilisateur user = getCurrentUser(req);
            r.setProfesseur(user);

            String moduleParam = req.getParameter("moduleId");
            if (moduleParam == null || moduleParam.isEmpty()) {
                moduleParam = req.getParameter("idModule");
            }
            Module mod = new Module();
            mod.setIdModule(Integer.parseInt(moduleParam));
            r.setModule(mod);

            String typeParam = req.getParameter("typeId");
            if (typeParam == null || typeParam.isEmpty()) {
                typeParam = req.getParameter("idType");
            }
            TypeRessource type = new TypeRessource();
            type.setIdType(Integer.parseInt(typeParam));
            r.setType(type);

            String realPath = utils.FileUploadUtil.getExternalUploadPath();
            ServiceResult<Ressource> result = ressourceService.upload(r, filePart, realPath);

            if (result.isSuccess()) {
                req.getSession().setAttribute("msgSuccess", result.getMessage());
                resp.sendRedirect(req.getContextPath() + "/professeur/ressources");
            } else {
                req.setAttribute("msgError", result.getErrors().get(0));
                showUploadForm(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("msgError", "Erreur lors de l'upload: " + e.getMessage());
            showUploadForm(req, resp);
        }
    }

    private void updateRessource(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Ressource r = ressourceService.findById(id);
        Utilisateur user = getCurrentUser(req);

        if (r == null || r.getProfesseur().getIdUtilisateur() != user.getIdUtilisateur()) {
            resp.sendError(403);
            return;
        }

        r.setTitre(req.getParameter("titre"));
        r.setDescription(req.getParameter("description"));
        r.setVisible(Boolean.parseBoolean(req.getParameter("visible")));

        String moduleParam = req.getParameter("moduleId");
        if (moduleParam == null || moduleParam.isEmpty()) {
            moduleParam = req.getParameter("idModule");
        }
        Module mod = new Module();
        mod.setIdModule(Integer.parseInt(moduleParam));
        r.setModule(mod);

        String typeParam = req.getParameter("typeId");
        if (typeParam == null || typeParam.isEmpty()) {
            typeParam = req.getParameter("idType");
        }
        TypeRessource type = new TypeRessource();
        type.setIdType(Integer.parseInt(typeParam));
        r.setType(type);

        ServiceResult<Ressource> result = ressourceService.update(r);
        if (result.isSuccess()) {
            req.getSession().setAttribute("msgSuccess", result.getMessage());
            resp.sendRedirect(req.getContextPath() + "/professeur/ressources");
        } else {
            req.setAttribute("msgError", result.getErrors().get(0));
            req.setAttribute("ressource", r);
            req.setAttribute("modules", moduleService.findByProfesseur(user.getIdUtilisateur()));
            req.setAttribute("types", typeRessourceService.findAll());
            req.getRequestDispatcher(Constants.VIEW_PROF_EDIT_RESSOURCE).forward(req, resp);
        }
    }

    private void deleteRessource(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String realPath = req.getServletContext().getRealPath("/assets/uploads");
        ressourceService.delete(id, realPath);
        req.getSession().setAttribute("msgSuccess", "Ressource supprimee avec succes");
        resp.sendRedirect(req.getContextPath() + "/professeur/ressources");
    }

    private void showStatistiques(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        int nbRessources = ressourceService.countByProfesseur(user.getIdUtilisateur());
        List<Module> modules = moduleService.findByProfesseur(user.getIdUtilisateur());

        req.setAttribute("nbRessources", nbRessources);
        req.setAttribute("modules", modules);
        req.getRequestDispatcher(Constants.VIEW_PROF_STATS).forward(req, resp);
    }

    private void showSoumissions(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        String moduleFilter = req.getParameter("module");

        List<Soumission> soumissions;
        if (moduleFilter != null && !moduleFilter.isEmpty()) {
            soumissions = soumissionService.findByProfesseur(user.getIdUtilisateur())
                .stream()
                .filter(s -> s.getModule() != null && String.valueOf(s.getModule().getIdModule()).equals(moduleFilter))
                .toList();
            req.setAttribute("moduleFilter", moduleFilter);
        } else {
            soumissions = soumissionService.findByProfesseur(user.getIdUtilisateur());
        }

        req.setAttribute("activeMenu", "soumissions");
        req.setAttribute("pageTitle", "Soumissions des étudiants");
        req.setAttribute("soumissions", soumissions);
        req.setAttribute("modules", moduleService.findByProfesseur(user.getIdUtilisateur()));
        req.getRequestDispatcher(Constants.VIEW_PROF_SOUMISSIONS).forward(req, resp);
    }

    private void voirSoumission(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Soumission s = soumissionService.findById(id);
        if (s == null) {
            resp.sendError(404, "Soumission introuvable");
            return;
        }

        req.setAttribute("activeMenu", "soumissions");
        req.setAttribute("pageTitle", "Détail soumission");
        req.setAttribute("soumission", s);
        req.getRequestDispatcher("/WEB-INF/views/professeur/soumission-detail.jsp").forward(req, resp);
    }

    private void evaluerSoumission(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String statut = req.getParameter("statut");
            String noteStr = req.getParameter("note");
            String commentaire = req.getParameter("commentaire");

            Double note = null;
            if (noteStr != null && !noteStr.trim().isEmpty()) {
                note = Double.parseDouble(noteStr);
            }

            ServiceResult<Soumission> result = soumissionService.evaluer(id, statut, note, commentaire);
            if (result.isSuccess()) {
                req.getSession().setAttribute("msgSuccess", result.getMessage());
            } else {
                req.getSession().setAttribute("msgError", result.getErrors().get(0));
            }
            resp.sendRedirect(req.getContextPath() + "/professeur/soumissions");
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("msgError", "Note invalide");
            resp.sendRedirect(req.getContextPath() + "/professeur/soumissions");
        }
    }

    private void showDevoirs(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        req.setAttribute("activeMenu", "devoirs");
        req.setAttribute("pageTitle", "Devoirs");
        req.setAttribute("devoirs", devoirService.findByProfesseur(user.getIdUtilisateur()));
        req.getRequestDispatcher(Constants.VIEW_PROF_DEVOIRS).forward(req, resp);
    }

    private void showDevoirForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        req.setAttribute("activeMenu", "devoirs");
        req.setAttribute("pageTitle", "Nouveau devoir");
        req.setAttribute("modules", moduleService.findByProfesseur(user.getIdUtilisateur()));
        req.getRequestDispatcher(Constants.VIEW_PROF_DEVOIR_FORM).forward(req, resp);
    }

    private void voirDevoir(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Devoir d = devoirService.findById(id);
        if (d == null) {
            resp.sendError(404, "Devoir introuvable");
            return;
        }

        req.setAttribute("activeMenu", "devoirs");
        req.setAttribute("pageTitle", d.getTitre());
        req.setAttribute("devoir", d);
        req.setAttribute("soumissions", soumissionService.findByDevoir(id));
        req.getRequestDispatcher(Constants.VIEW_PROF_DEVOIR_DETAIL).forward(req, resp);
    }

    private void creerDevoir(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Part filePart = req.getPart("fichier");

            Devoir d = new Devoir();
            d.setTitre(req.getParameter("titre"));
            d.setDescription(req.getParameter("description"));

            String dateLimiteStr = req.getParameter("dateLimite");
            if (dateLimiteStr != null && !dateLimiteStr.isEmpty()) {
                d.setDateLimite(java.time.LocalDateTime.parse(dateLimiteStr.replace("T", "T")));
            }

            Utilisateur user = getCurrentUser(req);
            d.setProfesseur(user);

            Module mod = new Module();
            mod.setIdModule(Integer.parseInt(req.getParameter("idModule")));
            d.setModule(mod);

            String realPath = utils.FileUploadUtil.getExternalUploadPath();
            ServiceResult<Devoir> result = devoirService.creer(d, filePart, realPath);

            if (result.isSuccess()) {
                req.getSession().setAttribute("msgSuccess", result.getMessage());
                resp.sendRedirect(req.getContextPath() + "/professeur/devoirs");
            } else {
                req.setAttribute("msgError", result.getErrors().get(0));
                showDevoirForm(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("msgError", "Erreur: " + e.getMessage());
            showDevoirForm(req, resp);
        }
    }

    private void deleteDevoir(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String realPath = req.getServletContext().getRealPath("/assets/uploads");
        devoirService.delete(id, realPath);
        req.getSession().setAttribute("msgSuccess", "Devoir supprimé avec succès");
        resp.sendRedirect(req.getContextPath() + "/professeur/devoirs");
    }

    private void downloadSoumission(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Soumission s = soumissionService.findById(id);
        if (s == null) {
            resp.sendError(404, "Soumission introuvable");
            return;
        }

        java.nio.file.Path filePath = utils.FileUploadUtil.resolveExternalPath(s.getCheminFichier());
        if (!java.nio.file.Files.exists(filePath)) {
            resp.sendError(404, "Fichier introuvable sur le serveur");
            return;
        }

        String contentType = getServletContext().getMimeType(s.getNomFichier());
        if (contentType == null) contentType = "application/octet-stream";

        resp.setContentType(contentType);
        resp.setHeader("Content-Disposition", "inline; filename=\"" + s.getNomFichier() + "\"");
        resp.setContentLengthLong(java.nio.file.Files.size(filePath));

        try (java.io.OutputStream out = resp.getOutputStream()) {
            java.nio.file.Files.copy(filePath, out);
        }
    }

}