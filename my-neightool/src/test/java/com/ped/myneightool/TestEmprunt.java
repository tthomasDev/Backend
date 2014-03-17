package com.ped.myneightool;

import java.util.Date;

import javax.xml.bind.JAXBContext;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.model.Adresse;
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
	private static Utilisateur utilisateurAdmin;

	@BeforeClass
	public static void setUp() throws Exception {
		jaxbc=JAXBContext.newInstance(	Emprunt.class,
										Utilisateur.class,
										Outil.class,
										Connexion.class,
										Date.class);
		crb= new ClientRequestBuilder(jaxbc);
		
		final Connexion connexion = new Connexion("adminCategorieOutilEmprunt",CryptHandler.encodedPw("admin"));
		final Adresse adresse = new Adresse("45 allée des rues","33000","Bordeaux","France",-6,6);
		final Date birthDate = new Date();
		final Utilisateur utilisateur= new Utilisateur("admin","admin",connexion,"adminCategorieOutilEmprunt@myneightool.com","0000000000",adresse,birthDate);
		utilisateur.setRole("ADMIN");
		utilisateurAdmin = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
	}
	
	
	/**
	 * test unitaire création d'un emprunt avec date
	 */
	@Test
	public void testCreateEmpruntWithDate() {
		try {
			
			final Categorie cat1= new Categorie("Sport");
			final Categorie cat= (Categorie) crb.httpRequestXMLBodyCategorie(cat1, "categorie/create",utilisateurAdmin);
			
			final Connexion connexion = new Connexion("loginCreateEmpruntDate",CryptHandler.encodedPw("passwordCreateEmpruntDate"));
			
			final Adresse adresse = new Adresse("18 allée des rues","33000","Bordeaux","France",-45,45);
			final Date birthDate = new Date(0);
			
			final Utilisateur u = new Utilisateur("userPrenomEmpruntDate","userNomEmpruntDate",connexion,"mailemprunt@mail.com","0102030405",adresse,birthDate);
			final Utilisateur uPost= (Utilisateur) crb.httpRequestXMLBody(u,"user/create");
		
			final Outil o= new Outil(uPost,"Haltères","savoir soulever",true,cat,50,new Date(0),new Date(),"http://localhost:8080/uploads/img/haltere.jpg");
			final Outil oPost=(Outil) crb.httpRequestXMLBody(o, "tool/create");
			
						
			
			
			final Date debutT = new Date(0);
			
			
			final Date finT = new Date(0);
			
			
			final Emprunt e = new Emprunt(oPost,uPost,debutT,finT,2);
			final Emprunt ePost = (Emprunt) crb.httpRequestXMLBody(e,"emprunt/create");
					
			Assert.assertNotSame(ePost,null);
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'emprunt", re);
			throw re;
		}
	}
	
	
	
}
