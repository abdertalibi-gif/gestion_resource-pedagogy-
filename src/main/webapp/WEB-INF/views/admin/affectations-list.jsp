<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Utilisateur" %>

<%
    request.setAttribute("role", "ADMIN");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Gestion des affectations");
    request.setAttribute("activeMenu", "affectations");
    String msgSuccess = (String) session.getAttribute("msgSuccess");
    String msgError = (String) session.getAttribute("msgError");
    if (msgSuccess != null) { request.setAttribute("msgSuccess", msgSuccess); session.removeAttribute("msgSuccess"); }
    if (msgError != null) { request.setAttribute("msgError", msgError); session.removeAttribute("msgError"); }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Affectations — GesPed</title>
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
            <c:if test="${not empty msgError}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${msgError}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div>
            </c:if>
            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Gérez les affectations professeurs-modules.</p>
                </div>
                <i class="fas fa-link welcome-icon"></i>
            </div>

            <div class="page-header">
                <h3>Affectations professeurs / modules</h3>
                <a href="${pageContext.request.contextPath}/admin/affectation/ajouter" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Nouvelle affectation</a>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr><th>Professeur</th><th>Module</th><th>Filiere</th><th>Semestre</th><th>Annee</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${affectations}">
                            <tr>
                                <td><strong>${a.professeur.nom}</strong><br><small class="text-muted">${a.professeur.email}</small></td>
                                <td><span class="badge badge-module">${a.module.codeModule}</span> ${a.module.nomModule}</td>
                                <td>${a.module.filiere.nomFiliere}</td>
                                <td>${a.module.semestre.nomSemestre}</td>
                                <td>${a.anneeUniversitaire}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/affectation/supprimer?id=${a.idAffectation}"
                                       class="btn-action btn-delete" title="Supprimer"
                                       onclick="return confirm('Supprimer cette affectation ?')"><i class="fas fa-trash"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty affectations}">
                            <tr><td colspan="6" class="text-center text-muted">Aucune affectation</td></tr>
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