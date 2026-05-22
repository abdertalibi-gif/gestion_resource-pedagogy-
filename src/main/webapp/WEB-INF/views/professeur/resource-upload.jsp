<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="models.Utilisateur" %>
<%
    request.setAttribute("role", "PROFESSEUR");
    request.setAttribute("nomComplet", ((Utilisateur) session.getAttribute("utilisateur")).getNomComplet());
    request.setAttribute("pageTitle", "D\u00e9poser une ressource");
    request.setAttribute("activeMenu", "upload");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>D\u00e9poser une ressource — GesPed</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Raleway:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --sidebar-bg:#1a5f7a;--sidebar-hover:rgba(255,255,255,.08);--sidebar-active:rgba(255,255,255,.14);
            --sidebar-text:#b8d8e5;--sidebar-dim:#6fa3bb;--sidebar-width:230px;
            --topbar-bg:#fff;--topbar-height:56px;--topbar-border:#dde6ec;
            --orange:#e8a020;--teal-dark:#1a5f7a;--teal-mid:#1e7090;--teal-light:#e8f4f8;
            --green-accent:#1ab98a;--blue-accent:#2a6b9e;--blue-mid:#2d99b8;
            --page-bg:#f2f4f6;--white:#fff;--text-dark:#1c3d4f;--text-muted:#7a9aaa;
            --border:#dde6ec;--border-light:#eaf0f4;
            --radius-sm:6px;--radius-md:10px;--radius-lg:14px;
            --danger:#d64545;
        }
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Open Sans',sans-serif;font-size:14px;color:var(--text-dark);background:var(--page-bg);display:flex;min-height:100vh}
        a{text-decoration:none;color:inherit}button{font-family:inherit;cursor:pointer}input,select,textarea{font-family:inherit}

        /* ---- SIDEBAR ---- */
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

        /* ---- TOPBAR ---- */
        .main-content{margin-left:var(--sidebar-width);flex:1;display:flex;flex-direction:column;min-height:100vh}
        .topbar{position:sticky;top:0;z-index:90;background:var(--topbar-bg);border-bottom:1px solid var(--topbar-border);height:var(--topbar-height);display:flex;align-items:center;justify-content:space-between;padding:0 24px}
        .topbar::after{content:'';position:absolute;bottom:0;left:0;right:0;height:2px;background:linear-gradient(90deg,var(--teal-dark),var(--orange))}
        .topbar-left{display:flex;align-items:center;gap:10px}
        .topbar-title{font-size:15px;font-weight:600;color:var(--text-dark)}
        .topbar-right{display:flex;align-items:center;gap:16px}
        .topbar-icon-btn{background:none;border:none;color:var(--text-muted);font-size:17px;display:flex;align-items:center;position:relative;transition:color .15s}
        .topbar-icon-btn:hover{color:var(--teal-dark)}
        .notif-badge{position:absolute;top:-4px;right:-5px;width:16px;height:16px;border-radius:50%;background:var(--orange);color:#fff;font-size:9px;display:flex;align-items:center;justify-content:center;font-weight:700}
        .user-avatar{width:34px;height:34px;border-radius:50%;background:var(--orange);color:#fff;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:600;cursor:pointer}
        .user-info{display:flex;flex-direction:column;align-items:flex-start}
        .user-info .user-name{font-size:13px;font-weight:600;color:var(--text-dark)}
        .user-info .user-role{font-size:11px;color:var(--text-muted)}

        /* ---- CONTENT ---- */
        .content-wrapper{padding:28px 28px 40px;flex:1}
        .page-header{margin-bottom:24px}
        .page-header h1{font-family:'Raleway',sans-serif;font-size:26px;font-weight:800;color:var(--teal-dark)}
        .page-header p{font-size:13px;color:var(--text-muted);margin-top:4px}

        /* ---- BREADCRUMB ---- */
        .breadcrumb{display:flex;align-items:center;gap:8px;margin-bottom:20px;font-size:12px}
        .breadcrumb a{color:var(--teal-mid);transition:color .15s}
        .breadcrumb a:hover{color:var(--teal-dark)}
        .breadcrumb .sep{color:var(--text-muted);font-size:9px}
        .breadcrumb .current{color:var(--text-dark);font-weight:500}

        /* ---- FORM CARD ---- */
        .form-card{background:var(--white);border:1px solid var(--border);border-radius:var(--radius-lg);overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,.04);max-width:680px}
        .form-card-header{padding:16px 20px;border-bottom:1px solid var(--border-light);background:#fafbfc;display:flex;align-items:center;justify-content:space-between}
        .form-card-header h3{font-size:14px;font-weight:700;color:var(--text-dark);display:flex;align-items:center;gap:8px}
        .form-card-header h3 i{color:var(--teal-mid);font-size:15px}
        .form-card-body{padding:24px 20px}

        /* ---- FORM GRID ---- */
        .form-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px}

        /* ---- FORM ELEMENTS ---- */
        .form-group{display:flex;flex-direction:column}
        .form-group.full-width{grid-column:1/-1}
        .form-group label{display:block;font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:.05em;color:var(--text-muted);margin-bottom:6px}
        .form-group .required{color:var(--danger);margin-left:2px}
        .form-input,.form-select,.form-textarea{width:100%;padding:9px 12px;border:1px solid var(--border);border-radius:var(--radius-sm);font-size:13px;outline:none;transition:border-color .15s,box-shadow .15s;color:var(--text-dark);background:var(--white)}
        .form-input:focus,.form-select:focus,.form-textarea:focus{border-color:var(--teal-mid);box-shadow:0 0 0 3px rgba(30,112,144,.1)}
        .form-textarea{min-height:90px;resize:vertical}

        /* ---- FILE UPLOAD ---- */
        .file-upload-zone{border:2px dashed var(--border);border-radius:var(--radius-md);padding:32px;text-align:center;transition:border-color .15s,background .15s;cursor:pointer}
        .file-upload-zone:hover,.file-upload-zone.dragover{border-color:var(--teal-mid);background:var(--teal-light)}
        .file-upload-zone i{font-size:32px;color:var(--teal-mid);margin-bottom:8px;display:block}
        .file-upload-zone p{font-size:13px;color:var(--text-dark);font-weight:500;margin-bottom:4px}
        .file-upload-zone small{font-size:11px;color:var(--text-muted)}
        .file-upload-zone .file-selected{color:var(--teal-dark);font-weight:600}

        /* ---- FORM ERRORS ---- */
        .field-error{font-size:11px;color:var(--danger);margin-top:4px;display:none}
        .field-error.show{display:block}
        .form-input.error,.form-select.error{border-color:var(--danger);box-shadow:0 0 0 3px rgba(214,69,69,.1)}

        /* ---- FORM ACTIONS ---- */
        .form-actions{grid-column:1/-1;display:flex;gap:10px;margin-top:8px;padding-top:18px;border-top:1px solid var(--border-light)}

        /* ---- BUTTONS ---- */
        .btn{display:inline-flex;align-items:center;gap:6px;border-radius:var(--radius-sm);font-size:13px;font-weight:500;padding:8px 16px;transition:all .18s;border:none;white-space:nowrap}
        .btn-sm{padding:5px 12px;font-size:12px}
        .btn-primary{background:var(--teal-dark);color:#fff;box-shadow:0 2px 6px rgba(26,95,122,.25)}
        .btn-primary:hover{background:var(--teal-mid);transform:translateY(-1px);box-shadow:0 4px 12px rgba(26,95,122,.3)}
        .btn-primary:active{transform:translateY(0)}
        .btn-secondary{background:var(--page-bg);color:var(--text-dark);border:1px solid var(--border)}
        .btn-secondary:hover{background:var(--border-light)}
        .btn-outline{background:none;border:1px solid var(--border);color:var(--teal-mid)}
        .btn-outline:hover{background:var(--teal-light);border-color:var(--teal-mid);color:var(--teal-dark)}
        .btn:disabled{opacity:.5;cursor:not-allowed;transform:none!important}

        /* ---- ALERTS ---- */
        .alert{display:flex;align-items:center;gap:10px;padding:12px 16px;border-radius:var(--radius-sm);font-size:13px;font-weight:500;margin-bottom:18px;position:relative;animation:alertSlide .3s ease}
        @keyframes alertSlide{from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:translateY(0)}}
        .alert-success{background:#d8f5ec;color:#0e7a54;border-left:3px solid var(--green-accent)}
        .alert-error{background:#fde8e8;color:#9e2b2b;border-left:3px solid var(--danger)}
        .alert-close{margin-left:auto;background:none;border:none;font-size:18px;color:inherit;opacity:.6;cursor:pointer}
        .alert-close:hover{opacity:1}

        /* ---- RESPONSIVE ---- */
        @media(max-width:768px){
            .sidebar-toggle{display:flex}.sidebar{transform:translateX(-100%)}.sidebar.open{transform:translateX(0)}.sidebar-overlay.open{display:block}
            .main-content{margin-left:0}.content-wrapper{padding:20px 16px 32px}
            .form-grid{grid-template-columns:1fr}.form-card{max-width:100%}
            .form-actions{flex-direction:column}
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/includes/sidebar.jsp" %>

    <div class="main-content">
        <%@ include file="/WEB-INF/includes/topbar.jsp" %>

        <div class="content-wrapper">

            <!-- Alerts -->
            <c:if test="${not empty msgError}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${msgError}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>
            <c:if test="${not empty msgSuccess}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${msgSuccess}
                    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>

            <div class="page-header">
                <h1>D&eacute;poser une ressource</h1>
                <p>Ajoutez un nouveau fichier p&eacute;dagogique</p>
            </div>

            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/professeur/dashboard">Tableau de bord</a>
                <span class="sep"><i class="fas fa-chevron-right"></i></span>
                <a href="${pageContext.request.contextPath}/professeur/ressources">Ressources</a>
                <span class="sep"><i class="fas fa-chevron-right"></i></span>
                <span class="current">D&eacute;poser</span>
            </div>

            <div class="form-card">
                <div class="form-card-header">
                    <h3><i class="fas fa-cloud-upload-alt"></i> Informations de la ressource</h3>
                    <a href="${pageContext.request.contextPath}/professeur/ressources" class="btn btn-sm btn-outline">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                </div>
                <div class="form-card-body">
                    <form method="post" action="${pageContext.request.contextPath}/professeur/ressource/ajouter"
                          enctype="multipart/form-data" class="form-grid" id="uploadForm" novalidate>

                        <!-- Titre -->
                        <div class="form-group full-width">
                            <label for="titre">Titre <span class="required">*</span></label>
                            <input type="text" id="titre" name="titre" class="form-input"
                                   value="${titre != null ? titre : ''}"
                                   placeholder="Ex: Cours Introduction Java">
                            <div class="field-error" id="titreError">Veuillez saisir un titre.</div>
                        </div>

                        <!-- Description -->
                        <div class="form-group full-width">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" class="form-textarea"
                                      placeholder="Description optionnelle de la ressource...">${description != null ? description : ''}</textarea>
                        </div>

					                        <!-- Module -->
					<div class="form-group">
					    <label for="moduleId">Module <span class="required">*</span></label>
					    <select id="moduleId" name="moduleId" class="form-select">
					        <option value="">-- S\u00e9lectionner un module --</option>
					        <c:forEach var="m" items="${modules}">
					            <option value="${m.idModule}">${m.codeModule} — ${m.nomModule}</option>
					        </c:forEach>
					    </select>
					    <div class="field-error" id="moduleError">Veuillez s\u00e9lectionner un module.</div>
					    <c:if test="${empty modules}">
					        <small style="color:var(--danger);margin-top:4px;display:block">Aucun module disponible. Contactez l'administrateur.</small>
					    </c:if>
					</div>

                        <!-- Type -->
                        <div class="form-group">
                            <label for="typeId">Type <span class="required">*</span></label>
                            <select id="typeId" name="typeId" class="form-select">
                                <option value="">-- S&eacute;lectionner un type --</option>
                                <option value="1" ${param.typeId == '1' ? 'selected' : ''}>PDF</option>
                                <option value="2" ${param.typeId == '2' ? 'selected' : ''}>Word</option>
                                <option value="3" ${param.typeId == '3' ? 'selected' : ''}>PowerPoint</option>
                                <option value="4" ${param.typeId == '4' ? 'selected' : ''}>Excel</option>
                                <option value="5" ${param.typeId == '5' ? 'selected' : ''}>Vid&eacute;o</option>
                                <option value="6" ${param.typeId == '6' ? 'selected' : ''}>ZIP</option>
                                <option value="7" ${param.typeId == '7' ? 'selected' : ''}>Image</option>
                            </select>
                            <div class="field-error" id="typeError">Veuillez s&eacute;lectionner un type.</div>
                        </div>

                        <!-- Fichier -->
                        <div class="form-group full-width">
                            <label>Fichier <span class="required">*</span></label>
                            <div class="file-upload-zone" id="dropZone" onclick="document.getElementById('fichier').click()">
                                <input type="file" id="fichier" name="fichier"
                                       accept=".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.mp4,.webm,.zip,.rar,.png,.jpg,.jpeg"
                                       style="display:none" onchange="updateFileName(this)">
                                <i class="fas fa-cloud-upload-alt" id="uploadIcon"></i>
                                <p id="fileLabel">Cliquez ou glissez-d&eacute;posez votre fichier ici</p>
                                <small>PDF, Word, PowerPoint, Excel, Vid&eacute;o, ZIP, Images — Max 50 Mo</small>
                            </div>
                            <div class="field-error" id="fileError">Veuillez s&eacute;lectionner un fichier.</div>
                        </div>

                        <!-- Actions -->
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                <i class="fas fa-upload"></i> D&eacute;poser
                            </button>
                            <a href="${pageContext.request.contextPath}/professeur/ressources" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Annuler
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script>
        /* Afficher nom du fichier sélectionné */
        function updateFileName(input){
            var file=input.files[0];
            var label=document.getElementById('fileLabel');
            var icon=document.getElementById('uploadIcon');
            if(file){
                label.textContent=file.name;
                label.classList.add('file-selected');
                icon.className='fas fa-file-check';
                document.getElementById('fileError').classList.remove('show');
                document.getElementById('fichier').classList.remove('error');
            } else {
                label.textContent='Cliquez ou glissez-d\u00e9posez votre fichier ici';
                label.classList.remove('file-selected');
                icon.className='fas fa-cloud-upload-alt';
            }
        }

        /* Drag & drop */
        var dropZone=document.getElementById('dropZone');
        ['dragenter','dragover'].forEach(function(e){
            dropZone.addEventListener(e,function(ev){ev.preventDefault();dropZone.classList.add('dragover')})
        });
        ['dragleave','drop'].forEach(function(e){
            dropZone.addEventListener(e,function(ev){ev.preventDefault();dropZone.classList.remove('dragover')})
        });
        dropZone.addEventListener('drop',function(ev){
            var file=ev.dataTransfer.files[0];
            if(file){
                document.getElementById('fichier').files=ev.dataTransfer.files;
                updateFileName(document.getElementById('fichier'));
            }
        });

        /* Validation côté client avant envoi */
        document.getElementById('uploadForm').addEventListener('submit',function(ev){
            var valid=true;
            var titre=document.getElementById('titre');
            var moduleId=document.getElementById('moduleId');
            var typeId=document.getElementById('typeId');
            var fichier=document.getElementById('fichier');

            // Titre
            if(!titre.value.trim()){
                titre.classList.add('error');
                document.getElementById('titreError').classList.add('show');
                valid=false;
            } else {
                titre.classList.remove('error');
                document.getElementById('titreError').classList.remove('show');
            }

            // Module
            if(!moduleId.value){
                moduleId.classList.add('error');
                document.getElementById('moduleError').classList.add('show');
                valid=false;
            } else {
                moduleId.classList.remove('error');
                document.getElementById('moduleError').classList.remove('show');
            }

            // Type
            if(!typeId.value){
                typeId.classList.add('error');
                document.getElementById('typeError').classList.add('show');
                valid=false;
            } else {
                typeId.classList.remove('error');
                document.getElementById('typeError').classList.remove('show');
            }

            // Fichier
            if(!fichier.files || fichier.files.length===0 || fichier.files[0].size===0){
                document.getElementById('fileError').classList.add('show');
                valid=false;
            } else if(fichier.files[0].size > 50*1024*1024){
                document.getElementById('fileError').textContent='Le fichier d\u00e9passe 50 Mo.';
                document.getElementById('fileError').classList.add('show');
                valid=false;
            } else {
                document.getElementById('fileError').classList.remove('show');
            }

            if(!valid) ev.preventDefault();
        });

        /* Enlever erreur au focus */
        ['titre','moduleId','typeId'].forEach(function(id){
            document.getElementById(id).addEventListener('focus',function(){
                this.classList.remove('error');
                var errId=id.replace('Id','Error').replace('moduleId','moduleError').replace('typeId','typeError');
                var err=document.getElementById(errId);
                if(err) err.classList.remove('show');
            });
        });
    </script>
</body>
</html>