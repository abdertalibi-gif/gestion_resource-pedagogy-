<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Utilisateur" %>

<%
    request.setAttribute("role", "PROFESSEUR");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Mes ressources");
    request.setAttribute("activeMenu", "ressources");
    String msgSuccess = (String) session.getAttribute("msgSuccess");
    if (msgSuccess != null) { request.setAttribute("msgSuccess", msgSuccess); session.removeAttribute("msgSuccess"); }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes ressources — GesPed</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Raleway:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/responsive.css?v=1">
</head>
<body class="app-layout">
    <%@ include file="/WEB-INF/includes/sidebar.jsp" %>
    <div class="main-content">
        <%@ include file="/WEB-INF/includes/topbar.jsp" %>
        <div class="content-wrapper">
            <c:if test="${not empty msgSuccess}">
                <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${msgSuccess}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div>
            </c:if>
            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Gérez vos ressources déposées.</p>
                </div>
                <i class="fas fa-file-alt welcome-icon"></i>
            </div>

            <div class="page-header">
                <h3>Mes ressources</h3>
                <a href="${pageContext.request.contextPath}/professeur/ressource/ajouter" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Deposer une ressource</a>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr><th>Titre</th><th>Type</th><th>Module</th><th>Taille</th><th>Statut</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${ressources}">
                            <tr>
                                <td><div class="table-file"><i class="fas ${r.iconeType}" style="color:${r.couleurType}"></i>${r.titre}</div></td>
                                <td><span class="badge" style="background:${r.couleurType}">${r.type.nomType}</span></td>
                                <td>${r.module.nomModule}</td>
                                <td>${r.tailleFormatee}</td>
                                <td><span class="status-badge ${r.visible ? 'status-active' : 'status-inactive'}">${r.visible ? 'Visible' : 'Masquee'}</span></td>
                                <td>
                                    <div class="table-actions">
                                        <a href="${pageContext.request.contextPath}/professeur/ressource/modifier?id=${r.idRessource}"
                                           class="btn-action btn-edit"><i class="fas fa-edit"></i></a>
                                        <a href="${pageContext.request.contextPath}/professeur/ressource/supprimer?id=${r.idRessource}"
                                           class="btn-action btn-delete"
                                           onclick="return confirm('Supprimer cette ressource ?')"><i class="fas fa-trash"></i></a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty ressources}">
                            <tr><td colspan="6" class="text-center text-muted">Aucune ressource</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>