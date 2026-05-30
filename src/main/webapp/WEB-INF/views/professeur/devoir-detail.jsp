<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    request.setAttribute("role", "PROFESSEUR");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Détail devoir");
    request.setAttribute("activeMenu", "devoirs");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${devoir.titre} — GesPed</title>
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
                    <p>Détails du devoir et soumissions.</p>
                </div>
                <i class="fas fa-eye welcome-icon"></i>
            </div>

            <div class="page-header">
                <h3>${devoir.titre}</h3>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/professeur/devoirs" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                    <a href="${pageContext.request.contextPath}/professeur/devoir/supprimer?id=${devoir.idDevoir}"
                       class="btn btn-danger"
                       onclick="return confirm('Supprimer ce devoir ?')">
                        <i class="fas fa-trash"></i> Supprimer
                    </a>
                </div>
            </div>

            <div class="detail-grid">
                <div class="card">
                    <div class="card-header"><h4>Informations</h4></div>
                    <div class="card-body">
                        <div class="detail-row">
                            <span class="detail-label">Module</span>
                            <span class="detail-value">${devoir.module.codeModule} — ${devoir.module.nomModule}</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Description</span>
                            <span class="detail-value">${not empty devoir.description ? devoir.description : 'Aucune description'}</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Date limite</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty devoir.dateLimite}">
                                        ${devoir.dateLimite.toLocalDate()} à ${devoir.dateLimite.toLocalTime()}
                                        <c:if test="${devoir.depasse}"><span class="badge badge-danger">Dépassé</span></c:if>
                                    </c:when>
                                    <c:otherwise>Pas de date limite</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Soumissions</span>
                            <span class="detail-value"><span class="badge badge-info">${devoir.nbSoumissions}</span></span>
                        </div>
                        <c:if test="${not empty devoir.nomFichier}">
                            <div class="detail-row">
                                <span class="detail-label">Sujet</span>
                                <span class="detail-value">${devoir.nomFichier}</span>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="dashboard-section">
                <div class="section-header">
                    <h3>Soumissions (${devoir.nbSoumissions})</h3>
                </div>

                <c:choose>
                    <c:when test="${empty soumissions}">
                        <div class="empty-state">
                            <i class="fas fa-inbox fa-3x"></i>
                            <p>Aucune soumission pour ce devoir.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-container">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Étudiant</th>
                                        <th>Titre</th>
                                        <th>Fichier</th>
                                        <th>Date</th>
                                        <th>Statut</th>
                                        <th>Note</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="s" items="${soumissions}">
                                        <tr>
                                            <td><strong>${s.etudiant.nom}</strong></td>
                                            <td>${s.titre}</td>
                                            <td>${s.nomFichier} <small>(${s.tailleFormatee})</small></td>
                                            <td>${s.dateSoumission.toLocalDate()} <small>${s.dateSoumission.toLocalTime()}</small></td>
                                            <td><span class="badge ${s.statutBadge}">${s.statutLabel}</span></td>
                                            <td><c:choose><c:when test="${not empty s.note}">${s.note}/20</c:when><c:otherwise>—</c:otherwise></c:choose></td>
                                            <td>
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
    </div>
</body>
</html>
