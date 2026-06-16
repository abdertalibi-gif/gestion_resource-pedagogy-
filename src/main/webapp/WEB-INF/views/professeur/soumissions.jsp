<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%
    request.setAttribute("role", "PROFESSEUR");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Soumissions des étudiants");
    request.setAttribute("activeMenu", "soumissions");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Soumissions — GesPed</title>
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
                    <p>Consultez les soumissions de vos étudiants.</p>
                </div>
                <i class="fas fa-check-circle welcome-icon"></i>
            </div>

            <div class="page-header">
                <div><h1>Soumissions des étudiants</h1><p>Consultez les soumissions de vos étudiants</p></div>
            </div>

            <div class="dashboard-section">
                <div class="section-header">
                    <div class="section-header-left">
                        <h3><i class="fas fa-inbox"></i> Liste des soumissions <span class="count">${fn:length(soumissions)}</span></h3>
                    </div>
                    <div class="toolbar">
                        <form method="get" class="filter-form" style="margin:0">
                            <select id="module" name="module" class="form-select" onchange="this.form.submit()">
                                <option value="">Tous les modules</option>
                                <c:forEach var="m" items="${modules}">
                                    <option value="${m.idModule}" ${moduleFilter == m.idModule ? 'selected' : ''}>${m.codeModule} — ${m.nomModule}</option>
                                </c:forEach>
                            </select>
                        </form>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty soumissions}">
                        <div class="table-responsive">
                            <table class="table" id="submissionsTable">
                                <thead>
                                    <tr>
                                        <th>Étudiant</th>
                                        <th>Titre</th>
                                        <th>Module</th>
                                        <th>Fichier</th>
                                        <th>Date</th>
                                        <th>Statut</th>
                                        <th style="text-align:center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="s" items="${soumissions}" varStatus="loop">
                                        <tr>
                                            <td>
                                                <div class="student-name-cell">
                                                    <div class="student-avatar-sm av-${loop.index mod 8}">${s.etudiant.prenom.substring(0,1)}${s.etudiant.nom.substring(0,1)}</div>
                                                    <div class="student-name-text">${s.etudiant.prenom} ${s.etudiant.nom}</div>
                                                </div>
                                            </td>
                                            <td><strong>${s.titre}</strong></td>
                                            <td><span class="filiere-badge"><i class="fas fa-book"></i> ${s.module.codeModule}</span></td>
                                            <td><i class="fas fa-file"></i> ${s.nomFichier} <small style="color:var(--text-muted)">(${s.tailleFormatee})</small></td>
                                            <td>${s.dateSoumission.toLocalDate()} <small style="color:var(--text-muted)">${s.dateSoumission.toLocalTime()}</small></td>
                                            <td><span class="status-badge ${s.statutBadge}">${s.statutLabel}</span></td>
                                            <td>
                                                <div class="actions-cell" style="justify-content:center">
                                                    <a href="${pageContext.request.contextPath}/professeur/soumission/voir?id=${s.idSoumission}" class="action-btn" title="Évaluer"><i class="fas fa-check-circle"></i></a>
                                                    <a href="${pageContext.request.contextPath}/professeur/soumission/telecharger?id=${s.idSoumission}" class="action-btn" title="Voir" target="_blank"><i class="fas fa-eye"></i></a>
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
                            <div class="empty-state-icon"><i class="fas fa-inbox"></i></div>
                            <div class="empty-state-title">Aucune soumission pour le moment</div>
                            <div class="empty-state-text">Les soumissions des étudiants apparaîtront ici une fois qu'ils auront soumis leurs devoirs.</div>
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
    </script>
</body>
</html>
