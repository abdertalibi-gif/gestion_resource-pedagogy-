<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Utilisateur" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<%
    request.setAttribute("role", "ADMIN");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    String msgSuccess = (String) session.getAttribute("msgSuccess");
    String msgError = (String) session.getAttribute("msgError");
    if (msgSuccess != null) { request.setAttribute("msgSuccess", msgSuccess); session.removeAttribute("msgSuccess"); }
    if (msgError != null) { request.setAttribute("msgError", msgError); session.removeAttribute("msgError"); }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${filiere.nomFiliere} — GesPed</title>
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
            <c:if test="${not empty msgSuccess}">
                <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${msgSuccess}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>

            <div class="page-header">
                <div>
                    <h3><i class="fas fa-layer-group" style="color:var(--teal-dark)"></i> ${filiere.nomFiliere}</h3>
                    <p style="color:var(--text-muted);margin-top:4px">${not empty filiere.description ? filiere.description : 'Aucune description'}</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/filieres" class="btn btn-outline">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
            </div>

            <c:forEach var="s" items="${semestres}">
                <c:set var="semModules" value=""/>
                <c:forEach var="m" items="${modules}">
                    <c:if test="${m.semestre.idSemestre == s.idSemestre}">
                        <c:set var="semModules" value="${semModules}${m.idModule},"/>
                    </c:if>
                </c:forEach>
                <c:if test="${fn:length(semModules) > 0}">
                    <div class="card" style="margin-bottom:20px">
                        <div class="card-header" style="display:flex;align-items:center;gap:12px;padding:16px 20px;border-bottom:1px solid var(--border-light)">
                            <i class="fas fa-calendar-alt" style="color:var(--teal-dark);font-size:18px"></i>
                            <h4 style="font-size:15px;font-weight:700;color:var(--text-dark);margin:0">Semestre ${s.nomSemestre}</h4>
                        </div>
                        <div class="card-body" style="padding:0">
                            <table class="table" style="margin-bottom:0">
                                <thead>
                                    <tr>
                                        <th>Code</th>
                                        <th>Module</th>
                                        <th>Professeur</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="m" items="${modules}">
                                        <c:if test="${m.semestre.idSemestre == s.idSemestre}">
                                            <tr>
                                                <td><span class="badge-module">${m.codeModule}</span></td>
                                                <td><strong>${m.nomModule}</strong></td>
                                                <td>${not empty m.nomProfesseur ? m.nomProfesseur : '<span class="text-muted">Non affecte</span>'}</td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:if>
            </c:forEach>

            <c:if test="${empty modules}">
                <div class="empty-state">
                    <i class="fas fa-folder-open" style="font-size:48px;color:var(--text-muted)"></i>
                    <p style="color:var(--text-muted);margin-top:12px">Aucun module pour cette filiere</p>
                </div>
            </c:if>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
