package utils;



import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public final class DateUtil {

    public static final DateTimeFormatter DATETIME_FORMATTER =
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    public static final DateTimeFormatter DATE_FORMATTER =
            DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private DateUtil() {}

    public static String formatDateTime(LocalDateTime dt) {
        if (dt == null) return "";
        return dt.format(DATETIME_FORMATTER);
    }

    public static String formatDate(LocalDateTime dt) {
        if (dt == null) return "";
        return dt.format(DATE_FORMATTER);
    }

    /**
     * Retourne une description lisible du temps ecoule (ex: "il y a 2 heures").
     */
    public static String tempsEcoule(LocalDateTime dt) {
        if (dt == null) return "";
        long minutes = ChronoUnit.MINUTES.between(dt, LocalDateTime.now());
        if (minutes < 1) return "A l'instant";
        if (minutes < 60) return "Il y a " + minutes + " min";
        long heures = ChronoUnit.HOURS.between(dt, LocalDateTime.now());
        if (heures < 24) return "Il y a " + heures + "h";
        long jours = ChronoUnit.DAYS.between(dt, LocalDateTime.now());
        if (jours < 30) return "Il y a " + jours + "j";
        long mois = ChronoUnit.MONTHS.between(dt, LocalDateTime.now());
        if (mois < 12) return "Il y a " + mois + " mois";
        return "Il y a " + ChronoUnit.YEARS.between(dt, LocalDateTime.now()) + " ans";
    }
}