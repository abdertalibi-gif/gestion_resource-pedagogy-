<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="models.Utilisateur" %>
<%
    request.setAttribute("role", "ADMIN");
    request.setAttribute("nomComplet", ((Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "Nouvelle affectation");
    request.setAttribute("activeMenu", "affectations");
    String msgSuccess = (String) request.getAttribute("msgSuccess");
    String msgError   = (String) request.getAttribute("msgError");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvelle affectation — GesPed</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Raleway:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root{--sidebar-bg:#1a5f7a;--sidebar-hover:rgba(255,255,255,.08);--sidebar-active:rgba(255,255,255,.14);--sidebar-text:#b8d8e5;--sidebar-dim:#6fa3bb;--sidebar-width:230px;--topbar-bg:#fff;--topbar-height:56px;--topbar-border:#dde6ec;--orange:#e8a020;--teal-dark:#1a5f7a;--teal-mid:#1e7090;--teal-light:#e8f4f8;--green-accent:#1ab98a;--blue-accent:#2a6b9e;--blue-mid:#2d99b8;--page-bg:#f2f4f6;--white:#fff;--text-dark:#1c3d4f;--text-muted:#7a9aaa;--border:#dde6ec;--border-light:#eaf0f4;--radius-sm:6px;--radius-md:10px;--radius-lg:14px;--danger:#d64545}
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Open Sans',sans-serif;font-size:14px;color:var(--text-dark);background:var(--page-bg);display:flex;min-height:100vh}
        a{text-decoration:none;color:inherit}button{font-family:inherit;cursor:pointer}input,select{font-family:inherit}

        .sidebar{width:var(--sidebar-width);background:var(--sidebar-bg);color:var(--sidebar-text);display:flex;flex-direction:column;position:fixed;top:0;left:0;height:100vh;z-index:100;transition:transform .25s ease}
        .sidebar-brand{padding:20px 18px 16px;border-bottom:1px solid rgba(255,255,255,.08)}
        .sidebar-brand .brand-name{font-family:'Raleway',sans-serif;font-size:22px;font-weight:900;color:#fff;letter-spacing:.02em}
        .sidebar-brand .brand-role{font-size:11px;color:var(--sidebar-dim);margin-top:2px;display:block}
        .sidebar-section{padding:14px 0 6px}
        .sidebar-section-label{font-size:10px;font-weight:600;text-transform:uppercase;letter-spacing:.08em;color:var(--sidebar-dim);padding:0 18px 6px}
        .nav-item{display:flex;align-items:center;gap:10px;padding:9px 18px;color:var(--sidebar-text);font-size:13px;font-weight:400;transition:background .15s,color .15s,border-color .15s;border-left:3px solid transparent;cursor:pointer}
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
        .topbar::after{content:'';position:absolute;bottom:0;left:0;right:0;height:2px;background:linear-gradient(90deg,var(--teal-dark),var(--orange))}
        .topbar-left{display:flex;align-items:center;gap:10px}
        .topbar-title{font-size:15px;font-weight:600;color:var(--text-dark)}
        .topbar-right{display:flex;align-items:center;gap:16px}
        .topbar-icon-btn{background:none;border:none;color:var(--text-muted);font-size:17px;display:flex;align-items:center;position:relative;transition:color .15s}
        .topbar-icon-btn:hover{color:var(--teal-dark)}
        .user-avatar{width:34px;height:34px;border-radius:50%;background:var(--teal-dark);color:#fff;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:600;cursor:pointer}
        .user-info{display:flex;flex-direction:column;align-items:flex-start}
        .user-info .user-name{font-size:13px;font-weight:600;color:var(--text-dark)}
        .user-info .user-role{font-size:11px;color:var(--text-muted)}

        .content-wrapper{padding:28px 28px 40px;flex:1}
        .breadcrumb{display:flex;align-items:center;gap:8px;margin-bottom:20px;font-size:12px}
        .breadcrumb a{color:var(--teal-mid);transition:color .15s}
        .breadcrumb a:hover{color:var(--teal-dark)}
        .breadcrumb .sep{color:var(--text-muted);font-size:9px}
        .breadcrumb .current{color:var(--text-dark);font-weight:500}

        .page-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:24px}
        .page-header h1{font-family:'Raleway',sans-serif;font-size:24px;font-weight:800;color:var(--teal-dark);line-height:1.2}
        .page-header p{font-size:13px;color:var(--text-muted);margin-top:4px}

        .alert{display:flex;align-items:center;gap:10px;padding:12px 16px;border-radius:var(--radius-sm);font-size:13px;font-weight:500;margin-bottom:18px;animation:alertSlide .3s ease}
        @keyframes alertSlide{from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:translateY(0)}}
        .alert-success{background:#d8f5ec;color:#0e7a54;border-left:3px solid var(--green-accent)}
        .alert-error{background:#fde8e8;color:#9e2b2b;border-left:3px solid var(--danger)}
        .alert-close{margin-left:auto;background:none;border:none;font-size:18px;line-height:1;color:inherit;opacity:.6;cursor:pointer}
        .alert-close:hover{opacity:1}

        .form-card{background:var(--white);border:1px solid var(--border);border-radius:var(--radius-lg);overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,.04);max-width:560px}
        .form-card-header{padding:16px 20px;border-bottom:1px solid var(--border-light);background:#fafbfc;display:flex;align-items:center;justify-content:space-between}
        .form-card-header h3{font-size:14px;font-weight:700;color:var(--text-dark);display:flex;align-items:center;gap:8px}
        .form-card-header h3 i{color:var(--teal-mid);font-size:15px}
        .form-card-body{padding:24px 20px}

        .form-group{margin-bottom:20px}
        .form-group label{display:block;font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);margin-bottom:6px}
        .form-group .required{color:var(--danger);margin-left:2px}
        .form-input,.form-select{width:100%;padding:10px 12px;border:1px solid var(--border);border-radius:var(--radius-sm);font-size:13px;outline:none;transition:border-color .15s,box-shadow .15s;color:var(--text-dark);background:var(--white)}
        .form-input:focus,.form-select:focus{border-color:var(--teal-mid);box-shadow:0 0 0 3px rgba(30,112,144,.1)}

        .form-actions{display:flex;gap:10px;margin-top:8px;padding-top:18px;border-top:1px solid var(--border-light)}

        .btn{display:inline-flex;align-items:center;gap:6px;border-radius:var(--radius-sm);font-size:13px;font-weight:500;padding:8px 16px;transition:all .18s;border:none;white-space:nowrap}
        .btn-sm{padding:5px 12px;font-size:12px}
        .btn-primary{background:var(--teal-dark);color:#fff;box-shadow:0 2px 6px rgba(26,95,122,.25)}
        .btn-primary:hover{background:var(--teal-mid);transform:translateY(-1px);box-shadow:0 4px 12px rgba(26,95,122,.3)}
        .btn-secondary{background:var(--page-bg);color:var(--text-dark);border:1px solid var(--border)}
        .btn-secondary:hover{background:var(--border-light)}

        .info-note{display:flex;align-items:flex-start;gap:10px;padding:12px 14px;border-radius:var(--radius-sm);background:var(--teal-light);color:var(--teal-dark);font-size:12px;line-height:1.6;margin-bottom:20px;border:1px solid #d0eaf3}
        .info-note i{margin-top:2px;flex-shrink:0;font-size:14px;color:var(--teal-mid)}

        @media(max-width:768px){.sidebar-toggle{display:flex}.sidebar{transform:translateX(-100%)}.sidebar.open{transform:translateX(0)}.sidebar-overlay.open{display:block}.main-content{margin-left:0}.content-wrapper{padding:20px 16px 32px}.page-header{flex-direction:column;align-items:flex-start;gap:12px}.form-card{max-width:100%}}
    </style>
</head>
<body>
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-brand"><span class="brand-name">GesPed</span><span class="brand-role">System Admin</span></div>
        <div class="sidebar-section"><div class="sidebar-section-label">Principal</div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item"><i class="fas fa-th-large"></i> Tableau de bord</a>
        </div>
        <div class="sidebar-section"><div class="sidebar-section-label">Gestion</div>
            <a href="${pageContext.request.contextPath}/admin/etudiants" class="nav-item"><i class="fas fa-users"></i> &Eacute;tudiants</a>
            <a href="${pageContext.request.contextPath}/admin/professeurs" class="nav-item"><i class="fas fa-chalkboard-teacher"></i> Professeurs</a>
            <a href="${pageContext.request.contextPath}/admin/modules" class="nav-item"><i class="fas fa-book"></i> Modules</a>
            <a href="${pageContext.request.contextPath}/admin/ressources" class="nav-item"><i class="fas fa-file-alt"></i> Ressources</a>
            <a href="${pageContext.request.contextPath}/admin/filieres" class="nav-item"><i class="fas fa-layer-group"></i> Fili&egrave;res</a>
            <a href="${pageContext.request.contextPath}/admin/affectations" class="nav-item active"><i class="fas fa-link"></i> Affectations</a>
        </div>
        <div class="sidebar-footer"><a href="${pageContext.request.contextPath}/logout" class="nav-item-logout"><i class="fas fa-sign-out-alt"></i> D&eacute;connexion</a></div>
    </aside>
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <div class="main-content">
        <header class="topbar">
            <div class="topbar-left"><button class="sidebar-toggle" id="sidebarToggle" aria-label="Menu"><i class="fas fa-bars"></i></button><span class="topbar-title">${pageTitle}</span></div>
            <div class="topbar-right">
                <button class="topbar-icon-btn" aria-label="Notifications"><i class="fas fa-bell"></i><span class="notif-badge">3</span></button>
                <div class="user-avatar">${nomComplet != null ? nomComplet.substring(0,1).toUpperCase() : 'A'}</div>
                <div class="user-info"><span class="user-name">${nomComplet}</span><span class="user-role">Administrateur</span></div>
            </div>
        </header>

        <div class="content-wrapper">
            <c:if test="${not empty msgSuccess}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${msgSuccess}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>
            <c:if test="${not empty msgError}"><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${msgError}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>

            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/admin/dashboard">Tableau de bord</a>
                <span class="sep"><i class="fas fa-chevron-right"></i></span>
                <a href="${pageContext.request.contextPath}/admin/affectations">Affectations</a>
                <span class="sep"><i class="fas fa-chevron-right"></i></span>
                <span class="current">Nouvelle affectation</span>
            </div>

            <div class="page-header">
                <div><h1>Nouvelle affectation</h1><p>Affecter un professeur &agrave; un module</p></div>
            </div>

            <div class="form-card">
                <div class="form-card-header">
                    <h3><i class="fas fa-link"></i> Cr&eacute;er une affectation</h3>
                    <a href="${pageContext.request.contextPath}/admin/affectations" class="btn btn-sm btn-secondary">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                </div>
                <div class="form-card-body">
                    <div class="info-note">
                        <i class="fas fa-info-circle"></i>
                        <span>Un professeur peut &ecirc;tre affect&eacute; &agrave; plusieurs modules. V&eacute;rifiez les affectations existantes avant d'en cr&eacute;er une nouvelle.</span>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/admin/affectation/ajouter" novalidate>
                        <div class="form-group">
                            <label for="idProfesseur">Professeur <span class="required">*</span></label>
                            <select id="idProfesseur" name="idProfesseur" class="form-select" required>
                                <option value="">-- S&eacute;lectionner un professeur --</option>
                                <c:forEach var="p" items="${professeurs}">
                                    <option value="${p.idUtilisateur}">${p.prenom} ${p.nom}</option>
                                </c:forEach>
                            </select>
                            <c:if test="${empty professeurs}">
                                <small style="color:var(--danger)">Aucun professeur disponible.</small>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="idModule">Module <span class="required">*</span></label>
                            <select name="idModule" class="form-select" required>
    <option value="">-- Sélectionner un module --</option>
    <c:forEach var="m" items="${modules}">
        <option value="${m.idModule}">${m.nomModule}</option>
    </c:forEach>
</select>
                            <c:if test="${empty modules}">
                                <small style="color:var(--danger)">Aucun module disponible.</small>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="anneeUniversitaire">Ann&eacute;e universitaire <span class="required">*</span></label>
                            <input type="text" id="anneeUniversitaire" name="anneeUniversitaire"
                                   class="form-input" placeholder="Ex: 2025-2026"
                                   value="${anneeDefaut != null ? anneeDefaut : ''}" required>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary"><i class="fas fa-check"></i> Cr&eacute;er</button>
                            <a href="${pageContextContext.request.contextPath}/admin/affectations" class="btn btn-secondary"><i class="fas fa-times"></i> Annuler</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        var sidebarToggle=document.getElementById('sidebarToggle'),
            sidebar=document.getElementById('sidebar'),
            overlay=document.getElementById('sidebarOverlay');
        if(sidebarToggle)sidebarToggle.addEventListener('click',function(){sidebar.classList.toggle('open');overlay.classList.toggle('open')});
        if(overlay)overlay.addEventListener('click',function(){sidebar.classList.remove('open');overlay.classList.remove('open')});
    </script>
</body>
</html>