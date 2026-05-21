package ma.gesped.controllers;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import Services.FavoriService;
import Services.FiliereService;
import Services.HistoriqueService;
import Services.ModuleService;
import Services.NotificationService;
import Services.RessourceService;
import Services.SemestreService;
import Services.TypeRessourceService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Filiere;
import models.Module;
import models.Ressource;
import models.Semestre;
import models.Utilisateur;
import utils.Constants;

@WebServlet("/etudiant/*")
public class EtudiantServlet extends HttpServlet {

    private final RessourceService ressourceService = new RessourceService();
    private final ModuleService moduleService = new ModuleService();
    private final FiliereService filiereService = new FiliereService();
    private final SemestreService semestreService = new SemestreService();
    private final TypeRessourceService typeRessourceService = new TypeRessourceService();
    private final FavoriService favoriService = new FavoriService();
    private final HistoriqueService historiqueService = new HistoriqueService();
    private final NotificationService notificationService = new NotificationService();

    private Utilisateur getCurrentUser(HttpServletRequest req) {
        return (Utilisateur) req.getSession().getAttribute(Constants.SESSION_USER);
    }

    private boolean checkEtudiantAccess(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Utilisateur user = getCurrentUser(req);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        if (!Constants.ROLE_ETUDIANT.equalsIgnoreCase(user.getRole().getNomRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        req.setAttribute("role", Constants.ROLE_ETUDIANT);
        req.setAttribute("nomComplet", user.getNomComplet());
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!checkEtudiantAccess(req, resp)) return;
        String path = req.getPathInfo();
        if (path == null) path = "/dashboard";

        switch (path) {
            case "/dashboard" -> showDashboard(req, resp);
            case "/modules" -> showModules(req, resp);
            case "/ressources" -> showRessources(req, resp);
            case "/ressource/voir" -> viewRessource(req, resp);
            case "/ressource/telecharger" -> downloadRessource(req, resp);
            case "/recherche" -> showRecherche(req, resp);
            case "/favoris" -> showFavoris(req, resp);
            case "/favori/ajouter" -> ajouterFavori(req, resp);
            case "/favori/retirer" -> retirerFavori(req, resp);
            case "/historique" -> showHistorique(req, resp);
            case "/profil" -> showProfil(req, resp);
            case "/notifications" -> showNotifications(req, resp);
            case "/notification/lire" -> markNotificationRead(req, resp);
            case "/notification/toutlire" -> markAllNotificationsRead(req, resp);
            default -> resp.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!checkEtudiantAccess(req, resp)) return;
        String path = req.getPathInfo();
        if (path == null) path = "/dashboard";
        if ("/profil".equals(path)) {
            showProfil(req, resp);
            return;
        }
        doGet(req, resp);
    }

    // ========================================================
    private void showDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        List<models.Module> modules = List.of();
        List<Ressource> recentes = ressourceService.findLast5();
        int nbFavoris = favoriService.countByEtudiant(user.getIdUtilisateur());
        int nbConsultations = historiqueService.countByEtudiant(user.getIdUtilisateur());
        int nbNonLues = notificationService.countNonLues(user.getIdUtilisateur());

        // Modules de la filiere/semestre de l'etudiant
        if (user.getFiliere() != null && user.getSemestre() != null) {
            Filiere f = filiereService.findById(user.getFiliere().getIdFiliere());
            Semestre s = semestreService.findById(user.getSemestre().getIdSemestre());
            if (f != null && s != null) {
                modules = moduleService.findByFiliereSemestre(
                    f.getIdFiliere(), s.getIdSemestre()
                );
            }
        }

        req.setAttribute("activeMenu", "dashboard");
        req.setAttribute("pageTitle", "Tableau de bord");
        req.setAttribute("modules", modules);
        req.setAttribute("recentes", recentes);
        req.setAttribute("nbFavoris", nbFavoris);
        req.setAttribute("nbConsultations", nbConsultations);
        req.setAttribute("nbNonLues", nbNonLues);

        req.getRequestDispatcher(Constants.VIEW_ETU_DASHBOARD).forward(req, resp);
    }

    private void showModules(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        List<Module> modules = List.of();

        if (user.getFiliere() != null && user.getSemestre() != null) {
            Filiere f = filiereService.findById(user.getFiliere().getIdFiliere());
            Semestre s = semestreService.findById(user.getSemestre().getIdSemestre());
            if (f != null && s != null) {
                modules = moduleService.findByFiliereSemestre(
                    f.getIdFiliere(), s.getIdSemestre()
                );
            }
        }
        req.setAttribute("activeMenu", "modules");
        req.setAttribute("pageTitle", "Mes modules");
        req.setAttribute("modules", modules);
        req.getRequestDispatcher(Constants.VIEW_ETU_MODULES).forward(req, resp);
    }

    private void showRessources(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String moduleParam = req.getParameter("module");
        String typeParam = req.getParameter("type");

        List<Ressource> ressources;

        if (moduleParam != null && !moduleParam.isEmpty()) {
            ressources = ressourceService.findByModule(Integer.parseInt(moduleParam));
            req.setAttribute("moduleFilter", moduleParam);
        } else {
            ressources = ressourceService.findAll();
        }

        if (typeParam != null && !typeParam.isEmpty()) {
            String typeFinal = typeParam;
            ressources = ressources.stream()
                .filter(r -> r.getType() != null && r.getType().getNomType().equals(typeFinal))
                .toList();
            req.setAttribute("typeFilter", typeParam);
        }

        Utilisateur user = getCurrentUser(req);
        // Marquer les favoris
        for (Ressource r : ressources) {
            r.setEstFavori(favoriService.isFavori(user.getIdUtilisateur(), r.getIdRessource()));
        }

        req.setAttribute("activeMenu", "ressources");
        req.setAttribute("pageTitle", "Ressources");
        req.setAttribute("ressources", ressources);
        req.setAttribute("types", typeRessourceService.findAll());
        req.getRequestDispatcher(Constants.VIEW_ETU_RESSOURCES).forward(req, resp);
    }

    private void viewRessource(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Ressource r = ressourceService.findById(id);
        if (r == null || !r.isVisible()) {
            resp.sendError(404, "Ressource introuvable");
            return;
        }

        Utilisateur user = getCurrentUser(req);
        // Enregistrer la consultation
        historiqueService.ajouter(user.getIdUtilisateur(), r.getIdRessource(), "CONSULTATION");
        r.setEstFavori(favoriService.isFavori(user.getIdUtilisateur(), r.getIdRessource()));
        r.setNombreConsultations(historiqueService.countByRessource(r.getIdRessource()));

        req.setAttribute("ressource", r);
        req.getRequestDispatcher(Constants.VIEW_ETU_RESSOURCE_VIEW).forward(req, resp);
    }

    private void downloadRessource(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Ressource r = ressourceService.findById(id);
        if (r == null || !r.isVisible()) {
            resp.sendError(404, "Ressource introuvable");
            return;
        }

        Utilisateur user = getCurrentUser(req);
        historiqueService.ajouter(user.getIdUtilisateur(), r.getIdRessource(), "TELECHARGEMENT");

        // Envoyer le fichier
        String realPath = req.getServletContext().getRealPath(r.getCheminFichier());
        Path filePath = Paths.get(realPath);
        if (!Files.exists(filePath)) {
            resp.sendError(404, "Fichier introuvable sur le serveur");
            return;
        }

        String contentType = getServletContext().getMimeType(r.getNomFichier());
        if (contentType == null) contentType = "application/octet-stream";

        resp.setContentType(contentType);
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + r.getNomFichier() + "\"");
        resp.setContentLengthLong(Files.size(filePath));

        try (OutputStream out = resp.getOutputStream()) {
            Files.copy(filePath, out);
        }
    }

    private void showRecherche(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("q");
        List<Ressource> resultats = List.of();

        if (keyword != null && !keyword.trim().isEmpty()) {
            resultats = ressourceService.search(keyword.trim());
            Utilisateur user = getCurrentUser(req);
            for (Ressource r : resultats) {
                r.setEstFavori(favoriService.isFavori(user.getIdUtilisateur(), r.getIdRessource()));
            }
        }

        req.setAttribute("activeMenu", "recherche");
        req.setAttribute("pageTitle", "Recherche");
        req.setAttribute("resultats", resultats);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher(Constants.VIEW_ETU_RECHERCHE).forward(req, resp);
    }

    private void showFavoris(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        req.setAttribute("activeMenu", "favoris");
        req.setAttribute("pageTitle", "Mes favoris");
        req.setAttribute("favoris", favoriService.findByEtudiant(user.getIdUtilisateur()));
        req.getRequestDispatcher(Constants.VIEW_ETU_FAVORIS).forward(req, resp);
    }

    private void ajouterFavori(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Utilisateur user = getCurrentUser(req);
        int idRessource = Integer.parseInt(req.getParameter("id"));
        favoriService.ajouter(user.getIdUtilisateur(), idRessource);
        String referer = req.getHeader("referer");
        resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/etudiant/ressources");
    }

    private void retirerFavori(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Utilisateur user = getCurrentUser(req);
        int idRessource = Integer.parseInt(req.getParameter("id"));
        favoriService.retirer(user.getIdUtilisateur(), idRessource);
        String referer = req.getHeader("referer");
        resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/etudiant/favoris");
    }

    private void showHistorique(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        req.setAttribute("activeMenu", "historique");
        req.setAttribute("pageTitle", "Historique");
        req.setAttribute("historique", historiqueService.findByEtudiant(user.getIdUtilisateur()));
        req.getRequestDispatcher(Constants.VIEW_ETU_HISTORIQUE).forward(req, resp);
    }

    private void showProfil(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        req.setAttribute("activeMenu", "profil");
        req.setAttribute("pageTitle", "Mon profil");
        req.setAttribute("utilisateur", user);
        req.getRequestDispatcher(Constants.VIEW_ETU_PROFIL).forward(req, resp);
    }

    private void showNotifications(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur user = getCurrentUser(req);
        req.setAttribute("notifications", notificationService.findByUtilisateur(user.getIdUtilisateur()));
        req.getRequestDispatcher("/WEB-INF/views/etudiant/notifications.jsp").forward(req, resp);
    }

    private void markNotificationRead(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Utilisateur user = getCurrentUser(req);
        notificationService.markAsRead(id, user.getIdUtilisateur());
        resp.sendRedirect(req.getContextPath() + "/etudiant/notifications");
    }

    private void markAllNotificationsRead(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Utilisateur user = getCurrentUser(req);
        notificationService.markAllAsRead(user.getIdUtilisateur());
        resp.sendRedirect(req.getContextPath() + "/etudiant/notifications");
    }
}