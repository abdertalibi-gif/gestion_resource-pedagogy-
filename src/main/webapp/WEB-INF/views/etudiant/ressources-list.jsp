<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("role", "ETUDIANT");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Ressources pedagogiques");
    request.setAttribute("activeMenu", "ressources");

    String msgSuccess = (String) session.getAttribute("msgSuccess");
    if (msgSuccess != null) { request.setAttribute("msgSuccess", msgSuccess); session.removeAttribute("msgSuccess"); }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ressources — GesPed</title>

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

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Retrouvez toutes les ressources pédagogiques.</p>
                </div>
                <i class="fas fa-folder-open welcome-icon"></i>
            </div>

            <div class="page-header">
                <h3>Ressources pedagogiques</h3>
                <a href="${pageContext.request.contextPath}/etudiant/recherche" class="btn btn-outline">
                    <i class="fas fa-search"></i> Recherche avancee
                </a>
            </div>

            <!-- Filtres par type -->
            <div class="filter-bar">
                <div class="filter-chips">
                    <a href="${pageContext.request.contextPath}/etudiant/ressources"
                       class="chip ${empty typeFilter ? 'chip-active' : ''}">Tous</a>
                    <c:forEach var="t" items="${types}">
                        <a href="${pageContext.request.contextPath}/etudiant/ressources?type=${t.nomType}${not empty moduleFilter ? '&module=' : ''}${moduleFilter}"
                           class="chip ${typeFilter == t.nomType ? 'chip-active' : ''}">
                            ${t.nomType}
                        </a>
                    </c:forEach>
                </div>
            </div>

            <!-- Liste des ressources -->
            <div class="cards-grid">
                <c:forEach var="r" items="${ressources}">
                    <div class="resource-card">
                        <div class="resource-card-icon" style="color:${r.couleurType}; background: ${r.couleurType}15;">
                            <i class="fas ${r.iconeType}"></i>
                        </div>
                        <div class="resource-card-body">
                            <h4>${r.titre}</h4>
                            <p class="resource-desc">${r.description}</p>
                            <p class="resource-meta-text">${r.module.nomModule} — ${r.module.codeModule}</p>
                            <p class="resource-meta-text"><i class="fas fa-user"></i> ${r.professeur.nom}</p>
                            <div class="resource-card-meta">
                                <span class="badge" style="background:${r.couleurType}">${r.type.nomType}</span>
                                <span class="resource-size">${r.tailleFormatee}</span>
                                <span class="resource-semestre">${r.module.semestre.nomSemestre}</span>
                            </div>
                        </div>
                        <div class="resource-card-actions">
                            <a href="${pageContext.request.contextPath}/etudiant/ressource/voir?id=${r.idRessource}"
                               class="btn-action btn-view" title="Voir"><i class="fas fa-eye"></i></a>
                            <a href="${pageContext.request.contextPath}/etudiant/ressource/telecharger?id=${r.idRessource}"
                               class="btn-action btn-download" title="Telecharger"><i class="fas fa-download"></i></a>
                            <c:choose>
                                <c:when test="${r.estFavori}">
                                    <a href="${pageContext.request.contextPath}/etudiant/favori/retirer?id=${r.idRessource}"
                                       class="btn-action btn-fav-active" title="Retirer des favoris"><i class="fas fa-star"></i></a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/etudiant/favori/ajouter?id=${r.idRessource}"
                                       class="btn-action btn-fav" title="Ajouter aux favoris"><i class="far fa-star"></i></a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty ressources}">
                    <p class="text-center text-muted" style="grid-column:1/-1;">Aucune ressource trouvee</p>
                </c:if>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>