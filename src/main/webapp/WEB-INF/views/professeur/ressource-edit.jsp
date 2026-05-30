<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Utilisateur" %>

<%
    request.setAttribute("role", "PROFESSEUR");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Modifier ressource");
    request.setAttribute("activeMenu", "ressources");
    String msgError = (String) session.getAttribute("msgError");
    if (msgError != null) { request.setAttribute("msgError", msgError); session.removeAttribute("msgError"); }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier ressource — GesPed</title>
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
            <c:if test="${not empty msgError}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${msgError}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div>
            </c:if>

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Modifiez vos ressources pédagogiques.</p>
                </div>
                <i class="fas fa-edit welcome-icon"></i>
            </div>

            <div class="form-card">
                <div class="form-card-header">
                    <h3><i class="fas fa-edit"></i> Modifier la ressource</h3>
                    <a href="${pageContext.request.contextPath}/professeur/ressources" class="btn btn-outline btn-sm">
                        <i class="fas fa-arrow-left"></i> Retour</a>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/professeur/ressource/modifier" class="form-grid">
                    <input type="hidden" name="id" value="${ressource.idRessource}">

                    <div class="form-group full-width">
                        <label for="titre">Titre <span class="required">*</span></label>
                        <input type="text" id="titre" name="titre" value="${ressource.titre}" required>
                    </div>
                    <div class="form-group full-width">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="3">${ressource.description}</textarea>
                    </div>
                    <div class="form-group">
                        <label for="idModule">Module <span class="required">*</span></label>
                        <select id="idModule" name="idModule" required class="form-select">
                            <c:forEach var="m" items="${modules}">
                                <option value="${m.idModule}" ${ressource.module.idModule == m.idModule ? 'selected' : ''}>
                                    ${m.codeModule} — ${m.nomModule}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="idType">Type <span class="required">*</span></label>
                        <select id="idType" name="idType" required class="form-select">
                            <c:forEach var="t" items="${types}">
                                <option value="${t.idType}" ${ressource.type.idType == t.idType ? 'selected' : ''}>
                                    ${t.nomType}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Fichier actuel</label>
                        <div style="padding:10px;background:var(--bg-body);border-radius:var(--radius-md);font-size:14px;">
                            <i class="fas ${ressource.iconeType}" style="color:${ressource.couleurType}"></i>
                            ${ressource.nomFichier} (${ressource.tailleFormatee})
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="visible">Visibilite</label>
                        <select id="visible" name="visible" class="form-select">
                            <option value="true" ${ressource.visible ? 'selected' : ''}>Visible</option>
                            <option value="false" ${not ressource.visible ? 'selected' : ''}>Masquee</option>
                        </select>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Enregistrer</button>
                        <a href="${pageContext.request.contextPath}/professeur/ressources" class="btn btn-outline">Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>