<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="models.Utilisateur" %>
<%
    request.setAttribute("role", "ETUDIANT");
    request.setAttribute("nomComplet", ((Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Mon profil");
    request.setAttribute("activeMenu", "profil");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon profil — GesPed</title>
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
            <c:if test="${not empty msgSuccess}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${msgSuccess}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>
            <c:if test="${not empty msgError}"><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${msgError}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Gérez les informations de votre compte.</p>
                </div>
                <i class="fas fa-user-circle welcome-icon"></i>
            </div>

            <div class="page-header"><h1>Mon profil</h1><p>Informations de votre compte</p></div>

            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-avatar-lg">${nomComplet != null ? nomComplet.substring(0,1).toUpperCase() : 'E'}</div>
                    <h2>${nomComplet}</h2>
                    <p>&Eacute;tudiant</p>
                </div>
                <div class="profile-body">
                    <div class="profile-field">
                        <span class="profile-label">Email</span>
                        <span class="profile-value">${email}</span>
                    </div>
                    <div class="profile-field">
                        <span class="profile-label">Fili&egrave;re</span>
                        <span class="profile-value">${utilisateur.filiere != null ? utilisateur.filiere.nomFiliere : 'Non assign&eacute;e'}</span>
                    </div>

                    <div class="section-divider">Changer le mot de passe</div>

                    <form method="post" action="${pageContext.request.contextPath}/etudiant/profil">
                        <div class="form-group">
                            <label>Nouveau mot de passe</label>
                            <input type="password" name="nouveauMdp" class="form-input" placeholder="Au moins 6 caractères" required>
                        </div>
                        <div class="form-group">
                            <label>Confirmer le mot de passe</label>
                            <input type="password" name="confirmMdp" class="form-input" placeholder="Retapez le mot de passe" required>
                        </div>
                        <button type="submit" class="btn btn-primary"><i class="fas fa-lock"></i> Mettre &agrave; jour</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script>const s=document.getElementById('sidebarToggle'),b=document.getElementById('sidebar'),o=document.getElementById('sidebarOverlay');if(s)s.addEventListener('click',function(){b.classList.toggle('open');o.classList.toggle('open')});if(o)o.addEventListener('click',function(){b.classList.remove('open');o.classList.remove('open')})</script>
</body>
</html>