<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    request.setAttribute("role", "ADMIN");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Ajouter un étudiant");
    request.setAttribute("activeMenu", "etudiants");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter un étudiant — GesPed</title>
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
            <div class="page-header">
                <h1>Ajouter un étudiant</h1>
                <p>Créer un nouveau compte étudiant</p>
            </div>

            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/dashboard">Tableau de bord</a>
                <span class="sep"><i class="fas fa-chevron-right"></i></span>
                <a href="${pageContext.request.contextPath}/admin/etudiants">Étudiants</a>
                <span class="sep"><i class="fas fa-chevron-right"></i></span>
                <span class="current">Ajouter</span>
            </div>
            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Ajoutez un nouvel étudiant à la plateforme.</p>
                </div>
                <i class="fas fa-user-plus welcome-icon"></i>
            </div>
            <div class="form-card">
                    <a href="${pageContext.request.contextPath}/admin/etudiants" class="btn btn-sm btn-secondary">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                </div>
        
            </div>
        </div>
    </div>
    <script>
        var sidebarToggle=document.getElementById('sidebarToggle'),
            sidebar=document.getElementById('sidebar'),
            overlay=document.getElementById('sidebarOverlay');
        if(sidebarToggle)sidebarToggle.addEventListener('click',function(){sidebar.classList.toggle('open');overlay.classList.toggle('open')});
        if(overlay)overlay.addEventListener('click',function(){sidebar.classList.remove('open');overlay.classList.remove('open')});
    </script>
</body>
</html>