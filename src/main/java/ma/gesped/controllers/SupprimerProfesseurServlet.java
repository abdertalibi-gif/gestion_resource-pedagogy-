package ma.gesped.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Utilisateur;
import Services.UtilisateurService;
import utils.Constants;
import java.io.IOException;

@WebServlet("/admin/professeurs/delete")
public class SupprimerProfesseurServlet extends HttpServlet {

    private final UtilisateurService utilisateurService = new UtilisateurService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utilisateur admin = (Utilisateur) request.getSession().getAttribute(Constants.SESSION_USER);

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/professeurs");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            HttpSession session = request.getSession();

            if (admin.getIdUtilisateur() == id) {
                session.setAttribute(Constants.FLASH_ERROR,
                    "Vous ne pouvez pas supprimer votre propre compte.");
            } else if (utilisateurService.delete(id)) {
                session.setAttribute(Constants.FLASH_SUCCESS,
                    "Professeur supprimé avec succès.");
            } else {
                session.setAttribute(Constants.FLASH_ERROR,
                    "Impossible de supprimer ce professeur.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute(Constants.FLASH_ERROR, "Identifiant invalide.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/professeurs");
    }
}
