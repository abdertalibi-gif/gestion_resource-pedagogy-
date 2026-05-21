package ma.gesped.controllers;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.Constants;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher(Constants.VIEW_FORGOT).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Veuillez saisir votre adresse email.");
            req.getRequestDispatcher(Constants.VIEW_FORGOT).forward(req, resp);
            return;
        }

        // TEMPORAIREMENT COMMENTÉ — à décommenter quand AuthService sera prêt
        // Services.AuthService authService = new Services.AuthService();
        // authService.sendResetToken(email);

        req.setAttribute("success",
            "Si un compte existe avec cet email, un lien de r\u00e9initialisation a \u00e9t\u00e9 envoy\u00e9.");
        req.getRequestDispatcher(Constants.VIEW_FORGOT).forward(req, resp);
    }
}