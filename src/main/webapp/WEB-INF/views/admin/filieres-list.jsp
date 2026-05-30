<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Utilisateur" %>

<%
    request.setAttribute("role", "ADMIN");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Gestion des filieres");
    request.setAttribute("activeMenu", "filieres");
    String msgSuccess = (String) session.getAttribute("msgSuccess");
    if (msgSuccess != null) { request.setAttribute("msgSuccess", msgSuccess); session.removeAttribute("msgSuccess"); }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Filieres — GesPed</title>
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
                    <p>Gérez les filières de l'établissement.</p>
                </div>
                <i class="fas fa-layer-group welcome-icon"></i>
            </div>

            <div class="page-header">
                <h3>Gestion des filieres</h3>
                <a href="${pageContext.request.contextPath}/admin/filiere/ajouter" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Ajouter une filiere
                </a>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead><tr><th>Filiere</th><th>Description</th><th>Actions</th></tr></thead>
                    <tbody>
                        <c:forEach var="f" items="${filieres}">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/filiere/voir?id=${f.idFiliere}"
                                       style="color:var(--teal-dark);font-weight:700;">
                                        <i class="fas fa-layer-group" style="margin-right:6px;color:var(--teal-mid)"></i>
                                        ${f.nomFiliere}
                                    </a>
                                </td>
                                <td>${not empty f.description ? f.description : '—'}</td>
                                <td>
                                    <div class="table-actions">
                                        <a href="${pageContext.request.contextPath}/admin/filiere/voir?id=${f.idFiliere}"
                                           class="btn-action" title="Voir semestres et modules"
                                           style="background:var(--teal-light);color:var(--teal-dark)">
                                            <i class="fas fa-sitemap"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/filiere/modifier?id=${f.idFiliere}"
                                           class="btn-action btn-edit" title="Modifier"><i class="fas fa-edit"></i></a>
                                        <a href="${pageContext.request.contextPath}/admin/filiere/supprimer?id=${f.idFiliere}"
                                           class="btn-action btn-delete" title="Supprimer"
                                           onclick="return confirm('Supprimer cette filiere ?')"><i class="fas fa-trash"></i></a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>