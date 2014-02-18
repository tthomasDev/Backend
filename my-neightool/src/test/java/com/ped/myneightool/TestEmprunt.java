package com.ped.myneightool;

import java.sql.Timestamp;
import java.util.Date;
import java.util.GregorianCalendar;

import javax.xml.bind.JAXBContext;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.model.Connexion;
import com.ped.myneightool.model.Emprunt;
import com.ped.myneightool.model.Outil;
import com.ped.myneightool.model.Utilisateur;





public class TestEmprunt {

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(TestEmprunt.class);

	
	private static JAXBContext jaxbc;
	private static ClientRequestBuilder crb;
	

	@BeforeClass
	public static void setUp() throws Exception {
		jaxbc=JAXBContext.newInstance(	Emprunt.class,
										Utilisateur.class,
										Outil.class,
										Connexion.class,
										Date.class,
										Timestamp.class);
		crb= new ClientRequestBuilder(jaxbc);
	}
		
	
	
	
	
	
	
	/**
	 * test unitaire création d'un message
	 */
	@Test
	public void testCreateMessage() {
		try {
			final Connexion connexion = new Connexion("loginCreate","passwordCreate");
			
			final Utilisateur u = new Utilisateur("userPrenomEmprunt","userNomEmprunt",connexion,"","");
			final Utilisateur uPost= (Utilisateur) crb.httpRequestXMLBody(u,"user/create");
		
			final Outil o= new Outil(uPost,"RateauTestEmprunt","savoir ratisser",true,"Jardinage",50);
			final Outil oPost=(Outil) crb.httpRequestXMLBody(o, "tool/create");
			
			Assert.assertNotSame(oPost,null);
			
			
			
			GregorianCalendar cal = new GregorianCalendar(2013, 9 - 1, 23);
			long millis = cal.getTimeInMillis();
			final Date debutT = new Date(millis);
			
			GregorianCalendar cal2 = new GregorianCalendar(2014, 9 - 1, 23);
			long millis2 = cal2.getTimeInMillis();
			final Date finT = new Date(millis2);
			
			
			final Emprunt e = new Emprunt(o,u,debutT,finT);
			final Emprunt ePost = (Emprunt) crb.httpRequestXMLBody(e,"emprunt/create");
					
			Assert.assertNotSame(ePost,null);
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'emprunt", re);
			throw re;
		}
	}
	
	
	
}
