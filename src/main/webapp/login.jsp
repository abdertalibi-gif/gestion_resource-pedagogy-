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


  <style>
    /* ============================================================
       Variables — même palette que l'index
       ============================================================ */
    :root {
      --blue-dark:  #006494;
      --blue:       #0582b5;
      --blue-mid:   #1497cc;
      --blue-light: #e8f4fb;
      --blue-pale:  #f0f8ff;
      --orange:     #e87722;
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
      display: flex;
      flex-direction: column;
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

    /* Logo FSM gauche */
    .logo-left a {
      display: flex; align-items: center;
    }
    .logo-left img {
      height: 54px; width: auto; object-fit: contain; display: block;
    }

    /* Logo GesPed droite */
    .logo-right {
      display: flex; align-items: center; gap: 10px;
    }
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
       PAGE BODY — split left/right
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

    /* Grille de points déco */
    .side-blue::before {
      content: '';
      position: absolute; inset: 0;
      background-image: radial-gradient(circle, rgba(255,255,255,0.055) 1px, transparent 1px);
      background-size: 28px 28px;
      pointer-events: none;
    }

    /* Grand chiffre décoratif */
    .deco-num {
      position: absolute; right: -20px; bottom: -50px;
      font-family: var(--font-display); font-size: 260px; font-weight: 900;
      color: rgba(255,255,255,0.045); line-height: 1;
      pointer-events: none; user-select: none;
    }

    /* Formules maths */
    .deco-formulas {
      position: absolute; top: 18px; right: 18px;
      font-family: 'Georgia', serif; font-size: 12px;
      color: rgba(255,255,255,0.07); line-height: 2.6;
      text-align: right; pointer-events: none; user-select: none;
    }

    /* Contenu panneau bleu */
    .blue-content { position: relative; z-index: 2; text-align: center; width: 100%; max-width: 340px; }

    .blue-avatar {
      width: 88px; height: 88px; border-radius: 24px;
      background: rgba(255,255,255,0.14);
      border: 2px solid rgba(255,255,255,0.26);
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 26px; font-size: 36px; color: white;
    }

    .blue-content h2 {
      font-family: var(--font-display); font-size: 32px; font-weight: 900;
      color: white; text-transform: uppercase; letter-spacing: 0.04em;
      line-height: 1.12; margin-bottom: 16px;
    }

    .orange-bar {
      width: 48px; height: 4px; border-radius: 2px;
      background: var(--orange); margin: 0 auto 22px;
    }

    .blue-content p {
      font-size: 14px; color: rgba(255,255,255,0.72);
      line-height: 1.78; margin-bottom: 36px;
    }

    /* Feature pills */
    .blue-features { display: flex; flex-direction: column; gap: 11px; }
    .bf {
      display: flex; align-items: center; gap: 12px;
      background: rgba(255,255,255,0.10);
      border: 1px solid rgba(255,255,255,0.16);
      border-radius: 10px; padding: 11px 16px; text-align: left;
    }
    .bf i { color: rgba(255,255,255,0.88); font-size: 16px; width: 20px; flex-shrink: 0; }
    .bf span { font-size: 13px; color: rgba(255,255,255,0.82); font-weight: 500; }

    /* ---- Panneau DROITE blanc ---- */
    .side-white {
      background: var(--white);
      display: flex; align-items: center; justify-content: center;
      padding: 52px 48px;
    }

    .form-box { width: 100%; max-width: 400px; }

    /* En-tête formulaire */
    .form-eyebrow {
      display: inline-flex; align-items: center; gap: 7px;
      background: var(--blue-light); color: var(--blue);
      font-size: 11px; font-weight: 700; text-transform: uppercase;
      letter-spacing: 0.10em; padding: 4px 12px; border-radius: 4px;
      border: 1px solid rgba(5,130,181,0.20); margin-bottom: 12px;
    }
    .form-title {
      font-family: var(--font-display); font-size: 30px; font-weight: 900;
      color: var(--blue-dark); text-transform: uppercase;
      letter-spacing: 0.03em; line-height: 1.1; margin-bottom: 6px;
    }
    .form-subtitle { font-size: 14px; color: var(--gray-500); margin-bottom: 28px; }

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
    .toggle-eye {
      position: absolute; right: 13px; top: 50%; transform: translateY(-50%);
      color: var(--gray-400); cursor: pointer; font-size: 14px;
      transition: color .2s;
    }
    .toggle-eye:hover { color: var(--blue); }

    /* Remember */
    .fcheck {
      display: flex; align-items: center; gap: 8px;
      margin-bottom: 24px; cursor: pointer;
    }
    .fcheck input {
      width: 15px; height: 15px; accent-color: var(--blue);
      cursor: pointer; border-radius: 3px;
    }
    .fcheck label {
      font-size: 13px; color: var(--gray-600); cursor: pointer; font-weight: 500;
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
    }
    .btn-submit:hover {
      background: var(--blue-dark); transform: translateY(-2px);
      box-shadow: 0 6px 18px rgba(0,100,148,0.35);
    }
    .btn-submit:active { transform: translateY(0); }

    /* Séparateur */
    .divider {
      display: flex; align-items: center; gap: 12px;
      margin: 22px 0; color: var(--gray-300); font-size: 12px;
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
      .form-box { max-width: 440px; background: var(--white); border-radius: 12px; padding: 36px 28px; box-shadow: 0 4px 20px rgba(0,60,100,0.10); }
    }
    @media (max-width: 480px) {
      .topbar-inner { padding: 0 16px; }
      .logo-left img { height: 42px; }
      .gesped-text small { display: none; }
      .form-title { font-size: 24px; }
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
        <% if (request.getParameter("error") != null) { %>
          <div class="alert alert-err">
            <i class="fas fa-exclamation-circle"></i>
            <span>Email ou mot de passe incorrect. Veuillez réessayer.</span>
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
          <%-- ⬇️ MODIFIÉ : href="#" → lien réel vers forgot-password --%>
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