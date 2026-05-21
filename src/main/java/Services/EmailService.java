package Services;

import java.util.Properties;

// ============================================
// LES 7 IMPORTS CORRECTS
// ============================================
import jakarta.mail.Authenticator;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Message;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
// ============================================

public class EmailService {

    private final String smtpHost = "smtp.gmail.com";
    private final String smtpPort = "587";
    private final String emailFrom = "gesped.fsm@gmail.com";
    private final String emailPassword = "votre_mot_de_passe_application";

    public boolean envoyerResetPassword(String destinataire, String lien) {

        String sujet = "GesPed — Réinitialisation du mot de passe";
        String contenu = buildContenu(lien);

        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", smtpHost);
            props.put("mail.smtp.port", smtpPort);
            props.put("mail.smtp.ssl.trust", smtpHost);

            Session session = Session.getInstance(props,
                new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(emailFrom, emailPassword);
                    }
                }
            );

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(emailFrom, "GesPed - FSM"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinataire));
            message.setSubject(sujet);
            message.setContent(contenu, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("Email envoyé avec succès !");
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private String buildContenu(String lien) {
        return """
            <!DOCTYPE html>
            <html lang="fr">
            <head><meta charset="UTF-8"></head>
            <body style="margin:0;padding:0;background:#f3f4f6;font-family:Arial,sans-serif;">
            <table width="100%%" cellpadding="0" cellspacing="0" style="padding:40px 20px;">
                <tr><td align="center">
                    <table width="600" cellpadding="0" cellspacing="0" style="background:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 4px 20px rgba(0,0,0,0.08);">
                        <tr>
                            <td style="background:linear-gradient(135deg,#004d73,#0582b5);padding:30px;text-align:center;">
                                <h1 style="margin:0;color:white;font-size:24px;">GesPed</h1>
                                <p style="margin-top:8px;color:#dbeafe;font-size:13px;">Gestion des Ressources Pédagogiques</p>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding:40px;">
                                <h2 style="color:#0582b5;margin-top:0;">Réinitialisation du mot de passe</h2>
                                <p style="color:#374151;line-height:1.7;font-size:14px;">Bonjour,<br><br>Vous avez demandé la réinitialisation de votre mot de passe.</p>
                                <p style="color:#374151;line-height:1.7;font-size:14px;">Cliquez sur le bouton ci-dessous pour définir un nouveau mot de passe :</p>
                                <div style="text-align:center;margin:35px 0;">
                                    <a href="%s" style="background:#0582b5;color:white;text-decoration:none;padding:14px 32px;border-radius:8px;display:inline-block;font-weight:bold;">Réinitialiser le mot de passe</a>
                                </div>
                                <div style="background:#fff7ed;border:1px solid #fdba74;padding:16px;border-radius:8px;">
                                    <p style="margin:0;color:#9a3412;font-size:13px;line-height:1.6;">⚠ Ce lien expire dans <strong>15 minutes</strong>.</p>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="background:#f9fafb;padding:20px;text-align:center;border-top:1px solid #e5e7eb;">
                                <p style="margin:0;color:#9ca3af;font-size:12px;">© 2025 GesPed — FSM</p>
                            </td>
                        </tr>
                    </table>
                </td></tr>
            </table>
            </body>
            </html>
            """.formatted(lien);
    }
}