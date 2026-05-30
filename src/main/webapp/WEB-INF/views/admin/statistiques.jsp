<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("role", "ADMIN");
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
                    <p>Consultez les statistiques de la plateforme.</p>
                </div>
                <i class="fas fa-chart-bar welcome-icon"></i>
            </div>

            <h3 class="mb-24">Statistiques de la plateforme</h3>

            <div class="stats-cards">
                <div class="stat-card-dashboard gradient-purple">
                    <div class="stat-card-icon"><i class="fas fa-user-shield"></i></div>
                    <div class="stat-card-info"><span class="stat-card-number">${nbAdmins}</span><span class="stat-card-label">Admins</span></div>
                </div>
                <div class="stat-card-dashboard gradient-pink">
                    <div class="stat-card-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                    <div class="stat-card-info"><span class="stat-card-number">${nbProfs}</span><span class="stat-card-label">Professeurs</span></div>
                </div>
                <div class="stat-card-dashboard gradient-blue">
                    <div class="stat-card-icon"><i class="fas fa-user-graduate"></i></div>
                    <div class="stat-card-info"><span class="stat-card-number">${nbEtudiants}</span><span class="stat-card-label">Etudiants</span></div>
                </div>
                <div class="stat-card-dashboard gradient-green">
                    <div class="stat-card-icon"><i class="fas fa-book"></i></div>
                    <div class="stat-card-info"><span class="stat-card-number">${nbModules}</span><span class="stat-card-label">Modules</span></div>
                </div>
                <div class="stat-card-dashboard gradient-orange">
                    <div class="stat-card-icon"><i class="fas fa-file-alt"></i></div>
                    <div class="stat-card-info"><span class="stat-card-number">${nbRessources}</span><span class="stat-card-label">Ressources</span></div>
                </div>
                <div class="stat-card-dashboard gradient-teal">
                    <div class="stat-card-icon"><i class="fas fa-layer-group"></i></div>
                    <div class="stat-card-info"><span class="stat-card-number">${nbFilieres}</span><span class="stat-card-label">Filieres</span></div>
                </div>
            </div>

            <!-- Repartition graphique CSS pur -->
            <div class="dashboard-section">
                <div class="section-header"><h3><i class="fas fa-chart-pie"></i> Repartition des utilisateurs</h3></div>
                <div class="flex flex-wrap items-center justify-center gap-40" style="padding:20px;">
                    <div class="flex flex-col gap-16">
                        <div class="flex items-center gap-12">
                            <div class="legend-box legend-red"></div>
                            <span>Admins : <strong>${nbAdmins}</strong></span>
                        </div>
                        <div class="flex items-center gap-12">
                            <div class="legend-box legend-amber"></div>
                            <span>Professeurs : <strong>${nbProfs}</strong></span>
                        </div>
                        <div class="flex items-center gap-12">
                            <div class="legend-box legend-blue"></div>
                            <span>Etudiants : <strong>${nbEtudiants}</strong></span>
                        </div>
                    </div>
                    <!-- Barre de proportion -->
                    <div style="flex:1;max-width:400px;min-width:200px;">
                        <div class="flex" style="height:40px;border-radius:8px;overflow:hidden;">
                            <c:set var="total" value="${nbAdmins + nbProfs + nbEtudiants}" />
                            <c:if test="${total > 0}">
                                <div style="width:${nbAdmins * 100 / total}%;background:#ef4444;" class="flex items-center justify-center text-white font-small font-bold">
                                    ${nbAdmins > 0 ? nbAdmins : ''}
                                </div>
                                <div style="width:${nbProfs * 100 / total}%;background:#f59e0b;" class="flex items-center justify-center text-white font-small font-bold">
                                    ${nbProfs > 0 ? nbProfs : ''}
                                </div>
                                <div style="width:${nbEtudiants * 100 / total}%;background:#3b82f6;" class="flex items-center justify-center text-white font-small font-bold">
                                    ${nbEtudiants > 0 ? nbEtudiants : ''}
                                </div>
                            </c:if>
                        </div>
                        <p class="text-center mt-8 font-small text-muted">
                            Total : ${total} utilisateurs
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>
