<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>

<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des professeurs — GesPed</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Raleway:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --sidebar-bg:#1a5f7a;--sidebar-hover:rgba(255,255,255,0.08);--sidebar-active:rgba(255,255,255,0.14);
            --sidebar-text:#b8d8e5;--sidebar-dim:#6fa3bb;--sidebar-width:230px;
            --topbar-bg:#fff;--topbar-height:56px;--topbar-border:#dde6ec;
            --orange:#e8a020;--teal-dark:#1a5f7a;--teal-mid:#1e7090;--teal-light:#e8f4f8;
            --green-accent:#1ab98a;--blue-accent:#2a6b9e;--blue-mid:#2d99b8;
            --page-bg:#f2f4f6;--white:#fff;--text-dark:#1c3d4f;--text-muted:#7a9aaa;--border:#dde6ec;
            --radius-sm:6px;--radius-md:10px;
        }
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Open Sans',sans-serif;font-size:14px;color:var(--text-dark);background:var(--page-bg);display:flex;min-height:100vh}
        a{text-decoration:none;color:inherit}button{font-family:inherit;cursor:pointer}
        .sidebar{width:var(--sidebar-width);background:var(--sidebar-bg);color:var(--sidebar-text);display:flex;flex-direction:column;position:fixed;top:0;left:0;height:100vh;z-index:100;transition:transform .25s ease}
        .sidebar-brand{padding:20px 18px 16px;border-bottom:1px solid rgba(255,255,255,.08)}
        .sidebar-brand .brand-name{font-family:'Raleway',sans-serif;font-size:22px;font-weight:900;color:#fff;letter-spacing:.02em}
        .sidebar-brand .brand-role{font-size:11px;color:var(--sidebar-dim);margin-top:2px;display:block}
        .sidebar-section{padding:14px 0 6px}
        .sidebar-section-label{font-size:10px;font-weight:600;text-transform:uppercase;letter-spacing:.08em;color:var(--sidebar-dim);padding:0 18px 6px}
        .nav-item{display:flex;align-items:center;gap:10px;padding:9px 18px;color:var(--sidebar-text);font-size:13px;font-weight:400;transition:background .15s,color .15s;border-left:3px solid transparent;cursor:pointer}
        .nav-item i{font-size:15px;width:18px;text-align:center}
        .nav-item:hover{background:var(--sidebar-hover);color:#fff}
        .nav-item.active{background:var(--sidebar-active);color:#fff;border-left-color:var(--orange);font-weight:600}
        .sidebar-footer{margin-top:auto;padding:14px 18px;border-top:1px solid rgba(255,255,255,.08)}
        .nav-item-logout{display:flex;align-items:center;gap:10px;padding:9px 0;color:#e8a0a0;font-size:13px;cursor:pointer;transition:color .15s}
        .nav-item-logout i{font-size:15px;width:18px;text-align:center}
        .nav-item-logout:hover{color:#ff8a8a}
        .sidebar-toggle{display:none;background:none;border:none;color:var(--text-dark);font-size:20px;padding:4px}
        .sidebar-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.4);z-index:99}
        .main-content{margin-left:var(--sidebar-width);flex:1;display:flex;flex-direction:column;min-height:100vh}
        .topbar{position:sticky;top:0;z-index:90;background:var(--topbar-bg);border-bottom:1px solid var(--topbar-border);height:var(--topbar-height);display:flex;align-items:center;justify-content:space-between;padding:0 24px}
        .topbar::after{content:'';position:absolute;bottom:0;left:0;right:0;height:2px;background:var(--orange)}
        .topbar-left{display:flex;align-items:center;gap:10px}
        .topbar-title{font-size:15px;font-weight:600;color:var(--text-dark)}
        .topbar-right{display:flex;align-items:center;gap:16px}
        .topbar-icon-btn{background:none;border:none;color:var(--text-muted);font-size:17px;display:flex;align-items:center;position:relative}
        .topbar-icon-btn:hover{color:var(--teal-dark)}
        .notif-badge{position:absolute;top:-4px;right:-5px;width:16px;height:16px;border-radius:50%;background:var(--orange);color:#fff;font-size:9px;display:flex;align-items:center;justify-content:center;font-weight:700}
        .user-avatar{width:34px;height:34px;border-radius:50%;background:var(--teal-dark);color:#fff;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:600;cursor:pointer}
        .user-info{display:flex;flex-direction:column;align-items:flex-start}
        .user-info .user-name{font-size:13px;font-weight:600;color:var(--text-dark)}
        .user-info .user-role{font-size:11px;color:var(--text-muted)}
        .content-wrapper{padding:28px 28px 40px;flex:1}
        .page-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:22px}
        .page-header h1{font-family:'Raleway',sans-serif;font-size:26px;font-weight:800;color:var(--teal-dark)}
        .page-header p{font-size:13px;color:var(--text-muted);margin-top:3px}
        .btn{display:inline-flex;align-items:center;gap:6px;border-radius:var(--radius-sm);font-size:13px;font-weight:500;padding:7px 14px;transition:all .15s}
        .btn-sm{padding:5px 12px;font-size:12px}
        .btn-primary{background:var(--teal-dark);color:#fff;border:none}
        .btn-primary:hover{background:var(--teal-mid)}
        .btn-outline{background:none;border:1px solid var(--border);color:var(--teal-mid)}
        .btn-outline:hover{background:var(--teal-light);border-color:var(--teal-mid);color:var(--teal-dark)}
        .btn-danger{background:none;border:1px solid #fde8e8;color:#9e2b2b}
        .btn-danger:hover{background:#fde8e8}
        .dashboard-section{background:var(--white);border:1px solid var(--border);border-radius:var(--radius-md);overflow:hidden}
        .section-header{display:flex;align-items:center;justify-content:space-between;padding:14px 18px;border-bottom:1px solid var(--border)}
        .section-header h3{font-size:14px;font-weight:700;color:var(--text-dark);display:flex;align-items:center;gap:8px;font-family:'Open Sans',sans-serif}
        .section-header h3 i{color:var(--teal-mid)}
        .section-header .count{background:var(--teal-light);color:var(--teal-dark);font-size:11px;font-weight:700;padding:2px 8px;border-radius:20px;margin-left:4px}
        .table-responsive{overflow-x:auto}
        .table{width:100%;border-collapse:collapse;font-size:13px}
        .table thead tr{background:#f8fafc}
        .table th{padding:10px 18px;text-align:left;font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:.06em;color:var(--teal-mid);border-bottom:1px solid var(--border);white-space:nowrap}
        .table td{padding:11px 18px;color:var(--text-dark);border-bottom:1px solid var(--border);vertical-align:middle}
        .table tbody tr:last-child td{border-bottom:none}
        .table tbody tr:hover{background:#f8fafc}
        .prof-name-cell{display:flex;align-items:center;gap:10px}
        .prof-avatar-sm{width:32px;height:32px;border-radius:50%;background:#fdf0d8;color:var(--orange);display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:600;flex-shrink:0}
        .prof-name-text{font-weight:500}
        .prof-email{font-size:11px;color:var(--text-muted)}
        .status-badge{display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:600}
        .status-badge::before{content:'';width:6px;height:6px;border-radius:50%}
        .status-active{background:#d8f5ec;color:#0e7a54}
        .status-active::before{background:#1ab98a}
        .status-inactive{background:#fde8e8;color:#9e2b2b}
        .status-inactive::before{background:#d64545}
        .actions-cell{display:flex;gap:6px}
        .empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;padding:48px 24px;text-align:center}
        .empty-state-icon{width:72px;height:72px;border-radius:50%;background:var(--teal-light);display:flex;align-items:center;justify-content:center;margin-bottom:16px}
        .empty-state-icon i{font-size:28px;color:var(--teal-mid)}
        .empty-state-title{font-size:15px;font-weight:600;color:var(--text-dark);margin-bottom:4px}
        .empty-state-text{font-size:13px;color:var(--text-muted);max-width:320px;line-height:1.5}
        .alert{display:flex;align-items:center;gap:10px;padding:12px 16px;border-radius:var(--radius-sm);font-size:13px;font-weight:500;margin-bottom:18px;position:relative}
        .alert-success{background:#d8f5ec;color:#0e7a54;border-left:3px solid var(--green-accent)}
        .alert-error{background:#fde8e8;color:#9e2b2b;border-left:3px solid #d64545}
        .alert-close{margin-left:auto;background:none;border:none;font-size:18px;line-height:1;color:inherit;opacity:.6;cursor:pointer}
        .alert-close:hover{opacity:1}
        @media(max-width:768px){
            .sidebar-toggle{display:flex}
            .sidebar{transform:translateX(-100%)}
            .sidebar.open{transform:translateX(0)}
            .sidebar-overlay.open{display:block}
            .main-content{margin-left:0}
            .content-wrapper{padding:20px 16px 32px}
            .page-header{flex-direction:column;align-items:flex-start;gap:12px}
        }
    </style>
</head>
<body>

    <aside class="sidebar" id="sidebar">
        <div class="sidebar-brand">
            <span class="brand-name">GesPed</span>
            <span class="brand-role">System Admin</span>
        </div>
        <div class="sidebar-section">
            <div class="sidebar-section-label">Principal</div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">
                <i class="fas fa-th-large"></i> Tableau de bord
            </a>
        </div>
        <div class="sidebar-section">
            <div class="sidebar-section-label">Gestion</div>
            <a href="${pageContext.request.contextPath}/admin/etudiants" class="nav-item">
                <i class="fas fa-users"></i> &Eacute;tudiants
            </a>
            <a href="${pageContext.request.contextPath}/admin/professeurs" class="nav-item active">
                <i class="fas fa-chalkboard-teacher"></i> Professeurs
            </a>
            <a href="${pageContext.request.contextPath}/admin/modules" class="nav-item">
                <i class="fas fa-book"></i> Modules
            </a>
            <a href="${pageContext.request.contextPath}/admin/ressources" class="nav-item">
                <i class="fas fa-file-alt"></i> Ressources
            </a>
            <a href="${pageContext.request.contextPath}/admin/filieres" class="nav-item">
                <i class="fas fa-layer-group"></i> Fili&egrave;res
            </a>
        </div>
        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/logout" class="nav-item-logout">
                <i class="fas fa-sign-out-alt"></i> D&eacute;connexion
            </a>
        </div>
    </aside>
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <div class="main-content">
        <header class="topbar">
            <div class="topbar-left">
                <button class="sidebar-toggle" id="sidebarToggle" aria-label="Menu"><i class="fas fa-bars"></i></button>
                <span class="topbar-title">${pageTitle}</span>
            </div>
            <div class="topbar-right">
                <button class="topbar-icon-btn" aria-label="Notifications">
                    <i class="fas fa-bell"></i><span class="notif-badge">3</span>
                </button>
                <div class="user-avatar" title="${nomComplet}">${nomComplet != null ? nomComplet.substring(0,1).toUpperCase() : 'A'}</div>
                <div class="user-info">
                    <span class="user-name">${nomComplet}</span>
                    <span class="user-role">Administrateur</span>
                </div>
            </div>
        </header>

        <div class="content-wrapper">

            <c:if test="${not empty msgSuccess}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${msgSuccess}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>
            <c:if test="${not empty msgError}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${msgError}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>

            <div class="page-header">
                <div>
                    <h1>Professeurs</h1>
                    <p>G&eacute;rez les comptes professeurs de la plateforme</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/professeurs/ajouter" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Ajouter un professeur
                </a>
            </div>

            <div class="dashboard-section">
                <div class="section-header">
                    <h3><i class="fas fa-chalkboard-teacher"></i> Liste des professeurs <span class="count">${fn:length(professeurs)}</span></h3>
                    <div style="display:flex;gap:8px;">
                        <input type="text" placeholder="Rechercher..." style="padding:6px 12px;border:1px solid var(--border);border-radius:var(--radius-sm);font-size:12px;width:180px;font-family:inherit;outline:none;">
                        <button class="btn btn-sm btn-outline"><i class="fas fa-filter"></i> Filtrer</button>
                    </div>
                </div>

                <c:if test="${not empty professeurs}">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Nom complet</th>
                                    <th>Email</th>
                                    <th>Module</th>
                                    <th>Ressources</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${professeurs}">
                                    <tr>
                                        <td>
                                            <div class="prof-name-cell">
                                                <div class="prof-avatar-sm">${p.nom.substring(0,1)}</div>
                                                <div>
                                                    <div class="prof-name-text">${p.prenom} ${p.nom}</div>
                                                    <div class="prof-email">${p.email}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>${p.email}</td>
                                        <td>—</td>
                                        <td>—</td>
                                        <td>
                                            <span class="status-badge ${p.statut ? 'status-active' : 'status-inactive'}">
                                                ${p.statut ? 'Actif' : 'Inactif'}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="actions-cell">
                                                <a href="${pageContext.request.contextPath}/admin/professeurs/edit?id=${p.idUtilisateur}" class="btn btn-sm btn-outline" title="Modifier">
                                                    <i class="fas fa-pen"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/professeurs/delete?id=${p.idUtilisateur}" class="btn btn-sm btn-danger" title="Supprimer" onclick="return confirm('Supprimer ce professeur ?')">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <c:if test="${empty professeurs}">
                    <div class="empty-state">
                        <div class="empty-state-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                        <div class="empty-state-title">Aucun professeur enregistr&eacute;</div>
                        <div class="empty-state-text">Commencez par ajouter des professeurs pour les g&eacute;rer depuis cette interface.</div>
                    </div>
                </c:if>
            </div>

        </div>
    </div>

    <script>
        const sidebarToggle = document.getElementById('sidebarToggle');
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');
        if(sidebarToggle){sidebarToggle.addEventListener('click',function(){sidebar.classList.toggle('open');overlay.classList.toggle('open')})}
        if(overlay){overlay.addEventListener('click',function(){sidebar.classList.remove('open');overlay.classList.remove('open')})}
    </script>
</body>
</html>