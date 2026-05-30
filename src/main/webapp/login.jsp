<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Connexion — GesPed</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Raleway:wght@700;800;900&display=swap" rel="stylesheet">
  <c:set var="ctx" value="${pageContext.request.contextPath}" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css?v=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/responsive.css?v=1">
</head>
<body>

  <!-- =====================================================
       TOPBAR
       ===================================================== -->
  <header class="topbar">
    <div class="topbar-inner">

      <div class="logo-left">
        <a href="${pageContext.request.contextPath}/" title="Accueil">
          <img src="logofsm.jpg" alt="Université Moulay Ismail — Faculté des Sciences">
        </a>
      </div>

      <a href="${pageContext.request.contextPath}/" class="logo-right" title="GesPed">
        <div class="gesped-icon"><i class="fas fa-graduation-cap"></i></div>
        <div class="gesped-text">
          <strong>GesPed</strong>
          <small class="text-warning">Gestion Pédagogique</small>
        </div>
      </a>

    </div>
  </header>


  <!-- =====================================================
       SPLIT SCREEN
       ===================================================== -->
  <div class="page-wrap">

    <!-- ===== GAUCHE bleu ===== -->
    <div class="side-blue">
      <div class="deco-formulas">
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>
      </div>
      <div class="deco-num">G</div>

      <div class="blue-content">
        <div class="blue-avatar">
          <i class="fas fa-graduation-cap"></i>
        </div>

        <h2>Bienvenue<br>sur GesPed</h2>
        <div class="orange-bar"></div>
        <p>Votre plateforme centralisée pour gérer, partager et consulter toutes vos ressources pédagogiques.</p>

        <div class="blue-features">
          <div class="bf">
            <i class="fas fa-file-alt"></i>
            <span>Cours PDF, vidéos, TD &amp; TP</span>
          </div>
          <div class="bf">
            <i class="fas fa-search"></i>
            <span>Recherche avancée par module</span>
          </div>
          <div class="bf">
            <i class="fas fa-star"></i>
            <span>Favoris et accès rapide</span>
          </div>
          <div class="bf">
            <i class="fas fa-chart-bar"></i>
            <span>Statistiques &amp; activité</span>
          </div>
          <div class="bf">
            <i class="fas fa-shield-alt"></i>
            <span>Accès sécurisé par profil</span>
          </div>
        </div>
      </div>
    </div>


    <!-- ===== DROITE blanc ===== -->
    <div class="side-white">
      <div class="form-box">

        <div class="form-eyebrow">
          <i class="fas fa-university"></i> Faculté des Sciences
        </div>
        <h1 class="form-title">Connexion</h1>
        <p class="form-subtitle">Connectez-vous à votre espace membre</p>

        <!-- Alertes JSP -->
        <%
          String errorMsg = (String) request.getAttribute("error");
          if (errorMsg != null) {
        %>
          <div class="alert alert-err">
            <i class="fas fa-exclamation-circle"></i>
            <span><%= errorMsg %></span>
          </div>
        <% } %>
        <% if (request.getParameter("logout") != null) { %>
          <div class="alert alert-ok">
            <i class="fas fa-check-circle"></i>
            <span>Vous avez été déconnecté avec succès.</span>
          </div>
        <% } %>
        <%-- ⬇️ NOUVEAU : alerte après reset réussi --%>
        <% if (request.getParameter("reset") != null) { %>
          <div class="alert alert-ok">
            <i class="fas fa-check-circle"></i>
            <span>Votre mot de passe a été modifié avec succès. Connectez-vous.</span>
          </div>
        <% } %>

        <!-- FORMULAIRE -->
        <form action="${pageContext.request.contextPath}/login" method="post" autocomplete="on">

          <!-- Email -->
          <div class="fgroup">
            <label class="flabel" for="email">
              <i class="fas fa-envelope"></i>Adresse email
            </label>
            <div class="finput-wrap">
              <i class="fas fa-envelope finput-icon"></i>
              <input type="email"
                     id="email" name="email"
                     class="finput"
                     placeholder="exemple@univ.ma"
                     autocomplete="email"
                     required>
            </div>
          </div>

          <!-- Mot de passe -->
          <div class="fgroup">
            <label class="flabel" for="password">
              <i class="fas fa-lock"></i>Mot de passe
            </label>
            <div class="finput-wrap">
              <i class="fas fa-lock finput-icon"></i>
              <input type="password"
                     id="password" name="password"
                     class="finput"
                     placeholder="Votre mot de passe"
                     autocomplete="current-password"
                     required>
              <i class="fas fa-eye toggle-eye" id="eyeIcon" onclick="togglePwd()"></i>
            </div>
          </div>

          <!-- Se souvenir -->
          <div class="fcheck">
            <input type="checkbox" id="remember" name="remember">
            <label for="remember">Se souvenir de moi</label>
          </div>

          <!-- Bouton -->
          <button type="submit" class="btn-submit">
            <i class="fas fa-sign-in-alt"></i>
            Se connecter
          </button>

        </form>

        <div class="divider">ou</div>

        <div class="form-links">
          <a href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus"></i> Créer un compte</a>
          <span class="dot">·</span>
          <a href="${pageContext.request.contextPath}/forgot-password"><i class="fas fa-key"></i> Mot de passe oublié ?</a>
          <span class="dot">·</span>
          <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Accueil</a>
        </div>

        <div class="secure">
          <i class="fas fa-lock"></i>
          Connexion chiffrée — Université Moulay Ismail
        </div>

      </div>
    </div>

  </div><!-- /page-wrap -->


  <!-- =====================================================
       FOOTER
       ===================================================== -->
  <footer class="foot">
    &copy; 2025 GesPed &mdash;
    <a href="https://fs-umi.ac.ma" target="_blank">Faculté des Sciences</a>
    &mdash; Université Moulay Ismail, Meknès
  </footer>


  <script>
    function togglePwd() {
      var inp  = document.getElementById('password');
      var icon = document.getElementById('eyeIcon');
      if (inp.type === 'password') {
        inp.type = 'text';
        icon.classList.replace('fa-eye', 'fa-eye-slash');
      } else {
        inp.type = 'password';
        icon.classList.replace('fa-eye-slash', 'fa-eye');
      }
    }
  </script>

</body>
</html>