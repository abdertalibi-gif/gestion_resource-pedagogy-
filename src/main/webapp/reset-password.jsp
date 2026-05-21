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

  <style>
    :root {
      --blue-dark:  #006494;
      --blue:       #0582b5;
      --blue-mid:   #1497cc;
      --blue-light: #e8f4fb;
      --blue-pale:  #f0f8ff;
      --orange:     #e87722;
      --orange-light:#fff3e8;
      --white:      #ffffff;
      --gray-50:    #f9fafb;
      --gray-100:   #f3f4f6;
      --gray-200:   #e5e7eb;
      --gray-300:   #d1d5db;
      --gray-400:   #9ca3af;
      --gray-500:   #8892a0;
      --gray-600:   #6b7280;
      --gray-700:   #374151;
      --text:       #111827;
      --red:        #dc2626;
      --green:      #16a34a;
      --font-body:    'Open Sans', sans-serif;
      --font-display: 'Raleway', sans-serif;
    }
    *, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }
    html, body { height: 100%; }
    body {
      font-family: var(--font-body);
      background: var(--gray-100);
      color: var(--text);
      display: flex; flex-direction: column;
      min-height: 100vh;
      -webkit-font-smoothing: antialiased;
    }
    a { text-decoration: none; color: inherit; }

    /* TOPBAR */
    .topbar {
      background: var(--white);
      border-bottom: 3px solid var(--orange);
      box-shadow: 0 2px 8px rgba(0,60,100,0.08);
      flex-shrink: 0;
    }
    .topbar-inner {
      max-width: 1180px; margin: 0 auto; padding: 0 28px;
      height: 72px;
      display: flex; align-items: center; justify-content: space-between;
    }
    .logo-left a { display: flex; align-items: center; }
    .logo-left img { height: 54px; width: auto; object-fit: contain; }
    .logo-right { display: flex; align-items: center; gap: 10px; }
    .gesped-icon {
      width: 42px; height: 42px; border-radius: 10px;
      background: linear-gradient(145deg, #0e6fa8, #1497cc);
      display: flex; align-items: center; justify-content: center;
      color: white; font-size: 18px;
      box-shadow: 0 2px 8px rgba(14,111,168,0.28);
    }
    .gesped-text strong {
      font-family: var(--font-display); font-size: 17px; font-weight: 800;
      color: var(--blue-dark); display: block; line-height: 1;
    }
    .gesped-text small { font-size: 10px; color: var(--gray-500); display: block; margin-top: 2px; }

    /* CENTER */
    .page-center {
      flex: 1; display: flex; align-items: center; justify-content: center;
      padding: 40px 24px;
    }
    .form-card {
      width: 100%; max-width: 440px;
      background: var(--white); border-radius: 14px;
      box-shadow: 0 4px 24px rgba(0,60,100,0.10);
      padding: 40px 36px;
      border-top: 4px solid var(--blue);
    }

    /* Header */
    .form-icon-header {
      width: 64px; height: 64px; border-radius: 16px;
      background: var(--blue-light);
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 20px; font-size: 26px; color: var(--blue);
      border: 2px solid rgba(5,130,181,0.15);
    }
    .form-title {
      font-family: var(--font-display); font-size: 24px; font-weight: 900;
      color: var(--blue-dark); text-transform: uppercase;
      letter-spacing: 0.03em; text-align: center; line-height: 1.1; margin-bottom: 6px;
    }
    .form-subtitle {
      font-size: 13.5px; color: var(--gray-500); text-align: center;
      margin-bottom: 28px; line-height: 1.6;
    }

    /* Alertes */
    .alert {
      display: flex; align-items: flex-start; gap: 10px;
      padding: 12px 14px; border-radius: 8px;
      font-size: 13px; font-weight: 500; margin-bottom: 20px;
    }
    .alert i { margin-top: 1px; flex-shrink: 0; font-size: 14px; }
    .alert-err {
      background: #fef2f2; color: #991b1b;
      border: 1px solid #fecaca; border-left: 4px solid var(--red);
    }

    /* Champs */
    .fgroup { margin-bottom: 18px; }
    .flabel {
      display: block; font-size: 12.5px; font-weight: 700;
      color: var(--gray-700); margin-bottom: 7px; letter-spacing: 0.02em;
    }
    .flabel i { color: var(--blue); margin-right: 5px; }
    .finput-wrap { position: relative; }
    .finput-icon {
      position: absolute; left: 13px; top: 50%; transform: translateY(-50%);
      color: var(--gray-400); font-size: 14px; pointer-events: none;
    }
    .finput {
      width: 100%; padding: 12px 42px 12px 40px;
      border: 1.5px solid var(--gray-300); border-radius: 8px;
      font-family: var(--font-body); font-size: 14px; color: var(--text);
      background: var(--gray-50); outline: none;
      transition: border-color .2s, box-shadow .2s, background .2s;
    }
    .finput::placeholder { color: var(--gray-400); }
    .finput:focus {
      border-color: var(--blue); background: var(--white);
      box-shadow: 0 0 0 3px rgba(5,130,181,0.12);
    }
    .finput.input-error {
      border-color: var(--red); background: #fffafa;
      box-shadow: 0 0 0 3px rgba(220,38,38,0.08);
    }
    .toggle-eye {
      position: absolute; right: 13px; top: 50%; transform: translateY(-50%);
      color: var(--gray-400); cursor: pointer; font-size: 14px; transition: color .2s;
    }
    .toggle-eye:hover { color: var(--blue); }

    /* Force indicator */
    .pwd-strength {
      display: flex; gap: 4px; margin-top: 8px;
    }
    .pwd-bar {
      flex: 1; height: 4px; border-radius: 2px;
      background: var(--gray-200); transition: background .3s;
    }
    .pwd-bar.weak { background: var(--red); }
    .pwd-bar.medium { background: #f59e0b; }
    .pwd-bar.strong { background: var(--green); }
    .pwd-hint {
      font-size: 11px; color: var(--gray-400); margin-top: 4px;
      transition: color .3s;
    }

    /* Bouton */
    .btn-submit {
      width: 100%; padding: 13px 20px;
      background: var(--blue); color: white;
      font-family: var(--font-display); font-size: 14px; font-weight: 900;
      text-transform: uppercase; letter-spacing: 0.08em;
      border: none; border-radius: 8px; cursor: pointer;
      display: flex; align-items: center; justify-content: center; gap: 9px;
      transition: background .2s, transform .2s, box-shadow .2s;
      box-shadow: 0 3px 12px rgba(5,130,181,0.30);
      margin-top: 6px;
    }
    .btn-submit:hover {
      background: var(--blue-dark); transform: translateY(-2px);
      box-shadow: 0 6px 18px rgba(0,100,148,0.35);
    }
    .btn-submit:active { transform: translateY(0); }

    /* Liens */
    .form-links {
      display: flex; align-items: center; justify-content: center;
      gap: 6px; margin-top: 22px; font-size: 13px;
    }
    .form-links a { color: var(--blue); font-weight: 600; transition: color .2s; }
    .form-links a:hover { color: var(--blue-dark); text-decoration: underline; }

    /* Sécurité */
    .secure {
      display: flex; align-items: center; justify-content: center; gap: 7px;
      margin-top: 20px; padding: 9px 16px;
      background: var(--gray-50); border: 1px solid var(--gray-200);
      border-radius: 8px; font-size: 12px; color: var(--gray-500);
    }
    .secure i { color: var(--green); }

    /* FOOTER */
    .foot {
      background: #002b45; border-top: 3px solid var(--orange);
      padding: 14px 28px; text-align: center;
      font-size: 12px; color: rgba(255,255,255,0.30); flex-shrink: 0;
    }
    .foot a { color: rgba(255,255,255,0.55); transition: color .2s; }
    .foot a:hover { color: white; }

    @media (max-width: 480px) {
      .topbar-inner { padding: 0 16px; }
      .logo-left img { height: 42px; }
      .form-card { padding: 28px 20px; border-radius: 12px; }
      .form-title { font-size: 20px; }
    }
  </style>
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
          <small style="color:red">Gestion P&eacute;dagogique</small>
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