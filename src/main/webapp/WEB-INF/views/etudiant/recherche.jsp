<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    request.setAttribute("role", "ETUDIANT");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Recherche");
    request.setAttribute("activeMenu", "recherche");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recherche — GesPed</title>

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
                    <p>Recherchez des ressources par mot-clé, module ou professeur.</p>
                </div>
                <i class="fas fa-search welcome-icon"></i>
            </div>

            <div class="page-header"><h3><i class="fas fa-search"></i> Recherche de ressources</h3></div>

            <form method="get" action="${pageContext.request.contextPath}/etudiant/recherche" class="filter-bar" style="margin-bottom:24px;">
                <div style="display:flex;gap:10px;flex:1;max-width:500px;">
                    <input type="text" name="q" value="${keyword}" placeholder="Rechercher par titre, module, description..."
                           class="form-control" style="flex:1;padding:10px 14px;border:2px solid var(--border-color);border-radius:var(--radius-md);font-size:14px;">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> Rechercher</button>
                </div>
            </form>

            <c:if test="${not empty keyword}">
                <p style="margin-bottom:20px;color:var(--text-secondary);font-size:14px;">
                    <strong>${resultats.size()}</strong> resultat(s) pour "<strong>${keyword}</strong>"
                </p>
            </c:if>

            <div class="cards-grid">
                <c:forEach var="r" items="${resultats}">
                    <div class="resource-card">
                        <div class="resource-card-icon" style="color:${r.couleurType};background:${r.couleurType}15;">
                            <i class="fas ${r.iconeType}"></i>
                        </div>
                        <div class="resource-card-body">
                            <h4>${r.titre}</h4>
                            <p class="resource-meta-text">${r.module.nomModule} — ${r.professeur.nom}</p>
                            <div class="resource-card-meta">
                                <span class="badge" style="background:${r.couleurType}">${r.type.nomType}</span>
                                <span class="resource-size">${r.tailleFormatee}</span>
                            </div>
                        </div>
                        <div class="resource-card-actions">
                            <a href="${pageContext.request.contextPath}/etudiant/ressource/voir?id=${r.idRessource}"
                               class="btn-action btn-view"><i class="fas fa-eye"></i></a>
                            <a href="${pageContext.request.contextPath}/etudiant/ressource/telecharger?id=${r.idRessource}"
                               class="btn-action btn-download"><i class="fas fa-download"></i></a>
                            <a href="${pageContext.request.contextPath}/etudiant/favori/ajouter?id=${r.idRessource}"
                               class="btn-action btn-fav"><i class="far fa-star"></i></a>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty resultats and not empty keyword}">
                    <div class="empty-state" style="grid-column:1/-1;">
                        <i class="fas fa-search"></i><h4>Aucun resultat</h4>
                        <p>Essayez avec d'autres mots-cles</p>
                    </div>
                </c:if>
                <c:if test="${empty keyword}">
                    <div class="empty-state" style="grid-column:1/-1;">
                        <i class="fas fa-search"></i><h4>Entrez un terme de recherche</h4>
                        <p>Recherchez par titre, module, description...</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>