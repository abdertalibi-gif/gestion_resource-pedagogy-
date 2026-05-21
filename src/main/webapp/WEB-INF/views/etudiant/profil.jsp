<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon profil — GesPed</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Raleway:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root{--sidebar-bg:#1a5f7a;--sidebar-hover:rgba(255,255,255,.08);--sidebar-active:rgba(255,255,255,.14);--sidebar-text:#b8d8e5;--sidebar-dim:#6fa3bb;--sidebar-width:230px;--topbar-bg:#fff;--topbar-height:56px;--topbar-border:#dde6ec;--orange:#e8a020;--teal-dark:#1a5f7a;--teal-mid:#1e7090;--teal-light:#e8f4f8;--green-accent:#1ab98a;--blue-accent:#2a6b9e;--blue-mid:#2d99b8;--page-bg:#f2f4f6;--white:#fff;--text-dark:#1c3d4f;--text-muted:#7a9aaa;--border:#dde6ec;--border-light:#eaf0f4;--radius-sm:6px;--radius-md:10px;--radius-lg:14px}
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}body{font-family:'Open Sans',sans-serif;font-size:14px;color:var(--text-dark);background:var(--page-bg);display:flex;min-height:100vh}a{text-decoration:none;color:inherit}button{font-family:inherit;cursor:pointer}input{font-family:inherit}
        .sidebar{width:var(--sidebar-width);background:var(--sidebar-bg);color:var(--sidebar-text);display:flex;flex-direction:column;position:fixed;top:0;left:0;height:100vh;z-index:100;transition:transform .25s ease}.sidebar-brand{padding:20px 18px 16px;border-bottom:1px solid rgba(255,255,255,.08)}.sidebar-brand .brand-name{font-family:'Raleway',sans-serif;font-size:22px;font-weight:900;color:#fff;letter-spacing:.02em}.sidebar-brand .brand-role{font-size:11px;color:var(--sidebar-dim);margin-top:2px;display:block}.sidebar-section{padding:14px 0 6px}.sidebar-section-label{font-size:10px;font-weight:600;text-transform:uppercase;letter-spacing:.08em;color:var(--sidebar-dim);padding:0 18px 6px}.nav-item{display:flex;align-items:center;gap:10px;padding:9px 18px;color:var(--sidebar-text);font-size:13px;font-weight:400;transition:background .15s,color .15s,border-color .15s;border-left:3px solid transparent;cursor:pointer}.nav-item i{font-size:15px;width:18px;text-align:center}.nav-item:hover{background:var(--sidebar-hover);color:#fff}.nav-item.active{background:var(--sidebar-active);color:#fff;border-left-color:var(--orange);font-weight:600}.sidebar-footer{margin-top:auto;padding:14px 18px;border-top:1px solid rgba(255,255,255,.08)}.nav-item-logout{display:flex;align-items:center;gap:10px;padding:9px 0;color:#e8a0a0;font-size:13px;cursor:pointer;transition:color .15s}.nav-item-logout i{font-size:15px;width:18px;text-align:center}.nav-item-logout:hover{color:#ff8a8a}.sidebar-toggle{display:none;background:none;border:none;color:var(--text-dark);font-size:20px;padding:4px}.sidebar-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.4);z-index:99}
        .main-content{margin-left:var(--sidebar-width);flex:1;display:flex;flex-direction:column;min-height:100vh}.topbar{position:sticky;top:0;z-index:90;background:var(--topbar-bg);border-bottom:1px solid var(--topbar-border);height:var(--topbar-height);display:flex;align-items:center;justify-content:space-between;padding:0 24px}.topbar::after{content:'';position:absolute;bottom:0;left:0;right:0;height:2px;background:linear-gradient(90deg,var(--teal-dark),var(--orange))}.topbar-left{display:flex;align-items:center;gap:10px}.topbar-title{font-size:15px;font-weight:600;color:var(--text-dark)}.topbar-right{display:flex;align-items:center;gap:16px}.user-avatar{width:34px;height:34px;border-radius:50%;background:var(--green-accent);color:#fff;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:600;cursor:pointer}.user-info{display:flex;flex-direction:column;align-items:flex-start}.user-info .user-name{font-size:13px;font-weight:600;color:var(--text-dark)}.user-info .user-role{font-size:11px;color:var(--text-muted)}
        .content-wrapper{padding:28px 28px 40px;flex:1}.page-header{margin-bottom:24px}.page-header h1{font-family:'Raleway',sans-serif;font-size:26px;font-weight:800;color:var(--teal-dark)}.page-header p{font-size:13px;color:var(--text-muted);margin-top:4px}
        .profile-card{background:var(--white);border:1px solid var(--border);border-radius:var(--radius-lg);overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,.04);max-width:600px}
        .profile-header{background:linear-gradient(135deg,var(--teal-dark),var(--teal-mid));padding:28px;text-align:center;color:#fff}
        .profile-avatar-lg{width:72px;height:72px;border-radius:50%;background:rgba(255,255,255,.2);color:#fff;display:flex;align-items:center;justify-content:center;font-size:26px;font-weight:700;margin:0 auto 12px;border:3px solid rgba(255,255,255,.3)}
        .profile-header h2{font-size:18px;font-weight:700}.profile-header p{font-size:13px;opacity:.8;margin-top:4px}
        .profile-body{padding:24px}
        .profile-field{display:flex;justify-content:space-between;align-items:center;padding:12px 0;border-bottom:1px solid var(--border-light)}
        .profile-field:last-child{border-bottom:none}
        .profile-label{font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted)}
        .profile-value{font-size:14px;font-weight:500;color:var(--text-dark)}
        .section-divider{display:flex;align-items:center;gap:10px;margin:20px 0 16px;font-size:13px;font-weight:700;color:var(--teal-dark)}.section-divider::after{content:'';flex:1;height:1px;background:var(--border)}
        .form-group{margin-bottom:14px}.form-group label{display:block;font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);margin-bottom:6px}
        .form-input{width:100%;padding:8px 12px;border:1px solid var(--border);border-radius:var(--radius-sm);font-size:13px;outline:none;transition:border-color .15s,box-shadow .15s;color:var(--text-dark)}.form-input:focus{border-color:var(--teal-mid);box-shadow:0 0 0 3px rgba(30,112,144,.1)}
        .btn{display:inline-flex;align-items:center;gap:6px;border-radius:var(--radius-sm);font-size:13px;font-weight:500;padding:8px 16px;transition:all .18s;border:none}.btn-primary{background:var(--teal-dark);color:#fff;box-shadow:0 2px 6px rgba(26,95,122,.25)}.btn-primary:hover{background:var(--teal-mid)}
        .alert{display:flex;align-items:center;gap:10px;padding:12px 16px;border-radius:var(--radius-sm);font-size:13px;font-weight:500;margin-bottom:18px}.alert-success{background:#d8f5ec;color:#0e7a54;border-left:3px solid var(--green-accent)}.alert-error{background:#fde8e8;color:#9e2b2b;border-left:3px solid #d64545}.alert-close{margin-left:auto;background:none;border:none;font-size:18px;color:inherit;opacity:.6;cursor:pointer}.alert-close:hover{opacity:1}
        @media(max-width:768px){.sidebar-toggle{display:flex}.sidebar{transform:translateX(-100%)}.sidebar.open{transform:translateX(0)}.sidebar-overlay.open{display:block}.main-content{margin-left:0}.content-wrapper{padding:20px 16px 32px}.profile-card{max-width:100%}}
    </style>
</head>
<body>
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-brand"><span class="brand-name">GesPed</span><span class="brand-role">Espace &Eacute;tudiant</span></div>
        <div class="sidebar-section"><div class="sidebar-section-label">Navigation</div>
            <a href="${pageContext.request.contextPath}/etudiant/dashboard" class="nav-item"><i class="fas fa-th-large"></i> Tableau de bord</a>
            <a href="${pageContext.request.contextPath}/etudiant/modules" class="nav-item"><i class="fas fa-book"></i> Mes modules</a>
            <a href="${pageContext.request.contextPath}/etudiant/ressources" class="nav-item"><i class="fas fa-folder-open"></i> Mes ressources</a>
        </div>
        <div class="sidebar-section"><div class="sidebar-section-label">Mon compte</div>
            <a href="${pageContext.request.contextPath}/etudiant/profil" class="nav-item active"><i class="fas fa-user-circle"></i> Mon profil</a>
        </div>
        <div class="sidebar-footer"><a href="${pageContext.request.contextPath}/logout" class="nav-item-logout"><i class="fas fa-sign-out-alt"></i> D&eacute;connexion</a></div>
    </aside>
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <div class="main-content">
        <header class="topbar">
            <div class="topbar-left"><button class="sidebar-toggle" id="sidebarToggle" aria-label="Menu"><i class="fas fa-bars"></i></button><span class="topbar-title">${pageTitle}</span></div>
            <div class="topbar-right"><div class="user-avatar">${nomComplet != null ? nomComplet.substring(0,1).toUpperCase() : 'E'}</div><div class="user-info"><span class="user-name">${nomComplet}</span><span class="user-role">&Eacute;tudiant</span></div></div>
        </header>

        <div class="content-wrapper">
            <c:if test="${not empty msgSuccess}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${msgSuccess}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>
            <c:if test="${not empty msgError}"><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${msgError}<button class="alert-close" onclick="this.parentElement.remove()">&times;</button></div></c:if>

            <div class="page-header"><h1>Mon profil</h1><p>Informations de votre compte</p></div>

            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-avatar-lg">${nomComplet != null ? nomComplet.substring(0,1).toUpperCase() : 'E'}</div>
                    <h2>${nomComplet}</h2>
                    <p>&Eacute;tudiant</p>
                </div>
                <div class="profile-body">
                    <div class="profile-field">
                        <span class="profile-label">Email</span>
                        <span class="profile-value">${email}</span>
                    </div>
                    <div class="profile-field">
                        <span class="profile-label">Fili&egrave;re</span>
                        <span class="profile-value">${utilisateur.filiere != null ? utilisateur.filiere.nomFiliere : 'Non assign&eacute;e'}</span>
                    </div>

                    <div class="section-divider">Changer le mot de passe</div>

                    <form method="post" action="${pageContext.request.contextPath}/etudiant/profil">
                        <div class="form-group">
                            <label>Nouveau mot de passe</label>
                            <input type="password" name="nouveauMdp" class="form-input" placeholder="Au moins 6 caractères" required>
                        </div>
                        <div class="form-group">
                            <label>Confirmer le mot de passe</label>
                            <input type="password" name="confirmMdp" class="form-input" placeholder="Retapez le mot de passe" required>
                        </div>
                        <button type="submit" class="btn btn-primary"><i class="fas fa-lock"></i> Mettre &agrave; jour</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script>const s=document.getElementById('sidebarToggle'),b=document.getElementById('sidebar'),o=document.getElementById('sidebarOverlay');if(s)s.addEventListener('click',function(){b.classList.toggle('open');o.classList.toggle('open')});if(o)o.addEventListener('click',function(){b.classList.remove('open');o.classList.remove('open')})</script>
</body>
</html>