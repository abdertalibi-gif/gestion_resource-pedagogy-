<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    request.setAttribute("role", "ADMIN");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Gestion des utilisateurs");
    request.setAttribute("activeMenu", "utilisateurs");

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
    <title>Utilisateurs — GesPed</title>
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
            <c:if test="${not empty msgError}">
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${msgError}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Gérez tous les utilisateurs de la plateforme.</p>
                </div>
                <i class="fas fa-users-cog welcome-icon"></i>
            </div>

            <div class="page-header">
                </div>
                <a href="${pageContext.request.contextPath}/admin/utilisateur/ajouter" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Ajouter un utilisateur
                </a>
            </div>

            <!-- Filtres -->
            <div class="filter-bar">
                <form method="get" class="filter-form">
                    <select name="role" onchange="this.form.submit()" class="form-select">
                        <option value="">Tous les roles</option>
                        <option value="ADMIN" ${roleFilter == 'ADMIN' ? 'selected' : ''}>Administrateurs</option>
                        <option value="PROFESSEUR" ${roleFilter == 'PROFESSEUR' ? 'selected' : ''}>Professeurs</option>
                        <option value="ETUDIANT" ${roleFilter == 'ETUDIANT' ? 'selected' : ''}>Etudiants</option>
                    </select>
                </form>
            </div>

            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Nom complet</th>
                            <th>Email</th>
                            <th>Telephone</th>
                            <th>Role</th>
                            <th>Filiere</th>
                            <th>Semestre</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${utilisateurs}">
                            <tr>
                                <td>
                                    <div class="table-user">
                                        <div class="table-avatar"><i class="fas fa-user"></i></div>
                                        <div>
                                            <strong>${u.nomComplet}</strong>
                                            <small>${u.dateCreation != null ? u.dateCreation.toString().substring(0,10) : ''}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>${u.email}</td>
                                <td>${u.telephone}</td>
                                <td>
                                    <span class="badge badge-${u.role.nomRole.toLowerCase()}">
                                        ${u.role.nomRole}
                                    </span>
                                </td>
                                <td>${u.filiere != null ? u.filiere.nomFiliere : '-'}</td>
                                <td>${u.semestre != null ? u.semestre.nomSemestre : '-'}</td>
                                <td>
                                    <span class="status-badge ${u.statut == 'ACCEPTE' ? 'status-active' : u.statut == 'EN_ATTENTE' ? 'status-pending' : 'status-inactive'}">
                                        ${u.statutLabel}
                                    </span>
                                </td>
                                <td>
                                    <div class="table-actions">
                                        <a href="${pageContext.request.contextPath}/admin/utilisateur/modifier?id=${u.idUtilisateur}"
                                           class="btn-action btn-edit" title="Modifier">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <c:if test="${u.statut == 'ACCEPTE'}">
                                        <a href="${pageContext.request.contextPath}/admin/utilisateur/toggle?id=${u.idUtilisateur}"
                                           class="btn-action btn-warning" title="Desactiver"
                                           onclick="return confirm('Confirmer ?')">
                                            <i class="fas fa-ban"></i>
                                        </a>
                                        </c:if>
                                        <c:if test="${u.statut == 'EN_ATTENTE'}">
                                        <a href="${pageContext.request.contextPath}/admin/utilisateur/accepter?id=${u.idUtilisateur}"
                                           class="btn-action btn-success" title="Accepter">
                                            <i class="fas fa-check"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/utilisateur/refuser?id=${u.idUtilisateur}"
                                           class="btn-action btn-danger" title="Refuser">
                                            <i class="fas fa-times"></i>
                                        </a>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/admin/utilisateur/supprimer?id=${u.idUtilisateur}"
                                           class="btn-action btn-delete" title="Supprimer"
                                           onclick="return confirm('Supprimer cet utilisateur ? Cette action est irreversible.')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty utilisateurs}">
                            <tr><td colspan="8" class="text-center text-muted">Aucun utilisateur trouve</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>
