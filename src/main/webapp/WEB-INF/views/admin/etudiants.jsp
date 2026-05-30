<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%
    request.setAttribute("role", "ADMIN");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Gestion des étudiants");
    request.setAttribute("activeMenu", "etudiants");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des étudiants — GesPed</title>
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
            <c:if test="${not empty msgSuccess}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${msgSuccess}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>
            <c:if test="${not empty msgError}"><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${msgError}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Gérez les comptes étudiants de la plateforme.</p>
                </div>
                <i class="fas fa-users welcome-icon"></i>
            </div>

            <div class="page-header">
                <div><h1>&Eacute;tudiants</h1><p>G&eacute;rez les comptes &eacute;tudiants de la plateforme</p></div>
                <a href="${pageContext.request.contextPath}/admin/etudiants/ajouter" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Ajouter un &eacute;tudiant
                </a>
            </div>

            <div class="dashboard-section">
                <div class="section-header">
                    <div class="section-header-left">
                        <h3><i class="fas fa-users"></i> Liste des &eacute;tudiants <span class="count">${fn:length(etudiants)}</span></h3>
                    </div>
                    <div class="toolbar">
                        <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Rechercher un &eacute;tudiant..." oninput="filterTable()"></div>
                        <button class="btn btn-sm btn-outline"><i class="fas fa-filter"></i> Filtrer</button>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty etudiants}">
                        <div class="table-responsive">
                            <table class="table" id="studentsTable">
                                <thead>
                                    <tr>
                                        <th>Nom complet</th>
                                        <th>Email</th>
                                        <th>Fili&egrave;re</th>
                                        <th>Statut</th>
                                        <th style="text-align:center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="e" items="${etudiants}" varStatus="loop">
                                        <tr>
                                            <td>
                                                <div class="student-name-cell">
                                                    <div class="student-avatar-sm av-${loop.index mod 8}">${e.nom.substring(0,1)}</div>
                                                    <div class="student-name-text">${e.prenom} ${e.nom}</div>
                                                </div>
                                            </td>
                                            <td class="email-cell"><i class="fas fa-envelope"></i> ${e.email}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${e.filiere != null}">
                                                        <span class="filiere-badge"><i class="fas fa-graduation-cap"></i> ${e.filiere.nomFiliere}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="filiere-badge filiere-none"><i class="fas fa-minus-circle"></i> Non assign&eacute;</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="status-badge ${e.statut == 'ACCEPTE' ? 'status-active' : e.statut == 'EN_ATTENTE' ? 'status-pending' : 'status-inactive'}">
                                                    ${e.statutLabel}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="actions-cell" style="justify-content:center">
                                                    <a href="${pageContext.request.contextPath}/admin/etudiants/edit?id=${e.idUtilisateur}" class="action-btn" title="Modifier"><i class="fas fa-pen"></i></a>
                                                    <a href="${pageContext.request.contextPath}/admin/etudiants/delete?id=${e.idUtilisateur}" class="action-btn danger" title="Supprimer" onclick="return confirm('Supprimer cet \u00e9tudiant ?')"><i class="fas fa-trash-alt"></i></a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-icon"><i class="fas fa-user-graduate"></i></div>
                            <div class="empty-state-title">Aucun &eacute;tudiant enregistr&eacute;</div>
                            <div class="empty-state-text">Commencez par ajouter des &eacute;tudiants pour les g&eacute;rer depuis cette interface.</div>
                            <a href="${pageContext.request.contextPath}/admin/etudiants/ajouter" class="btn btn-primary" style="margin-top:18px"><i class="fas fa-plus"></i> Ajouter un &eacute;tudiant</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <script>
        var sidebarToggle = document.getElementById('sidebarToggle'),
            sidebar = document.getElementById('sidebar'),
            overlay = document.getElementById('sidebarOverlay');
        if (sidebarToggle) sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('open');
            overlay.classList.toggle('open');
        });
        if (overlay) overlay.addEventListener('click', function() {
            sidebar.classList.remove('open');
            overlay.classList.remove('open');
        });
        function filterTable() {
            var q = document.getElementById('searchInput').value.toLowerCase();
            document.querySelectorAll('#studentsTable tbody tr').forEach(function(r) {
                r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none';
            });
        }
    </script>
</body>
</html>
