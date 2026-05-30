package utils;


import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public final class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^[0-9]{10}$");

    private ValidationUtil() {}

    public static List<String> validerUtilisateur(String nom, String prenom,
                                                   String email, String motDePasse) {
        List<String> erreurs = new ArrayList<>();

        if (nom == null || nom.trim().isEmpty()) {
            erreurs.add("Le nom est obligatoire");
        } else if (nom.trim().length() < 2) {
            erreurs.add("Le nom doit contenir au moins 2 caracteres");
        }

        if (prenom == null || prenom.trim().isEmpty()) {
            erreurs.add("Le prenom est obligatoire");
        }

        if (email == null || email.trim().isEmpty()) {
            erreurs.add("L'email est obligatoire");
        } else if (!EMAIL_PATTERN.matcher(email).matches()) {
            erreurs.add("Format d'email invalide");
        }

        if (motDePasse == null || motDePasse.isEmpty()) {
            erreurs.add("Le mot de passe est obligatoire");
        } else if (motDePasse.length() < 6) {
            erreurs.add("Le mot de passe doit contenir au moins 6 caracteres");
        }

        return erreurs;
    }

    public static List<String> validerModule(String nom, String code) {
        List<String> erreurs = new ArrayList<>();

        if (nom == null || nom.trim().isEmpty()) {
            erreurs.add("Le nom du module est obligatoire");
        }
        if (code == null || code.trim().isEmpty()) {
            erreurs.add("Le code du module est obligatoire");
        }

        return erreurs;
    }

    public static boolean isNullOrEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }
}