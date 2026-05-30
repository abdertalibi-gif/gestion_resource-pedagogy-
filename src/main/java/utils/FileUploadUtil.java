package utils;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.UUID;

public final class FileUploadUtil {

    private FileUploadUtil() {}

    /**
     * Sauvegarde un fichier uploade et retourne le chemin relatif.
     */
    public static String saveFile(Part part, String realUploadPath) throws IOException {
        String fileName = getFileName(part);
        if (fileName == null || fileName.isEmpty()) {
            throw new IOException("Aucun fichier selectionne");
        }

        String contentType = part.getContentType();
        if (!isAllowedType(contentType)) {
            throw new IOException("Type de fichier non autorise: " + contentType);
        }

        if (part.getSize() > Constants.MAX_FILE_SIZE) {
            throw new IOException("Fichier trop volumineux (max " + (Constants.MAX_FILE_SIZE / 1048576) + " Mo)");
        }

        // Generer un nom unique pour eviter les conflits
        String extension = fileName.substring(fileName.lastIndexOf("."));
        String uniqueName = UUID.randomUUID().toString().replace("-", "") + extension;

        // Creer le sous-repertoire selon le type
        String subDir = getSubDirectory(contentType);
        Path dirPath = Paths.get(realUploadPath, subDir);
        Files.createDirectories(dirPath);

        Path filePath = dirPath.resolve(uniqueName);
        part.write(filePath.toString());

        return Constants.UPLOAD_DIR + subDir + "/" + uniqueName;
    }

    /**
     * Supprime un fichier physique du serveur.
     */
    public static void deleteFile(String relativePath, String realUploadPath) {
        if (relativePath == null || relativePath.isEmpty()) return;
        try {
            // Retirer le prefixe /assets/uploads/
            String cleanPath = relativePath.replaceFirst("^/assets/uploads/?", "");
            Path filePath = Paths.get(realUploadPath, cleanPath);
            Files.deleteIfExists(filePath);
        } catch (IOException e) {
            System.err.println("Erreur suppression fichier: " + e.getMessage());
        }
    }

    private static String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) return null;
        for (String content : contentDisposition.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    private static boolean isAllowedType(String contentType) {
        if (contentType == null) return false;
        return Arrays.asList(Constants.ALLOWED_TYPES).contains(contentType);
    }

    private static String getSubDirectory(String contentType) {
        if (contentType == null) return "documents";
        if (contentType.startsWith("video/")) return "videos";
        if (contentType.equals("application/pdf")) return "pdf";
        if (contentType.startsWith("image/")) return "images";
        return "documents";
    }
}