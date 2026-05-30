<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Utilisateur" %>

<%
    request.setAttribute("role", "PROFESSEUR");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Statistiques");
    request.setAttribute("activeMenu", "statistiques");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques — GesPed</title>
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
                    <p>Consultez vos statistiques pédagogiques.</p>
                </div>
                <i class="fas fa-chart-bar welcome-icon"></i>
            </div>

            <h3 style="margin-bottom:24px;">Mes statistiques</h3>
            <div class="stats-cards">
                <div class="stat-card-dashboard gradient-blue">
                    <div class="stat-card-icon"><i class="fas fa-book"></i></div>
                    <div class="stat-card-info"><span class="stat-card-number">${modules.size()}</span><span class="stat-card-label">Modules</span></div>
                </div>
                <div class="stat-card-dashboard gradient-green">
                    <div class="stat-card-icon"><i class="fas fa-file-alt"></i></div>
                    <div class="stat-card-info"><span class="stat-card-number">${nbRessources}</span><span class="stat-card-label">Ressources deposees</span></div>
                </div>
            </div>
            <div class="dashboard-section">
                <div class="section-header"><h3><i class="fas fa-book"></i> Detail par module</h3></div>
                <c:forEach var="m" items="${modules}">
                    <div style="display:flex;align-items:center;gap:16px;padding:14px 0;border-bottom:1px solid var(--border-color);">
                        <span class="badge badge-module">${m.codeModule}</span>
                        <strong>${m.nomModule}</strong>
                        <span class="text-muted">${m.filiere.nomFiliere} — ${m.semestre.nomSemestre}</span>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>