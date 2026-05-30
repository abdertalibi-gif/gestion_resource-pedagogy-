package Filtres;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Utilisateur;
import utils.Constants;

/**
 * Filtre qui verifie le role de l'utilisateur pour les zones protegees.
 */
@WebFilter(urlPatterns = {
    "/admin/*", "/professeur/*", "/etudiant/*"
})
public class RoleFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        if (session == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        Utilisateur user = (Utilisateur) session.getAttribute(Constants.SESSION_USER);
        String path = httpRequest.getServletPath();

        if (user.getRole() == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        if (path.startsWith("/admin") && !user.getRole().isAdmin()) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acces refuse");
            return;
        }
        if (path.startsWith("/professeur") && !user.getRole().isProfesseur()) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acces refuse");
            return;
        }
        if (path.startsWith("/etudiant") && !user.getRole().isEtudiant()) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acces refuse");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}