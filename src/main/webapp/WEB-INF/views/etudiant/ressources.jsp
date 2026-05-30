<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="models.Utilisateur" %>
<%
    request.setAttribute("role", "ETUDIANT");
    request.setAttribute("nomComplet", ((Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Mes ressources");
    request.setAttribute("activeMenu", "ressources");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes ressources — GesPed</title>

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
                    <p>Accédez à toutes vos ressources.</p>
                </div>
                <i class="fas fa-folder-open welcome-icon"></i>
            </div>

            <div class="page-header"><h1>Mes ressources</h1><p>Toutes les ressources de vos modules</p></div>

            <div class="dashboard-section">
                <div class="section-header">
                    <h3><i class="fas fa-folder-open"></i> Liste des ressources</h3>
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" placeholder="Rechercher..." oninput="filterTable()"></div>
                </div>

                <c:choose>
                    <c:when test="${not empty ressources}">
                        <div class="table-responsive">
                            <table class="table" id="ressourcesTable">
                                <thead><tr><th>Titre</th><th>Type</th><th>Module</th><th>Professeur</th><th>Taille</th><th>Action</th></tr></thead>
                                <tbody>
                                    <c:forEach var="r" items="${ressources}">
                                        <tr>
                                            <td><div class="table-file"><i class="fas ${r.iconeType}" style="color:${r.couleurType}"></i><span>${r.titre}</span></div></td>
                                            <td><span class="badge" style="background:${r.couleurType}">${r.type.nomType}</span></td>
                                            <td>${r.module.nomModule}</td>
                                            <td>${r.professeur.nom}</td>
                                            <td>${r.tailleFormatee}</td>
                                            <td><a href="${pageContext.request.contextPath}/etudiant/ressources/download?id=${r.id}" class="btn btn-sm btn-download"><i class="fas fa-download"></i></a></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-icon"><i class="fas fa-folder-open"></i></div>
                            <div class="empty-state-title">Aucune ressource disponible</div>
                            <div class="empty-state-text">Vos professeurs n'ont pas encore d&eacute;pos&eacute; de ressources pour vos modules.</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <script>const s=document.getElementById('sidebarToggle'),b=document.getElementById('sidebar'),o=document.getElementById('sidebarOverlay');if(s)s.addEventListener('click',function(){b.classList.toggle('open');o.classList.toggle('open')});if(o)o.addEventListener('click',function(){b.classList.remove('open');o.classList.remove('open')});function filterTable(){const q=document.querySelector('.search-box input').value.toLowerCase();document.querySelectorAll('#ressourcesTable tbody tr').forEach(r=>{r.style.display=r.textContent.toLowerCase().includes(q)?'':'none'})}</script>
</body>
</html>
