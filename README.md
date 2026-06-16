# projet_jee
LINALINA/
│
├── pom.xml
├── README.md
├── .base-donne
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   │
│   │   │   ├── dao/
│   │   │   │   ├── AffectationDAO.java
│   │   │   │   ├── DAOFactory.java
│   │   │   │   ├── DevoirDAO.java
│   │   │   │   ├── FavoriDAO.java
│   │   │   │   ├── FiliereDAO.java
│   │   │   │   ├── HistoriqueDAO.java
│   │   │   │   ├── ModuleDAO.java
│   │   │   │   ├── ResetTokenDAO.java
│   │   │   │   ├── RessourceDAO.java
│   │   │   │   ├── SemestreDAO.java
│   │   │   │   ├── SoumissionDAO.java
│   │   │   │   ├── TypeRessourceDAO.java
│   │   │   │   └── UtilisateurDAO.java
│   │   │   │
│   │   │   ├── Filtres/
│   │   │   │   ├── AuthFilter.java
│   │   │   │   ├── EncodingFilter.java
│   │   │   │   └── RoleFilter.java
│   │   │   │
│   │   │   ├── ma/gesped/controllers/
│   │   │   │   ├── AdminServlet.java
│   │   │   │   ├── AuthServlet.java
│   │   │   │   ├── EtudiantServlet.java
│   │   │   │   ├── ForgotPasswordServlet.java
│   │   │   │   ├── HomeServlet.java
│   │   │   │   ├── LogoutServlet.java
│   │   │   │   ├── ProfesseurServlet.java
│   │   │   │   ├── RegisterServlet.java
│   │   │   │   ├── ResetPasswordServlet.java
│   │   │   │   ├── SupprimerEtudiantServlet.java
│   │   │   │   └── SupprimerProfesseurServlet.java
│   │   │   │
│   │   │   ├── models/
│   │   │   │   ├── AffectationModule.java
│   │   │   │   ├── Devoir.java
│   │   │   │   ├── Favori.java
│   │   │   │   ├── Filiere.java
│   │   │   │   ├── HistoriqueConsultation.java
│   │   │   │   ├── Module.java
│   │   │   │   ├── ResetToken.java
│   │   │   │   ├── Ressource.java
│   │   │   │   ├── Role.java
│   │   │   │   ├── Semestre.java
│   │   │   │   ├── Soumission.java
│   │   │   │   ├── TypeRessource.java
│   │   │   │   └── Utilisateur.java
│   │   │   │
│   │   │   ├── Services/
│   │   │   │   ├── AffectationService.java
│   │   │   │   ├── AuthService.java
│   │   │   │   ├── DevoirService.java
│   │   │   │   ├── EmailService.java
│   │   │   │   ├── FavoriService.java
│   │   │   │   ├── FiliereService.java
│   │   │   │   ├── HistoriqueService.java
│   │   │   │   ├── ModuleService.java
│   │   │   │   ├── RessourceService.java
│   │   │   │   ├── SemestreService.java
│   │   │   │   ├── ServiceResult.java
│   │   │   │   ├── SoumissionService.java
│   │   │   │   ├── TypeRessourceService.java
│   │   │   │   └── UtilisateurService.java
│   │   │   │
│   │   │   └── utils/
│   │   │       ├── Constants.java
│   │   │       ├── DatabaseConnection.java
│   │   │       ├── DateUtil.java
│   │   │       ├── FileUploadUtil.java
│   │   │       ├── PasswordUtil.java
│   │   │       └── ValidationUtil.java
│   │   │
│   │   │           
│   │   │
│   │   └── webapp/
│   │       ├── index.jsp
│   │       ├── login.jsp
│   │       ├── reset-password.jsp
│   │       ├── logofsm.jpg
│   │       │
│   │       ├── assets/
│   │       │   ├── css/
│   │       │   │   ├── components.css
│   │       │   │   ├── dashboard.css
│   │       │   │   ├── responsive.css
│   │       │   │   └── style.css
│   │       │   ├── js/
│   │       │   │   ├── dashboard.js
│   │       │   │   └── main.js
│   │       │   └── uploads/
│   │       │       ├── documents/   
│   │       │       ├── images/     
│   │       │       ├── pdf/         
│   │       │       └── videos/     
│   │       │
│   │       ├── META-INF/
│   │       │   └── MANIFEST.MF
│   │       │
│   │       └── WEB-INF/
│   │           ├── web.xml
│   │           ├── upload.js
│   │           ├── lib/
│   │           │   └── jakarta.mail-2.0.1.jar
│   │           ├── includes/
│   │           │   ├── sidebar.jsp
│   │           │   └── topbar.jsp
│   │           └── views/
│   │               ├── auth/
│   │               │   ├── forgot-password.jsp
│   │               │  
│   │               ├── error/
│   │               │   ├── 403.jsp
│   │               │   ├── 404.jsp
│   │               │   └── 500.jsp
│   │               ├── admin/
│   │               │   ├── dashboard.jsp
|	|				|	|___import.jsp		
│   │               │   ├── utilisateur-form.jsp
│   │               │   ├── utilisateurs-list.jsp
│   │               │   ├── etudiants.jsp
│   │               │   ├── etudiant-ajouter.jsp
│   │               │   ├── professeurs.jsp
│   │               │   ├── modules-list.jsp
│   │               │   ├── module-form.jsp
│   │               │   ├── filieres-list.jsp
│   │               │   ├── filiere-form.jsp
│   │               │   ├── filiere-voir.jsp
│   │               │   ├── semestres-list.jsp
│   │               │   ├── semestre-form.jsp
│   │               │   ├── affectations-list.jsp
│   │               │   ├── affectation-form.jsp
│   │               │   ├── ressources-list.jsp
│   │               │   ├── demandes.jsp
│   │               │   └── statistiques.jsp
│   │               ├── professeur/
│   │               │   ├── dashboard.jsp
│   │               │   ├── modules.jsp
│   │               │   ├── resources-list.jsp
│   │               │   ├── resource-upload.jsp
│   │               │   ├── ressource-edit.jsp
│   │               │   ├── devoirs-list.jsp
│   │               │   ├── devoir-form.jsp
│   │               │   ├── devoir-detail.jsp
│   │               │   ├── soumissions.jsp
│   │               │   ├── soumission-detail.jsp
│   │               │   └── statistiques.jsp
│   │               └── etudiant/
│   │                   ├── dashboard.jsp
│   │                   ├── modules.jsp
│   │                   ├── ressources.jsp
│   │                   ├── ressources-list.jsp
│   │                   ├── ressource-view.jsp
│   │                   ├── recherche.jsp
│   │                   ├── favoris.jsp
│   │                   ├── historique.jsp
│   │                   ├── mes-devoirs.jsp
│   │                   ├── soumettre.jsp
│   │                   ├── mes-soumissions.jsp
│   │                   └── profil.jsp
│   │
