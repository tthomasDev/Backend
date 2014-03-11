package com.ped.myneightool;

import java.util.Date;

import javax.xml.bind.JAXBContext;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.model.Categorie;
import com.ped.myneightool.model.Connexion;
import com.ped.myneightool.model.Emprunt;
import com.ped.myneightool.model.Outil;
import com.ped.myneightool.model.Utilisateur;





public class TestEmprunt {
	
	public Categorie cat1= new Categorie("Sport");
	public Categorie cat= (Categorie) crb.httpRequestXMLBody(cat1, "categorie/create");
	
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
										Date.class);
		crb= new ClientRequestBuilder(jaxbc);
	}
	
	
	/**
	 * test unitaire création d'un emprunt avec date
	 */
	@Test
	public void testCreateEmpruntWithDate() {
		try {
			final Connexion connexion = new Connexion("loginCreateEmpruntDate","passwordCreateEmpruntDate");
			
			final Utilisateur u = new Utilisateur("userPrenomEmpruntDate","userNomEmpruntDate",connexion);
			final Utilisateur uPost= (Utilisateur) crb.httpRequestXMLBody(u,"user/create");
		
			final Outil o= new Outil(uPost,"RateauTestEmpruntDate","savoir ratisser",true,cat,50);
			final Outil oPost=(Outil) crb.httpRequestXMLBody(o, "tool/create");
			
						
			
			
			final Date debutT = new Date(0);
			
			
			final Date finT = new Date(0);
			
			
			final Emprunt e = new Emprunt(oPost,uPost,debutT,finT);
			final Emprunt ePost = (Emprunt) crb.httpRequestXMLBody(e,"emprunt/create");
					
			Assert.assertNotSame(ePost,null);
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'emprunt", re);
			throw re;
		}
	}
	
	
	
}
