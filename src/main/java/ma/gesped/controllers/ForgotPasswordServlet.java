package ma.gesped.controllers;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Services.AuthService;
import dao.DAOFactory;
import dao.UtilisateurDAO;
import models.Utilisateur;
import utils.Constants;
import utils.PasswordUtil;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private AuthService authService;
    private UtilisateurDAO utilisateurDAO;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
        utilisateurDAO = DAOFactory.getUtilisateurDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher(Constants.VIEW_FORGOT).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if ("reset".equals(action)) {
            handleReset(req, resp);
        } else {
            handleVerify(req, resp);
        }
    }

    private void handleVerify(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email   = req.getParameter("email");
        String nom     = req.getParameter("nom");
        String prenom  = req.getParameter("prenom");
        String cne     = req.getParameter("cne");

        if (email == null || email.trim().isEmpty() ||
            nom == null || nom.trim().isEmpty() ||
            prenom == null || prenom.trim().isEmpty()) {
            req.setAttribute("error", "Veuillez remplir tous les champs d\u2019identification.");
            req.getRequestDispatcher(Constants.VIEW_FORGOT).forward(req, resp);
            return;
        }

        Utilisateur user = authService.verifyIdentity(email.trim(), nom.trim(), prenom.trim(), cne);

        if (user == null) {
            req.setAttribute("error", "Aucun compte ne correspond \u00e0 ces informations.");
            req.getRequestDispatcher(Constants.VIEW_FORGOT).forward(req, resp);
            return;
        }

        req.setAttribute("verified", true);
        req.setAttribute("userId", user.getIdUtilisateur());
        req.setAttribute("userName", user.getPrenom() + " " + user.getNom());
        req.getRequestDispatcher(Constants.VIEW_FORGOT).forward(req, resp);
    }

    private void handleReset(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String userIdStr = req.getParameter("userId");
        String password   = req.getParameter("password");
        String confirm    = req.getParameter("confirm");

        if (userIdStr == null || password == null || confirm == null) {
            req.setAttribute("error", "Donn\u00e9es invalides.");
            req.getRequestDispatcher(Constants.VIEW_FORGOT).forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "Le mot de passe doit contenir au moins 6 caract\u00e8res.");
            req.setAttribute("verified", true);
            req.setAttribute("userId", userIdStr);
            req.getRequestDispatcher(Constants.VIEW_FORGOT).forward(req, resp);
            return;
        }

        if (!password.equals(confirm)) {
            req.setAttribute("error", "Les mots de passe ne correspondent pas.");
            req.setAttribute("verified", true);
            req.setAttribute("userId", userIdStr);
            req.getRequestDispatcher(Constants.VIEW_FORGOT).forward(req, resp);
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            String hashed = PasswordUtil.hash(password);
            utilisateurDAO.updatePassword(userId, hashed);
        } catch (Exception e) {
            req.setAttribute("error", "Erreur lors de la mise \u00e0 jour.");
            req.setAttribute("verified", true);
            req.setAttribute("userId", userIdStr);
            req.getRequestDispatcher(Constants.VIEW_FORGOT).forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/login?reset=success");
    }
}