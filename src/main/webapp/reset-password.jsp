<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Nouveau mot de passe — GesPed</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Raleway:wght@700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css?v=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/responsive.css?v=1">
</head>
<body>

  <!-- TOPBAR -->
  <header class="topbar">
    <div class="topbar-inner">
      <div class="logo-left">
        <a href="${pageContext.request.contextPath}/" title="Accueil">
          <img src="logofsm.jpg" alt="FSM — UMI">
        </a>
      </div>
      <a href="${pageContext.request.contextPath}/" class="logo-right" title="GesPed">
        <div class="gesped-icon"><i class="fas fa-graduation-cap"></i></div>
        <div class="gesped-text">
          <strong>GesPed</strong>
          <small class="text-warning">Gestion P&eacute;dagogique</small>
        </div>
      </a>
    </div>
  </header>

  <!-- FORMULAIRE -->
  <div class="page-center">
    <div class="form-card">

      <div class="form-icon-header">
        <i class="fas fa-lock-open"></i>
      </div>
      <h1 class="form-title">Nouveau mot de passe</h1>
      <p class="form-subtitle">Choisissez un mot de passe fort pour votre compte GesPed</p>

      <!-- Erreur champ -->
      <% if (request.getAttribute("errorField") != null) { %>
        <div class="alert alert-err">
          <i class="fas fa-exclamation-circle"></i>
          <span>${errorField}</span>
        </div>
      <% } %>

      <form action="${pageContext.request.contextPath}/reset-password" method="post" novalidate>
        <input type="hidden" name="token" value="${token}">

        <!-- Nouveau mot de passe -->
        <div class="fgroup">
          <label class="flabel" for="newPassword">
            <i class="fas fa-lock"></i>Nouveau mot de passe
          </label>
          <div class="finput-wrap">
            <i class="fas fa-lock finput-icon"></i>
            <input type="password" id="newPassword" name="newPassword"
                   class="finput" placeholder="Minimum 6 caract&egrave;res"
                   minlength="6" required autocomplete="new-password">
            <i class="fas fa-eye toggle-eye" onclick="togglePwd('newPassword', this)"></i>
          </div>
          <div class="pwd-strength" id="pwdStrength">
            <div class="pwd-bar" id="bar1"></div>
            <div class="pwd-bar" id="bar2"></div>
            <div class="pwd-bar" id="bar3"></div>
            <div class="pwd-bar" id="bar4"></div>
          </div>
          <div class="pwd-hint" id="pwdHint">Entrez votre mot de passe</div>
        </div>

        <!-- Confirmation -->
        <div class="fgroup">
          <label class="flabel" for="confirmPassword">
            <i class="fas fa-lock"></i>Confirmer le mot de passe
          </label>
          <div class="finput-wrap">
            <i class="fas fa-lock finput-icon"></i>
            <input type="password" id="confirmPassword" name="confirmPassword"
                   class="finput" placeholder="Retapez le m&ecirc;me mot de passe"
                   minlength="6" required autocomplete="new-password">
            <i class="fas fa-eye toggle-eye" onclick="togglePwd('confirmPassword', this)"></i>
          </div>
        </div>

        <button type="submit" class="btn-submit">
          <i class="fas fa-check-circle"></i>
          Enregistrer le mot de passe
        </button>
      </form>

      <div class="form-links">
        <a href="${pageContext.request.contextPath}/login"><i class="fas fa-arrow-left"></i> Retour &agrave; la connexion</a>
      </div>

      <div class="secure">
        <i class="fas fa-shield-alt"></i>
        Connexion s&eacute;curis&eacute;e — Universit&eacute; Moulay Ismail
      </div>

    </div>
  </div>

  <!-- FOOTER -->
  <footer class="foot">
    &copy; 2025 GesPed &mdash;
    <a href="https://fs-umi.ac.ma" target="_blank">Facult&eacute; des Sciences</a>
    &mdash; Universit&eacute; Moulay Ismail, Mekn&egrave;s
  </footer>

  <script>
    /* Toggle mot de passe */
    function togglePwd(id, icon) {
      var inp = document.getElementById(id);
      if (inp.type === 'password') {
        inp.type = 'text';
        icon.classList.replace('fa-eye', 'fa-eye-slash');
      } else {
        inp.type = 'password';
        icon.classList.replace('fa-eye-slash', 'fa-eye');
      }
    }

    /* Indicateur de force */
    var pwdInput = document.getElementById('newPassword');
    var bars = [
      document.getElementById('bar1'),
      document.getElementById('bar2'),
      document.getElementById('bar3'),
      document.getElementById('bar4')
    ];
    var hint = document.getElementById('pwdHint');

    pwdInput.addEventListener('input', function() {
      var val = this.value;
      var score = 0;

      if (val.length >= 6) score++;
      if (val.length >= 10) score++;
      if (/[A-Z]/.test(val) && /[a-z]/.test(val)) score++;
      if (/\d/.test(val)) score++;
      if (/[^A-Za-z0-9]/.test(val)) score++;

      // Clamp 0-4
      score = Math.min(score, 4);

      var labels = ['Entrez votre mot de passe', 'Faible', 'Moyen', 'Bon', 'Fort'];
      var classes = ['', 'weak', 'medium', 'medium', 'strong'];
      var colors  = ['var(--gray-400)', 'var(--red)', '#f59e0b', '#f59e0b', 'var(--green)'];

      bars.forEach(function(bar, i) {
        bar.className = 'pwd-bar';
        if (val.length === 0) return;
        if (i < score) bar.classList.add(classes[score]);
      });

      hint.textContent = labels[score];
      hint.style.color = colors[score];
    });
  </script>

</body>
</html>