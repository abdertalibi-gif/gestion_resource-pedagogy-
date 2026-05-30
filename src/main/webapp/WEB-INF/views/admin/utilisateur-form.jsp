<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Boolean editMode = (Boolean) request.getAttribute("editMode");

    request.setAttribute("role", "ADMIN");

    request.setAttribute(
        "nomComplet",
        ((models.Utilisateur) session.getAttribute("utilisateur"))
            .getNomComplet()
    );

    request.setAttribute(
        "pageTitle",
        (editMode != null && editMode)
            ? "Modifier utilisateur"
            : "Ajouter utilisateur"
    );

    request.setAttribute("activeMenu", "utilisateurs");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} — GesPed</title>
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
            <!-- Erreurs de validation -->
            <c:if test="${not empty errors}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <ul>
                        <c:forEach var="err" items="${errors}">
                            <li>${err}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Créez ou modifiez un utilisateur.</p>
                </div>
                <i class="fas fa-user-cog welcome-icon"></i>
            </div>

            <div class="form-card">
                <div class="form-card-header">
            <h3>
            ${editMode ? 'Modifier l\'utilisateur' : 'Nouvel utilisateur'}</h3>
            
            
                    <a href="${pageContext.request.contextPath}/admin/utilisateurs" class="btn btn-outline btn-sm">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                </div>

                <form method="post"
                      action="${pageContext.request.contextPath}/admin/utilisateur/${editMode ? 'modifier' : 'ajouter'}"
                      class="form-grid" id="userForm">

                    <c:if test="${editMode}">
                        <input type="hidden" name="id" value="${utilisateur.idUtilisateur}">
                    </c:if>

                    <div class="form-group">
                        <label for="nom">Nom <span class="required">*</span></label>
                        <input type="text" id="nom" name="nom" value="${utilisateur.nom}" required
                               placeholder="Nom de famille">
                    </div>

                    <div class="form-group">
                        <label for="prenom">Prenom <span class="required">*</span></label>
                        <input type="text" id="prenom" name="prenom" value="${utilisateur.prenom}" required
                               placeholder="Prenom">
                    </div>

                    <div class="form-group">
                        <label for="email">Email <span class="required">*</span></label>
                        <input type="email" id="email" name="email" value="${utilisateur.email}" required
                               placeholder="email@exemple.com">
                    </div>

                    <div class="form-group">
                        <label for="telephone">Telephone</label>
                        <input type="tel" id="telephone" name="telephone" value="${utilisateur.telephone}"
                               placeholder="0600000000">
                    </div>

                    <div class="form-group hidden" id="cneGroup">
                        <label for="cne">CNE <span class="required">*</span></label>
                        <input type="text" id="cne" name="cne" value="${utilisateur.cne}"
                               placeholder="Ex: E123456789">
                    </div>

                    <c:if test="${not editMode}">
                        <div class="form-group">
                            <label for="motDePasse">Mot de passe <span class="required">*</span></label>
                            <input type="password" id="motDePasse" name="motDePasse" required
                                   placeholder="Minimum 6 caracteres" minlength="6">
                        </div>
                    </c:if>

                    <div class="form-group">
                        <label for="role">Role <span class="required">*</span></label>
                        <select id="role" name="role" required class="form-select">
                            <option value="">-- Selectionner un role --</option>
                            <option value="ADMIN" ${utilisateur.role.nomRole == 'ADMIN' ? 'selected' : ''}>Administrateur</option>
                            <option value="PROFESSEUR" ${utilisateur.role.nomRole == 'PROFESSEUR' ? 'selected' : ''}>Professeur</option>
                            <option value="ETUDIANT" ${utilisateur.role.nomRole == 'ETUDIANT' ? 'selected' : ''}>Etudiant</option>
                        </select>
                    </div>

                    <div class="form-group hidden" id="filiereGroup">
                        <label for="idFiliere">Filiere</label>
                        <select id="idFiliere" name="idFiliere" class="form-select">
                            <option value="">-- Selectionner --</option>
                            <c:forEach var="f" items="${filieres}">
                                <option value="${f.idFiliere}"
                                    ${utilisateur.filiere != null && utilisateur.filiere.idFiliere == f.idFiliere ? 'selected' : ''}>
                                    ${f.nomFiliere}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group hidden" id="semestreGroup">
                        <label for="idSemestre">Semestre</label>
                        <select id="idSemestre" name="idSemestre" class="form-select">
                            <option value="">-- Selectionner --</option>
                            <c:forEach var="s" items="${semestres}">
                                <option value="${s.idSemestre}"
                                    ${utilisateur.semestre != null && utilisateur.semestre.idSemestre == s.idSemestre ? 'selected' : ''}>
                                    ${s.nomSemestre}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> ${editMode ? 'Modifier' : 'Creer'}
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/utilisateurs" class="btn btn-outline">
                            Annuler
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</h3>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script>
        // Afficher filiere/semestre/cne uniquement pour le role ETUDIANT
        const roleSelect = document.getElementById('role');
        const filiereGroup = document.getElementById('filiereGroup');
        const semestreGroup = document.getElementById('semestreGroup');
        const cneGroup = document.getElementById('cneGroup');

        function toggleFields() {
            const isEtudiant = roleSelect.value === 'ETUDIANT';
            filiereGroup.style.display = isEtudiant ? '' : 'none';
            semestreGroup.style.display = isEtudiant ? '' : 'none';
            cneGroup.style.display = isEtudiant ? '' : 'none';
        }

        roleSelect.addEventListener('change', toggleFields);
        toggleFields(); // initial
        
    </script>
</body>
</html>
