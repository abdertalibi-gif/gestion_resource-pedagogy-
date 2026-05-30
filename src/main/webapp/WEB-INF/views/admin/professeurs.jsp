<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%
    request.setAttribute("role", "ADMIN");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Gestion des professeurs");
    request.setAttribute("activeMenu", "professeurs");
%>
<!DOCTYPE html>

<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des professeurs — GesPed</title>
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
                    <p>Gérez les comptes professeurs de la plateforme.</p>
                </div>
                <i class="fas fa-chalkboard-teacher welcome-icon"></i>
            </div>

            <div class="page-header">
                    <p>G&eacute;rez les comptes professeurs de la plateforme</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/professeurs/ajouter" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Ajouter un professeur
                </a>
            </div>

            <div class="dashboard-section">
                <div class="section-header">
                    <h3><i class="fas fa-chalkboard-teacher"></i> Liste des professeurs <span class="count">${fn:length(professeurs)}</span></h3>
                    <div class="flex gap-8">
                        <input type="text" placeholder="Rechercher..." class="search-input-sm">
                        <button class="btn btn-sm btn-outline"><i class="fas fa-filter"></i> Filtrer</button>
                    </div>
                </div>

                <c:if test="${not empty professeurs}">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Nom complet</th>
                                    <th>Email</th>
                                    <th>Module</th>
                                    <th>Ressources</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${professeurs}">
                                    <tr>
                                        <td>
                                            <div class="prof-name-cell">
                                                <div class="prof-avatar-sm">${p.nom.substring(0,1)}</div>
                                                <div>
                                                    <div class="prof-name-text">${p.prenom} ${p.nom}</div>
                                                    <div class="prof-email">${p.email}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>${p.email}</td>
                                        <td>—</td>
                                        <td>—</td>
                                        <td>
                                            <span class="status-badge ${p.statut == 'ACCEPTE' ? 'status-active' : p.statut == 'EN_ATTENTE' ? 'status-pending' : 'status-inactive'}">
                                                ${p.statutLabel}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="actions-cell">
                                                <a href="${pageContext.request.contextPath}/admin/professeurs/edit?id=${p.idUtilisateur}" class="btn btn-sm btn-outline" title="Modifier">
                                                    <i class="fas fa-pen"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/professeurs/delete?id=${p.idUtilisateur}" class="btn btn-sm btn-danger" title="Supprimer" onclick="return confirm('Supprimer ce professeur ?')">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <c:if test="${empty professeurs}">
                    <div class="empty-state">
                        <div class="empty-state-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                        <div class="empty-state-title">Aucun professeur enregistr&eacute;</div>
                        <div class="empty-state-text">Commencez par ajouter des professeurs pour les g&eacute;rer depuis cette interface.</div>
                    </div>
                </c:if>
            </div>

        </div>
    </div>

    <script>
        const sidebarToggle = document.getElementById('sidebarToggle');
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');
        if(sidebarToggle){sidebarToggle.addEventListener('click',function(){sidebar.classList.toggle('open');overlay.classList.toggle('open')})}
        if(overlay){overlay.addEventListener('click',function(){sidebar.classList.remove('open');overlay.classList.remove('open')})}
    </script>
</body>
</html>