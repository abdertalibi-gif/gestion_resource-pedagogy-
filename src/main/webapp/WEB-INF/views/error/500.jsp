<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 — Erreur serveur</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body class="error-body">
    <div class="error-container">
        <div class="error-code">500</div>
        <h2>Erreur interne du serveur</h2>
        <p>Une erreur inattendue s'est produite. Veuillez reessayer plus tard.</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
            <i class="fas fa-home"></i> Retour a l'accueil
        </a>
    </div>
</body>
</html>