<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    request.setAttribute("role", "PROFESSEUR");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Évaluer une soumission");
    request.setAttribute("activeMenu", "soumissions");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Évaluer — GesPed</title>
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
                    <p>Évaluez les soumissions de vos étudiants.</p>
                </div>
                <i class="fas fa-clipboard-check welcome-icon"></i>
            </div>

            <div class="page-header">
                <h3>Évaluation de la soumission</h3>
                <a href="${pageContext.request.contextPath}/professeur/soumissions" class="btn btn-outline">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
            </div>

            <div class="detail-grid">
                <div class="card">
                    <div class="card-header">
                        <h4>Informations</h4>
                    </div>
                    <div class="card-body">
                        <div class="detail-row">
                            <span class="detail-label">Étudiant</span>
                            <span class="detail-value">${soumission.etudiant.nom}</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Titre</span>
                            <span class="detail-value">${soumission.titre}</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Module</span>
                            <span class="detail-value">${soumission.module.codeModule} — ${soumission.module.nomModule}</span>
                        </div>
                        <c:if test="${not empty soumission.description}">
                            <div class="detail-row">
                                <span class="detail-label">Description</span>
                                <span class="detail-value">${soumission.description}</span>
                            </div>
                        </c:if>
                        <div class="detail-row">
                            <span class="detail-label">Fichier</span>
                            <span class="detail-value">${soumission.nomFichier} (${soumission.tailleFormatee})</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Date de soumission</span>
                            <span class="detail-value">${soumission.dateSoumission.toLocalDate()} à ${soumission.dateSoumission.toLocalTime()}</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Statut actuel</span>
                            <span class="detail-value"><span class="badge ${soumission.statutBadge}">${soumission.statutLabel}</span></span>
                        </div>
                    </div>
                    <div class="card-footer">
                        <a href="${pageContext.request.contextPath}/professeur/soumission/telecharger?id=${soumission.idSoumission}"
                           class="btn btn-primary" target="_blank">
                            <i class="fas fa-eye"></i> Voir le fichier
                        </a>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h4>Évaluation</h4>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/professeur/soumission/evaluer" method="post">
                            <input type="hidden" name="id" value="${soumission.idSoumission}">

                            <div class="form-group">
                                <label for="statut">Décision</label>
                                <select id="statut" name="statut" class="form-control" required>
                                    <option value="ACCEPTE" ${soumission.statut == 'ACCEPTE' ? 'selected' : ''}>Accepter</option>
                                    <option value="REFUSE" ${soumission.statut == 'REFUSE' ? 'selected' : ''}>Refuser</option>
                                    <option value="EN_ATTENTE" ${soumission.statut == 'EN_ATTENTE' ? 'selected' : ''}>En attente</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="note">Note /20 (optionnelle)</label>
                                <input type="number" id="note" name="note" class="form-control"
                                       min="0" max="20" step="0.5"
                                       value="${soumission.note}">
                            </div>

                            <div class="form-group">
                                <label for="commentaire">Commentaire (optionnel)</label>
                                <textarea id="commentaire" name="commentaire" class="form-control" rows="4">${soumission.commentaire}</textarea>
                            </div>

                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Enregistrer l'évaluation
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
