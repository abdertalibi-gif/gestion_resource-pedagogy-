<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="models.Utilisateur" %>
<%
    request.setAttribute("role", "ADMIN");
    request.setAttribute("nomComplet", ((Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Nouvelle affectation");
    request.setAttribute("activeMenu", "affectations");
    String msgSuccess = (String) request.getAttribute("msgSuccess");
    String msgError   = (String) request.getAttribute("msgError");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvelle affectation — GesPed</title>
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
                    <p>Affectez des professeurs aux modules.</p>
                </div>
                <i class="fas fa-link welcome-icon"></i>
            </div>

            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/dashboard">Tableau de bord</a>
                <span class="sep"><i class="fas fa-chevron-right"></i></span>
                <a href="${pageContext.request.contextPath}/admin/affectations">Affectations</a>
                <span class="sep"><i class="fas fa-chevron-right"></i></span>
                <span class="current">Nouvelle affectation</span>
            </div>

            <div class="page-header">
                <div><h1>Nouvelle affectation</h1><p>Affecter un professeur &agrave; un module</p></div>
            </div>

            <div class="form-card">
                <div class="form-card-header">
                    <h3><i class="fas fa-link"></i> Cr&eacute;er une affectation</h3>
                    <a href="${pageContext.request.contextPath}/admin/affectations" class="btn btn-sm btn-secondary">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                </div>
                <div class="form-card-body">
                    <div class="info-note">
                        <i class="fas fa-info-circle"></i>
                        <span>Un professeur peut &ecirc;tre affect&eacute; &agrave; plusieurs modules. V&eacute;rifiez les affectations existantes avant d'en cr&eacute;er une nouvelle.</span>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/admin/affectation/ajouter" novalidate>
                        <div class="form-group">
                            <label for="idProfesseur">Professeur <span class="required">*</span></label>
                            <select id="idProfesseur" name="idProfesseur" class="form-select" required>
                                <option value="">-- S&eacute;lectionner un professeur --</option>
                                <c:forEach var="p" items="${professeurs}">
                                    <option value="${p.idUtilisateur}">${p.prenom} ${p.nom}</option>
                                </c:forEach>
                            </select>
                            <c:if test="${empty professeurs}">
                                <small class="text-danger">Aucun professeur disponible.</small>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="idModule">Module <span class="required">*</span></label>
                            <select name="idModule" class="form-select" required>
    <option value="">-- Sélectionner un module --</option>
    <c:forEach var="m" items="${modules}">
        <option value="${m.idModule}">${m.nomModule}</option>
    </c:forEach>
</select>
                            <c:if test="${empty modules}">
                                <small class="text-danger">Aucun module disponible.</small>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="anneeUniversitaire">Ann&eacute;e universitaire <span class="required">*</span></label>
                            <input type="text" id="anneeUniversitaire" name="anneeUniversitaire"
                                   class="form-input" placeholder="Ex: 2025-2026"
                                   value="${anneeDefaut != null ? anneeDefaut : ''}" required>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary"><i class="fas fa-check"></i> Cr&eacute;er</button>
                            <a href="${pageContextContext.request.contextPath}/admin/affectations" class="btn btn-secondary"><i class="fas fa-times"></i> Annuler</a>
                        </div>
                    </form>
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