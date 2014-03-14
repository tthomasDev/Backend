package com.ped.myneightool;

import java.util.Date;
import java.util.Iterator;

import javax.xml.bind.JAXBContext;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.dto.MessagesDTO;
import com.ped.myneightool.dto.UtilisateursDTO;
import com.ped.myneightool.model.Adresse;
import com.ped.myneightool.model.Connexion;
import com.ped.myneightool.model.Message;
import com.ped.myneightool.model.Utilisateur;

public class TestMessage {

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(TestMessage.class);

	
	private static JAXBContext jaxbc;
	private static ClientRequestBuilder crb;
	

	@BeforeClass
	public static void setUp() throws Exception {
		jaxbc=JAXBContext.newInstance(	Utilisateur.class,
										UtilisateursDTO.class,
										Connexion.class,
										Adresse.class,
										Message.class,
										MessagesDTO.class);
		crb= new ClientRequestBuilder(jaxbc);
		
			
		
	}
	
	/**
	 * test unitaire création d'un message
	 */
	@Test
	public void testCreateMessage() {
		try {
			final Connexion connexion = new Connexion("loginCreateMessage",CryptHandler.encodedPw("passwordCreateMessage"));
			
			final Adresse adresse = new Adresse("18 rue Sainte-Catherine","33000","Bordeaux","France",44,0);
			final Date birthDate = new Date(0);
			
			final Utilisateur utilisateur= new Utilisateur("JeanEmetteur","DucheminEmetteur",connexion,"message1@mail.com","0102030405",adresse,birthDate);
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
			
			final Connexion connexion2 = new Connexion("loginCreateMessage2",CryptHandler.encodedPw("passwordCreateMessage2"));
			final Utilisateur utilisateur2= new Utilisateur("JacquesDestinataire","DucheminDestinataire",connexion2);
			final Utilisateur utilisateurPost2 = (Utilisateur) crb.httpRequestXMLBody(utilisateur2,"user/create");
						
			final Date d = new Date();
			
			final Message message = new Message(utilisateurPost,utilisateurPost2,"Titre message","Corps du message",d,0,0);
			final Message messagePost = (Message) crb.httpRequestXMLBody(message,"message/create");
			
			Assert.assertNotSame(messagePost,null);
						
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'utilisateur", re);
			throw re;
		}
	}
	
	
	/**
	 * test unitaire obtenir un message
	 */
	
	@Test
	public final void testGetMessage() {

		try{
			
			Connexion co = new Connexion("totdsqdo",CryptHandler.encodedPw("titi"));
			Connexion co3 = new Connexion("totgfddsqdo",CryptHandler.encodedPw("titi"));
			
			final Adresse adresse = new Adresse("19 rue Sainte-Catherine","33000","Bordeaux","France",44,0);
			final Date birthDate = new Date(0);
			final Utilisateur utilisateur= new Utilisateur("JeanEmetteurGet","DucheminEmetteurGet",co,"message2@mail.com","0102030405",adresse,birthDate);
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
			
			
			final Utilisateur utilisateur2= new Utilisateur("JacquesDestinataireGet","DucheminDestinataireGet",co3,"message3@mail.com","0102030405",adresse,birthDate);
			final Utilisateur utilisateurPost2 = (Utilisateur) crb.httpRequestXMLBody(utilisateur2,"user/create");
						
			final Date d = new Date();
			
			final Message message = new Message(utilisateurPost,utilisateurPost2,"Titre messageGet","Corps du messageGetMessage",d,0,0);
			final Message messagePost = (Message) crb.httpRequestXMLBody(message,"message/create");
			
			Assert.assertNotSame(messagePost,null);
			
			int i = messagePost.getId();
			LOG.info(""+messagePost.getId()+""+messagePost.getObjet()+""+messagePost.getCorps()+"");
			
			
			final Message messageGet =(Message) crb.httpGetRequest("message",i,utilisateurPost2);
			LOG.info(""+messageGet.getId()+""+messageGet.getObjet()+""+messageGet.getCorps()+"");
			
			Assert.assertNotSame(messageGet,null);
						
			
		}
		catch(final RuntimeException r){
			LOG.error("testGetMessage failed",r);
			throw r;
		}
	}
	
	
	
	/**
	 * test unitaire création puis suppression d'un message
	 */
	@Test
	public void testDeleteMessage() {
		try {
			Connexion co = new Connexion("totdsaaaaqdo",CryptHandler.encodedPw("titi"));
			Connexion co3 = new Connexion("totgaaaaaafddsqdo",CryptHandler.encodedPw("titi"));
			
			final Adresse adresse = new Adresse("4 rue Sainte-Catherine","33000","Bordeaux","France",44,0);
			final Date birthDate = new Date(0);
			final Utilisateur utilisateur= new Utilisateur("JeanEmetteur2","DucheminEmetteur2",co,"jean.duchemin@mail.com","0152830465",adresse,birthDate);
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
			final Utilisateur utilisateur2= new Utilisateur("JacquesDestinataire","DucheminDestinataire",co3,"message4@mail.com","0102030405",adresse,birthDate);
			final Utilisateur utilisateurPost2 = (Utilisateur) crb.httpRequestXMLBody(utilisateur2,"user/create");
						
			final Date d = new Date();
			
			final Message message = new Message(utilisateurPost,utilisateurPost2,"Titre message","Corps du message",d,0,0);
			final Message messagePost = (Message) crb.httpRequestXMLBody(message,"message/create");
			
			Assert.assertNotSame(messagePost,null);
			
			int i = messagePost.getId();
			crb.httpGetRequest("message/delete",i,utilisateurPost2);
			
			try{
				final Message messageGet = (Message) crb.httpGetRequest("message", i,utilisateurPost2);
				Assert.assertSame(messageGet, null);
			}
			catch(final RuntimeException r){
				LOG.error("testDeleteMessage failed",r);
				throw r;
			}	
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de du message", re);
			throw re;
		}
	}
	
	
	/**
	 * test unitaire trouver les messages envoyés par l'utilisateur
	 */
	
	@Test
	public void testFindSendMessagesByUser(){
		try{
			Connexion c1=new Connexion("log1",CryptHandler.encodedPw("25"));
			Connexion c2=new Connexion("log2",CryptHandler.encodedPw("25"));
			Connexion c3=new Connexion("log3",CryptHandler.encodedPw("25"));
			Connexion c4=new Connexion("log4",CryptHandler.encodedPw("25"));
			
			final Adresse adresse = new Adresse("5 rue Sainte-Catherine","33000","Bordeaux","France",44,0);
			final Date birthDate = new Date(0);
			
			
			final Utilisateur user1 = new Utilisateur("Toto","Titi",c1,"message5@mail.com","0102030405",adresse,birthDate);
			final Utilisateur user1Post= (Utilisateur) crb.httpRequestXMLBody(user1,"user/create");
			final Utilisateur user2 = new Utilisateur("Momo","Mimi",c2,"message6@mail.com","0102030405",adresse,birthDate);
			final Utilisateur user2Post= (Utilisateur) crb.httpRequestXMLBody(user2,"user/create");
			final Utilisateur user3 = new Utilisateur("Momo","Mimi",c3,"message7@mail.com","0102030405",adresse,birthDate);
			final Utilisateur user3Post= (Utilisateur) crb.httpRequestXMLBody(user3,"user/create");
			final Utilisateur user4 = new Utilisateur("Momo","Mimi",c4,"message8@mail.com","0102030405",adresse,birthDate);
			final Utilisateur user4Post= (Utilisateur) crb.httpRequestXMLBody(user4,"user/create");

			final Date d= new Date();

			final Message message1 = new Message(user1Post,user2Post,"Message1","Corps du message",d,0,0);
			final Message message1Post = (Message) crb.httpRequestXMLBody(message1,"message/create");

			Assert.assertNotSame(message1Post,null);

			final Message message2 = new Message(user1Post,user3Post,"Message2","Corps du message",d,0,0);
			final Message message2Post = (Message) crb.httpRequestXMLBody(message2,"message/create");

			Assert.assertNotSame(message2Post,null);

			final Message message3 = new Message(user1Post,user4Post,"Message3","Corps du message",d,0,0);
			final Message message3Post = (Message) crb.httpRequestXMLBody(message3,"message/create");

			Assert.assertNotSame(message3Post,null);

			int i = user1Post.getId();
			MessagesDTO mdto = (MessagesDTO) crb.httpGetRequest("message/list/send", i,user1Post);
			LOG.info("ID de l'utilisateur envoyeur");

			LOG.info("\n\n\n");
			LOG.info("taille liste messages envoyés:" +mdto.size());
			LOG.info("\n\n\n");

			LOG.info("liste des messages:\n");
			Iterator<Message> ito=mdto.getListeMessages().iterator();
			while(ito.hasNext()){

				final Message msg = ito.next();
				LOG.info(msg.getId()+" "+msg.getObjet()+" "+msg.getCorps()+" EmetteurId:"+msg.getEmetteur()+" DestinataireId:"+msg.getDestinataire()+" "+msg.getDate());

			}


			Assert.assertTrue( mdto.getListeMessages().size() >= 0);
			LOG.info("\n\n\n");
		}
		catch(final RuntimeException r){
			LOG.error("testF failed",r);
			throw r;
		}
	}
	
	
	/**
	 * test unitaire trouver les messages reçus par l'utilisateur
	 */
	@Test
	public void testFindReceiveMessagesByUser(){
		try{
			Connexion c1=new Connexion("log10",CryptHandler.encodedPw("25"));
			Connexion c2=new Connexion("log20",CryptHandler.encodedPw("25"));
			Connexion c3=new Connexion("log30",CryptHandler.encodedPw("25"));
			Connexion c4=new Connexion("log40",CryptHandler.encodedPw("25"));
			
			final Adresse adresse = new Adresse("6 rue Sainte-Catherine","33000","Bordeaux","France",44,0);
			final Date birthDate = new Date();
			
			final Utilisateur user1 = new Utilisateur("Toto","Titi",c1,"message9@mail.com","0102030405",adresse,birthDate);
			final Utilisateur user1Post= (Utilisateur) crb.httpRequestXMLBody(user1,"user/create");
			final Utilisateur user2 = new Utilisateur("Momo","Mimi",c2,"message10@mail.com","0102030405",adresse,birthDate);
			final Utilisateur user2Post= (Utilisateur) crb.httpRequestXMLBody(user2,"user/create");
			final Utilisateur user3 = new Utilisateur("Momo","Mimi",c3,"message11@mail.com","0102030405",adresse,birthDate);
			final Utilisateur user3Post= (Utilisateur) crb.httpRequestXMLBody(user3,"user/create");
			final Utilisateur user4 = new Utilisateur("Momo","Mimi",c4,"message12@mail.com","0102030405",adresse,birthDate);
			final Utilisateur user4Post= (Utilisateur) crb.httpRequestXMLBody(user4,"user/create");

			final Date d= new Date();

			final Message message1 = new Message(user2Post,user1Post,"Message1","Corps du message",d,0,0);
			final Message message1Post = (Message) crb.httpRequestXMLBody(message1,"message/create");

			Assert.assertNotSame(message1Post,null);

			final Message message2 = new Message(user3Post,user1Post,"Message2","Corps du message",d,0,0);
			final Message message2Post = (Message) crb.httpRequestXMLBody(message2,"message/create");

			Assert.assertNotSame(message2Post,null);

			final Message message3 = new Message(user4Post,user1Post,"Message3","Corps du message",d,0,0);
			final Message message3Post = (Message) crb.httpRequestXMLBody(message3,"message/create");

			Assert.assertNotSame(message3Post,null);

			int i = user1Post.getId();
			MessagesDTO mdto = (MessagesDTO) crb.httpGetRequest("message/list/receive", i,user1Post);
			LOG.info("ID de l'utilisateur envoyeur");

			LOG.info("\n\n\n");
			LOG.info("taille liste messages envoyés:" +mdto.size());
			LOG.info("\n\n\n");

			LOG.info("liste des messages:\n");
			Iterator<Message> ito=mdto.getListeMessages().iterator();
			while(ito.hasNext()){

				final Message msg = ito.next();
				LOG.info(msg.getId()+" "+msg.getObjet()+" "+msg.getCorps()+" EmetteurId:"+msg.getEmetteur()+" DestinataireId:"+msg.getDestinataire()+" "+msg.getDate());

			}


			Assert.assertTrue( mdto.getListeMessages().size() >= 0);
			LOG.info("\n\n\n");
		}
		catch(final RuntimeException r){
			LOG.error("testF failed",r);
			throw r;
		}
	}
	
	
}
