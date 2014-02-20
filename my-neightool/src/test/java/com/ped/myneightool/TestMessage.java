package com.ped.myneightool;

import java.util.Date;

import javax.xml.bind.JAXBContext;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.LoggerFactory;

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
										Message.class);
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
	
	
	
}
