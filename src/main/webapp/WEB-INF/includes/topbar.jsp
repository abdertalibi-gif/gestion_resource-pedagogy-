<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<header class="topbar">
    <div class="topbar-left">
        <button class="hamburger" onclick="toggleSidebar()">
            <i class="fas fa-bars"></i>
        </button>
        <h2 class="page-title">${pageTitle}</h2>
    </div>
    <div class="topbar-right">
        <!-- Recherche rapide (etudiant) -->
        <c:if test="${role == 'ETUDIANT'}">
            <form action="${ctx}/etudiant/recherche" method="get" class="topbar-search">
                <input type="text" name="q" placeholder="Rechercher une ressource...">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
        </c:if>

        <!-- Notifications -->
        <div class="topbar-notifications" id="notifDropdown">
            <button class="notif-btn" onclick="toggleNotif()">
                <i class="fas fa-bell"></i>
                <c:if test="${nbNonLues > 0}">
                    <span class="notif-badge">${nbNonLues}</span>
                </c:if>
            </button>
            <div class="notif-dropdown" id="notifMenu">
                <div class="notif-header">
                    <span>Notifications</span>
                    <a href="#">Tout marquer comme lu</a>
                </div>
                <div class="notif-body">
                    <p class="notif-empty">Aucune notification</p>
                </div>
            </div>
        </div>

        <!-- Profil -->
        <div class="topbar-profile">
            <div class="profile-avatar">
                <i class="fas fa-user-circle"></i>
            </div>
            <span class="profile-name">${nomComplet}</span>
        </div>
    </div>
</header>