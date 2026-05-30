<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
            ? "Modifier module"
            : "Ajouter module"
    );

    request.setAttribute("activeMenu", "modules");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} — GesPed</title>
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
            <c:if test="${not empty errors}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <ul><c:forEach var="err" items="${errors}"><li>${err}</li></c:forEach></ul>
                </div>
            </c:if>

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Créez ou modifiez un module.</p>
                </div>
                <i class="fas fa-book welcome-icon"></i>
            </div>

            <div class="form-card">
                    <a href="${not empty returnUrl ? returnUrl : pageContext.request.contextPath.concat('/admin/modules')}"
                       class="btn btn-outline btn-sm">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                </div>
                <form method="post"
                      action="${pageContext.request.contextPath}/admin/module/${editMode ? 'modifier' : 'ajouter'}"
                      class="form-grid">
                    <c:if test="${editMode}">
                        <input type="hidden" name="id" value="${module.idModule}">
                    </c:if>
                    <c:if test="${not empty returnUrl}">
                        <input type="hidden" name="returnUrl" value="${returnUrl}">
                        <input type="hidden" name="fromParcours" value="1">
                    </c:if>
                    <div class="form-group">
                        <label for="codeModule">Code module <span class="required">*</span></label>
                        <input type="text" id="codeModule" name="codeModule" value="${module.codeModule}"
                               required placeholder="Ex: BDD-S5">
                    </div>
                    <div class="form-group">
                        <label for="nomModule">Nom du module <span class="required">*</span></label>
                        <input type="text" id="nomModule" name="nomModule" value="${module.nomModule}"
                               required placeholder="Ex: Base de donnees">
                    </div>
                    <div class="form-group">
                        <label for="idFiliere">Filiere <span class="required">*</span></label>
                        <select id="idFiliere" name="idFiliere" required class="form-select">
                            <option value="">-- Selectionner --</option>
                            <c:forEach var="f" items="${filieres}">
                                <option value="${f.idFiliere}"
                                    ${module.filiere != null && module.filiere.idFiliere == f.idFiliere ? 'selected' : ''}>
                                    ${f.nomFiliere}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="idSemestre">Semestre <span class="required">*</span></label>
                        <select id="idSemestre" name="idSemestre" required class="form-select">
                            <option value="">-- Selectionner --</option>
                            <c:forEach var="s" items="${semestres}">
                                <option value="${s.idSemestre}"
                                    ${module.semestre != null && module.semestre.idSemestre == s.idSemestre ? 'selected' : ''}>
                                    ${s.nomSemestre}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group full-width">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="3"
                                  placeholder="Description optionnelle">${module.description}</textarea>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> ${editMode ? 'Modifier' : 'Creer'}
                        </button>
                        <a href="${not empty returnUrl ? returnUrl : pageContext.request.contextPath.concat('/admin/modules')}"
                           class="btn btn-outline">Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>