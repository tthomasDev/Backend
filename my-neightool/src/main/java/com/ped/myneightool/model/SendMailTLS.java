package com.ped.myneightool.model;

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
 
		final String username = "myneightool@gmail.com";
		final String password = "ped2014tool";
 
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		
		
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
			message.setSubject("Message de NeighTool");
			message.setText(myMessage);
			
			Transport.send(message);
			
			System.out.println("Message envoyé");
 
		} catch (MessagingException e) {
			throw new RuntimeException(e);
		}
	}
	
	
	public SendMailTLS (String dest,String myMessage, String myObjet)
	{
		String objet=myObjet;
		final String username = "myneightool@gmail.com";
		final String password = "ped2014tool";
 
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		
		Session session = Session.getInstance(props,
		  new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		  });
		System.out.println("Autentification fait 2");
		try {
 
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress("myneightool@gmail.com"));
			message.setRecipients(Message.RecipientType.TO,
				InternetAddress.parse(dest));
			message.setSubject(objet);
			message.setText(myMessage);
			Transport.send(message);
			
			System.out.println("Message envoyé 2");
 
		} catch (MessagingException e) {
			throw new RuntimeException(e);
		}
	}
}