<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="models.Utilisateur" %>
<%@ page import="models.HistoriqueConsultation" %>
<%@ page import="utils.DateUtil" %>
<%
    request.setAttribute("role", "ETUDIANT");
    request.setAttribute("nomComplet", ((Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Historique");
    request.setAttribute("activeMenu", "historique");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique — GesPed</title>
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
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Consultez votre historique de consultations.</p>
                </div>
                <i class="fas fa-history welcome-icon"></i>
            </div>
            <div class="page-header"><h3><i class="fas fa-history"></i> Mon historique</h3></div>
            <div class="cards-grid">
                <c:forEach var="h" items="${historique}">
                    <div class="resource-card">
                        <div class="resource-card-icon" style="color:${h.ressource.couleurType};background:${h.ressource.couleurType}15;">
                            <i class="fas ${h.ressource.iconeType}"></i>
                        </div>
                        <div class="resource-card-body">
                            <h4>${h.ressource.titre}</h4>
                            <p class="resource-meta-text">${h.ressource.module.nomModule} — ${h.ressource.type.nomType}</p>
                            <div class="resource-card-meta">
                                <span class="historique-action-badge">${h.typeAction}</span>
                                <span class="resource-size">${DateUtil.tempsEcoule(h.dateConsultation)}</span>
                            </div>
                        </div>
                        <div class="resource-card-actions">
                            <a href="${pageContext.request.contextPath}/etudiant/ressource/voir?id=${h.ressource.idRessource}"
                               class="btn-action btn-view" title="Voir"><i class="fas fa-eye"></i></a>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty historique}">
                    <div class="empty-state" style="grid-column:1/-1;">
                        <i class="fas fa-history"></i>
                        <h4>Aucun historique</h4>
                        <p>Votre historique de consultations apparaitra ici</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>