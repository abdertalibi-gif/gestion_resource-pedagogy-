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

  <style>
    /* ============================================================
       VARIABLES — Palette GesPed
       ============================================================ */
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

    /* ============================================================
       TOPBAR
       ============================================================ */
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
    .logo-left img { height: 54px; width: auto; object-fit: contain; display: block; }
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
    .gesped-text small {
      font-size: 10px; color: var(--gray-500); display: block; margin-top: 2px;
    }

    /* ============================================================
       PAGE BODY
       ============================================================ */
    .page-wrap {
      flex: 1;
      display: grid;
      grid-template-columns: 1fr 1fr;
    }

    /* ---- Panneau GAUCHE bleu ---- */
    .side-blue {
      background: linear-gradient(145deg, #004d73 0%, #0582b5 55%, #1497cc 100%);
      display: flex; flex-direction: column;
      align-items: center; justify-content: center;
      padding: 64px 52px;
      position: relative; overflow: hidden;
    }
    .side-blue::before {
      content: '';
      position: absolute; inset: 0;
      background-image: radial-gradient(circle, rgba(255,255,255,0.055) 1px, transparent 1px);
      background-size: 28px 28px;
      pointer-events: none;
    }
    .deco-num {
      position: absolute; right: -20px; bottom: -50px;
      font-family: var(--font-display); font-size: 260px; font-weight: 900;
      color: rgba(255,255,255,0.045); line-height: 1;
      pointer-events: none; user-select: none;
    }
    .deco-formulas {
      position: absolute; top: 18px; right: 18px;
      font-family: 'Georgia', serif; font-size: 12px;
      color: rgba(255,255,255,0.07); line-height: 2.6;
      text-align: right; pointer-events: none; user-select: none;
    }
    .blue-content { position: relative; z-index: 2; text-align: center; width: 100%; max-width: 340px; }
    .blue-avatar {
      width: 88px; height: 88px; border-radius: 24px;
      background: rgba(255,255,255,0.14);
      border: 2px solid rgba(255,255,255,0.26);
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 26px; font-size: 36px; color: white;
    }
    .blue-content h2 {
      font-family: var(--font-display); font-size: 30px; font-weight: 900;
      color: white; text-transform: uppercase; letter-spacing: 0.04em;
      line-height: 1.15; margin-bottom: 16px;
    }
    .orange-bar {
      width: 48px; height: 4px; border-radius: 2px;
      background: var(--orange); margin: 0 auto 22px;
    }
    .blue-content p {
      font-size: 14px; color: rgba(255,255,255,0.72);
      line-height: 1.78; margin-bottom: 36px;
    }
    .blue-steps { display: flex; flex-direction: column; gap: 14px; }
    .bs {
      display: flex; align-items: center; gap: 14px;
      background: rgba(255,255,255,0.10);
      border: 1px solid rgba(255,255,255,0.16);
      border-radius: 10px; padding: 14px 16px; text-align: left;
    }
    .bs-num {
      width: 30px; height: 30px; border-radius: 8px;
      background: rgba(255,255,255,0.18);
      display: flex; align-items: center; justify-content: center;
      font-family: var(--font-display); font-size: 13px; font-weight: 800;
      color: white; flex-shrink: 0;
    }
    .bs-text { font-size: 13px; color: rgba(255,255,255,0.82); font-weight: 500; line-height: 1.45; }

    /* ---- Panneau DROITE blanc ---- */
    .side-white {
      background: var(--white);
      display: flex; align-items: center; justify-content: center;
      padding: 52px 48px;
    }
    .form-box { width: 100%; max-width: 420px; }

    /* En-tête */
    .form-eyebrow {
      display: inline-flex; align-items: center; gap: 7px;
      background: var(--orange-light); color: var(--orange);
      font-size: 11px; font-weight: 700; text-transform: uppercase;
      letter-spacing: 0.10em; padding: 4px 12px; border-radius: 4px;
      border: 1px solid rgba(232,119,34,0.20); margin-bottom: 12px;
    }
    .form-title {
      font-family: var(--font-display); font-size: 28px; font-weight: 900;
      color: var(--blue-dark); text-transform: uppercase;
      letter-spacing: 0.03em; line-height: 1.1; margin-bottom: 6px;
    }
    .form-subtitle { font-size: 14px; color: var(--gray-500); margin-bottom: 28px; line-height: 1.6; }

    /* Info box */
    .info-box {
      display: flex; align-items: flex-start; gap: 12px;
      padding: 14px 16px; border-radius: 8px;
      background: var(--blue-light); color: var(--blue-dark);
      border: 1px solid rgba(5,130,181,0.15);
      font-size: 13px; line-height: 1.65; margin-bottom: 24px;
    }
    .info-box i { margin-top: 2px; flex-shrink: 0; font-size: 16px; color: var(--blue); }
    .info-box strong { font-weight: 700; }

    /* Alertes */
    .alert {
      display: flex; align-items: flex-start; gap: 10px;
      padding: 13px 15px; border-radius: 8px;
      font-size: 13px; font-weight: 500; margin-bottom: 20px;
      animation: slideIn .3s ease;
    }
    @keyframes slideIn {
      from { opacity:0; transform: translateY(-6px); }
      to   { opacity:1; transform: translateY(0); }
    }
    .alert i { margin-top: 1px; flex-shrink: 0; font-size: 14px; }
    .alert-err {
      background: #fef2f2; color: #991b1b;
      border: 1px solid #fecaca; border-left: 4px solid var(--red);
    }
    .alert-ok {
      background: #f0fdf4; color: #14532d;
      border: 1px solid #bbf7d0; border-left: 4px solid var(--green);
    }

    /* Champs */
    .fgroup { margin-bottom: 20px; }
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
      width: 100%; padding: 12px 14px 12px 40px;
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
    .field-error {
      font-size: 12px; color: var(--red); font-weight: 600;
      margin-top: 6px; display: none;
      align-items: center; gap: 5px;
    }
    .field-error.show { display: flex; }

    /* Bouton principal */
    .btn-submit {
      width: 100%; padding: 13px 20px;
      background: var(--blue); color: white;
      font-family: var(--font-display); font-size: 14px; font-weight: 900;
      text-transform: uppercase; letter-spacing: 0.08em;
      border: none; border-radius: 8px; cursor: pointer;
      display: flex; align-items: center; justify-content: center; gap: 9px;
      transition: background .2s, transform .2s, box-shadow .2s;
      box-shadow: 0 3px 12px rgba(5,130,181,0.30);
      margin-top: 4px;
    }
    .btn-submit:hover {
      background: var(--blue-dark); transform: translateY(-2px);
      box-shadow: 0 6px 18px rgba(0,100,148,0.35);
    }
    .btn-submit:active { transform: translateY(0); }
    .btn-submit:disabled {
      opacity: 0.6; cursor: not-allowed; transform: none !important;
      box-shadow: none !important;
    }
    .btn-submit .spinner {
      display: none; width: 18px; height: 18px;
      border: 2.5px solid rgba(255,255,255,0.3);
      border-top-color: white; border-radius: 50%;
      animation: spin .6s linear infinite;
    }
    .btn-submit.loading .spinner { display: block; }
    .btn-submit.loading .btn-text { display: none; }
    .btn-submit.loading .btn-icon { display: none; }
    @keyframes spin { to { transform: rotate(360deg); } }

    /* Séparateur */
    .divider {
      display: flex; align-items: center; gap: 12px;
      margin: 24px 0; color: var(--gray-300); font-size: 12px;
    }
    .divider::before, .divider::after {
      content: ''; flex: 1; height: 1px; background: var(--gray-200);
    }

    /* Liens bas */
    .form-links {
      display: flex; align-items: center; justify-content: center;
      gap: 6px; flex-wrap: wrap; font-size: 13px;
    }
    .form-links a { color: var(--blue); font-weight: 600; transition: color .2s; }
    .form-links a:hover { color: var(--blue-dark); text-decoration: underline; }
    .form-links .dot { color: var(--gray-300); }

    /* Badge sécurité */
    .secure {
      display: flex; align-items: center; justify-content: center; gap: 7px;
      margin-top: 24px; padding: 9px 16px;
      background: var(--gray-50); border: 1px solid var(--gray-200);
      border-radius: 8px; font-size: 12px; color: var(--gray-500);
    }
    .secure i { color: var(--green); }

    /* ============================================================
       FOOTER
       ============================================================ */
    .foot {
      background: #002b45; border-top: 3px solid var(--orange);
      padding: 14px 28px; text-align: center;
      font-size: 12px; color: rgba(255,255,255,0.30);
      flex-shrink: 0;
    }
    .foot a { color: rgba(255,255,255,0.55); transition: color .2s; }
    .foot a:hover { color: white; }

    /* ============================================================
       RESPONSIVE
       ============================================================ */
    @media (max-width: 860px) {
      .page-wrap { grid-template-columns: 1fr; }
      .side-blue { display: none; }
      .side-white { padding: 40px 24px; background: var(--gray-100); }
      .form-box {
        max-width: 440px; background: var(--white); border-radius: 12px;
        padding: 36px 28px; box-shadow: 0 4px 20px rgba(0,60,100,0.10);
      }
    }
    @media (max-width: 480px) {
      .topbar-inner { padding: 0 16px; }
      .logo-left img { height: 42px; }
      .gesped-text small { display: none; }
      .form-title { font-size: 23px; }
      .form-box { padding: 28px 20px; }
    }
  </style>
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
          <small style="color:red">Gestion Pédagogique</small>
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