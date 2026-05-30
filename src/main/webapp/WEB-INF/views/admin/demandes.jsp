<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%
    request.setAttribute("role", "ADMIN");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Demandes d'inscription");
    request.setAttribute("activeMenu", "demandes");

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
    <title>Demandes d'inscription — GesPed</title>
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
                    <p>Gérez les demandes d'inscription en attente.</p>
                </div>
                <i class="fas fa-clipboard-list welcome-icon"></i>
            </div>

            <div class="page-header">
                <div class="page-header-left">
                    <h3>Demandes d'inscription</h3>
                    <p>Gérez les demandes de création de compte en attente de validation</p>
                </div>
            </div>

            <div class="dashboard-section">
                <div class="section-header">
                    <h3><i class="fas fa-clock"></i> Demandes en attente <span class="count">${fn:length(demandes)}</span></h3>
                </div>

                <c:if test="${not empty demandes}">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Nom complet</th>
                                    <th>Email</th>
                                    <th>Téléphone</th>
                                    <th>Rôle</th>
                                    <th>Filière</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="d" items="${demandes}">
                                    <tr>
                                        <td>
                                            <div class="table-user">
                                                <div class="table-avatar"><i class="fas fa-user"></i></div>
                                                <div>
                                                    <strong>${d.nomComplet}</strong>
                                                </div>
                                            </div>
                                        </td>
                                        <td>${d.email}</td>
                                        <td>${d.telephone}</td>
                                        <td>
                                            <span class="badge badge-${d.role.nomRole.toLowerCase()}">
                                                ${d.role.nomRole}
                                            </span>
                                        </td>
                                        <td>${d.filiere != null ? d.filiere.nomFiliere : '-'}</td>
                                        <td>${d.dateCreation != null ? d.dateCreation.toString().substring(0,10) : ''}</td>
                                        <td>
                                            <div class="table-actions">
                                                <a href="${pageContext.request.contextPath}/admin/utilisateur/accepter?id=${d.idUtilisateur}"
                                                   class="btn-action btn-success" title="Accepter"
                                                   onclick="return confirm('Accepter cette demande d\'inscription ?')">
                                                    <i class="fas fa-check"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/utilisateur/refuser?id=${d.idUtilisateur}"
                                                   class="btn-action btn-danger" title="Refuser"
                                                   onclick="return confirm('Refuser cette demande d\'inscription ?')">
                                                    <i class="fas fa-times"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/utilisateur/modifier?id=${d.idUtilisateur}"
                                                   class="btn-action btn-edit" title="Modifier">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <c:if test="${empty demandes}">
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="empty-state-title">Aucune demande en attente</div>
                        <div class="empty-state-text">
                            Toutes les demandes d'inscription ont été traitées.
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>