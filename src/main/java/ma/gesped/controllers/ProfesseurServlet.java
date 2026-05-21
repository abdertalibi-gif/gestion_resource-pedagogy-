package ma.gesped.controllers;

import java.io.IOException;
import java.util.List;

import Services.AmiService;
import Services.HistoriqueService;
import Services.ModuleService;
import Services.NotificationService;
import Services.RessourceService;
import Services.ServiceResult;
import Services.TypeRessourceService;
import Services.UtilisateurService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import models.Module;
import models.Ressource;
import models.TypeRessource;
import models.Utilisateur;
import utils.Constants;

@WebServlet("/professeur/*")
@MultipartConfig(maxFileSize = Constants.MAX_FILE_SIZE, maxRequestSize = Constants.MAX_FILE_SIZE)
public class ProfesseurServlet extends HttpServlet {

    private final RessourceService ressourceService = new RessourceService();
    private final ModuleService moduleService = new ModuleService();
    private final TypeRessourceService typeRessourceService = new TypeRessourceService();
    private final NotificationService notificationService = new NotificationService();
    private final HistoriqueService historiqueService = new HistoriqueService();
    private final AmiService amiService = new AmiService();
    private final UtilisateurService utilisateurService = new UtilisateurService();

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
            case "/amis" -> showAmis(req, resp);
            case "/ami/ajouter" -> ajouterAmi(req, resp);
            case "/ami/retirer" -> retirerAmi(req, resp);
            case "/notifications" -> showNotifications(req, resp);
            case "/notification/lire" -> markNotificationRead(req, resp);
            case "/notification/toutlire" -> markAllNotificationsRead(req, resp);
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
        int nbNonLues = notificationService.countNonLues(user.getIdUtilisateur());

        req.setAttribute("modules", modules);
        req.setAttribute("nbRessources", nbRessources);
        req.setAttribute("dernieresRessources", dernieresRessources);
        req.setAttribute("nbNonLues", nbNonLues);

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

            String realPath = req.getServletContext().getRealPath("/assets/uploads");
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

    private void showNotifications(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        req.setAttribute("notifications", notificationService.findByUtilisateur(user.getIdUtilisateur()));
        req.getRequestDispatcher("/WEB-INF/views/professeur/notifications.jsp").forward(req, resp);
    }

    private void markNotificationRead(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Utilisateur user = getCurrentUser(req);
        notificationService.markAsRead(id, user.getIdUtilisateur());
        resp.sendRedirect(req.getContextPath() + "/professeur/notifications");
    }

    private void markAllNotificationsRead(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Utilisateur user = getCurrentUser(req);
        notificationService.markAllAsRead(user.getIdUtilisateur());
        resp.sendRedirect(req.getContextPath() + "/professeur/notifications");
    }

    private void showAmis(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        String tab = req.getParameter("tab");
        if (tab == null || tab.isEmpty()) tab = "amis";

        req.setAttribute("activeMenu", "amis");
        req.setAttribute("pageTitle", "Mes amis");
        req.setAttribute("tab", tab);
        req.setAttribute("amis", amiService.getAmis(req.getSession()));
        req.setAttribute("suggestions", amiService.getSuggestions(user.getIdUtilisateur(), req.getSession()));
        req.setAttribute("nbAmis", amiService.countAmis(req.getSession()));
        req.setAttribute("nbSuggestions", amiService.getSuggestions(user.getIdUtilisateur(), req.getSession()).size());

        String msgSuccess = (String) req.getSession().getAttribute(Constants.FLASH_SUCCESS);
        String msgError = (String) req.getSession().getAttribute(Constants.FLASH_ERROR);
        if (msgSuccess != null) {
            req.setAttribute(Constants.FLASH_SUCCESS, msgSuccess);
            req.getSession().removeAttribute(Constants.FLASH_SUCCESS);
        }
        if (msgError != null) {
            req.setAttribute(Constants.FLASH_ERROR, msgError);
            req.getSession().removeAttribute(Constants.FLASH_ERROR);
        }

        req.getRequestDispatcher(Constants.VIEW_PROF_AMIS).forward(req, resp);
    }

    private void ajouterAmi(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Utilisateur user = getCurrentUser(req);
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            if (id == user.getIdUtilisateur()) {
                req.getSession().setAttribute(Constants.FLASH_ERROR, "Vous ne pouvez pas vous ajouter vous-m\u00eame.");
            } else if (utilisateurService.findById(id) == null) {
                req.getSession().setAttribute(Constants.FLASH_ERROR, "Professeur introuvable.");
            } else {
                amiService.ajouter(req.getSession(), id);
                req.getSession().setAttribute(Constants.FLASH_SUCCESS, "Ami ajout\u00e9 avec succ\u00e8s.");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute(Constants.FLASH_ERROR, "Identifiant invalide.");
        }
        resp.sendRedirect(req.getContextPath() + "/professeur/amis?tab=suggestions");
    }

    private void retirerAmi(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            amiService.retirer(req.getSession(), id);
            req.getSession().setAttribute(Constants.FLASH_SUCCESS, "Ami retir\u00e9 de votre liste.");
        } catch (NumberFormatException e) {
            req.getSession().setAttribute(Constants.FLASH_ERROR, "Identifiant invalide.");
        }
        resp.sendRedirect(req.getContextPath() + "/professeur/amis?tab=amis");
    }
}