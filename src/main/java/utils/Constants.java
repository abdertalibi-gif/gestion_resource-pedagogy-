package utils;


public final class Constants {

    private Constants() {}

    // Roles
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_PROFESSEUR = "PROFESSEUR";
    public static final String ROLE_ETUDIANT = "ETUDIANT";

    // Sessions
    public static final String SESSION_USER = "utilisateur";
    public static final String SESSION_ROLE = "role";

    // Messages
    public static final String MSG_SUCCESS = "success";
    public static final String MSG_ERROR = "error";
    public static final String MSG_WARNING = "warning";

    // Upload
    public static final long MAX_FILE_SIZE = 50 * 1024 * 1024; // 50 Mo
    public static final String UPLOAD_DIR = "/assets/uploads/";

    // Pages
    public static final String VIEW_LOGIN = "/login.jsp";
    public static final String VIEW_FORGOT = "/WEB-INF/views/auth/forgot-password.jsp";
    public static final String VIEW_HOME = "/index.jsp";
  

    public static final String VIEW_ADMIN_DASHBOARD = "/WEB-INF/views/admin/dashboard.jsp";
    public static final String VIEW_ADMIN_UTILISATEURS = "/WEB-INF/views/admin/utilisateurs-list.jsp";
    public static final String VIEW_ADMIN_UTILISATEUR_FORM = "/WEB-INF/views/admin/utilisateur-form.jsp";
    public static final String VIEW_ADMIN_MODULES = "/WEB-INF/views/admin/modules-list.jsp";
    public static final String VIEW_ADMIN_MODULE_FORM = "/WEB-INF/views/admin/module-form.jsp";
    public static final String VIEW_ADMIN_FILIERES = "/WEB-INF/views/admin/filieres-list.jsp";
    public static final String VIEW_ADMIN_FILIERE_FORM = "/WEB-INF/views/admin/filiere-form.jsp";
    public static final String VIEW_ADMIN_SEMESTRES = "/WEB-INF/views/admin/semestres-list.jsp";
    public static final String VIEW_ADMIN_SEMESTRE_FORM = "/WEB-INF/views/admin/semestre-form.jsp";
    public static final String VIEW_ADMIN_AFFECTATIONS = "/WEB-INF/views/admin/affectations-list.jsp";
    public static final String VIEW_ADMIN_AFFECTATION_FORM = "/WEB-INF/views/admin/affectation-form.jsp";
    public static final String VIEW_ADMIN_RESSOURCES = "/WEB-INF/views/admin/ressources-list.jsp";
    public static final String VIEW_ADMIN_STATS = "/WEB-INF/views/admin/statistiques.jsp";
    public static final String VIEW_ADMIN_ETUDIANTS = "/WEB-INF/views/admin/etudiants.jsp";
    public static final String VIEW_ADMIN_PROFESSEURS = "/WEB-INF/views/admin/professeurs.jsp";
    public static final String VIEW_ETU_PROFIL = "/WEB-INF/views/etudiant/profil.jsp";

    public static final String VIEW_PROF_DASHBOARD = "/WEB-INF/views/professeur/dashboard.jsp";
    public static final String VIEW_PROF_MODULES = "/WEB-INF/views/professeur/modules.jsp";
    public static final String VIEW_PROF_RESSOURCES = "/WEB-INF/views/professeur/resources-list.jsp";
    public static final String VIEW_PROF_UPLOAD = "/WEB-INF/views/professeur/resource-upload.jsp";
    public static final String VIEW_PROF_EDIT_RESSOURCE = "/WEB-INF/views/professeur/ressource-edit.jsp";
    public static final String VIEW_PROF_STATS = "/WEB-INF/views/professeur/statistiques.jsp";
    public static final String VIEW_PROF_AMIS = "/WEB-INF/views/professeur/amis.jsp";

    public static final String VIEW_ETU_DASHBOARD = "/WEB-INF/views/etudiant/dashboard.jsp";
    public static final String VIEW_ETU_MODULES = "/WEB-INF/views/etudiant/modules.jsp";
    public static final String VIEW_ETU_RESSOURCES = "/WEB-INF/views/etudiant/ressources-list.jsp";
    public static final String VIEW_ETU_RESSOURCE_VIEW = "/WEB-INF/views/etudiant/ressource-view.jsp";
    public static final String VIEW_ETU_RECHERCHE = "/WEB-INF/views/etudiant/recherche.jsp";
    public static final String VIEW_ETU_FAVORIS = "/WEB-INF/views/etudiant/favoris.jsp";
    public static final String VIEW_ETU_HISTORIQUE = "/WEB-INF/views/etudiant/historique.jsp";

    public static final String VIEW_403 = "/WEB-INF/views/error/403.jsp";
    public static final String VIEW_404 = "/WEB-INF/views/error/404.jsp";
    public static final String VIEW_500 = "/WEB-INF/views/error/500.jsp";

    
 // Ajouter ces lignes dans votre fichier Constants.java existant :

 // Dashboard views
 public static final String VIEW_ETUDIANT_DASHBOARD  = "/WEB-INF/views/etudiant/dashboard.jsp";
 public static final String VIEW_PROFESSEUR_DASHBOARD = "/WEB-INF/views/professeur/dashboard.jsp";

 // Messages flash
 public static final String FLASH_SUCCESS = "msgSuccess";
 public static final String FLASH_ERROR   = "msgError";
    // Types MIME autorises
    public static final String[] ALLOWED_TYPES = {
        "application/pdf",
        "video/mp4", "video/webm",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "application/vnd.openxmlformats-officedocument.presentationml.presentation",
        "application/zip", "application/x-zip-compressed",
        "image/png", "image/jpeg", "image/jpg"
    };
}