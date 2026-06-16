<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Utilisateur" %>

<%
    request.setAttribute("role", "ETUDIANT");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Vue ressource");
    request.setAttribute("activeMenu", "ressources");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Consultez les ressources pédagogiques.</p>
                </div>
                <i class="fas fa-file-alt welcome-icon"></i>
            </div>

            <div class="page-header">
                <a href="${pageContext.request.contextPath}/etudiant/ressources" class="btn btn-outline btn-sm">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
            </div>

            <div class="resource-view-card">
                <div class="resource-view-header">
                    <div class="resource-view-icon" style="color:${ressource.couleurType}; background:${ressource.couleurType}15;">
                        <i class="fas ${ressource.iconeType}"></i>
                    </div>
                    <div class="resource-view-info">
                        <h2>${ressource.titre}</h2>
                        <p>${ressource.description}</p>
                        <div class="resource-view-meta">
                            <span class="badge" style="background:${ressource.couleurType}">${ressource.type.nomType}</span>
                            <span><i class="fas fa-book"></i> ${ressource.module.nomModule}</span>
                            <span><i class="fas fa-user"></i> ${ressource.professeur.nom}</span>
                            <span><i class="fas fa-hdd"></i> ${ressource.tailleFormatee}</span>
                            <span><i class="fas fa-eye"></i> ${ressource.nombreConsultations} consultations</span>
                        </div>
                    </div>
                    <div class="resource-view-actions">
                        <a href="${pageContext.request.contextPath}/etudiant/ressource/telecharger?id=${ressource.idRessource}"
                           class="btn btn-primary btn-download-action">
                            <i class="fas fa-download"></i> Télécharger
                        </a>
                        <c:choose>
                            <c:when test="${ressource.estFavori}">
                                <a href="${pageContext.request.contextPath}/etudiant/favori/retirer?id=${ressource.idRessource}"
                                   class="btn btn-fav-active">
                                    <i class="fas fa-star"></i> Dans les favoris
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/etudiant/favori/ajouter?id=${ressource.idRessource}"
                                   class="btn btn-fav-inactive">
                                    <i class="far fa-star"></i> Ajouter aux favoris
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Zone de previsualisation -->
                <div class="resource-preview">
                    <c:choose>
                        <c:when test="${ressource.type.nomType == 'PDF'}">
                            <iframe src="${pageContext.request.contextPath}${ressource.cheminFichier}"
                                    width="100%" height="700px" style="border:none; border-radius:8px;">
                            </iframe>
                        </c:when>
                        <c:when test="${ressource.type.nomType == 'VIDEO'}">
                            <video controls width="100%" style="border-radius:8px; max-height:500px;">
                                <source src="${pageContext.request.contextPath}${ressource.cheminFichier}" type="video/mp4">
                                Votre navigateur ne supporte pas la lecture video.
                            </video>
                        </c:when>
                        <c:otherwise>
                            <div class="preview-fallback">
                                <i class="fas ${ressource.iconeType}" style="font-size:4rem; color:${ressource.couleurType};"></i>
                                <p>Apercu non disponible pour ce type de fichier</p>
                                <a href="${pageContext.request.contextPath}/etudiant/ressource/telecharger?id=${ressource.idRessource}"
                                   class="btn btn-primary">
                                    <i class="fas fa-download"></i> Telecharger le fichier
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>