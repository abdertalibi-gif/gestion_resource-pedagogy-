<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="models.Utilisateur" %>
<%
    Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
    request.setAttribute("role", "PROFESSEUR");
    request.setAttribute("nomComplet", u != null ? u.getNomComplet() : "");
    request.setAttribute("pageTitle", "Mes amis");
    request.setAttribute("activeMenu", "amis");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes amis — GesPed</title>
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
                <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${msgSuccess}</div>
            </c:if>
            <c:if test="${not empty msgError}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${msgError}</div>
            </c:if>

            <div class="page-header">
                <h1>Mes amis</h1>
                <p>Connectez-vous avec vos coll&egrave;gues professeurs</p>
            </div>

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Retrouvez vos collègues et suggestions d'amis.</p>
                </div>
                <i class="fas fa-user-friends welcome-icon"></i>
            </div>

            <div class="stats-cards">
                <div class="stat-card-dashboard grad-deep">
                    <div class="stat-card-icon"><i class="fas fa-user-friends"></i></div>
                    <div>
                        <div class="stat-card-number">${nbAmis}</div>
                        <div class="stat-card-label">Amis</div>
                    </div>
                </div>
                <div class="stat-card-dashboard grad-mid">
                    <div class="stat-card-icon"><i class="fas fa-user-plus"></i></div>
                    <div>
                        <div class="stat-card-number">${nbSuggestions}</div>
                        <div class="stat-card-label">Suggestions</div>
                    </div>
                </div>
                <div class="stat-card-dashboard grad-orange">
                    <div class="stat-card-icon"><i class="fas fa-envelope"></i></div>
                    <div>
                        <div class="stat-card-number">0</div>
                        <div class="stat-card-label">Demandes</div>
                    </div>
                </div>
            </div>

            <div class="dashboard-section">
                <div class="section-toolbar">
                    <div class="tabs">
                        <a href="${pageContext.request.contextPath}/professeur/amis?tab=amis"
                           class="tab ${tab == 'amis' ? 'active' : ''}">Mes amis</a>
                        <a href="${pageContext.request.contextPath}/professeur/amis?tab=suggestions"
                           class="tab ${tab == 'suggestions' ? 'active' : ''}">D&eacute;couvrir</a>
                    </div>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="friendSearch" placeholder="Rechercher un coll&egrave;gue..." oninput="filterFriends()">
                    </div>
                </div>

                <div class="friends-grid" id="friendsGrid">
                    <c:choose>
                        <c:when test="${tab == 'suggestions'}">
                            <c:forEach var="p" items="${suggestions}" varStatus="st">
                                <div class="friend-card" data-name="${p.prenom} ${p.nom} ${p.email}">
                                    <div class="friend-card-header">
                                        <div class="friend-avatar av-${st.index mod 4}">${p.nom.substring(0,1)}</div>
                                        <div>
                                            <div class="friend-name">${p.prenom} ${p.nom}</div>
                                            <div class="friend-meta">Professeur</div>
                                        </div>
                                    </div>
                                    <div class="friend-info"><i class="fas fa-envelope"></i> ${p.email}</div>
                                    <c:if test="${not empty p.telephone}">
                                        <div class="friend-info"><i class="fas fa-phone"></i> ${p.telephone}</div>
                                    </c:if>
                                    <div class="friend-actions">
                                        <a href="${pageContext.request.contextPath}/professeur/ami/ajouter?id=${p.idUtilisateur}"
                                           class="btn btn-primary"><i class="fas fa-user-plus"></i> Ajouter</a>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty suggestions}">
                                <div class="empty-state">
                                    <div class="empty-state-icon"><i class="fas fa-users"></i></div>
                                    <div class="empty-state-title">Aucune suggestion</div>
                                    <p class="empty-state-text">Tous les professeurs sont d&eacute;j&agrave; dans votre liste.</p>
                                </div>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="p" items="${amis}" varStatus="st">
                                <div class="friend-card" data-name="${p.prenom} ${p.nom} ${p.email}">
                                    <div class="friend-card-header">
                                        <div class="friend-avatar av-${st.index mod 4}">${p.nom.substring(0,1)}</div>
                                        <div>
                                            <div class="friend-name">${p.prenom} ${p.nom}</div>
                                            <div class="friend-meta"><span class="status-online">En ligne</span></div>
                                        </div>
                                    </div>
                                    <div class="friend-info"><i class="fas fa-envelope"></i> ${p.email}</div>
                                    <c:if test="${not empty p.telephone}">
                                        <div class="friend-info"><i class="fas fa-phone"></i> ${p.telephone}</div>
                                    </c:if>
                                    <div class="friend-actions">
                                        <a href="mailto:${p.email}" class="btn btn-outline"><i class="fas fa-envelope"></i> Message</a>
                                        <a href="${pageContext.request.contextPath}/professeur/ami/retirer?id=${p.idUtilisateur}"
                                           class="btn btn-danger"
                                           onclick="return confirm('Retirer ${p.prenom} ${p.nom} de vos amis ?')">
                                            <i class="fas fa-user-minus"></i> Retirer
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty amis}">
                                <div class="empty-state">
                                    <div class="empty-state-icon"><i class="fas fa-user-friends"></i></div>
                                    <div class="empty-state-title">Aucun ami pour le moment</div>
                                    <p class="empty-state-text">D&eacute;couvrez vos coll&egrave;gues professeurs et ajoutez-les &agrave; votre r&eacute;seau.</p>
                                    <a href="${pageContext.request.contextPath}/professeur/amis?tab=suggestions" class="btn btn-primary">
                                        <i class="fas fa-search"></i> D&eacute;couvrir des coll&egrave;gues
                                    </a>
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script>
        function filterFriends() {
            var q = (document.getElementById('friendSearch').value || '').toLowerCase();
            document.querySelectorAll('.friend-card').forEach(function(card) {
                var name = (card.getAttribute('data-name') || '').toLowerCase();
                card.style.display = name.indexOf(q) >= 0 ? '' : 'none';
            });
        }
        function toggleSidebar() {
            var s = document.getElementById('sidebar');
            var o = document.getElementById('sidebarOverlay');
            if (s) s.classList.toggle('open');
            if (o) o.classList.toggle('open');
        }
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
