<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Inscription — GesPed</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;600;700&family=Raleway:wght@700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css?v=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/responsive.css?v=1">
  <style>
    .form-box { max-width: 520px; }
    .form-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    @media (max-width: 500px) { .form-grid-2 { grid-template-columns: 1fr; } }
  </style>
</head>
<body>

  <header class="topbar">
    <div class="topbar-inner">
      <div class="logo-left">
        <a href="${pageContext.request.contextPath}/" title="Accueil">
          <img src="${pageContext.request.contextPath}/logofsm.jpg" alt="Université Moulay Ismail — Faculté des Sciences">
        </a>
      </div>
      <a href="${pageContext.request.contextPath}/" class="logo-right" title="GesPed">
        <div class="gesped-icon"><i class="fas fa-graduation-cap"></i></div>
        <div class="gesped-text">
          <strong>GesPed</strong>
          <small class="text-warning">Gestion Pédagogique</small>
        </div>
      </a>
    </div>
  </header>

  <div class="page-wrap">

    <div class="side-blue">
      <div class="deco-formulas">
        <div></div><div></div><div></div><div></div><div></div>
      </div>
      <div class="deco-num">G</div>
      <div class="blue-content">
        <div class="blue-avatar">
          <i class="fas fa-user-plus"></i>
        </div>
        <h2>Créer un<br>compte</h2>
        <div class="orange-bar"></div>
        <p>Inscrivez-vous pour accéder aux ressources pédagogiques.</p>
        <div class="blue-features">
          <div class="bf"><i class="fas fa-file-alt"></i><span>Cours PDF, vidéos, TD &amp; TP</span></div>
          <div class="bf"><i class="fas fa-search"></i><span>Recherche avancée par module</span></div>
          <div class="bf"><i class="fas fa-star"></i><span>Favoris et accès rapide</span></div>
          <div class="bf"><i class="fas fa-shield-alt"></i><span>Accès sécurisé par profil</span></div>
        </div>
      </div>
    </div>

    <div class="side-white">
      <div class="form-box">

        <div class="form-eyebrow">
          <i class="fas fa-university"></i> Faculté des Sciences
        </div>
        <h1 class="form-title">Inscription</h1>
        <p class="form-subtitle">Créez votre compte membre</p>

        <c:if test="${not empty success}">
          <div class="alert alert-ok">
            <i class="fas fa-check-circle"></i>
            <span>${success}</span>
          </div>
          <div class="form-links" style="margin-top:20px;text-align:center">
            <a href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt"></i> Se connecter</a>
          </div>
        </c:if>

        <c:if test="${empty success}">
          <c:if test="${not empty errors}">
            <div class="alert alert-err">
              <i class="fas fa-exclamation-circle"></i>
              <ul>
                <c:forEach var="err" items="${errors}">
                  <li>${err}</li>
                </c:forEach>
              </ul>
            </div>
          </c:if>

          <form action="${pageContext.request.contextPath}/register" method="post" autocomplete="on">

            <div class="form-grid-2">
              <div class="fgroup">
                <label class="flabel" for="nom"><i class="fas fa-user"></i>Nom</label>
                <div class="finput-wrap">
                  <input type="text" id="nom" name="nom" class="finput" placeholder="Votre nom" required
                         value="${utilisateur.nom}">
                </div>
              </div>
              <div class="fgroup">
                <label class="flabel" for="prenom"><i class="fas fa-user"></i>Prénom</label>
                <div class="finput-wrap">
                  <input type="text" id="prenom" name="prenom" class="finput" placeholder="Votre prénom" required
                         value="${utilisateur.prenom}">
                </div>
              </div>
            </div>

            <div class="fgroup">
              <label class="flabel" for="email"><i class="fas fa-envelope"></i>Adresse email</label>
              <div class="finput-wrap">
                <i class="fas fa-envelope finput-icon"></i>
                <input type="email" id="email" name="email" class="finput" placeholder="exemple@univ.ma"
                       autocomplete="email" required value="${utilisateur.email}">
              </div>
            </div>

            <div class="fgroup">
              <label class="flabel" for="motDePasse"><i class="fas fa-lock"></i>Mot de passe</label>
              <div class="finput-wrap">
                <i class="fas fa-lock finput-icon"></i>
                <input type="password" id="motDePasse" name="motDePasse" class="finput"
                       placeholder="Minimum 6 caractères" autocomplete="new-password" required minlength="6">
                <i class="fas fa-eye toggle-eye" id="eyeIcon" onclick="togglePwd()"></i>
              </div>
            </div>

            <div class="fgroup">
              <label class="flabel" for="telephone"><i class="fas fa-phone"></i>Téléphone</label>
              <div class="finput-wrap">
                <i class="fas fa-phone finput-icon"></i>
                <input type="tel" id="telephone" name="telephone" class="finput" placeholder="0600000000"
                       value="${utilisateur.telephone}">
              </div>
            </div>

            <div class="fgroup" id="cneGroup" style="display:none">
              <label class="flabel" for="cne"><i class="fas fa-id-card"></i>CNE</label>
              <div class="finput-wrap">
                <i class="fas fa-id-card finput-icon"></i>
                <input type="text" id="cne" name="cne" class="finput" placeholder="Ex: E123456789"
                       value="${utilisateur.cne}">
              </div>
            </div>

            <div class="fgroup">
              <label class="flabel" for="role"><i class="fas fa-user-tag"></i>Vous êtes</label>
              <div class="finput-wrap">
                <select id="role" name="role" class="finput" required onchange="toggleRoleFields()">
                  <option value="">-- Sélectionner --</option>
                  <option value="ETUDIANT" ${utilisateur.role.nomRole == 'ETUDIANT' ? 'selected' : ''}>Étudiant</option>
                  <option value="PROFESSEUR" ${utilisateur.role.nomRole == 'PROFESSEUR' ? 'selected' : ''}>Professeur</option>
                </select>
              </div>
            </div>

            <div class="fgroup" id="filiereGroup" style="display:none">
              <label class="flabel" for="idFiliere"><i class="fas fa-graduation-cap"></i>Filière</label>
              <div class="finput-wrap">
                <select id="idFiliere" name="idFiliere" class="finput">
                  <option value="">-- Sélectionner --</option>
                  <c:forEach var="f" items="${filieres}">
                    <option value="${f.idFiliere}"
                      ${utilisateur.filiere != null && utilisateur.filiere.idFiliere == f.idFiliere ? 'selected' : ''}>
                      ${f.nomFiliere}
                    </option>
                  </c:forEach>
                </select>
              </div>
            </div>

            <div class="fgroup" id="semestreGroup" style="display:none">
              <label class="flabel" for="idSemestre"><i class="fas fa-calendar-alt"></i>Semestre</label>
              <div class="finput-wrap">
                <select id="idSemestre" name="idSemestre" class="finput">
                  <option value="">-- Sélectionner --</option>
                  <c:forEach var="s" items="${semestres}">
                    <option value="${s.idSemestre}"
                      ${utilisateur.semestre != null && utilisateur.semestre.idSemestre == s.idSemestre ? 'selected' : ''}>
                      ${s.nomSemestre}
                    </option>
                  </c:forEach>
                </select>
              </div>
            </div>

            <button type="submit" class="btn-submit">
              <i class="fas fa-user-plus"></i>
              Créer mon compte
            </button>

          </form>

          <div class="divider">ou</div>

          <div class="form-links">
            <a href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt"></i> Déjà un compte ? Connectez-vous</a>
            <span class="dot">·</span>
            <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Accueil</a>
          </div>
        </c:if>

        <div class="secure">
          <i class="fas fa-lock"></i>
          Connexion chiffrée — Université Moulay Ismail
        </div>

      </div>
    </div>

  </div>

  <footer class="foot">
    &copy; 2025 GesPed &mdash;
    <a href="https://fs-umi.ac.ma" target="_blank">Faculté des Sciences</a>
    &mdash; Université Moulay Ismail, Meknès
  </footer>

  <script>
    function togglePwd() {
      var inp = document.getElementById('motDePasse');
      var icon = document.getElementById('eyeIcon');
      if (inp.type === 'password') {
        inp.type = 'text';
        icon.classList.replace('fa-eye', 'fa-eye-slash');
      } else {
        inp.type = 'password';
        icon.classList.replace('fa-eye-slash', 'fa-eye');
      }
    }
    function toggleRoleFields() {
      var role = document.getElementById('role').value;
      var fg = document.getElementById('filiereGroup');
      var sg = document.getElementById('semestreGroup');
      var cg = document.getElementById('cneGroup');
      if (role === 'ETUDIANT') {
        fg.style.display = '';
        sg.style.display = '';
        cg.style.display = '';
      } else {
        fg.style.display = 'none';
        sg.style.display = 'none';
        cg.style.display = 'none';
      }
    }
    toggleRoleFields();
  </script>

</body>
</html>