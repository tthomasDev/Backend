package model;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
 
public class SendMailTLS {
	
	public SendMailTLS (String dest,String myMessage)
	{
		System.out.println("Envoi d'un message");
 
		final String username = "alex.delesse@gmail.com";
		final String password = "TODO";/* TODO */
 
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		
		System.out.println("propriétés fait");
		
		Session session = Session.getInstance(props,
		  new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		  });
		System.out.println("Autentification fait");
		try {
 
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress("myneightool@gmail.com"));
			message.setRecipients(Message.RecipientType.TO,
				InternetAddress.parse(dest));
			message.setSubject("Testing Subject");
			message.setText(myMessage);
 
			Transport.send(message);
 
			System.out.println("Done");
 
		} catch (MessagingException e) {
			throw new RuntimeException(e);
		}
	}
}