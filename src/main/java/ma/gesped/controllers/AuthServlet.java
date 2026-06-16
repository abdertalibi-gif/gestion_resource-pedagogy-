package ma.gesped.controllers;

import java.io.IOException;

import Services.AuthService;
import Services.AuthService.AuthResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Utilisateur;
import utils.Constants;

@WebServlet("/login")
public class AuthServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute(Constants.SESSION_USER) != null) {
            redirectByRole(req, (Utilisateur) session.getAttribute(Constants.SESSION_USER), resp);
            return;
        }
        req.getRequestDispatcher(Constants.VIEW_LOGIN).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        AuthResult result = authService.authenticateWithStatus(email, password);

        if (result.isSuccess()) {
            Utilisateur user = result.getUser();
            HttpSession session = req.getSession(true);
            session.setAttribute(Constants.SESSION_USER, user);
            session.setAttribute(Constants.SESSION_ROLE, user.getRole().getNomRole());
            session.setAttribute(Constants.FLASH_SUCCESS,
                "Bienvenue, " + user.getNomComplet() + " !");
            redirectByRole(req, user, resp);
        } else if (result.isInactif()) {
            req.setAttribute("error", "Votre compte est désactivé. Veuillez contacter l'administrateur.");
            req.setAttribute("email", email);
            req.getRequestDispatcher(Constants.VIEW_LOGIN).forward(req, resp);
        } else {
            req.setAttribute("error", "Email ou mot de passe incorrect");
            req.setAttribute("email", email);
            req.getRequestDispatcher(Constants.VIEW_LOGIN).forward(req, resp);
        }
    }

    private void redirectByRole(HttpServletRequest req, Utilisateur user, HttpServletResponse resp)
            throws IOException {
        String ctx = req.getContextPath();
        switch (user.getRole().getNomRole()) {
            case Constants.ROLE_ADMIN:
                resp.sendRedirect(ctx + "/admin/dashboard");
                break;
            case Constants.ROLE_PROFESSEUR:
                resp.sendRedirect(ctx + "/professeur/dashboard");
                break;
            case Constants.ROLE_ETUDIANT:
                resp.sendRedirect(ctx + "/etudiant/dashboard");
                break;
            default:
                resp.sendRedirect(ctx + "/login");
        }
    }
    
}