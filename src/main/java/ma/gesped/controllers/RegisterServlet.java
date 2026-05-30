package ma.gesped.controllers;

import java.io.IOException;
import java.util.List;

import Services.FiliereService;
import Services.SemestreService;
import Services.ServiceResult;
import Services.UtilisateurService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Filiere;
import models.Role;
import models.Semestre;
import models.Utilisateur;
import utils.Constants;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UtilisateurService utilisateurService = new UtilisateurService();
    private final FiliereService filiereService = new FiliereService();
    private final SemestreService semestreService = new SemestreService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Filiere> filieres = filiereService.findAll();
        List<Semestre> semestres = semestreService.findAll();
        req.setAttribute("filieres", filieres);
        req.setAttribute("semestres", semestres);
        req.getRequestDispatcher(Constants.VIEW_REGISTER).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilisateur u = new Utilisateur();
        u.setNom(req.getParameter("nom"));
        u.setPrenom(req.getParameter("prenom"));
        u.setEmail(req.getParameter("email"));
        u.setMotDePasse(req.getParameter("motDePasse"));
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
        }

        String semestreStr = req.getParameter("idSemestre");
        if (semestreStr != null && !semestreStr.isEmpty()) {
            Semestre s = new Semestre();
            s.setIdSemestre(Integer.parseInt(semestreStr));
            u.setSemestre(s);
        }

        ServiceResult<Utilisateur> result = utilisateurService.register(u);

        if (result.isSuccess()) {
            req.setAttribute("success", result.getMessage());
            req.getRequestDispatcher(Constants.VIEW_REGISTER).forward(req, resp);
        } else {
            req.setAttribute("errors", result.getErrors());
            req.setAttribute("utilisateur", u);
            List<Filiere> filieres = filiereService.findAll();
            List<Semestre> semestres = semestreService.findAll();
            req.setAttribute("filieres", filieres);
            req.setAttribute("semestres", semestres);
            req.getRequestDispatcher(Constants.VIEW_REGISTER).forward(req, resp);
        }
    }
}