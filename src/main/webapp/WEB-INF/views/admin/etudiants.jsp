<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des étudiants — GesPed</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Raleway:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        /* ============================================================
           VARIABLES
           ============================================================ */
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
            --border-light:    #eaf0f4;

            --radius-sm:       6px;
            --radius-md:       10px;
            --radius-lg:       14px;

            /* Palette avatars */
            --av-1: #1a5f7a;
            --av-2: #2d99b8;
            --av-3: #1ab98a;
            --av-4: #e8a020;
            --av-5: #9b59b6;
            --av-6: #e74c6f;
            --av-7: #34495e;
            --av-8: #16a085;
        }

        /* ============================================================
           RESET & BASE
           ============================================================ */
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
        input { font-family: inherit; }

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
            transition: background 0.15s, color 0.15s, border-color 0.15s;
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
            background: linear-gradient(90deg, var(--teal-dark), var(--orange));
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
            transition: color 0.15s;
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
            animation: notifPulse 2s infinite;
        }
        @keyframes notifPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.12); }
        }
        .user-avatar {
            width: 34px; height: 34px;
            border-radius: 50%;
            background: var(--teal-dark);
            color: #fff;
            display: flex; align-items: center; justify-content: center;
            font-size: 12px; font-weight: 600;
            cursor: pointer;
            transition: box-shadow 0.2s;
        }
        .user-avatar:hover { box-shadow: 0 0 0 3px rgba(26,95,122,0.2); }
        .user-info { display: flex; flex-direction: column; align-items: flex-start; }
        .user-info .user-name { font-size: 13px; font-weight: 600; color: var(--text-dark); }
        .user-info .user-role { font-size: 11px; color: var(--text-muted); }

        /* ============================================================
           CONTENU PRINCIPAL
           ============================================================ */
        .content-wrapper { padding: 28px 28px 40px; flex: 1; }

        /* ---- Page header ---- */
        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }
        .page-header h1 {
            font-family: 'Raleway', sans-serif;
            font-size: 26px;
            font-weight: 800;
            color: var(--teal-dark);
            line-height: 1.2;
        }
        .page-header p {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 4px;
        }

        /* ============================================================
           BOUTONS
           ============================================================ */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border-radius: var(--radius-sm);
            font-size: 13px;
            font-weight: 500;
            padding: 7px 14px;
            transition: all 0.18s;
            border: none;
            white-space: nowrap;
        }
        .btn-sm { padding: 5px 12px; font-size: 12px; }
        .btn-primary {
            background: var(--teal-dark);
            color: #ffffff;
            border: none;
            box-shadow: 0 2px 6px rgba(26,95,122,0.25);
        }
        .btn-primary:hover {
            background: var(--teal-mid);
            box-shadow: 0 4px 12px rgba(26,95,122,0.3);
            transform: translateY(-1px);
        }
        .btn-primary:active {
            transform: translateY(0);
            box-shadow: 0 1px 3px rgba(26,95,122,0.25);
        }
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
        .btn-danger {
            background: none;
            border: 1px solid #fde8e8;
            color: #9e2b2b;
        }
        .btn-danger:hover {
            background: #fde8e8;
            border-color: #e8b4b4;
        }

        /* ============================================================
           SECTION CARTE
           ============================================================ */
        .dashboard-section {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.04);
        }
        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 20px;
            border-bottom: 1px solid var(--border-light);
            background: #fafbfc;
        }
        .section-header-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-header h3 {
            font-size: 14px;
            font-weight: 700;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 8px;
            font-family: 'Open Sans', sans-serif;
        }
        .section-header h3 i { color: var(--teal-mid); font-size: 15px; }
        .count {
            background: var(--teal-light);
            color: var(--teal-dark);
            font-size: 11px;
            font-weight: 700;
            padding: 2px 9px;
            border-radius: 20px;
        }

        /* ---- Toolbar (recherche + filtre) ---- */
        .toolbar {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .search-box { position: relative; }
        .search-box i {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 12px;
            pointer-events: none;
        }
        .search-box input {
            padding: 6px 12px 6px 30px;
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 12px;
            width: 200px;
            outline: none;
            transition: border-color 0.15s, box-shadow 0.15s;
            background: var(--white);
            color: var(--text-dark);
        }
        .search-box input::placeholder { color: var(--text-muted); }
        .search-box input:focus {
            border-color: var(--teal-mid);
            box-shadow: 0 0 0 3px rgba(30,112,144,0.1);
        }

        /* ============================================================
           TABLEAU
           ============================================================ */
        .table-responsive { overflow-x: auto; }
        .table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        .table thead tr { background: #f6f8fa; }
        .table th {
            padding: 11px 20px;
            text-align: left;
            font-size: 10.5px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.07em;
            color: var(--teal-mid);
            border-bottom: 2px solid var(--border-light);
            white-space: nowrap;
        }
        .table td {
            padding: 14px 20px;
            color: var(--text-dark);
            border-bottom: 1px solid var(--border-light);
            vertical-align: middle;
        }
        .table tbody tr:last-child td { border-bottom: none; }
        .table tbody tr { transition: background 0.12s; }
        .table tbody tr:hover { background: #f8fbfc; }

        /* ---- Student name cell ---- */
        .student-name-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .student-avatar-sm {
            width: 36px; height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 700;
            color: #fff;
            flex-shrink: 0;
            letter-spacing: 0.02em;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            transition: transform 0.15s;
        }
        .table tbody tr:hover .student-avatar-sm {
            transform: scale(1.08);
        }
        .student-name-text {
            font-weight: 600;
            color: var(--text-dark);
            font-size: 13px;
        }

        /* Couleurs avatars dynamiques */
        .av-0 { background: var(--av-1); }
        .av-1 { background: var(--av-2); }
        .av-2 { background: var(--av-3); }
        .av-3 { background: var(--av-4); }
        .av-4 { background: var(--av-5); }
        .av-5 { background: var(--av-6); }
        .av-6 { background: var(--av-7); }
        .av-7 { background: var(--av-8); }

        /* ---- Email ---- */
        .email-cell {
            color: var(--text-muted);
            font-size: 12.5px;
        }
        .email-cell i {
            margin-right: 4px;
            font-size: 11px;
            color: var(--border);
        }

        /* ---- Filière badge ---- */
        .filiere-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: var(--radius-sm);
            font-size: 12px;
            font-weight: 500;
            background: var(--teal-light);
            color: var(--teal-dark);
            border: 1px solid #d0eaf3;
        }
        .filiere-badge i { font-size: 10px; opacity: 0.6; }
        .filiere-none {
            background: var(--page-bg);
            color: var(--text-muted);
            border-color: var(--border);
        }

        /* ---- Status badge ---- */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.02em;
        }
        .status-badge::before {
            content: '';
            width: 7px; height: 7px;
            border-radius: 50%;
            flex-shrink: 0;
        }
        .status-active {
            background: #d8f5ec;
            color: #0e7a54;
        }
        .status-active::before {
            background: #1ab98a;
            box-shadow: 0 0 6px rgba(26,185,138,0.4);
        }
        .status-inactive {
            background: #fde8e8;
            color: #9e2b2b;
        }
        .status-inactive::before {
            background: #d64545;
        }

        /* ---- Actions ---- */
        .actions-cell {
            display: flex;
            gap: 6px;
        }
        .action-btn {
            width: 32px; height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: var(--radius-sm);
            border: 1px solid var(--border);
            background: var(--white);
            color: var(--text-muted);
            font-size: 12px;
            transition: all 0.15s;
            cursor: pointer;
        }
        .action-btn:hover {
            border-color: var(--teal-mid);
            color: var(--teal-dark);
            background: var(--teal-light);
        }
        .action-btn.danger:hover {
            border-color: #e8b4b4;
            color: #9e2b2b;
            background: #fde8e8;
        }

        /* ============================================================
           BADGE GÉNÉRIQUE
           ============================================================ */
        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            color: #ffffff;
            letter-spacing: 0.03em;
        }

        /* ============================================================
           ÉTAT VIDE
           ============================================================ */
        .empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 56px 24px;
            text-align: center;
            animation: fadeInUp 0.4s ease;
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .empty-state-icon {
            width: 80px; height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--teal-light), #d0eaf3);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 18px;
            box-shadow: 0 4px 16px rgba(26,95,122,0.1);
        }
        .empty-state-icon i {
            font-size: 30px;
            color: var(--teal-mid);
        }
        .empty-state-title {
            font-size: 16px;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 6px;
        }
        .empty-state-text {
            font-size: 13px;
            color: var(--text-muted);
            max-width: 340px;
            line-height: 1.6;
        }

        /* ============================================================
           ALERTES FLASH
           ============================================================ */
        .alert {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 16px;
            border-radius: var(--radius-sm);
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 18px;
            position: relative;
            animation: alertSlide 0.3s ease;
        }
        @keyframes alertSlide {
            from { opacity: 0; transform: translateY(-8px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .alert-success {
            background: #d8f5ec;
            color: #0e7a54;
            border-left: 3px solid var(--green-accent);
        }
        .alert-error {
            background: #fde8e8;
            color: #9e2b2b;
            border-left: 3px solid #d64545;
        }
        .alert-close {
            margin-left: auto;
            background: none;
            border: none;
            font-size: 18px;
            line-height: 1;
            color: inherit;
            opacity: 0.6;
            cursor: pointer;
            transition: opacity 0.15s;
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
            .content-wrapper { padding: 20px 16px 32px; }
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }
            .section-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            .toolbar {
                width: 100%;
                flex-wrap: wrap;
            }
            .search-box input { width: 100%; }
        }
    </style>
</head>
<body>
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-brand"><span class="brand-name">GesPed</span><span class="brand-role">System Admin</span></div>
        <div class="sidebar-section"><div class="sidebar-section-label">Principal</div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item"><i class="fas fa-th-large"></i> Tableau de bord</a>
        </div>
        <div class="sidebar-section"><div class="sidebar-section-label">Gestion</div>
            <a href="${pageContext.request.contextPath}/admin/etudiants" class="nav-item active"><i class="fas fa-users"></i> &Eacute;tudiants</a>
            <a href="${pageContext.request.contextPath}/admin/professeurs" class="nav-item"><i class="fas fa-chalkboard-teacher"></i> Professeurs</a>
            <a href="${pageContext.request.contextPath}/admin/modules" class="nav-item"><i class="fas fa-book"></i> Modules</a>
            <a href="${pageContext.request.contextPath}/admin/ressources" class="nav-item"><i class="fas fa-file-alt"></i> Ressources</a>
            <a href="${pageContext.request.contextPath}/admin/filieres" class="nav-item"><i class="fas fa-layer-group"></i> Fili&egrave;res</a>
        </div>
        <div class="sidebar-footer"><a href="${pageContext.request.contextPath}/logout" class="nav-item-logout"><i class="fas fa-sign-out-alt"></i> D&eacute;connexion</a></div>
    </aside>
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <div class="main-content">
        <header class="topbar">
            <div class="topbar-left"><button class="sidebar-toggle" id="sidebarToggle" aria-label="Menu"><i class="fas fa-bars"></i></button><span class="topbar-title">${pageTitle}</span></div>
            <div class="topbar-right">
                <button class="topbar-icon-btn" aria-label="Notifications"><i class="fas fa-bell"></i><span class="notif-badge">3</span></button>
                <div class="user-avatar" title="${nomComplet}">${nomComplet != null ? nomComplet.substring(0,1).toUpperCase() : 'A'}</div>
                <div class="user-info"><span class="user-name">${nomComplet}</span><span class="user-role">Administrateur</span></div>
            </div>
        </header>

        <div class="content-wrapper">
            <c:if test="${not empty msgSuccess}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${msgSuccess}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>
            <c:if test="${not empty msgError}"><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${msgError}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>

            <div class="page-header">
                <div><h1>&Eacute;tudiants</h1><p>G&eacute;rez les comptes &eacute;tudiants de la plateforme</p></div>
                <a href="${pageContext.request.contextPath}/admin/etudiants/ajouter" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Ajouter un &eacute;tudiant
                </a>
            </div>

            <div class="dashboard-section">
                <div class="section-header">
                    <div class="section-header-left">
                        <h3><i class="fas fa-users"></i> Liste des &eacute;tudiants <span class="count">${fn:length(etudiants)}</span></h3>
                    </div>
                    <div class="toolbar">
                        <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Rechercher un &eacute;tudiant..." oninput="filterTable()"></div>
                        <button class="btn btn-sm btn-outline"><i class="fas fa-filter"></i> Filtrer</button>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty etudiants}">
                        <div class="table-responsive">
                            <table class="table" id="studentsTable">
                                <thead>
                                    <tr>
                                        <th>Nom complet</th>
                                        <th>Email</th>
                                        <th>Fili&egrave;re</th>
                                        <th>Statut</th>
                                        <th style="text-align:center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="e" items="${etudiants}" varStatus="loop">
                                        <tr>
                                            <td>
                                                <div class="student-name-cell">
                                                    <div class="student-avatar-sm av-${loop.index mod 8}">${e.nom.substring(0,1)}</div>
                                                    <div class="student-name-text">${e.prenom} ${e.nom}</div>
                                                </div>
                                            </td>
                                            <td class="email-cell"><i class="fas fa-envelope"></i> ${e.email}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${e.filiere != null}">
                                                        <span class="filiere-badge"><i class="fas fa-graduation-cap"></i> ${e.filiere.nomFiliere}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="filiere-badge filiere-none"><i class="fas fa-minus-circle"></i> Non assign&eacute;</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="status-badge ${e.statut ? 'status-active' : 'status-inactive'}">
                                                    ${e.statut ? 'Actif' : 'Inactif'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="actions-cell" style="justify-content:center">
                                                    <a href="${pageContext.request.contextPath}/admin/etudiants/edit?id=${e.idUtilisateur}" class="action-btn" title="Modifier"><i class="fas fa-pen"></i></a>
                                                    <a href="${pageContext.request.contextPath}/admin/etudiants/delete?id=${e.idUtilisateur}" class="action-btn danger" title="Supprimer" onclick="return confirm('Supprimer cet \u00e9tudiant ?')"><i class="fas fa-trash-alt"></i></a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-icon"><i class="fas fa-user-graduate"></i></div>
                            <div class="empty-state-title">Aucun &eacute;tudiant enregistr&eacute;</div>
                            <div class="empty-state-text">Commencez par ajouter des &eacute;tudiants pour les g&eacute;rer depuis cette interface.</div>
                            <a href="${pageContext.request.contextPath}/admin/etudiants/ajouter" class="btn btn-primary" style="margin-top:18px"><i class="fas fa-plus"></i> Ajouter un &eacute;tudiant</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <script>
        var sidebarToggle = document.getElementById('sidebarToggle'),
            sidebar = document.getElementById('sidebar'),
            overlay = document.getElementById('sidebarOverlay');
        if (sidebarToggle) sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('open');
            overlay.classList.toggle('open');
        });
        if (overlay) overlay.addEventListener('click', function() {
            sidebar.classList.remove('open');
            overlay.classList.remove('open');
        });
        function filterTable() {
            var q = document.getElementById('searchInput').value.toLowerCase();
            document.querySelectorAll('#studentsTable tbody tr').forEach(function(r) {
                r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none';
            });
        }
    </script>
</body>
</html>