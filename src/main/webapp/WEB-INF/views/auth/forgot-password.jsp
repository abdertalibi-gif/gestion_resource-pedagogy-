<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mot de passe oublié — GesPed</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Raleway:wght@700;800;900&display=swap" rel="stylesheet">
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
        <div>(1+x+y+2a)·(3a+3g)</div>
        <div>&int;&#8320;^&infin; e^(-t&sup2;) dt = &radic;&pi;/2</div>
        <div>&sum; x&#7522;&sup2; = &Vert;x&Vert;&sup2; cos(&theta;)</div>
        <div>&nabla;f = (&part;f/&part;x, &part;f/&part;y)</div>
        <div>y = ax&sup2; + bx + c</div>
      </div>
      <div class="deco-num">?</div>

      <div class="blue-content">
        <div class="blue-avatar">
          <i class="fas fa-key"></i>
        </div>

        <h2>Mot de passe<br>oubli&eacute; ?</h2>
        <div class="orange-bar"></div>
        <p>Pas d'inqui&eacute;tude, r&eacute;initialiser votre acc&egrave;s est simple et rapide.</p>

        <div class="blue-steps">
          <div class="bs">
            <div class="bs-num">1</div>
            <div class="bs-text">Entrez votre adresse email institutionnelle</div>
          </div>
          <div class="bs">
            <div class="bs-num">2</div>
            <div class="bs-text">Recevez un lien de r&eacute;initialisation par email</div>
          </div>
          <div class="bs">
            <div class="bs-num">3</div>
            <div class="bs-text">D&eacute;finissez votre nouveau mot de passe</div>
          </div>
          <div class="bs">
            <div class="bs-num">4</div>
            <div class="bs-text">Reconnectez-vous &agrave; votre espace GesPed</div>
          </div>
        </div>
      </div>
    </div>


    <!-- ===== DROITE blanc ===== -->
    <div class="side-white">
      <div class="form-box">

        <div class="form-eyebrow">
          <i class="fas fa-key"></i> R&eacute;cup&eacute;ration
        </div>
        <h1 class="form-title">R&eacute;initialiser</h1>
        <p class="form-subtitle">Entrez l'email associ&eacute; &agrave; votre compte pour recevoir un lien de r&eacute;initialisation.</p>

        <!-- Info -->
        <div class="info-box">
          <i class="fas fa-info-circle"></i>
          <span>Le lien de r&eacute;initialisation est valable <strong>15 minutes</strong>. V&eacute;rifiez &eacute;galement votre dossier <strong>spam</strong> si vous ne recevez pas l'email.</span>
        </div>

        <!-- Alertes -->
        <% if (request.getParameter("error") != null) { %>
          <div class="alert alert-err">
            <i class="fas fa-exclamation-circle"></i>
            <span>Aucun compte trouv&eacute; avec cette adresse email.</span>
          </div>
        <% } %>
        <% if (request.getParameter("sent") != null) { %>
          <div class="alert alert-ok">
            <i class="fas fa-check-circle"></i>
            <span>Un email de r&eacute;initialisation a &eacute;t&eacute; envoy&eacute; &agrave; votre adresse. V&eacute;rifiez votre bo&icirc;te de r&eacute;ception.</span>
          </div>
        <% } %>

        <!-- FORMULAIRE -->
        <form id="forgotForm" action="${pageContext.request.contextPath}/forgot-password" method="post" autocomplete="on" novalidate>

          <!-- Email -->
          <div class="fgroup">
            <label class="flabel" for="email">
              <i class="fas fa-envelope"></i>Adresse email institutionnelle
            </label>
            <div class="finput-wrap">
              <i class="fas fa-envelope finput-icon"></i>
              <input type="email"
                     id="email" name="email"
                     class="finput"
                     placeholder="votre.nom@univ.ma"
                     autocomplete="email"
                     required>
            </div>
            <div class="field-error" id="emailError">
              <i class="fas fa-exclamation-triangle"></i>
              <span>Veuillez entrer une adresse email valide.</span>
            </div>
          </div>

          <!-- Bouton -->
          <button type="submit" class="btn-submit" id="submitBtn">
            <span class="btn-icon"><i class="fas fa-paper-plane"></i></span>
            <span class="btn-text">Envoyer le lien</span>
            <span class="spinner"></span>
          </button>

        </form>

        <div class="divider">ou</div>

        <div class="form-links">
          <a href="${pageContext.request.contextPath}/login"><i class="fas fa-arrow-left"></i> Retour &agrave; la connexion</a>
          <span class="dot">&middot;</span>
          <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Accueil</a>
        </div>

        <div class="secure">
          <i class="fas fa-shield-alt"></i>
          Demande s&eacute;curis&eacute;e — Universit&eacute; Moulay Ismail
        </div>

      </div>
    </div>

  </div><!-- /page-wrap -->


  <!-- =====================================================
       FOOTER
       ===================================================== -->
  <footer class="foot">
    &copy; 2025 GesPed &mdash;
    <a href="https://fs-umi.ac.ma" target="_blank">Facult&eacute; des Sciences</a>
    &mdash; Universit&eacute; Moulay Ismail, Mekn&egrave;s
  </footer>


  <script>
    (function() {
      var form = document.getElementById('forgotForm');
      var emailInput = document.getElementById('email');
      var emailError = document.getElementById('emailError');
      var submitBtn = document.getElementById('submitBtn');

      /* Regex email basique */
      var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;

      /* Validation en temps réel quand l'utilisateur sort du champ */
      emailInput.addEventListener('blur', function() {
        if (this.value.trim() !== '' && !emailRegex.test(this.value.trim())) {
          this.classList.add('input-error');
          emailError.classList.add('show');
        } else {
          this.classList.remove('input-error');
          emailError.classList.remove('show');
        }
      });

      /* Retirer l'erreur quand l'utilisateur retape */
      emailInput.addEventListener('input', function() {
        this.classList.remove('input-error');
        emailError.classList.remove('show');
      });

      /* Soumission */
      form.addEventListener('submit', function(e) {
        var val = emailInput.value.trim();

        /* Validation */
        if (!val || !emailRegex.test(val)) {
          e.preventDefault();
          emailInput.classList.add('input-error');
          emailError.classList.add('show');
          emailInput.focus();
          return;
        }

        /* État chargement */
        submitBtn.classList.add('loading');
        submitBtn.disabled = true;
        /* Le formulaire est soumis normalement (pas d'AJAX)
           le spinner sera visible pendant le redirect serveur */
      });
    })();
  </script>

</body>
</html>