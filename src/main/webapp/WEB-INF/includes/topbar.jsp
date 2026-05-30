<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<header class="topbar">
    <div class="topbar-left">
        <button class="sidebar-toggle" id="sidebarToggle" aria-label="Menu">
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

        <!-- Profil -->
        <div class="topbar-profile">
            <div class="profile-avatar">
                <i class="fas fa-user-circle"></i>
            </div>
            <span class="profile-name">${nomComplet}</span>
        </div>
    </div>
</header>