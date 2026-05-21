<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <span class="brand-name">GesPed</span>
        <span class="brand-role">
            <c:choose>
                <c:when test="${role == 'ADMIN'}">System Admin</c:when>
                <c:when test="${role == 'ETUDIANT'}">Espace &Eacute;tudiant</c:when>
                <c:when test="${role == 'PROFESSEUR'}">Espace Professeur</c:when>
            </c:choose>
        </span>
    </div>

    <!-- Menu Étudiant -->
    <c:if test="${role == 'ETUDIANT'}">
        <div class="sidebar-section">
            <div class="sidebar-section-label">Navigation</div>
            <a href="${pageContext.request.contextPath}/etudiant/dashboard" class="nav-item ${activeMenu == 'dashboard' ? 'active' : ''}">
                <i class="fas fa-th-large"></i> Tableau de bord
            </a>
            <a href="${pageContext.request.contextPath}/etudiant/modules" class="nav-item ${activeMenu == 'modules' ? 'active' : ''}">
                <i class="fas fa-book"></i> Mes modules
            </a>
            <a href="${pageContext.request.contextPath}/etudiant/ressources" class="nav-item ${activeMenu == 'ressources' ? 'active' : ''}">
                <i class="fas fa-folder-open"></i> Ressources
            </a>
            <a href="${pageContext.request.contextPath}/etudiant/recherche" class="nav-item ${activeMenu == 'recherche' ? 'active' : ''}">
                <i class="fas fa-search"></i> Recherche
            </a>
            <a href="${pageContext.request.contextPath}/etudiant/favoris" class="nav-item ${activeMenu == 'favoris' ? 'active' : ''}">
                <i class="fas fa-star"></i> Favoris
            </a>
            <a href="${pageContext.request.contextPath}/etudiant/historique" class="nav-item ${activeMenu == 'historique' ? 'active' : ''}">
                <i class="fas fa-history"></i> Historique
            </a>
            <a href="${pageContext.request.contextPath}/etudiant/profil" class="nav-item ${activeMenu == 'profil' ? 'active' : ''}">
                <i class="fas fa-user"></i> Mon profil
            </a>
        </div>
    </c:if>

<!-- ======== MENU PROFESSEUR ======== -->
<c:if test="${role == 'PROFESSEUR'}">
    <c:if test="${not empty nomComplet}">
        <div class="sidebar-profile" style="margin:12px 14px;padding:12px;background:rgba(255,255,255,0.06);border-radius:10px;display:flex;align-items:center;gap:10px;">
            <div style="width:40px;height:40px;border-radius:50%;background:#1a5f7a;color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:14px;border:2px solid rgba(255,255,255,0.15);">
                ${nomComplet.substring(0,1)}
            </div>
            <div>
                <div style="color:#fff;font-size:13px;font-weight:600;">${nomComplet}</div>
                <span style="display:inline-block;margin-top:4px;padding:2px 8px;background:rgba(26,185,129,0.25);color:#6ee7b7;font-size:10px;font-weight:600;border-radius:20px;">Professeur</span>
            </div>
        </div>
    </c:if>
    <div class="sidebar-section">
        <div class="sidebar-section-label">Navigation</div>
        <a href="${pageContext.request.contextPath}/professeur/dashboard"
           class="nav-item ${activeMenu == 'dashboard' ? 'active' : ''}">
            <i class="fas fa-th-large"></i> Tableau de bord
        </a>
        <a href="${pageContext.request.contextPath}/professeur/modules"
           class="nav-item ${activeMenu == 'modules' ? 'active' : ''}">
            <i class="fas fa-book"></i> Mes modules
        </a>
        <a href="${pageContext.request.contextPath}/professeur/ressources"
           class="nav-item ${activeMenu == 'ressources' ? 'active' : ''}">
            <i class="fas fa-file-alt"></i> Mes ressources
        </a>
        <a href="${pageContext.request.contextPath}/professeur/ressource/ajouter"
           class="nav-item ${activeMenu == 'upload' ? 'active' : ''}">
            <i class="fas fa-cloud-upload-alt"></i> D&eacute;poser
        </a>
        <a href="${pageContext.request.contextPath}/professeur/amis"
           class="nav-item ${activeMenu == 'amis' ? 'active' : ''}">
            <i class="fas fa-user-friends"></i> Amis
        </a>
    </div>
    <div class="sidebar-section">
        <div class="sidebar-section-label">Analyse</div>
        <a href="${pageContext.request.contextPath}/professeur/statistiques"
           class="nav-item ${activeMenu == 'statistiques' ? 'active' : ''}">
            <i class="fas fa-chart-bar"></i> Statistiques
        </a>
    </div>
</c:if>
    <!-- Menu Admin -->
    <c:if test="${role == 'ADMIN'}">
        <div class="sidebar-section">
            <div class="sidebar-section-label">Principal</div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item ${activeMenu == 'dashboard' ? 'active' : ''}">
                <i class="fas fa-th-large"></i> Tableau de bord
            </a>
        </div>
        <div class="sidebar-section">
            <div class="sidebar-section-label">Gestion</div>
            <a href="${pageContext.request.contextPath}/admin/etudiants" class="nav-item ${activeMenu == 'etudiants' ? 'active' : ''}">
                <i class="fas fa-users"></i> &Eacute;tudiants
            </a>
            <a href="${pageContext.request.contextPath}/admin/professeurs" class="nav-item ${activeMenu == 'professeurs' ? 'active' : ''}">
                <i class="fas fa-chalkboard-teacher"></i> Professeurs
            </a>
            <a href="${pageContext.request.contextPath}/admin/modules" class="nav-item ${activeMenu == 'modules' ? 'active' : ''}">
                <i class="fas fa-book"></i> Modules
            </a>
            <a href="${pageContext.request.contextPath}/admin/ressources" class="nav-item ${activeMenu == 'ressources' ? 'active' : ''}">
                <i class="fas fa-file-alt"></i> Ressources
            </a>
            <a href="${pageContext.request.contextPath}/admin/filieres" class="nav-item ${activeMenu == 'filieres' ? 'active' : ''}">
                <i class="fas fa-layer-group"></i> Fili&egrave;res
            </a>
            <a href="${pageContext.request.contextPath}/admin/semestres" class="nav-item ${activeMenu == 'semestres' ? 'active' : ''}">
                <i class="fas fa-calendar-alt"></i> Semestres
            </a>
            <a href="${pageContext.request.contextPath}/admin/affectations" class="nav-item ${activeMenu == 'affectations' ? 'active' : ''}">
                <i class="fas fa-link"></i> Affectations
            </a>
        </div>
        <div class="sidebar-section">
            <div class="sidebar-section-label">Analyse</div>
            <a href="${pageContext.request.contextPath}/admin/statistiques" class="nav-item ${activeMenu == 'statistiques' ? 'active' : ''}">
                <i class="fas fa-chart-bar"></i> Statistiques
            </a>
        </div>
    </c:if>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="nav-item-logout">
            <i class="fas fa-sign-out-alt"></i> D&eacute;connexion
        </a>
    </div>
</aside>
<div class="sidebar-overlay" id="sidebarOverlay"></div>