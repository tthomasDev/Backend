package com.ped.myneightool;

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
	

	@BeforeClass
	public static void setUp() throws Exception {
		jaxbc=JAXBContext.newInstance(	Utilisateur.class,
										UtilisateursDTO.class,
										Connexion.class,
										Adresse.class,
										Categorie.class,
										CategoriesDTO.class);
		crb= new ClientRequestBuilder(jaxbc);
		
			
		
	}
	
	/**
	 * test unitaire création d'un categorie
	 */
	@Test
	public void testCreateCategorie() {
		try {
			
			final Categorie categorie = new Categorie("Jardin");
			final Categorie categoriePost = (Categorie) crb.httpRequestXMLBody(categorie,"categorie/create");
			
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
			final Categorie categoriePost = (Categorie) crb.httpRequestXMLBody(categorie,"categorie/create");
			
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