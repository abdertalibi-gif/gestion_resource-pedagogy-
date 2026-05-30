package ma.gesped.controllers;

import java.io.IOException;
import java.util.List;

import Services.ModuleService;
import Services.RessourceService;
import Services.UtilisateurService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Ressource;

@WebServlet("")
public class HomeServlet extends HttpServlet {

    private final RessourceService ressourceService = new RessourceService();
    private final ModuleService moduleService = new ModuleService();
    private final UtilisateurService utilisateurService = new UtilisateurService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Statistiques pour la page d'accueil
        int nbEtudiants = utilisateurService.countByRole("ETUDIANT");
        int nbProfs = utilisateurService.countByRole("PROFESSEUR");
        int nbModules = moduleService.count();
        int nbRessources = ressourceService.count();
        List<Ressource> dernieresRessources = ressourceService.findLast5();

        req.setAttribute("nbEtudiants", nbEtudiants);
        req.setAttribute("nbProfs", nbProfs);
        req.setAttribute("nbModules", nbModules);
        req.setAttribute("nbRessources", nbRessources);
        req.setAttribute("dernieresRessources", dernieresRessources);

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}