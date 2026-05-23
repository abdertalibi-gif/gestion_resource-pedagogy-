<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Utilisateur" %>

<%
    request.setAttribute("role", "PROFESSEUR");
    request.setAttribute("nomComplet", ((models.Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Mes modules");
    request.setAttribute("activeMenu", "modules");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes modules — GesPed</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Raleway:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        :root {
            --sidebar-bg:      #1a5f7a;
            --sidebar-hover:   rgba(255,255,255,0.08);
            --sidebar-active:  rgba(255,255,255,0.14);
            --sidebar-text:    #b8d8e5;
            --sidebar-dim:     #6fa3bb;
            --sidebar-width:   230px;

            --topbar-bg:       #ffffff;
            --topbar-height:   56px;
            --topbar-border:   #dde6ec;

            --orange:          #e8a020;
            --teal-dark:       #1a5f7a;
            --teal-mid:        #1e7090;
            --teal-light:      #e8f4f8;
            --green-accent:    #1ab98a;
            --blue-accent:     #2a6b9e;
            --blue-mid:        #2d99b8;

            --page-bg:         #f2f4f6;
            --white:           #ffffff;
            --text-dark:       #1c3d4f;
            --text-muted:      #7a9aaa;
            --border:          #dde6ec;

            --radius-sm:       6px;
            --radius-md:       10px;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Open Sans', sans-serif;
            font-size: 14px;
            color: var(--text-dark);
            background: var(--page-bg);
            display: flex;
            min-height: 100vh;
        }
        a { text-decoration: none; color: inherit; }
        button { font-family: inherit; cursor: pointer; }

        /* ============================================================
           SIDEBAR
           ============================================================ */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--sidebar-bg);
            color: var(--sidebar-text);
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0; left: 0;
            height: 100vh;
            z-index: 100;
            transition: transform 0.25s ease;
        }

        .sidebar-brand {
            padding: 20px 18px 16px;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }
        .sidebar-brand .brand-name {
            font-family: 'Raleway', sans-serif;
            font-size: 22px;
            font-weight: 900;
            color: #ffffff;
            letter-spacing: 0.02em;
        }
        .sidebar-brand .brand-role {
            font-size: 11px;
            color: var(--sidebar-dim);
            margin-top: 2px;
            display: block;
        }

        .sidebar-section { padding: 14px 0 6px; }
        .sidebar-section-label {
            font-size: 10px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--sidebar-dim);
            padding: 0 18px 6px;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 9px 18px;
            color: var(--sidebar-text);
            font-size: 13px;
            font-weight: 400;
            transition: background 0.15s, color 0.15s;
            border-left: 3px solid transparent;
            cursor: pointer;
        }
        .nav-item i { font-size: 15px; width: 18px; text-align: center; }
        .nav-item:hover { background: var(--sidebar-hover); color: #ffffff; }
        .nav-item.active {
            background: var(--sidebar-active);
            color: #ffffff;
            border-left-color: var(--orange);
            font-weight: 600;
        }

        .sidebar-footer {
            margin-top: auto;
            padding: 14px 18px;
            border-top: 1px solid rgba(255,255,255,0.08);
        }
        .nav-item-logout {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 9px 0;
            color: #e8a0a0;
            font-size: 13px;
            cursor: pointer;
            transition: color 0.15s;
        }
        .nav-item-logout i { font-size: 15px; width: 18px; text-align: center; }
        .nav-item-logout:hover { color: #ff8a8a; }

        /* Bouton hamburger mobile */
        .sidebar-toggle {
            display: none;
            background: none;
            border: none;
            color: var(--text-dark);
            font-size: 20px;
            padding: 4px;
        }
        .sidebar-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.4);
            z-index: 99;
        }

        /* ============================================================
           TOPBAR
           ============================================================ */
        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .topbar {
            position: sticky;
            top: 0; z-index: 90;
            background: var(--topbar-bg);
            border-bottom: 1px solid var(--topbar-border);
            height: var(--topbar-height);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 24px;
        }
        .topbar::after {
            content: '';
            position: absolute;
            bottom: 0; left: 0; right: 0;
            height: 2px;
            background: var(--orange);
        }
        .topbar-left { display: flex; align-items: center; gap: 10px; }
        .topbar-title { font-size: 15px; font-weight: 600; color: var(--text-dark); }
        .topbar-right { display: flex; align-items: center; gap: 16px; }

        .topbar-icon-btn {
            background: none; border: none;
            color: var(--text-muted);
            font-size: 17px;
            display: flex; align-items: center;
            position: relative;
        }
        .topbar-icon-btn:hover { color: var(--teal-dark); }

        .notif-badge {
            position: absolute;
            top: -4px; right: -5px;
            width: 16px; height: 16px;
            border-radius: 50%;
            background: var(--orange);
            color: #fff;
            font-size: 9px;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700;
        }

        .user-avatar {
            width: 34px; height: 34px;
            border-radius: 50%;
            background: var(--teal-dark);
            color: #fff;
            display: flex; align-items: center; justify-content: center;
            font-size: 12px; font-weight: 600;
            cursor: pointer;
        }
        .user-info { display: flex; flex-direction: column; align-items: flex-start; }
        .user-info .user-name { font-size: 13px; font-weight: 600; color: var(--text-dark); }
        .user-info .user-role { font-size: 11px; color: var(--text-muted); }

        /* ============================================================
           CONTENU PRINCIPAL
           ============================================================ */
        .content-wrapper { padding: 28px 28px 40px; flex: 1; }

        .page-header { margin-bottom: 22px; }
        .page-header h1 {
            font-family: 'Raleway', sans-serif;
            font-size: 26px;
            font-weight: 800;
            color: var(--teal-dark);
        }
        .page-header p { font-size: 13px; color: var(--text-muted); margin-top: 3px; }

        /* ============================================================
           CARTES STATISTIQUES
           ============================================================ */
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 14px;
            margin-bottom: 26px;
        }

        .stat-card-dashboard {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 16px 14px;
            display: flex;
            align-items: center;
            gap: 12px;
            position: relative;
            overflow: hidden;
            transition: box-shadow 0.2s, transform 0.2s;
        }
        .stat-card-dashboard:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.07);
        }
        .stat-card-dashboard::after {
            content: '';
            position: absolute;
            bottom: 0; left: 0; right: 0;
            height: 3px;
        }

        .grad-deep::after   { background: var(--teal-dark); }
        .grad-mid::after    { background: var(--blue-mid); }
        .grad-bright::after { background: var(--green-accent); }
        .grad-teal::after   { background: var(--blue-accent); }
        .grad-orange::after { background: var(--orange); }

        .stat-card-icon {
            width: 40px; height: 40px;
            border-radius: var(--radius-sm);
            display: flex; align-items: center; justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }
        .grad-deep   .stat-card-icon { background: #deedf4; color: var(--teal-dark); }
        .grad-mid    .stat-card-icon { background: #ddf0f7; color: var(--blue-mid); }
        .grad-bright .stat-card-icon { background: #d8f5ec; color: var(--green-accent); }
        .grad-teal   .stat-card-icon { background: #dce8f2; color: var(--blue-accent); }
        .grad-orange .stat-card-icon { background: #fdf0d8; color: var(--orange); }

        .stat-card-info { display: flex; flex-direction: column; }
        .stat-card-number {
            font-size: 24px; font-weight: 700;
            color: var(--text-dark); line-height: 1;
        }
        .stat-card-label {
            font-size: 10px; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.06em;
            color: var(--text-muted); margin-top: 4px;
        }

        /* ============================================================
           SECTION TABLEAU
           ============================================================ */
        .dashboard-section {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            overflow: hidden;
        }

        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 18px;
            border-bottom: 1px solid var(--border);
        }
        .section-header h3 {
            font-size: 14px; font-weight: 700;
            color: var(--text-dark);
            display: flex; align-items: center; gap: 8px;
            font-family: 'Open Sans', sans-serif;
        }
        .section-header h3 i { color: var(--teal-mid); }

        .btn {
            display: inline-flex; align-items: center; gap: 6px;
            border-radius: var(--radius-sm);
            font-size: 13px; font-weight: 500;
            padding: 7px 14px;
            transition: all 0.15s;
        }
        .btn-sm { padding: 5px 12px; font-size: 12px; }
        .btn-outline {
            background: none;
            border: 1px solid var(--border);
            color: var(--teal-mid);
        }
        .btn-outline:hover {
            background: var(--teal-light);
            border-color: var(--teal-mid);
            color: var(--teal-dark);
        }

        .table-responsive { overflow-x: auto; }

        .table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .table thead tr { background: #f8fafc; }
        .table th {
            padding: 10px 18px;
            text-align: left;
            font-size: 11px; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.06em;
            color: var(--teal-mid);
            border-bottom: 1px solid var(--border);
            white-space: nowrap;
        }
        .table td {
            padding: 11px 18px;
            color: var(--text-dark);
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
        }
        .table tbody tr:last-child td { border-bottom: none; }
        .table tbody tr:hover { background: #f8fafc; }

        .table-file { display: flex; align-items: center; gap: 8px; }
        .table-file i { font-size: 16px; }
        .table-file span { font-weight: 500; }

        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px; font-weight: 600;
            color: #ffffff;
            letter-spacing: 0.03em;
        }

        .status-badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px; font-weight: 600;
        }
        .status-badge::before {
            content: '';
            width: 6px; height: 6px;
            border-radius: 50%;
        }
        .status-active  { background: #d8f5ec; color: #0e7a54; }
        .status-active::before  { background: #1ab98a; }
        .status-inactive { background: #fde8e8; color: #9e2b2b; }
        .status-inactive::before { background: #d64545; }

        /* ============================================================
           ÉTAT VIDE (EMPTY STATE)
           ============================================================ */
        .empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 48px 24px;
            text-align: center;
        }
        .empty-state-icon {
            width: 72px; height: 72px;
            border-radius: 50%;
            background: var(--teal-light);
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 16px;
        }
        .empty-state-icon i {
            font-size: 28px;
            color: var(--teal-mid);
        }
        .empty-state-title {
            font-size: 15px;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 4px;
        }
        .empty-state-text {
            font-size: 13px;
            color: var(--text-muted);
            max-width: 320px;
            line-height: 1.5;
        }
        .empty-state-action {
            margin-top: 16px;
        }
        .btn-primary {
            background: var(--teal-dark);
            color: #ffffff;
            border: none;
        }
        .btn-primary:hover {
            background: var(--teal-mid);
        }

        /* ============================================================
           ALERTES FLASH
           ============================================================ */
        .alert {
            display: flex; align-items: center; gap: 10px;
            padding: 12px 16px;
            border-radius: var(--radius-sm);
            font-size: 13px; font-weight: 500;
            margin-bottom: 18px;
            position: relative;
        }
        .alert-success { background: #d8f5ec; color: #0e7a54; border-left: 3px solid var(--green-accent); }
        .alert-error   { background: #fde8e8; color: #9e2b2b; border-left: 3px solid #d64545; }
        .alert-close {
            margin-left: auto; background: none; border: none;
            font-size: 18px; line-height: 1;
            color: inherit; opacity: 0.6; cursor: pointer;
        }
        .alert-close:hover { opacity: 1; }

        /* ============================================================
           UTILITAIRES
           ============================================================ */
        .text-center { text-align: center; }
        .text-muted  { color: var(--text-muted); }

        /* ============================================================
           RESPONSIVE
           ============================================================ */
        @media (max-width: 768px) {
            .sidebar-toggle { display: flex; }
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); }
            .sidebar-overlay.open { display: block; }
            .main-content { margin-left: 0; }
            .stats-cards { grid-template-columns: repeat(2, 1fr); }
            .content-wrapper { padding: 20px 16px 32px; }
        }
    </style>
</head>
<body class="app-body">
    <%@ include file="/WEB-INF/includes/sidebar.jsp" %>
    <div class="main-content">
        <%@ include file="/WEB-INF/includes/topbar.jsp" %>
        <div class="content-wrapper">
            <div class="page-header"><h3>Mes modules</h3></div>
            <div class="cards-grid">
                <c:forEach var="m" items="${modules}">
                    <a href="${pageContext.request.contextPath}/professeur/ressources?module=${m.idModule}"
                       class="info-card clickable">
                        <div class="info-card-header"><span class="badge badge-module">${m.codeModule}</span></div>
                        <h4>${m.nomModule}</h4>
                        <p>${m.filiere.nomFiliere} — ${m.semestre.nomSemestre}</p>
                        <p class="text-muted" style="font-size:12px;margin-top:8px;">
                            <i class="fas fa-file-alt"></i> Voir les ressources
                        </p>
                    </a>
                </c:forEach>
                <c:if test="${empty modules}">
                    <div class="empty-state" style="grid-column:1/-1;">
                        <i class="fas fa-book"></i>
                        <h4>Aucun module affecte</h4>
                        <p>Contactez l'administrateur pour vous affecter des modules</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>