<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Utilisateur" %>

<%
    Boolean editMode = (Boolean) request.getAttribute("editMode");

    request.setAttribute("role", "ADMIN");

    request.setAttribute(
        "nomComplet",
        ((models.Utilisateur) session.getAttribute("utilisateur"))
            .getNomComplet()
    );

    request.setAttribute(
        "pageTitle",
        (editMode != null && editMode)
            ? "Modifier semestre"
            : "Ajouter semestre"
    );

    request.setAttribute("activeMenu", "semestres");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} — GesPed</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body class="app-body">
    <%@ include file="/WEB-INF/includes/sidebar.jsp" %>
    <div class="main-content">
        <%@ include file="/WEB-INF/includes/topbar.jsp" %>
        <div class="content-wrapper">
            <div class="form-card">
                <div class="form-card-header">
                    <h3>${editMode ? 'Modifier le semestre' : 'Nouveau semestre'}</h3>
                    <a href="${pageContext.request.contextPath}/admin/semestres" class="btn btn-outline btn-sm">
                        <i class="fas fa-arrow-left"></i> Retour</a>
                </div>
                <form method="post"
                      action="${pageContext.request.contextPath}/admin/semestre/${editMode ? 'modifier' : 'ajouter'}"
                      class="form-grid">
                    <c:if test="${editMode}">
                        <input type="hidden" name="id" value="${semestre.idSemestre}">
                    </c:if>
                    <div class="form-group">
                        <label for="nomSemestre">Nom du semestre <span class="required">*</span></label>
                        <input type="text" id="nomSemestre" name="nomSemestre"
                               value="${semestre.nomSemestre}" required placeholder="Ex: S5">
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <input type="text" id="description" name="description"
                               value="${semestre.description}" placeholder="Description optionnelle">
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> ${editMode ? 'Modifier' : 'Creer'}</button>
                        <a href="${pageContext.request.contextPath}/admin/semestres" class="btn btn-outline">Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>