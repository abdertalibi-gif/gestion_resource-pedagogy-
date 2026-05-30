<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    request.setAttribute("role", "ETUDIANT");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Mes devoirs");
    request.setAttribute("activeMenu", "devoirs");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes devoirs — GesPed</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/responsive.css?v=1">
</head>
<body class="app-layout">
    <%@ include file="/WEB-INF/includes/sidebar.jsp" %>
    <div class="main-content">
        <%@ include file="/WEB-INF/includes/topbar.jsp" %>

        <div class="content-wrapper">
            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Consultez vos devoirs à rendre.</p>
                </div>
                <i class="fas fa-tasks welcome-icon"></i>
            </div>

            <div class="page-header">
                <h3>Mes devoirs à rendre</h3>
            </div>

            <c:choose>
                <c:when test="${empty devoirs}">
                    <div class="empty-state">
                        <i class="fas fa-tasks fa-3x"></i>
                        <p>Aucun devoir pour le moment.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="cards-grid">
                        <c:forEach var="d" items="${devoirs}">
                            <div class="info-card">
                                <div class="info-card-header">
                                    <span class="badge badge-module">${d.module.codeModule}</span>
                                    <c:if test="${d.depasse}"><span class="badge badge-danger">Dépassé</span></c:if>
                                </div>
                                <h4>${d.titre}</h4>
                                <p><i class="fas fa-chalkboard-teacher"></i> ${d.professeur.nom}</p>
                                <c:if test="${not empty d.description}">
                                    <p class="text-muted">${d.description}</p>
                                </c:if>
                                <div class="card-meta">
                                    <c:if test="${not empty d.dateLimite}">
                                        <small><i class="fas fa-clock"></i> Limite : ${d.dateLimite.toLocalDate()} ${d.dateLimite.toLocalTime()}</small>
                                    </c:if>
                                </div>
                                <div class="card-actions">
                                    <a href="${pageContext.request.contextPath}/etudiant/soumettre?idDevoir=${d.idDevoir}"
                                       class="btn btn-sm btn-primary">
                                        <i class="fas fa-upload"></i> Soumettre
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
