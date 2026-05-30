<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="models.Utilisateur" %>
<%
    request.setAttribute("role", "PROFESSEUR");
    request.setAttribute("nomComplet", ((Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Tableau de bord");
    request.setAttribute("activeMenu", "dashboard");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Professeur — GesPed</title>
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
        <header class="topbar">
            <div class="topbar-left"><button class="sidebar-toggle" id="sidebarToggle" aria-label="Menu"><i class="fas fa-bars"></i></button><span class="topbar-title">${pageTitle}</span></div>
            <div class="topbar-right"><div class="user-avatar">${nomComplet != null ? nomComplet.substring(0,1).toUpperCase() : 'P'}</div><div class="user-info"><span class="user-name">${nomComplet}</span><span class="user-role">Professeur</span></div></div>
        </header>

        <div class="content-wrapper">
            <c:if test="${not empty msgSuccess}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${msgSuccess}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>
            <c:if test="${not empty msgError}"><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${msgError}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>

            <div class="welcome-banner">
                <div class="welcome-text"><h2>Bienvenue, ${nomComplet}</h2><p>G&eacute;rez vos ressources p&eacute;dagogiques depuis cet espace.</p></div>
                <i class="fas fa-chalkboard-teacher welcome-icon"></i>
            </div>

            <div class="page-header"><h1>Tableau de bord</h1><p>Vue d'ensemble de votre espace</p></div>

            <div class="stats-cards">
                <div class="stat-card-dashboard grad-deep"><div class="stat-card-icon"><i class="fas fa-book"></i></div><div class="stat-card-info"><span class="stat-card-number">${nbModules}</span><span class="stat-card-label">Modules</span></div></div>
                <div class="stat-card-dashboard grad-mid"><div class="stat-card-icon"><i class="fas fa-file-alt"></i></div><div class="stat-card-info"><span class="stat-card-number">${nbRessources}</span><span class="stat-card-label">Ressources</span></div></div>
                <div class="stat-card-dashboard grad-bright"><div class="stat-card-icon"><i class="fas fa-graduation-cap"></i></div><div class="stat-card-info"><span class="stat-card-number" style="font-size:15px">${nbFiliere}</span><span class="stat-card-label">Fili&egrave;re</span></div></div>
            </div>

            <div class="dashboard-section">
                <div class="section-header">
                    <h3><i class="fas fa-bolt"></i> Actions rapides</h3>
                </div>
                <div class="quick-actions">
                    <a href="${pageContext.request.contextPath}/professeur/ressource/ajouter" class="btn btn-primary">
                        <i class="fas fa-plus"></i> D&eacute;poser une ressource
                    </a>
                    <a href="${pageContext.request.contextPath}/professeur/ressources" class="btn btn-outline">
                        <i class="fas fa-list"></i> Voir mes ressources
                    </a>
                    <a href="${pageContext.request.contextPath}/professeur/amis" class="btn btn-outline">
                        <i class="fas fa-user-friends"></i> Mes amis
                    </a>
                </div>
            </div>
        </div>
    </div>
    <script>const s=document.getElementById('sidebarToggle'),b=document.getElementById('sidebar'),o=document.getElementById('sidebarOverlay');if(s)s.addEventListener('click',function(){b.classList.toggle('open');o.classList.toggle('open')});if(o)o.addEventListener('click',function(){b.classList.remove('open');o.classList.remove('open')})</script>
</body>
</html>
