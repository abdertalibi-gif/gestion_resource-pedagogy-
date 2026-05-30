package utils;

public final class Constants {

    private Constants() {}

    // ==================== STATUTS COMPTE ====================
    public static final String STATUT_EN_ATTENTE = "EN_ATTENTE";
    public static final String STATUT_ACCEPTE = "ACCEPTE";
    public static final String STATUT_REFUSE = "REFUSE";

    // ==================== ROLES ====================
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_PROFESSEUR = "PROFESSEUR";
    public static final String ROLE_ETUDIANT = "ETUDIANT";

    // ==================== SESSIONS ====================
    public static final String SESSION_USER = "utilisateur";
    public static final String SESSION_ROLE = "role";

    // ==================== MESSAGES FLASH ====================
    public static final String FLASH_SUCCESS = "msgSuccess";
    public static final String FLASH_ERROR = "msgError";
    public static final String MSG_SUCCESS = "success";
    public static final String MSG_ERROR = "error";
    public static final String MSG_WARNING = "warning";

    // ==================== UPLOAD ====================
    public static final long MAX_FILE_SIZE = 50 * 1024 * 1024; // 50 Mo
    public static final String UPLOAD_DIR = "/assets/uploads/";
    public static final String[] ALLOWED_TYPES = {
        "application/pdf",
        "video/mp4", "video/webm",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "application/vnd.openxmlformats-officedocument.presentationml.presentation",
        "application/zip", "application/x-zip-compressed",
        "image/png", "image/jpeg", "image/jpg"
    };

    // ==================== VUES PUBLIQUES ====================
    public static final String VIEW_LOGIN = "/login.jsp";
    public static final String VIEW_FORGOT = "/WEB-INF/views/auth/forgot-password.jsp";
    public static final String VIEW_HOME = "/index.jsp";

    // ==================== VUES ADMIN ====================
    public static final String VIEW_ADMIN_DASHBOARD = "/WEB-INF/views/admin/dashboard.jsp";
    public static final String VIEW_ADMIN_UTILISATEURS = "/WEB-INF/views/admin/utilisateurs-list.jsp";
    public static final String VIEW_ADMIN_UTILISATEUR_FORM = "/WEB-INF/views/admin/utilisateur-form.jsp";
    public static final String VIEW_ADMIN_ETUDIANTS = "/WEB-INF/views/admin/etudiants.jsp";
    public static final String VIEW_ADMIN_PROFESSEURS = "/WEB-INF/views/admin/professeurs.jsp";
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

    // ==================== VUES PROFESSEUR ====================
    public static final String VIEW_PROF_DASHBOARD = "/WEB-INF/views/professeur/dashboard.jsp";
    public static final String VIEW_PROF_MODULES = "/WEB-INF/views/professeur/modules.jsp";
    public static final String VIEW_PROF_RESSOURCES = "/WEB-INF/views/professeur/resources-list.jsp";
    public static final String VIEW_PROF_UPLOAD = "/WEB-INF/views/professeur/resource-upload.jsp";
    public static final String VIEW_PROF_EDIT_RESSOURCE = "/WEB-INF/views/professeur/ressource-edit.jsp";
    public static final String VIEW_PROF_STATS = "/WEB-INF/views/professeur/statistiques.jsp";
    public static final String VIEW_PROF_SOUMISSIONS = "/WEB-INF/views/professeur/soumissions.jsp";
    public static final String VIEW_PROF_DEVOIRS = "/WEB-INF/views/professeur/devoirs-list.jsp";
    public static final String VIEW_PROF_DEVOIR_FORM = "/WEB-INF/views/professeur/devoir-form.jsp";
    public static final String VIEW_PROF_DEVOIR_DETAIL = "/WEB-INF/views/professeur/devoir-detail.jsp";

    // ==================== VUES ETUDIANT ====================
    public static final String VIEW_ETU_DASHBOARD = "/WEB-INF/views/etudiant/dashboard.jsp";
    public static final String VIEW_ETU_MODULES = "/WEB-INF/views/etudiant/modules.jsp";
    public static final String VIEW_ETU_RESSOURCES = "/WEB-INF/views/etudiant/ressources-list.jsp";
    public static final String VIEW_ETU_RESSOURCE_VIEW = "/WEB-INF/views/etudiant/ressource-view.jsp";
    public static final String VIEW_ETU_RECHERCHE = "/WEB-INF/views/etudiant/recherche.jsp";
    public static final String VIEW_ETU_FAVORIS = "/WEB-INF/views/etudiant/favoris.jsp";
    public static final String VIEW_ETU_HISTORIQUE = "/WEB-INF/views/etudiant/historique.jsp";
    public static final String VIEW_ETU_PROFIL = "/WEB-INF/views/etudiant/profil.jsp";
    public static final String VIEW_ETU_SOUMETTRE = "/WEB-INF/views/etudiant/soumettre.jsp";
    public static final String VIEW_ETU_MES_SOUMISSIONS = "/WEB-INF/views/etudiant/mes-soumissions.jsp";
    public static final String VIEW_ETU_DEVOIRS = "/WEB-INF/views/etudiant/mes-devoirs.jsp";

    // ==================== VUES PUBLIQUES (suite) ====================
    public static final String VIEW_REGISTER = "/WEB-INF/views/auth/register.jsp";

    // ==================== VUES ADMIN (demandes inscription) ====================
    public static final String VIEW_ADMIN_DEMANDES = "/WEB-INF/views/admin/demandes.jsp";
    public static final String VIEW_ADMIN_FILIERE_VOIR = "/WEB-INF/views/admin/filiere-voir.jsp";

    // ==================== VUES ERREURS ====================
    public static final String VIEW_403 = "/WEB-INF/views/error/403.jsp";
    public static final String VIEW_404 = "/WEB-INF/views/error/404.jsp";
    public static final String VIEW_500 = "/WEB-INF/views/error/500.jsp";
}