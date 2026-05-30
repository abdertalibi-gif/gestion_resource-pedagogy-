package utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public final class PasswordUtil {

    private static final SecureRandom RANDOM = new SecureRandom();

    private PasswordUtil() {}

    public static String hash(String password) {
        byte[] salt = new byte[16];
        RANDOM.nextBytes(salt);
        return hash(password, salt);
    }

    public static String hash(String password, byte[] salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            byte[] combined = new byte[salt.length + hashedPassword.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);
            return Base64.getEncoder().encodeToString(combined);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Algorithme SHA-256 non disponible", e);
        }
    }

    public static boolean verify(String password, String storedHash) {
        // 1. Essayer la vérification avec hash (pour les nouveaux mots de passe)
        try {
            byte[] combined = Base64.getDecoder().decode(storedHash);
            if (combined.length >= 16) {
                byte[] salt = new byte[16];
                System.arraycopy(combined, 0, salt, 0, 16);
                String computedHash = hash(password, salt);
                if (computedHash.equals(storedHash)) {
                    return true;
                }
            }
        } catch (Exception e) {
            // Pas un hash Base64 = mot de passe en clair, on continue
        }

        // 2. Fallback : comparaison directe (pour les mots de passe en clair dans la BDD)
        return password.equals(storedHash);
    }
}