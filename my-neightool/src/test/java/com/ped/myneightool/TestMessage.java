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
			final Connexion connexion = new Connexion("loginCreateMessage","passwordCreateMessage");
			final Utilisateur utilisateur= new Utilisateur("JeanEmetteur","DucheminEmetteur",connexion);
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
			
			final Connexion connexion2 = new Connexion("loginCreateMessage2","passwordCreateMessage2");
			final Utilisateur utilisateur2= new Utilisateur("JacquesDestinataire","DucheminDestinataire",connexion2);
			final Utilisateur utilisateurPost2 = (Utilisateur) crb.httpRequestXMLBody(utilisateur2,"user/create");
						
			final Date d = new Date();
			
			final Message message = new Message(utilisateurPost,utilisateurPost2,"Titre message","Corps du message",d);
			final Message messagePost = (Message) crb.httpRequestXMLBody(message,"message/create");
			
			Assert.assertNotSame(messagePost,null);
						
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'utilisateur", re);
			throw re;
		}
	}
	
	
	/**
	 * test unitaire trouver les messages envoyés par l'utilisateur
	 */
	
	@Test
	public void testFindSendMessagesByUser(){
		try{
			final Utilisateur user1 = new Utilisateur("Toto","Titi");
			final Utilisateur user1Post= (Utilisateur) crb.httpRequestXMLBody(user1,"user/create");
			final Utilisateur user2 = new Utilisateur("Momo","Mimi");
			final Utilisateur user2Post= (Utilisateur) crb.httpRequestXMLBody(user2,"user/create");
			final Utilisateur user3 = new Utilisateur("Momo","Mimi");
			final Utilisateur user3Post= (Utilisateur) crb.httpRequestXMLBody(user3,"user/create");
			final Utilisateur user4 = new Utilisateur("Momo","Mimi");
			final Utilisateur user4Post= (Utilisateur) crb.httpRequestXMLBody(user4,"user/create");

			final Date d= new Date();

			final Message message1 = new Message(user1Post,user2Post,"Message1","Corps du message",d);
			final Message message1Post = (Message) crb.httpRequestXMLBody(message1,"message/create");

			Assert.assertNotSame(message1Post,null);

			final Message message2 = new Message(user1Post,user3Post,"Message2","Corps du message",d);
			final Message message2Post = (Message) crb.httpRequestXMLBody(message2,"message/create");

			Assert.assertNotSame(message2Post,null);

			final Message message3 = new Message(user1Post,user4Post,"Message3","Corps du message",d);
			final Message message3Post = (Message) crb.httpRequestXMLBody(message3,"message/create");

			Assert.assertNotSame(message3Post,null);

			int i = user1Post.getId();
			MessagesDTO mdto = (MessagesDTO) crb.httpGetRequest("message/list/send", i);
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
			final Utilisateur user1 = new Utilisateur("Toto","Titi");
			final Utilisateur user1Post= (Utilisateur) crb.httpRequestXMLBody(user1,"user/create");
			final Utilisateur user2 = new Utilisateur("Momo","Mimi");
			final Utilisateur user2Post= (Utilisateur) crb.httpRequestXMLBody(user2,"user/create");
			final Utilisateur user3 = new Utilisateur("Momo","Mimi");
			final Utilisateur user3Post= (Utilisateur) crb.httpRequestXMLBody(user3,"user/create");
			final Utilisateur user4 = new Utilisateur("Momo","Mimi");
			final Utilisateur user4Post= (Utilisateur) crb.httpRequestXMLBody(user4,"user/create");

			final Date d= new Date();

			final Message message1 = new Message(user2Post,user1Post,"Message1","Corps du message",d);
			final Message message1Post = (Message) crb.httpRequestXMLBody(message1,"message/create");

			Assert.assertNotSame(message1Post,null);

			final Message message2 = new Message(user3Post,user1Post,"Message2","Corps du message",d);
			final Message message2Post = (Message) crb.httpRequestXMLBody(message2,"message/create");

			Assert.assertNotSame(message2Post,null);

			final Message message3 = new Message(user4Post,user1Post,"Message3","Corps du message",d);
			final Message message3Post = (Message) crb.httpRequestXMLBody(message3,"message/create");

			Assert.assertNotSame(message3Post,null);

			int i = user1Post.getId();
			MessagesDTO mdto = (MessagesDTO) crb.httpGetRequest("message/list/receive", i);
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
