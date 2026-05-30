<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Utilisateur" %>

<%
    request.setAttribute("role", "PROFESSEUR");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Mes modules");
    request.setAttribute("activeMenu", "modules");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes modules — GesPed</title>
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
            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Consultez vos modules et leurs ressources.</p>
                </div>
                <i class="fas fa-book welcome-icon"></i>
            </div>

            <div class="page-header"><h3>Mes modules</h3></div>
            <div class="cards-grid">
                <c:forEach var="m" items="${modules}">
                    <a href="${pageContext.request.contextPath}/professeur/ressources?module=${m.idModule}"
                       class="info-card clickable">
                        <div class="info-card-header"><span class="badge badge-module">${m.codeModule}</span></div>
                        <h4>${m.nomModule}</h4>
                        <p>${m.filiere.nomFiliere} — ${m.semestre.nomSemestre}</p>
                        <p class="text-muted" style="font-size:12px;margin-top:8px;">
                            <i class="fas fa-file-alt"></i> Voir les ressources
                        </p>
                    </a>
                </c:forEach>
                <c:if test="${empty modules}">
                    <div class="empty-state" style="grid-column:1/-1;">
                        <i class="fas fa-book"></i>
                        <h4>Aucun module affecte</h4>
                        <p>Contactez l'administrateur pour vous affecter des modules</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>