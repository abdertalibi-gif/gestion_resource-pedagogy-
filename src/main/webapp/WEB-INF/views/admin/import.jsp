<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%
    request.setAttribute("role", "ADMIN");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Import Excel");
    request.setAttribute("activeMenu", "import");

    String msgSucc = (String) session.getAttribute("msgSuccess");
    String msgErr = (String) session.getAttribute("msgError");
    if (msgSucc != null) { request.setAttribute("msgSuccess", msgSucc); session.removeAttribute("msgSuccess"); }
    if (msgErr != null) { request.setAttribute("msgError", msgErr); session.removeAttribute("msgError"); }
    Object errList = session.getAttribute("errors");
    if (errList != null) { request.setAttribute("errors", errList); session.removeAttribute("errors"); }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Import Excel — GesPed</title>
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
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i>
                    <ul style="margin:8px 0 0 20px">
                        <c:forEach var="err" items="${errors}">
                            <li>${err}</li>
                        </c:forEach>
                    </ul>
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>

            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Importez des etudiants ou des professeurs depuis un fichier Excel.</p>
                </div>
                <i class="fas fa-file-import welcome-icon"></i>
            </div>

            <div class="page-header">
                <div class="page-header-left">
                    <h3>Import Excel</h3>
                    <p>Importez en masse des comptes a partir d'un fichier Excel (.xlsx)</p>
                </div>
            </div>

            <div class="dashboard-section">
                <div class="section-header">
                    <h3><i class="fas fa-upload"></i> Importer un fichier</h3>
                </div>
                <div class="card" style="max-width:600px">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/import" method="post" enctype="multipart/form-data">
                            <div class="fgroup">
                                <label class="flabel"><i class="fas fa-user-tag"></i> Type d'import</label>
                                <div style="display:flex;gap:20px;margin-top:8px">
                                    <label style="display:flex;align-items:center;gap:6px;cursor:pointer">
                                        <input type="radio" name="typeImport" value="ETUDIANT" checked onchange="toggleFormat()">
                                        <i class="fas fa-user-graduate"></i> Etudiants
                                    </label>
                                    <label style="display:flex;align-items:center;gap:6px;cursor:pointer">
                                        <input type="radio" name="typeImport" value="PROFESSEUR" onchange="toggleFormat()">
                                        <i class="fas fa-chalkboard-teacher"></i> Professeurs
                                    </label>
                                </div>
                            </div>
                            <div class="fgroup">
                                <label class="flabel" for="fichierExcel">
                                    <i class="fas fa-file-excel"></i> Fichier Excel (.xlsx)
                                </label>
                                <div class="finput-wrap" style="padding:8px 12px">
                                    <input type="file" id="fichierExcel" name="fichierExcel"
                                           accept=".xlsx,.xls" required
                                           style="width:100%;border:none;outline:none;font-size:14px">
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary" style="margin-top:16px">
                                <i class="fas fa-upload"></i> Importer
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="dashboard-section">
                <div class="section-header">
                    <h3><i class="fas fa-info-circle"></i> Format attendu</h3>
                </div>

                <!-- Table Etudiants -->
                <div class="card" id="formatEtudiants" style="max-width:700px">
                    <div class="card-header"><h4><i class="fas fa-user-graduate"></i> Etudiants</h4></div>
                    <div class="card-body">
                        <table class="table" style="margin-top:0">
                            <thead><tr><th>#</th><th>Colonne</th><th>Description</th><th>Obligatoire</th></tr></thead>
                            <tbody>
                                <tr><td>1</td><td>Nom</td><td>Nom de famille</td><td><span class="status-badge status-active">Oui</span></td></tr>
                                <tr><td>2</td><td>Prenom</td><td>Prenom</td><td><span class="status-badge status-active">Oui</span></td></tr>
                                <tr><td>3</td><td>Email</td><td>Adresse email unique</td><td><span class="status-badge status-active">Oui</span></td></tr>
                                <tr><td>4</td><td>MotDePasse</td><td>Mot de passe</td><td><span class="status-badge status-active">Oui</span></td></tr>
                                <tr><td>5</td><td>Filiere</td><td>Nom de la filiere (ex: IDA)</td><td><span class="status-badge status-active">Oui</span></td></tr>
                                <tr><td>6</td><td>Niveau</td><td>Semestre (ex: S1, S2, ...)</td><td><span class="status-badge status-active">Oui</span></td></tr>
                                <tr><td>7</td><td>CNE</td><td>Code National Etudiant</td><td><span class="status-badge status-inactive">Non</span></td></tr>
                                <tr><td>8</td><td>Telephone</td><td>Numero de telephone</td><td><span class="status-badge status-inactive">Non</span></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Table Professeurs -->
                <div class="card" id="formatProfesseurs" style="max-width:700px;display:none">
                    <div class="card-header"><h4><i class="fas fa-chalkboard-teacher"></i> Professeurs</h4></div>
                    <div class="card-body">
                        <table class="table" style="margin-top:0">
                            <thead><tr><th>#</th><th>Colonne</th><th>Description</th><th>Obligatoire</th></tr></thead>
                            <tbody>
                                <tr><td>1</td><td>Nom</td><td>Nom de famille</td><td><span class="status-badge status-active">Oui</span></td></tr>
                                <tr><td>2</td><td>Prenom</td><td>Prenom</td><td><span class="status-badge status-active">Oui</span></td></tr>
                                <tr><td>3</td><td>Email</td><td>Adresse email unique</td><td><span class="status-badge status-active">Oui</span></td></tr>
                                <tr><td>4</td><td>MotDePasse</td><td>Mot de passe</td><td><span class="status-badge status-active">Oui</span></td></tr>
                                <tr><td>5</td><td>Telephone</td><td>Numero de telephone</td><td><span class="status-badge status-inactive">Non</span></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
    function toggleFormat() {
        var etu = document.getElementById('formatEtudiants');
        var prof = document.getElementById('formatProfesseurs');
        var val = document.querySelector('input[name="typeImport"]:checked').value;
        if (val === 'ETUDIANT') { etu.style.display = ''; prof.style.display = 'none'; }
        else { etu.style.display = 'none'; prof.style.display = ''; }
    }
    </script>
</body>
</html>