<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="models.Utilisateur" %>
<%@ page import="models.HistoriqueConsultation" %>
<%@ page import="models.Ressource" %>
<%@ page import="utils.DateUtil" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("role", "ETUDIANT");
    request.setAttribute("nomComplet", ((Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Historique");
    request.setAttribute("activeMenu", "historique");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique — GesPed</title>

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
                    <p>Consultez votre historique de consultations.</p>
                </div>
                <i class="fas fa-history welcome-icon"></i>
            </div>

            <div class="page-header"><h3><i class="fas fa-history"></i> Mon historique</h3></div>
            <div class="dashboard-section">
                <%
                    List<HistoriqueConsultation> historique = (List<HistoriqueConsultation>) request.getAttribute("historique");
                    if (historique != null) {
                        for (HistoriqueConsultation h : historique) {
                %>
                    <div class="historique-item">
                        <div class="historique-icon"
                             style="color:${h.getRessource().getCouleurType()};background:${h.getRessource().getCouleurType()}15;">
                            <i class="fas ${h.getRessource().getIconeType()}"></i>
                        </div>
                        <div class="historique-info">
                            <strong><%= h.getRessource().getTitre() %></strong>
                            <p><%= h.getRessource().getModule().getNomModule() %> — <%= h.getRessource().getType().getNomType() %></p>
                        </div>
                        <span class="historique-action"><%= h.getTypeAction() %></span>
                        <span class="historique-date"><%= DateUtil.tempsEcoule(h.getDateConsultation()) %></span>
                        <a href="${pageContext.request.contextPath}/etudiant/ressource/voir?id=${h.getRessource().getIdRessource()}"
                           class="btn-action btn-view"><i class="fas fa-eye"></i></a>
                    </div>
                <%
                        }
                    }
                %>
          <%
				    if (historique == null || historique.isEmpty()) {
				%>
				    <div class="empty-state">
				        <i class="fas fa-history"></i>
				        <h4>Aucun historique</h4>
				        <p>Votre historique de consultations apparaitra ici</p>
				    </div>
				<%
				    }
				%>
            </div>
        </div>
    </div>
     <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>