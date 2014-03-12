package com.ped.myneightool;


import java.util.Date;
import java.util.Iterator;

import javax.xml.bind.JAXBContext;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.dto.CategoriesDTO;
import com.ped.myneightool.dto.UtilisateursDTO;
import com.ped.myneightool.model.Adresse;
import com.ped.myneightool.model.Categorie;
import com.ped.myneightool.model.Connexion;
import com.ped.myneightool.model.Utilisateur;





public class TestCategorie {

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(TestCategorie.class);

	
	private static JAXBContext jaxbc;
	private static ClientRequestBuilder crb;
	private static Utilisateur utilisateurAdmin;
	

	@BeforeClass
	public static void setUp() throws Exception {
		jaxbc=JAXBContext.newInstance(	Utilisateur.class,
										UtilisateursDTO.class,
										Connexion.class,
										Adresse.class,
										Categorie.class,
										CategoriesDTO.class,
										Date.class);
		crb= new ClientRequestBuilder(jaxbc);
		
		try {
			final Connexion connexion = new Connexion("adminCategorie","admin");
			final Adresse adresse = new Adresse("666 rue des pigeons meurtriers","33000","Bordeaux","France",-666,666);
			final Date birthDate = new Date();
			
			final Utilisateur utilisateur= new Utilisateur("admin","admin",connexion,"adminCategorie@myneightool.com","0000000000",adresse,birthDate);
			utilisateur.setRole("ADMIN");
			utilisateurAdmin = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
									
					
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'utilisateur", re);
			throw re;
		}		
				
		
	}
	
	/**
	 * test unitaire création d'une categorie
	 */
	@Test
	public void testCreateCategorie() {
		try {
			
			final Categorie categorie = new Categorie("Salle de Bain");
			final Categorie categoriePost = (Categorie) crb.httpRequestXMLBodyCategorie(categorie,"categorie/create",utilisateurAdmin);
			
			Assert.assertNotSame(categoriePost,null);
						
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de la categorie", re);
			throw re;
		}
	}
	
	
	/**
	 * test unitaire obtenir un categorie
	 */
	@Test
	public final void testGetCategorie() {

		try{
			
			final Categorie categorie = new Categorie("Voiture");
			final Categorie categoriePost = (Categorie) crb.httpRequestXMLBodyCategorie(categorie,"categorie/create",utilisateurAdmin);
			
			Assert.assertNotSame(categoriePost,null);
			
			int i = categoriePost.getId();
			LOG.info(""+categoriePost.getId()+"");
			
			
			final Categorie categorieGet =(Categorie) crb.httpGetRequest("categorie",i);
			LOG.info(""+categorieGet.getId()+"");
			
			Assert.assertNotSame(categorieGet,null);
						
			
		}
		catch(final RuntimeException r){
			LOG.error("testGetUser failed",r);
			throw r;
		}
	}
	
	
	
	/**
	 * test unitaire pour obtenir la liste des Categories
	 */
	@Test
	public final void testGetAllCategories() {
		try{
			
			CategoriesDTO dto =(CategoriesDTO) crb.httpGetRequestWithoutArgument("categorie/list");
			
			LOG.info("\n\n\n");
			LOG.info("taille liste Categories:" +dto.size());
			LOG.info("\n\n\n");
			
			LOG.info("liste des categories:\n");
			
			Iterator<Categorie> ito=dto.getListeCategories().iterator();
			while(ito.hasNext()){
				
				final Categorie categorie = ito.next();
				LOG.info(categorie.getId()+" "+categorie.getNom());
				
			}
			
			
			Assert.assertTrue( dto.getListeCategories().size() > 0);
			LOG.info("\n\n\n");
		}
		catch(final RuntimeException r){
			LOG.error("getAllCategories failed",r);
			throw r;
		}
	}
	
}