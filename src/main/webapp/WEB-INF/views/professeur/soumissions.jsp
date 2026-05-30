<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
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
            <c:if test="${not empty msgError}">
                <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${msgError}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Consultez les soumissions de vos étudiants.</p>
                </div>
                <i class="fas fa-check-circle welcome-icon"></i>
            </div>

            <div class="page-header">
                <h3>Soumissions des étudiants</h3>
            </div>

            <!-- Filtre par module -->
            <div class="filter-bar">
                <form method="get" class="filter-form">
                    <div class="filter-group">
                        <label for="module">Filtrer par module :</label>
                        <select id="module" name="module" class="form-control" onchange="this.form.submit()">
                            <option value="">Tous les modules</option>
                            <c:forEach var="m" items="${modules}">
                                <option value="${m.idModule}" ${moduleFilter == m.idModule ? 'selected' : ''}>${m.codeModule} — ${m.nomModule}</option>
                            </c:forEach>
                        </select>
                    </div>
                </form>
            </div>

            <c:choose>
                <c:when test="${empty soumissions}">
                    <div class="empty-state">
                        <i class="fas fa-inbox fa-3x"></i>
                        <p>Aucune soumission pour le moment.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Étudiant</th>
                                    <th>Titre</th>
                                    <th>Module</th>
                                    <th>Fichier</th>
                                    <th>Date</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${soumissions}">
                                    <tr>
                                        <td><strong>${s.etudiant.nom}</strong></td>
                                        <td>${s.titre}</td>
                                        <td>${s.module.codeModule}</td>
                                        <td>${s.nomFichier} <small>(${s.tailleFormatee})</small></td>
                                        <td>${s.dateSoumission.toLocalDate()} <small>${s.dateSoumission.toLocalTime()}</small></td>
                                        <td><span class="badge ${s.statutBadge}">${s.statutLabel}</span></td>
                                        <td class="actions-cell">
                                            <a href="${pageContext.request.contextPath}/professeur/soumission/voir?id=${s.idSoumission}"
                                               class="btn btn-sm btn-primary">
                                                <i class="fas fa-check-circle"></i> Évaluer
                                            </a>
                                            <a href="${pageContext.request.contextPath}/professeur/soumission/telecharger?id=${s.idSoumission}"
                                               class="btn btn-sm btn-outline" target="_blank">
                                                <i class="fas fa-eye"></i> Voir
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
