<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="models.Utilisateur" %>
<%
    request.setAttribute("role", "ETUDIANT");
    request.setAttribute("nomComplet", ((Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
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
            <c:if test="${not empty msgSuccess}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${msgSuccess}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>
            <c:if test="${not empty msgError}"><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${msgError}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Découvrez les modules de votre filière.</p>
                </div>
                <i class="fas fa-book welcome-icon"></i>
            </div>

            <div class="page-header">
                <h1>Mes modules</h1>
                <p>
                    <c:if test="${not empty utilisateur.filiere}">
                        <span class="badge badge-filiere"><i class="fas fa-layer-group"></i> ${utilisateur.filiere.nomFiliere}</span>
                    </c:if>
                    <c:if test="${not empty utilisateur.semestre}">
                        <span class="badge badge-semestre"><i class="fas fa-calendar-alt"></i> ${utilisateur.semestre.nomSemestre}</span>
                    </c:if>
                </p>
            </div>

            <div class="dashboard-section">
                <div class="section-header"><h3><i class="fas fa-book"></i> Liste des modules</h3></div>

                <c:choose>
                    <c:when test="${not empty modules}">
                        <div class="modules-grid">
                            <c:forEach var="m" items="${modules}">
                                <div class="module-card">
                                    <div class="module-icon"><i class="fas fa-book"></i></div>
                                    <div class="module-info">
                                        <h4>${m.codeModule} — ${m.nomModule}</h4>
                                        <p class="module-prof"><i class="fas fa-chalkboard-teacher"></i> ${m.nomProfesseur != null ? m.nomProfesseur : 'Professeur non assigné'}</p>
                                        <p class="module-desc">${m.description != null ? m.description : 'Aucune description'}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-icon"><i class="fas fa-book-open"></i></div>
                            <div class="empty-state-title">Aucun module disponible</div>
                            <div class="empty-state-text">Votre fili&egrave;re n'a pas encore de modules assign&eacute;s. Contactez l'administrateur.</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <script>const s=document.getElementById('sidebarToggle'),b=document.getElementById('sidebar'),o=document.getElementById('sidebarOverlay');if(s)s.addEventListener('click',function(){b.classList.toggle('open');o.classList.toggle('open')});if(o)o.addEventListener('click',function(){b.classList.remove('open');o.classList.remove('open')})</script>
</body>
</html>