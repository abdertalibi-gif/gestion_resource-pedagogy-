<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Utilisateur" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%
    request.setAttribute("role", "ETUDIANT");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Tableau de bord");
    request.setAttribute("activeMenu", "dashboard");

    String msgSuccess = (String) session.getAttribute("msgSuccess");
    if (msgSuccess != null) { request.setAttribute("msgSuccess", msgSuccess); session.removeAttribute("msgSuccess"); }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Etudiant — GesPed</title>
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

            <!-- Alert -->
            <c:if test="${not empty msgSuccess}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${msgSuccess}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Retrouvez vos modules et ressources pédagogiques depuis cet espace.</p>
                    <div class="welcome-meta">
                        <c:if test="${not empty utilisateur.filiere}">
                            <span class="badge badge-filiere"><i class="fas fa-layer-group"></i> ${utilisateur.filiere.nomFiliere}</span>
                        </c:if>
                        <c:if test="${not empty utilisateur.semestre}">
                            <span class="badge badge-semestre"><i class="fas fa-calendar-alt"></i> ${utilisateur.semestre.nomSemestre}</span>
                        </c:if>
                    </div>
                </div>
                <i class="fas fa-graduation-cap welcome-icon"></i>
            </div>

            <!-- Stats -->
            <div class="stats-cards">
                <div class="stat-card-dashboard gradient-blue">
                    <div class="stat-card-icon"><i class="fas fa-book"></i></div>
                    <div class="stat-card-info">
                        <span class="stat-card-number ${modules.size() == 0 ? 'zero' : ''}">${modules.size()}</span>
                        <span class="stat-card-label">Mes modules</span>
                    </div>
                </div>
                <div class="stat-card-dashboard gradient-green">
                    <div class="stat-card-icon"><i class="fas fa-file-alt"></i></div>
                    <div class="stat-card-info">
                        <span class="stat-card-number ${recentes.size() == 0 ? 'zero' : ''}">${recentes.size()}</span>
                        <span class="stat-card-label">Ressources r&eacute;centes</span>
                    </div>
                </div>
                <div class="stat-card-dashboard gradient-orange">
                    <div class="stat-card-icon"><i class="fas fa-star"></i></div>
                    <div class="stat-card-info">
                        <span class="stat-card-number ${nbFavoris == 0 ? 'zero' : ''}">${nbFavoris}</span>
                        <span class="stat-card-label">Favoris</span>
                    </div>
                </div>
                <div class="stat-card-dashboard gradient-purple">
                    <div class="stat-card-icon"><i class="fas fa-history"></i></div>
                    <div class="stat-card-info">
                        <span class="stat-card-number ${nbConsultations == 0 ? 'zero' : ''}">${nbConsultations}</span>
                        <span class="stat-card-label">Consultations</span>
                    </div>
                </div>
            </div>

            <!-- ★ Mes modules — Empty state stylisé ★ -->
            <div class="dashboard-section">
                <div class="section-header">
                    <h3><i class="fas fa-book"></i> Mes modules</h3>
                    <a href="${pageContext.request.contextPath}/etudiant/modules" class="btn btn-sm btn-outline">
                        <i class="fas fa-arrow-right"></i> Voir tout
                    </a>
                </div>
                <div class="cards-grid">
                    <c:forEach var="m" items="${modules}">
                        <a href="${pageContext.request.contextPath}/etudiant/ressources?module=${m.idModule}"
                           class="info-card clickable">
                            <div class="info-card-header">
                                <span class="badge badge-module">${m.codeModule}</span>
                            </div>
                            <h4>${m.nomModule}</h4>
                            <p><i class="fas fa-chalkboard-teacher"></i> ${m.nomProfesseur != null ? m.nomProfesseur : 'Professeur non assigné'}</p>
                            <p class="text-muted">${m.filiere.nomFiliere} — ${m.semestre.nomSemestre}</p>
                        </a>
                    </c:forEach>
                    <c:if test="${empty modules}">
                        <div class="empty-state">
                            <div class="empty-state-icon">
                                <i class="fas fa-book-open"></i>
                            </div>
                            <div class="empty-state-title">Aucun module disponible</div>
                            <div class="empty-state-text">
                                Votre fili&egrave;re n'a pas encore de modules assign&eacute;s.
                                Contactez l'administrateur pour plus d'informations.
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- ★ Ressources récentes — Empty state stylisé ★ -->
            <div class="dashboard-section">
                <div class="section-header">
                    <h3><i class="fas fa-clock"></i> Ressources r&eacute;centes</h3>
                    <a href="${pageContext.request.contextPath}/etudiant/ressources" class="btn btn-sm btn-outline">
                        <i class="fas fa-arrow-right"></i> Voir tout
                    </a>
                </div>
                <div class="cards-grid">
                    <c:forEach var="r" items="${recentes}">
                        <div class="resource-card">
                            <div class="resource-card-icon" style="color:${r.couleurType}; background: ${r.couleurType}15;">
                                <i class="fas ${r.iconeType}"></i>
                            </div>
                            <div class="resource-card-body">
                                <h4>${r.titre}</h4>
                                <p>${r.module.nomModule} — ${r.professeur.nom}</p>
                                <div class="resource-card-meta">
                                    <span class="badge" style="background:${r.couleurType}">${r.type.nomType}</span>
                                    <span class="resource-size">${r.tailleFormatee}</span>
                                </div>
                            </div>
                            <div class="resource-card-actions">
                                <a href="${pageContext.request.contextPath}/etudiant/ressource/voir?id=${r.idRessource}"
                                   class="btn-action btn-view" title="Voir"><i class="fas fa-eye"></i></a>
                                <a href="${pageContext.request.contextPath}/etudiant/favori/ajouter?id=${r.idRessource}"
                                   class="btn-action btn-fav" title="Favoris"><i class="fas fa-star"></i></a>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty recentes}">
                        <div class="empty-state resource-empty-state">
                            <div class="empty-state-icon">
                                <i class="fas fa-folder-open"></i>
                            </div>
                            <div class="empty-state-title">Aucune ressource r&eacute;cente</div>
                            <div class="empty-state-text">
                                Vos professeurs n'ont pas encore d&eacute;pos&eacute; de ressources
                                pour vos modules. Revenez plus tard !
                            </div>
                            <div class="empty-state-link">
                                <a href="${pageContext.request.contextPath}/etudiant/modules" class="btn btn-sm btn-outline">
                                    <i class="fas fa-book"></i> Voir mes modules
                                </a>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>
