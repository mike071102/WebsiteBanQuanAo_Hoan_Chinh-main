package poly.java.Utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletContext;

import java.util.Properties;

public class EmailUtils {

    private static final String FROM_EMAIL = "minhnhut07112002@gmail.com"; // ⚠️ Đổi thành Gmail của bạn
    private static final String APP_PASSWORD = "vxhnsfwuzkaacmkh"; // Mã Google App Password của bạn

    public static void sendEmail(ServletContext servletContext, String toEmail, String subject, String bodyContent) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL, "Clothing Shop"));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        message.setSubject(subject);
        message.setContent(bodyContent, "text/html; charset=UTF-8");

        Transport.send(message);
    }
}