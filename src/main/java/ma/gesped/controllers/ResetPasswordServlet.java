package ma.gesped.controllers;

import dao.DAOFactory;
import dao.ResetTokenDAO;
import dao.UtilisateurDAO;
import models.ResetToken;
import models.Utilisateur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private ResetTokenDAO tokenDAO;
    private UtilisateurDAO utilisateurDAO;

    @Override
    public void init() throws ServletException {
        tokenDAO = DAOFactory.getResetTokenDAO();
        utilisateurDAO = DAOFactory.getUtilisateurDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = req.getParameter("token");

        // Pas de token → rediriger vers forgot
        if (token == null || token.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password?error");
            return;
        }

        try {
            // Vérifier le token
            ResetToken rt = tokenDAO.findByToken(token.trim());

            if (rt == null || !rt.isValide()) {
                // Token invalide ou expiré
                resp.sendRedirect(req.getContextPath() + "/forgot-password?error=expired");
                return;
            }

            // Token valide → afficher le formulaire de reset
            req.setAttribute("token", token.trim());
            req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/forgot-password?error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = req.getParameter("token");
        String nouveauMotDePasse = req.getParameter("newPassword");
        String confirmation = req.getParameter("confirmPassword");

        // Validations
        if (token == null || token.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password?error");
            return;
        }

        if (nouveauMotDePasse == null || nouveauMotDePasse.length() < 6) {
            req.setAttribute("token", token);
            req.setAttribute("errorField", "Le mot de passe doit contenir au moins 6 caractères.");
            req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!nouveauMotDePasse.equals(confirmation)) {
            req.setAttribute("token", token);
            req.setAttribute("errorField", "Les mots de passe ne sont pas identiques.");
            req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
            return;
        }

        try {
            // Vérifier le token
            ResetToken rt = tokenDAO.findByToken(token.trim());

            if (rt == null || !rt.isValide()) {
                resp.sendRedirect(req.getContextPath() + "/forgot-password?error=expired");
                return;
            }

            // Mettre à jour le mot de passe
            utilisateurDAO.updateMotDePasse(rt.getUtilisateurId(), nouveauMotDePasse);

            // Marquer le token comme utilisé
            tokenDAO.marquerUtilise(token.trim());

            // Rediriger vers login avec message de succès
            resp.sendRedirect(req.getContextPath() + "/login?reset=success");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("token", token);
            req.setAttribute("errorField", "Une erreur est survenue. Veuillez réessayer.");
            req.getRequestDispatcher("/reset-password.jsp").forward(req, resp);
        }
    }
}