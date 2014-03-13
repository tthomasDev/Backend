package com.ped.myneightool;

import javax.xml.bind.JAXBContext;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.model.Adresse;
import com.ped.myneightool.model.Connexion;
import com.ped.myneightool.model.Outil;
import com.ped.myneightool.model.Utilisateur;





public class TestAdresse {

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(TestAdresse.class);

	
	private static JAXBContext jaxbc;
	private static ClientRequestBuilder crb;
	

	@BeforeClass
	public static void setUp() throws Exception {
		jaxbc=JAXBContext.newInstance(	Utilisateur.class, 
										Outil.class);
		crb= new ClientRequestBuilder(jaxbc);
	}
		
	
	
	/**
	 * test unitaire création d'utilisateur avec adresse
	 */
	@Test
	public void testCreateUserWithAddress() {
		try {
			final Connexion connexion = new Connexion("loginCreateAdress",CryptHandler.encodedPw("passwordCreate"));
			final Adresse adresse = new Adresse("666 rue des pigeons meurtriers","33000","Bordeaux","France",-666,666);
			
			//final Utilisateur utilisateur = new Utilisateur("test", "xml");
			final Utilisateur utilisateur2= new Utilisateur("JeanAdresseCreate","DucheminAdresseCreate",connexion,"dsqdqsjean-duchemin@gmail.com","0606060606",adresse);
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur2,"user/create");
			
						
			Assert.assertNotSame(utilisateurPost,null);
			
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'utilisateur", re);
			throw re;
		}
	}
		
	/**
	 * test unitaire mis à jour d'adresse utilisateur
	 */
	@Test
	public void testUpdateAddressFromUtilisateur() {
		try {
			final Connexion connexion = new Connexion("loginCreatesqdsqd",CryptHandler.encodedPw("passwordCreate"));
			final Adresse adresse = new Adresse("666 rue des pigeons meurtriers","33000","Bordeaux","France",-666,666);
			
			
			final Utilisateur utilisateur= new Utilisateur("JeanAdresseCreate","DucheminAdresseCreate",connexion,"dsqdjean-duchemin@gmail.com","0606060606",adresse);
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
			
			utilisateurPost.getAdresse().setRue("42 rue des bisounours");
			utilisateurPost.getAdresse().setPays("Pakistan");
			
			final Utilisateur utilisateurPost2 = (Utilisateur) crb.httpRequestXMLBody(utilisateurPost, "user/update");
			
						
			Assert.assertNotSame(utilisateurPost2,null);
			
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'utilisateur", re);
			throw re;
		}
	}
	
	
}
