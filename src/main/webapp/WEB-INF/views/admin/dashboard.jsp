<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    String role = "ADMIN";
    request.setAttribute("role", role);
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Tableau de bord");
    request.setAttribute("activeMenu", "dashboard");

    String msgSuccess = (String) session.getAttribute("msgSuccess");
    String msgError   = (String) session.getAttribute("msgError");
    if (msgSuccess != null) { request.setAttribute("msgSuccess", msgSuccess); session.removeAttribute("msgSuccess"); }
    if (msgError   != null) { request.setAttribute("msgError",   msgError);   session.removeAttribute("msgError");   }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin — GesPed</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Raleway:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/responsive.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css?v=1">
</head>
<body class="app-layout">

    <%@ include file="/WEB-INF/includes/sidebar.jsp" %>

    <!-- ======================== CONTENU PRINCIPAL ======================== -->
    <div class="main-content">

        <!-- TOPBAR -->
        <%@ include file="/WEB-INF/includes/topbar.jsp" %>

        <div class="content-wrapper">

            <!-- Messages flash -->
            <c:if test="${not empty msgSuccess}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${msgSuccess}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>
            <c:if test="${not empty msgError}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${msgError}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Administration de la plateforme GesPed — gérez utilisateurs, modules et ressources.</p>
                </div>
                <i class="fas fa-shield-alt welcome-icon"></i>
            </div>

            <!-- En-tête de page -->
            <div class="page-header">
                <h1>Tableau de bord</h1>
                <p>Vue d'ensemble de la plateforme GesPed</p>
            </div>

            <!-- Cartes statistiques -->
            <div class="stats-cards">
                <div class="stat-card-dashboard grad-deep">
                    <div class="stat-card-icon"><i class="fas fa-users"></i></div>
                    <div class="stat-card-info">
                        <span class="stat-card-number">${nbEtudiants}</span>
                        <span class="stat-card-label">&Eacute;tudiants</span>
                    </div>
                </div>
                <div class="stat-card-dashboard grad-mid">
                    <div class="stat-card-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                    <div class="stat-card-info">
                        <span class="stat-card-number">${nbProfs}</span>
                        <span class="stat-card-label">Professeurs</span>
                    </div>
                </div>
                <div class="stat-card-dashboard grad-bright">
                    <div class="stat-card-icon"><i class="fas fa-book"></i></div>
                    <div class="stat-card-info">
                        <span class="stat-card-number">${nbModules}</span>
                        <span class="stat-card-label">Modules</span>
                    </div>
                </div>
                <div class="stat-card-dashboard grad-teal">
                    <div class="stat-card-icon"><i class="fas fa-file-alt"></i></div>
                    <div class="stat-card-info">
                        <span class="stat-card-number">${nbRessources}</span>
                        <span class="stat-card-label">Ressources</span>
                    </div>
                </div>
                <div class="stat-card-dashboard grad-orange">
                    <div class="stat-card-icon"><i class="fas fa-layer-group"></i></div>
                    <div class="stat-card-info">
                        <span class="stat-card-number">${nbFilieres}</span>
                        <span class="stat-card-label">Fili&egrave;res</span>
                    </div>
                </div>
            </div>

            <!-- Dernières ressources -->
            <div class="dashboard-section">
                <div class="section-header">
                    <h3><i class="fas fa-clock"></i> Derni&egrave;res ressources d&eacute;pos&eacute;es</h3>
                    <a href="${pageContext.request.contextPath}/admin/ressources" class="btn btn-sm btn-outline">
                        <i class="fas fa-arrow-right"></i> Voir tout
                    </a>
                </div>

                <!-- Table avec données -->
                <c:if test="${not empty dernieresRessources}">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Titre</th>
                                    <th>Type</th>
                                    <th>Module</th>
                                    <th>Professeur</th>
                                    <th>Taille</th>
                                    <th>Statut</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${dernieresRessources}">
                                    <tr>
                                        <td>
                                            <div class="table-file">
                                                <i class="fas ${r.iconeType}" style="color:${r.couleurType}"></i>
                                                <span>${r.titre}</span>
                                            </div>
                                        </td>
                                        <td><span class="badge" style="background:${r.couleurType}">${r.type.nomType}</span></td>
                                        <td>${r.module.nomModule}</td>
                                        <td>${r.professeur.nom}</td>
                                        <td>${r.tailleFormatee}</td>
                                        <td>
                                            <span class="status-badge ${r.visible ? 'status-active' : 'status-inactive'}">
                                                ${r.visible ? 'Visible' : 'Masqu&eacute;e'}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <!-- État vide -->
                <c:if test="${empty dernieresRessources}">
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-folder-open"></i>
                        </div>
                        <div class="empty-state-title">Aucune ressource d&eacute;pos&eacute;e</div>
                        <div class="empty-state-text">
                            Les ressources ajout&eacute;es par les professeurs appara&icirc;tront ici automatiquement.
                        </div>
                        <div class="empty-state-action">
                            <a href="${pageContext.request.contextPath}/admin/ressources" class="btn btn-primary btn-sm">
                                <i class="fas fa-plus"></i> G&eacute;rer les ressources
                            </a>
                        </div>
                    </div>
                </c:if>
            </div>

        </div><!-- /content-wrapper -->
    </div><!-- /main-content -->

    <script>
        // Toggle sidebar mobile
        const sidebarToggle = document.getElementById('sidebarToggle');
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');

        if (sidebarToggle) {
            sidebarToggle.addEventListener('click', function() {
                sidebar.classList.toggle('open');
                overlay.classList.toggle('open');
            });
        }
        if (overlay) {
            overlay.addEventListener('click', function() {
                sidebar.classList.remove('open');
                overlay.classList.remove('open');
            });
        }
    </script>

</body>
</html>
