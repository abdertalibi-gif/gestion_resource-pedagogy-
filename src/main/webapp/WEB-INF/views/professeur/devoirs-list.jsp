<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    request.setAttribute("role", "PROFESSEUR");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Devoirs");
    request.setAttribute("activeMenu", "devoirs");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Devoirs — GesPed</title>
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
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>
            <c:if test="${not empty msgError}">
                <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${msgError}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Gérez les devoirs de vos modules.</p>
                </div>
                <i class="fas fa-tasks welcome-icon"></i>
            </div>

            <div class="page-header">
                <h3>Mes devoirs</h3>
                <a href="${pageContext.request.contextPath}/professeur/devoir/ajouter" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Nouveau devoir
                </a>
            </div>

            <c:choose>
                <c:when test="${empty devoirs}">
                    <div class="empty-state">
                        <i class="fas fa-tasks fa-3x"></i>
                        <p>Aucun devoir créé pour le moment.</p>
                        <a href="${pageContext.request.contextPath}/professeur/devoir/ajouter" class="btn btn-primary">Créer un devoir</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Titre</th>
                                    <th>Module</th>
                                    <th>Date limite</th>
                                    <th>Soumissions</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="d" items="${devoirs}">
                                    <tr>
                                        <td><strong>${d.titre}</strong></td>
                                        <td>${d.module.codeModule}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty d.dateLimite}">
                                                    ${d.dateLimite.toLocalDate()} <small>${d.dateLimite.toLocalTime()}</small>
                                                    <c:if test="${d.depasse}"><span class="badge badge-danger">Dépassé</span></c:if>
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><span class="badge badge-info">${d.nbSoumissions}</span></td>
                                        <td class="actions-cell">
                                            <a href="${pageContext.request.contextPath}/professeur/devoir/voir?id=${d.idDevoir}"
                                               class="btn btn-sm btn-primary">
                                                <i class="fas fa-eye"></i> Détail
                                            </a>
                                            <a href="${pageContext.request.contextPath}/professeur/devoir/supprimer?id=${d.idDevoir}"
                                               class="btn btn-sm btn-danger"
                                               onclick="return confirm('Supprimer ce devoir ?')">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
