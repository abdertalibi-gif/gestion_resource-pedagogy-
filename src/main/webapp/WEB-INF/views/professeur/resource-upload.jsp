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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/responsive.css?v=1">
</head>
<body class="app-layout">
    <%@ include file="/WEB-INF/includes/sidebar.jsp" %>

    <div class="main-content">
        <%@ include file="/WEB-INF/includes/topbar.jsp" %>

        <div class="content-wrapper">

            <!-- ★ Banner bienvenue ★ -->
            <div class="welcome-banner">
                <div class="welcome-text">
                    <h2>Bienvenue, ${nomComplet} !</h2>
                    <p>Déposez une nouvelle ressource pédagogique.</p>
                </div>
                <i class="fas fa-upload welcome-icon"></i>
            </div>

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
    <option value="">-- Sélectionner un type --</option>

    <option value="1">PDF</option>
    <option value="20">Excel</option>
    <option value="5">PowerPoint</option>
    <option value="2">Vidéo</option>
    <option value="19">ZIP</option>
    <option value="3">TD</option>
    <option value="4">TP</option>
</select>
                            <div class="field-error" id="typeError">Veuillez s&eacute;lectionner un type.</div>
                        </div>

                        <!-- Fichier -->
                        <div class="form-group full-width">
                            <label>Fichier <span class="required">*</span></label>
                            <div class="file-upload-zone" id="dropZone" onclick="document.getElementById('fichier').click()">
                                <input type="file" id="fichier" name="fichier"
                                       accept=".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.mp4,.webm,.zip,.rar,.png,.jpg,.jpeg"
                                       class="hidden" onchange="updateFileName(this)">
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

    <script>
        /* Sidebar toggle */
        var sidebarToggle=document.getElementById('sidebarToggle'),
            sidebar=document.getElementById('sidebar'),
            overlay=document.getElementById('sidebarOverlay');
        if(sidebarToggle)sidebarToggle.addEventListener('click',function(){sidebar.classList.toggle('open');overlay.classList.toggle('open')});
        if(overlay)overlay.addEventListener('click',function(){sidebar.classList.remove('open');overlay.classList.remove('open')});

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