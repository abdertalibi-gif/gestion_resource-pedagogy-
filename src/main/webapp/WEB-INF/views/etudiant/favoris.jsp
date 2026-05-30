<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Utilisateur" %>
<%@ page import="utils.DateUtil" %>

<%
    request.setAttribute("role", "ETUDIANT");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Mes favoris");
    request.setAttribute("activeMenu", "favoris");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Favoris — GesPed</title>

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
                    <p>Retrouvez vos ressources favorites.</p>
                </div>
                <i class="fas fa-star welcome-icon"></i>
            </div>

            <div class="page-header"><h3><i class="fas fa-star"></i> Mes favoris</h3></div>
            <div class="cards-grid">
                <c:forEach var="fav" items="${favoris}">
                    <div class="resource-card">
                        <div class="resource-card-icon" style="color:${fav.ressource.couleurType};background:${fav.ressource.couleurType}15;">
                            <i class="fas ${fav.ressource.iconeType}"></i>
                        </div>
                        <div class="resource-card-body">
                            <h4>${fav.ressource.titre}</h4>
								<p class="resource-meta-text">
								    ${fav.ressource.module.nomModule}
								    — Ajouté le ${fav.dateAjout}
								</p>                            
								<div class="resource-card-meta">
								
                                <span class="badge" style="background:${fav.ressource.couleurType}">${fav.ressource.type.nomType}</span>
                            </div>
                        </div>
                        <div class="resource-card-actions">
                            <a href="${pageContext.request.contextPath}/etudiant/ressource/voir?id=${fav.ressource.idRessource}"
                               class="btn-action btn-view"><i class="fas fa-eye"></i></a>
                            <a href="${pageContext.request.contextPath}/etudiant/ressource/telecharger?id=${fav.ressource.idRessource}"
                               class="btn-action btn-download"><i class="fas fa-download"></i></a>
                            <a href="${pageContext.request.contextPath}/etudiant/favori/retirer?id=${fav.ressource.idRessource}"
                               class="btn-action btn-fav-active" title="Retirer des favoris"><i class="fas fa-star"></i></a>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty favoris}">
                    <div class="empty-state" style="grid-column:1/-1;">
                        <i class="fas fa-star"></i><h4>Aucun favori</h4>
                        <p>Vous n'avez pas encore ajoute de ressources en favori</p>
                        <a href="${pageContext.request.contextPath}/etudiant/ressources" class="btn btn-primary">Parcourir les ressources</a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>