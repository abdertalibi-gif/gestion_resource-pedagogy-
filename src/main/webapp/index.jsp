<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>GesPed — Gestion des Ressources Pédagogiques</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Raleway:wght@700;800;900&display=swap" rel="stylesheet">

  <style>
    /* ============================================================
       GesPed — Style FSM-inspired : Blanc & Bleu universitaire
       ============================================================ */

    :root {
      --blue-dark:   #006494;
      --blue:        #0582b5;
      --blue-mid:    #1497cc;
      --blue-light:  #e8f4fb;
      --blue-pale:   #f0f8ff;
      --orange:      #e87722;
      --white:       #ffffff;
      --gray-100:    #f7f8fa;
      --gray-200:    #eef0f4;
      --gray-300:    #dde1e8;
      --gray-500:    #8892a0;
      --gray-700:    #4a5568;
      --text:        #1a202c;

      --shadow-xs:   0 1px 3px rgba(0,60,100,0.08);
      --shadow-sm:   0 2px 8px rgba(0,60,100,0.10);
      --shadow-md:   0 6px 20px rgba(0,60,100,0.12);
      --shadow-lg:   0 12px 40px rgba(0,60,100,0.16);

      --font-body:    'Open Sans', sans-serif;
      --font-display: 'Raleway', sans-serif;
      --ease: cubic-bezier(.4,0,.2,1);
    }

    *, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }
    html { scroll-behavior: smooth; }
    body {
      font-family: var(--font-body);
      background: var(--white);
      color: var(--text);
      line-height: 1.65;
      font-size: 15px;
      -webkit-font-smoothing: antialiased;
    }
    a { text-decoration: none; color: inherit; }

    .container { max-width: 1180px; margin: 0 auto; padding: 0 24px; }

    /* =========================================================
       HEADER — blanc comme FSM
       ========================================================= */
    .header {
      background: var(--white);
      border-bottom: 3px solid var(--orange);
      position: sticky; top: 0; z-index: 1000;
      box-shadow: var(--shadow-sm);
    }
    .header-inner {
      display: flex; align-items: center; justify-content: space-between;
      height: 82px; gap: 16px;
    }

    /* ---- Logo UMI gauche ---- */
    .logo-umi {
      display: flex; align-items: center; gap: 12px;
      text-decoration: none; flex-shrink: 0;
    }
    .logo-umi svg { height: 54px; width: auto; display: block; }
    .logo-umi-text {
      display: flex; flex-direction: column;
      border-left: 2px solid #dde3ea;
      padding-left: 13px; line-height: 1.3;
    }
    .logo-umi-text .lu1 {
      font-family: var(--font-display); font-size: 11.5px; font-weight: 800;
      color: var(--blue-dark); text-transform: uppercase; letter-spacing: 0.05em;
    }
    .logo-umi-text .lu2 {
      font-size: 10px; color: var(--gray-500); font-weight: 400;
      letter-spacing: 0.01em; direction: rtl;
    }
    .logo-umi-text .lu3 {
      font-family: var(--font-display); font-size: 11px; font-weight: 700;
      color: var(--orange); text-transform: uppercase; letter-spacing: 0.06em;
      margin-top: 1px;
    }

    /* ---- Navigation centre ---- */
    .header-nav-wrap {
      display: flex; align-items: center; flex: 1; justify-content: center;
    }
    nav { display: flex; align-items: center; gap: 2px; }
    nav a {
      color: var(--gray-700); font-size: 14px; font-weight: 600;
      padding: 8px 13px; border-radius: 6px;
      transition: color .2s, background .2s;
    }
    nav a:hover  { color: var(--blue); background: var(--blue-light); }
    nav a.active { color: var(--blue); }

    .btn-connexion {
      display: inline-flex; align-items: center; gap: 7px;
      padding: 9px 20px; border-radius: 6px;
      background: var(--blue); color: white;
      font-size: 14px; font-weight: 700;
      transition: background .2s, transform .2s, box-shadow .2s;
      margin-left: 10px;
      box-shadow: 0 2px 8px rgba(5,130,181,0.30);
    }
    .btn-connexion:hover {
      background: var(--blue-dark); transform: translateY(-1px);
      box-shadow: 0 4px 14px rgba(0,100,148,0.35);
    }

    /* ---- Logo GesPed droite ---- */
    .logo-gesped {
      display: flex; align-items: center; gap: 11px;
      text-decoration: none; flex-shrink: 0;
    }
    .gesped-icon {
      width: 46px; height: 46px; border-radius: 12px;
      background: linear-gradient(145deg, #0e6fa8, #1497cc);
      display: flex; align-items: center; justify-content: center;
      color: white; font-size: 20px; flex-shrink: 0;
      box-shadow: 0 3px 10px rgba(14,111,168,0.30);
    }
    .gesped-text strong {
      font-family: var(--font-display); font-size: 19px; font-weight: 800;
      color: var(--blue-dark); display: block; line-height: 1;
      letter-spacing: -0.3px;
    }
    .gesped-text span {
      font-size: 10.5px; font-weight: 400; color: var(--gray-500);
      display: block; margin-top: 3px; letter-spacing: 0.01em;
    }

    .mobile-btn {
      display: none; background: none; border: none;
      font-size: 22px; color: var(--blue-dark); cursor: pointer;
    }

    /* =========================================================
       HERO BANNER — bleu avec effet formules
       ========================================================= */
    .hero {
      position: relative; overflow: hidden;
      background: var(--blue-dark);
      background-image: linear-gradient(135deg, #004d73 0%, #0582b5 60%, #1497cc 100%);
      padding: 72px 24px 62px;
      border-bottom: 5px solid var(--orange);
    }
    .hero-bg {
      position: absolute; right: 5%; top: 50%; transform: translateY(-50%);
      opacity: 0.09; font-family: 'Georgia', serif;
      font-size: 17px; color: white; pointer-events: none;
      user-select: none; line-height: 2.4; text-align: right;
    }
    .hero-deco {
      position: absolute; right: 6%; top: 50%; transform: translateY(-50%);
      font-family: var(--font-display); font-size: 240px; font-weight: 900;
      color: rgba(255,255,255,0.055); line-height: 1;
      pointer-events: none; user-select: none;
    }
    .hero-content { position: relative; z-index: 2; animation: fadeUp .75s ease both; }
    .hero-eyebrow {
      display: inline-flex; align-items: center; gap: 8px;
      background: rgba(255,255,255,0.15); border: 1px solid rgba(255,255,255,0.25);
      border-radius: 4px; padding: 4px 14px;
      font-family: var(--font-display); font-size: 11px; font-weight: 700;
      color: rgba(255,255,255,0.92); text-transform: uppercase;
      letter-spacing: 0.12em; margin-bottom: 18px;
    }
    .hero h1 {
      font-family: var(--font-display);
      font-size: clamp(28px, 4.5vw, 50px); font-weight: 900;
      color: white; text-transform: uppercase;
      letter-spacing: 0.04em; line-height: 1.1; margin-bottom: 16px;
    }
    .hero p {
      font-size: 15px; color: rgba(255,255,255,0.78);
      max-width: 500px; line-height: 1.75; margin-bottom: 32px;
    }
    .hero-actions { display: flex; gap: 12px; flex-wrap: wrap; }
    .btn-hero-primary {
      display: inline-flex; align-items: center; gap: 8px;
      padding: 12px 28px; border-radius: 6px;
      background: var(--orange); color: white;
      font-weight: 700; font-size: 14px;
      box-shadow: 0 4px 14px rgba(232,119,34,0.45);
      transition: background .2s, transform .2s, box-shadow .2s;
    }
    .btn-hero-primary:hover {
      background: #d06315; transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(232,119,34,0.50);
    }
    .btn-hero-secondary {
      display: inline-flex; align-items: center; gap: 8px;
      padding: 11px 26px; border-radius: 6px;
      background: transparent; color: white;
      font-weight: 600; font-size: 14px;
      border: 2px solid rgba(255,255,255,0.50);
      transition: background .2s, border-color .2s;
    }
    .btn-hero-secondary:hover {
      background: rgba(255,255,255,0.12); border-color: white;
    }

    /* =========================================================
       BARRE DE STATS
       ========================================================= */
    .stats-bar {
      background: var(--white);
      border-bottom: 1px solid var(--gray-300);
      padding: 0;
    }
    .stats-bar-inner {
      display: grid; grid-template-columns: repeat(4, 1fr);
      max-width: 900px; margin: 0 auto;
      border-left: 1px solid var(--gray-300);
    }
    .stat-item {
      display: flex; align-items: center; gap: 14px;
      padding: 28px 22px 26px;
      border-right: 1px solid var(--gray-300);
      transition: background .2s;
    }
    .stat-item:hover { background: var(--blue-pale); }
    .stat-icon-wrap {
      width: 48px; height: 48px; border-radius: 8px; flex-shrink: 0;
      display: flex; align-items: center; justify-content: center;
      font-size: 18px; color: white;
    }
    .si-blue   { background: linear-gradient(135deg,#004d73,#0582b5); }
    .si-teal   { background: linear-gradient(135deg,#0891b2,#22d3ee); }
    .si-green  { background: linear-gradient(135deg,#059669,#34d399); }
    .si-purple { background: linear-gradient(135deg,#6d28d9,#a78bfa); }
    .stat-num {
      font-family: var(--font-display); font-size: 32px; font-weight: 800;
      color: var(--blue-dark); line-height: 1;
    }
    .stat-lbl {
      font-size: 11px; font-weight: 700; color: var(--gray-500);
      text-transform: uppercase; letter-spacing: 0.07em; margin-top: 4px;
    }

    /* =========================================================
       SECTION HEAD COMMUN
       ========================================================= */
    .section-head { text-align: center; margin-bottom: 50px; }
    .section-tag {
      display: inline-block; background: var(--blue-light);
      color: var(--blue); font-size: 11px; font-weight: 700;
      text-transform: uppercase; letter-spacing: 0.10em;
      padding: 5px 14px; border-radius: 4px; margin-bottom: 12px;
      border: 1px solid rgba(5,130,181,0.20);
    }
    .section-title {
      font-family: var(--font-display); font-size: clamp(22px,3vw,32px);
      font-weight: 800; color: var(--blue-dark); text-transform: uppercase;
      letter-spacing: 0.03em; margin-bottom: 10px;
    }
    .section-sub {
      font-size: 15px; color: var(--gray-500);
      max-width: 520px; margin: 0 auto; line-height: 1.7;
    }
    .section-line {
      width: 50px; height: 4px; border-radius: 2px;
      background: var(--orange); margin: 14px auto 0; border: none;
    }

    /* =========================================================
       FONCTIONNALITÉS
       ========================================================= */
    .features-section { padding: 82px 24px; background: var(--gray-100); }
    .features-grid {
      display: grid; grid-template-columns: repeat(3,1fr);
      gap: 22px; max-width: 1060px; margin: 0 auto;
    }
    .feat-card {
      background: var(--white); border: 1px solid var(--gray-300);
      border-radius: 8px; padding: 34px 26px 30px;
      text-align: center;
      transition: transform .24s var(--ease), box-shadow .24s var(--ease), border-color .24s var(--ease);
      position: relative; overflow: hidden;
    }
    .feat-card::after {
      content:''; position:absolute; top:0; left:0; right:0; height:3px;
      background: var(--blue); transform: scaleX(0); transform-origin: left;
      transition: transform .3s ease;
    }
    .feat-card:hover { transform: translateY(-5px); box-shadow: var(--shadow-md); border-color: transparent; }
    .feat-card:hover::after { transform: scaleX(1); }
    .feat-icon {
      width: 58px; height: 58px; border-radius: 12px;
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 18px; color: white; font-size: 22px;
    }
    .fi-1 { background: linear-gradient(135deg,#004d73,#0582b5); }
    .fi-2 { background: linear-gradient(135deg,#e87722,#f5a623); }
    .fi-3 { background: linear-gradient(135deg,#059669,#10b981); }
    .fi-4 { background: linear-gradient(135deg,#6d28d9,#8b5cf6); }
    .fi-5 { background: linear-gradient(135deg,#0891b2,#06b6d4); }
    .fi-6 { background: linear-gradient(135deg,#dc2626,#f87171); }
    .feat-card h3 {
      font-family: var(--font-display); font-size: 14px; font-weight: 800;
      color: var(--blue-dark); margin-bottom: 10px;
      text-transform: uppercase; letter-spacing: 0.04em;
    }
    .feat-card p { font-size: 13px; color: var(--gray-500); line-height: 1.65; }

    /* =========================================================
       DERNIÈRES RESSOURCES
       ========================================================= */
    .recent-section { padding: 82px 24px; background: var(--white); }
    .recent-grid {
      display: grid; grid-template-columns: repeat(3,1fr);
      gap: 16px; max-width: 1000px; margin: 0 auto;
    }
    .recent-card {
      background: var(--white); border: 1px solid var(--gray-300);
      border-radius: 8px; padding: 18px 20px;
      display: flex; align-items: center; gap: 14px;
      transition: transform .22s var(--ease), box-shadow .22s var(--ease), border-color .22s var(--ease);
      cursor: pointer;
    }
    .recent-card:hover {
      transform: translateY(-3px);
      box-shadow: var(--shadow-md);
      border-color: var(--blue-mid);
    }
    .recent-icon {
      width: 44px; height: 44px; border-radius: 8px; flex-shrink: 0;
      display: flex; align-items: center; justify-content: center; font-size: 16px;
    }
    .recent-info { min-width: 0; }
    .recent-info h4 {
      font-size: 14px; font-weight: 700; color: var(--blue-dark);
      margin-bottom: 3px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    }
    .recent-info p {
      font-size: 12px; color: var(--gray-500); margin-bottom: 6px;
      white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    }
    .badge {
      display: inline-block; padding: 2px 10px; border-radius: 4px;
      font-size: 11px; font-weight: 600; color: white; letter-spacing: 0.02em;
    }
    .empty-state {
      grid-column: 1/-1; text-align: center;
      padding: 60px 20px; color: var(--gray-500);
    }
    .empty-state i { font-size: 36px; margin-bottom: 12px; opacity: .3; display: block; }

    /* =========================================================
       ACCÈS RAPIDE
       ========================================================= */
    .access-section { padding: 82px 24px; background: var(--gray-100); }
    .access-grid {
      display: grid; grid-template-columns: repeat(3,1fr);
      gap: 22px; max-width: 980px; margin: 0 auto;
    }
    .access-card {
      background: var(--white); border: 1px solid var(--gray-300);
      border-radius: 8px; padding: 50px 30px 42px;
      text-align: center;
      transition: transform .26s var(--ease), box-shadow .26s var(--ease), border-color .26s var(--ease);
      position: relative; overflow: hidden;
    }
    .access-card::before {
      content:''; position:absolute; top:0; left:0; right:0; height:4px;
      background: var(--card-color, var(--blue));
    }
    .access-card:hover {
      transform: translateY(-7px);
      box-shadow: var(--shadow-lg);
      border-color: var(--card-color, var(--blue));
    }
    .ac-admin { --card-color: #dc2626; }
    .ac-prof  { --card-color: #e87722; }
    .ac-etu   { --card-color: #0582b5; }
    .access-card i {
      font-size: 46px; display: block; margin-bottom: 18px;
      color: var(--card-color, var(--blue));
    }
    .access-card h3 {
      font-family: var(--font-display); font-size: 17px; font-weight: 800;
      color: var(--text); text-transform: uppercase;
      letter-spacing: 0.06em; margin-bottom: 10px; line-height: 1.3;
    }
    .access-card p {
      font-size: 13px; color: var(--gray-500); margin-bottom: 26px; line-height: 1.6;
    }
    .btn-access {
      display: inline-flex; align-items: center; gap: 7px;
      padding: 10px 26px; border-radius: 6px;
      background: var(--card-color, var(--blue)); color: white;
      font-weight: 700; font-size: 13px; letter-spacing: 0.01em;
      transition: opacity .2s, transform .2s;
    }
    .btn-access:hover { opacity: .88; transform: scale(1.04); }

    /* =========================================================
       FOOTER
       ========================================================= */
    .footer {
      background: #002b45;
      border-top: 4px solid var(--orange);
      color: rgba(255,255,255,0.55);
      padding: 62px 24px 28px;
    }
    .footer-grid {
      display: grid; grid-template-columns: 2fr 1fr 1fr 1fr;
      gap: 44px; max-width: 1140px; margin: 0 auto;
      padding-bottom: 42px;
      border-bottom: 1px solid rgba(255,255,255,0.08);
    }
    .footer-brand { display: flex; align-items: center; gap: 12px; margin-bottom: 14px; }
    .footer-brand .logo-icon {
      background: linear-gradient(135deg,#006494,#1497cc);
      width: 40px; height: 40px; font-size: 17px;
    }
    .footer-brand strong {
      font-family: var(--font-display); font-size: 20px; font-weight: 800;
      color: white; letter-spacing: -0.5px;
    }
    .footer-col > p { font-size: 13px; color: rgba(255,255,255,0.45); line-height: 1.7; }
    .footer-col h4 {
      font-size: 11px; font-weight: 700; text-transform: uppercase;
      letter-spacing: 0.12em; color: rgba(255,255,255,0.92); margin-bottom: 16px;
    }
    .footer-col a, .f-line {
      color: rgba(255,255,255,0.50); font-size: 13px;
      display: block; margin-bottom: 10px; transition: color .2s;
    }
    .footer-col a:hover { color: white; }
    .f-line i { color: var(--orange); margin-right: 8px; width: 14px; }
    .social-row { display: flex; gap: 8px; margin-top: 16px; }
    .social-row a {
      width: 34px; height: 34px; border-radius: 6px;
      border: 1px solid rgba(255,255,255,0.12);
      display: flex; align-items: center; justify-content: center;
      color: rgba(255,255,255,0.55); font-size: 13px; margin-bottom: 0;
      transition: background .2s, border-color .2s, color .2s, transform .2s;
    }
    .social-row a:hover {
      background: var(--orange); border-color: var(--orange);
      color: white; transform: translateY(-2px);
    }
    .footer-bottom {
      padding-top: 22px; text-align: center; font-size: 12px;
      color: rgba(255,255,255,0.25); max-width: 1140px; margin: 0 auto;
    }

    /* =========================================================
       ANIMATIONS
       ========================================================= */
    @keyframes fadeUp {
      from { opacity:0; transform:translateY(20px); }
      to   { opacity:1; transform:translateY(0); }
    }

    /* =========================================================
       RESPONSIVE
       ========================================================= */
    @media (max-width: 1024px) {
      .features-grid { grid-template-columns: repeat(2,1fr); }
    }
    @media (max-width: 768px) {
      .header-inner { height: 64px; }
      .logo-umi-text .lu2 { display: none; }
      .logo-umi svg { height: 42px; }
      .gesped-text span { display: none; }
      .header-nav-wrap {
        display: none; flex-direction: column; position: absolute;
        top: 64px; left: 0; right: 0; background: white;
        border-bottom: 3px solid var(--orange);
        padding: 12px; box-shadow: var(--shadow-md); gap: 2px;
      }
      .header-nav-wrap.open { display: flex; }
      nav { flex-direction: column; width: 100%; }
      nav a { padding: 10px 14px; width: 100%; }
      .btn-connexion { margin: 8px 0 0; justify-content: center; }
      .mobile-btn { display: block; }
      .hero { padding: 60px 20px 50px; }
      .hero h1 { font-size: 26px; }
      .stats-bar-inner { grid-template-columns: repeat(2,1fr); }
      .features-grid { grid-template-columns: 1fr; }
      .recent-grid   { grid-template-columns: 1fr; }
      .access-grid   { grid-template-columns: 1fr; }
      .footer-grid   { grid-template-columns: 1fr; gap: 28px; }
    }
    @media (max-width: 480px) {
      .stats-bar-inner { grid-template-columns: 1fr 1fr; }
      .hero-actions { flex-direction: column; }
    }
    .logo-fsm{
    height: 60px;
    width: auto;
    object-fit: contain;
    display: flex;
    align-items: center;
}

  </style>
</head>
<body>

  <!-- ======================================================
       HEADER — Logo UMI gauche · Nav centre · GesPed droite
       ====================================================== -->
  <header class="header"> 
    <div class="container header-inner">
<img src="logofsm.jpg" alt="Logo FSM" class="logo-fsm">      
      <!-- ===== CENTRE : Navigation ===== -->
      <div class="header-nav-wrap" id="main-nav">
        <nav>
          <a href="${pageContext.request.contextPath}/" class="active">Accueil</a>
          <a href="#features">Fonctionnalités</a>
          <a href="#stats">Statistiques</a>
          <a href="#contact">Contact</a>
          <a href="${pageContext.request.contextPath}/login" class="btn-connexion">
            <i class="fas fa-sign-in-alt"></i> Connexion
          </a>
        </nav>
      </div>
      <!-- ===== DROITE : Logo GesPed ===== -->
      <a href="${pageContext.request.contextPath}/" class="logo-gesped" title="GesPed — Gestion Pédagogique">
        <div class="gesped-icon">
          <i class="fas fa-graduation-cap"></i>
        </div>
        <div class="gesped-text">
          <strong>GesPed</strong>
          <span>Gestion Pédagogique</span>
        </div>
      </a>
      <button class="mobile-btn"
              onclick="document.getElementById('main-nav').classList.toggle('open')"
              aria-label="Ouvrir le menu">
        <i class="fas fa-bars"></i>
      </button>

    </div>
  </header>
  <!-- ======================================================
       HERO BANNER
       ====================================================== -->
  <section class="hero">
    <div class="hero-bg">
			  <div></div>
			<div></div>
			      <div></div>
			      <div></div>
			      <div></div>
			    </div>
    <div class="hero-deco">01</div>

    <div class="container">
      <div class="hero-content">
        <div class="hero-eyebrow">
          <i class="fas fa-university"></i> Plateforme Académique
        </div>
        <h1>Ressources<br>Pédagogiques</h1>
        <p>Centralisez, partagez et consultez vos supports de cours en toute simplicité.
           PDF, vidéos, TD, TP — tout dans un seul espace sécurisé.</p>
        <div class="hero-actions">
          <a href="${pageContext.request.contextPath}/login" class="btn-hero-primary">
            <i class="fas fa-sign-in-alt"></i> Accéder à la plateforme
          </a>
          <a href="#features" class="btn-hero-secondary">
            <i class="fas fa-info-circle"></i> En savoir plus
          </a>
        </div>
      </div>
    </div>
  </section>


  <!-- ======================================================
       BARRE DE STATISTIQUES
       ====================================================== -->
  <section id="stats" class="stats-bar">
    <div class="stats-bar-inner">

      <div class="stat-item">
        <div class="stat-icon-wrap si-blue"><i class="fas fa-users"></i></div>
        <div>
          <div class="stat-num">${nbEtudiants}</div>
          <div class="stat-lbl">Étudiants</div>
        </div>
      </div>

      <div class="stat-item">
        <div class="stat-icon-wrap si-teal"><i class="fas fa-chalkboard-teacher"></i></div>
        <div>
          <div class="stat-num">${nbProfs}</div>
          <div class="stat-lbl">Professeurs</div>
        </div>
      </div>

      <div class="stat-item">
        <div class="stat-icon-wrap si-green"><i class="fas fa-book"></i></div>
        <div>
          <div class="stat-num">${nbModules}</div>
          <div class="stat-lbl">Modules</div>
        </div>
      </div>

      <div class="stat-item">
        <div class="stat-icon-wrap si-purple"><i class="fas fa-file-alt"></i></div>
        <div>
          <div class="stat-num">${nbRessources}</div>
          <div class="stat-lbl">Ressources</div>
        </div>
      </div>

    </div>
  </section>


  <!-- ======================================================
       FONCTIONNALITÉS
       ====================================================== -->
  <section id="features" class="features-section">
    <div class="container">
      <div class="section-head">
        <div class="section-tag">Ce que nous offrons</div>
        <h2 class="section-title">Fonctionnalités</h2>
        <p class="section-sub">Tout ce dont vous avez besoin pour gérer vos ressources pédagogiques.</p>
        <hr class="section-line">
      </div>
      <div class="features-grid">

        <div class="feat-card">
          <div class="feat-icon fi-1"><i class="fas fa-shield-alt"></i></div>
          <h3>Administration</h3>
          <p>Gérez les utilisateurs, modules, filières et semestres depuis un tableau de bord centralisé.</p>
        </div>

        <div class="feat-card">
          <div class="feat-icon fi-2"><i class="fas fa-upload"></i></div>
          <h3>Dépôt de ressources</h3>
          <p>Les professeurs déposent facilement PDF, vidéos, TD, TP et tous types de documents.</p>
        </div>

        <div class="feat-card">
          <div class="feat-icon fi-3"><i class="fas fa-search"></i></div>
          <h3>Recherche avancée</h3>
          <p>Trouvez rapidement une ressource par titre, module, type ou professeur.</p>
        </div>

        <div class="feat-card">
          <div class="feat-icon fi-4"><i class="fas fa-star"></i></div>
          <h3>Favoris</h3>
          <p>Sauvegardez vos ressources préférées pour y accéder rapidement à tout moment.</p>
        </div>

        <div class="feat-card">
          <div class="feat-icon fi-5"><i class="fas fa-chart-bar"></i></div>
          <h3>Statistiques</h3>
          <p>Suivez les consultations, téléchargements et l'activité de la plateforme.</p>
        </div>

        <div class="feat-card">
          <div class="feat-icon fi-6"><i class="fas fa-bell"></i></div>
          <h3>Notifications</h3>
          <p>Restez informé des nouvelles ressources et mises à jour en temps réel.</p>
        </div>

      </div>
    </div>
  </section>


  <!-- ======================================================
       DERNIÈRES RESSOURCES
       ====================================================== -->
  <section class="recent-section">
    <div class="container">
      <div class="section-head">
        <div class="section-tag">Tout juste publiées</div>
        <h2 class="section-title">Dernières ressources</h2>
        <p class="section-sub">Les ressources les plus récemment ajoutées sur la plateforme.</p>
        <hr class="section-line">
      </div>
      <div class="recent-grid">

        <c:forEach var="r" items="${dernieresRessources}">
          <div class="recent-card">
            <div class="recent-icon" style="color:${r.couleurType}; background:${r.couleurType}18;">
              <i class="fas ${r.iconeType}"></i>
            </div>
            <div class="recent-info">
              <h4>${r.titre}</h4>
              <p>${r.module.nomModule} — ${r.professeur.nom}</p>
              <span class="badge" style="background:${r.couleurType}">${r.type.nomType}</span>
            </div>
          </div>
        </c:forEach>

        <c:if test="${empty dernieresRessources}">
          <div class="empty-state">
            <i class="fas fa-box-open"></i>
            <p>Aucune ressource disponible pour le moment.</p>
          </div>
        </c:if>

      </div>
    </div>
  </section>


  <!-- ======================================================
       ACCÈS RAPIDE
       ====================================================== -->
  <section class="access-section">
    <div class="container">
      <div class="section-head">
        <div class="section-tag">Selon votre profil</div>
        <h2 class="section-title">Accès rapide</h2>
        <p class="section-sub">Connectez-vous selon votre rôle et accédez à votre espace dédié.</p>
        <hr class="section-line">
      </div>
      <div class="access-grid">

        <div class="access-card ac-admin">
          <i class="fas fa-user-shield"></i>
          <h3>Administration</h3>
          <p>Gestion complète de la plateforme, des utilisateurs et des paramètres système.</p>
          <a href="${pageContext.request.contextPath}/login" class="btn-access">
            Accéder <i class="fas fa-arrow-right"></i>
          </a>
        </div>

        <div class="access-card ac-prof">
          <i class="fas fa-chalkboard-teacher"></i>
          <h3>Professeur</h3>
          <p>Déposez et gérez vos ressources pédagogiques en toute autonomie.</p>
          <a href="${pageContext.request.contextPath}/login" class="btn-access">
            Accéder <i class="fas fa-arrow-right"></i>
          </a>
        </div>

        <div class="access-card ac-etu">
          <i class="fas fa-user-graduate"></i>
          <h3>Étudiant</h3>
          <p>Consultez, téléchargez et sauvegardez les ressources de vos modules.</p>
          <a href="${pageContext.request.contextPath}/login" class="btn-access">
            Accéder <i class="fas fa-arrow-right"></i>
          </a>
        </div>

      </div>
    </div>
  </section>


  <!-- ======================================================
       FOOTER
       ====================================================== -->
  <footer id="contact" class="footer">
    <div class="container">
      <div class="footer-grid">

        <div class="footer-col">
          <div class="footer-brand">
            <div class="logo-icon" style="width:40px;height:40px;border-radius:8px;background:linear-gradient(135deg,#006494,#1497cc);display:flex;align-items:center;justify-content:center;color:white;font-size:17px;flex-shrink:0;">
              <i class="fas fa-graduation-cap"></i>
            </div>
            <strong>GesPed</strong>
          </div>
          <p>Plateforme de gestion des ressources pédagogiques pour les établissements d'enseignement supérieur au Maroc.</p>
          <div class="social-row">
            <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
            <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
            <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
            <a href="#" aria-label="GitHub"><i class="fab fa-github"></i></a>
          </div>
        </div>

        <div class="footer-col">
          <h4>Navigation</h4>
          <a href="${pageContext.request.contextPath}/">Accueil</a>
          <a href="#features">Fonctionnalités</a>
          <a href="#stats">Statistiques</a>
          <a href="#contact">Contact</a>
        </div>

        <div class="footer-col">
          <h4>Contact</h4>
          <p class="f-line"><i class="fas fa-envelope"></i> contact@gesped.ma</p>
          <p class="f-line"><i class="fas fa-phone"></i> +212 5XX-XXXXXX</p>
          <p class="f-line"><i class="fas fa-map-marker-alt"></i> Maroc</p>
        </div>

        <div class="footer-col">
          <h4>Accès direct</h4>
          <a href="${pageContext.request.contextPath}/login">
            <i class="fas fa-user-shield" style="margin-right:6px; color:#f87171"></i>Espace Admin
          </a>
          <a href="${pageContext.request.contextPath}/login">
            <i class="fas fa-chalkboard-teacher" style="margin-right:6px; color:#fbbf24"></i>Espace Professeur
          </a>
          <a href="${pageContext.request.contextPath}/login">
            <i class="fas fa-user-graduate" style="margin-right:6px; color:#60a5fa"></i>Espace Étudiant
          </a>
        </div>

      </div>
      <div class="footer-bottom">
        <p>&copy; 2025 GesPed — Tous droits réservés</p>
      </div>
    </div>
  </footer>


  <!-- ======================================================
       SCRIPTS
       ====================================================== -->
  <script>
    // Fermer nav mobile sur clic lien
    document.querySelectorAll('#main-nav a').forEach(function(l) {
      l.addEventListener('click', function() {
        document.getElementById('main-nav').classList.remove('open');
      });
    });

    // Fermer en dehors du menu
    document.addEventListener('click', function(e) {
      var nav = document.getElementById('main-nav');
      var btn = document.querySelector('.mobile-btn');
      if (nav && btn && !nav.contains(e.target) && !btn.contains(e.target)) {
        nav.classList.remove('open');
      }
    });

    // Reveal au scroll via IntersectionObserver
    var io = new IntersectionObserver(function(entries) {
      entries.forEach(function(en) {
        if (en.isIntersecting) {
          en.target.style.opacity  = '1';
          en.target.style.transform = 'translateY(0)';
          io.unobserve(en.target);
        }
      });
    }, { threshold: 0.10 });

    document.querySelectorAll('.feat-card, .recent-card, .access-card, .stat-item').forEach(function(el) {
      el.style.opacity   = '0';
      el.style.transform = 'translateY(18px)';
      el.style.transition = 'opacity .5s ease, transform .5s ease, box-shadow .24s ease, border-color .24s ease';
      io.observe(el);
    });
  </script>

</body>
</html>
