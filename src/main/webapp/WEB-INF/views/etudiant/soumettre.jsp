<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    request.setAttribute("role", "ETUDIANT");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Soumettre un devoir");
    request.setAttribute("activeMenu", "soumettre");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Soumettre — GesPed</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/responsive.css?v=1">
</head>
<body class="app-layout">
    <%@ include file="/WEB-INF/includes/sidebar.jsp" %>
    <div class="main-content">
        <%@ include file="/WEB-INF/includes/topbar.jsp" %>

        <div class="content-wrapper">
            <c:if test="${not empty msgError}">
                <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${msgError}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Soumettez vos devoirs et travaux pratiques.</p>
                </div>
                <i class="fas fa-upload welcome-icon"></i>
            </div>

            <div class="page-header">
                <h3>Soumettre un devoir / TP</h3>
            </div>

            <div class="form-card">
                <form action="${pageContext.request.contextPath}/etudiant/soumettre" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="titre">Titre du devoir</label>
                        <input type="text" id="titre" name="titre" class="form-control" placeholder="Ex: TP Algorithmique 1" required>
                    </div>

                    <div class="form-group">
                        <label for="idModule">Module</label>
                        <select id="idModule" name="idModule" class="form-control" required>
                            <option value="">— Sélectionnez un module —</option>
                            <c:forEach var="m" items="${modules}">
                                <option value="${m.idModule}">${m.codeModule} — ${m.nomModule}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="idDevoir">Devoir concerné (optionnel)</label>
                        <select id="idDevoir" name="idDevoir" class="form-control">
                            <option value="">— Soumission libre (sans devoir) —</option>
                            <c:forEach var="d" items="${devoirs}">
                                <option value="${d.idDevoir}" ${param.idDevoir == d.idDevoir ? 'selected' : ''}>${d.titre} — ${d.module.codeModule}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="description">Description (optionnelle)</label>
                        <textarea id="description" name="description" class="form-control" rows="3" placeholder="Brève description de votre travail"></textarea>
                    </div>

                    <div class="form-group">
                        <label for="fichier">Fichier (PDF uniquement)</label>
                        <input type="file" id="fichier" name="fichier" class="form-control-file" accept="application/pdf" required>
                        <small class="form-text text-muted">Format accepté : PDF. Taille max : 50 Mo.</small>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-upload"></i> Soumettre
                        </button>
                        <a href="${pageContext.request.contextPath}/etudiant/dashboard" class="btn btn-outline">Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
