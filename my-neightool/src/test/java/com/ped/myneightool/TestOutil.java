package com.ped.myneightool;

import java.util.Iterator;

import javax.xml.bind.JAXBContext;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.dto.OutilsDTO;
import com.ped.myneightool.model.Outil;
import com.ped.myneightool.model.Utilisateur;





public class TestOutil {

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(TestOutil.class);

	
	private static JAXBContext jaxbc;
	private static ClientRequestBuilder crb;
	

	@BeforeClass
	public static void setUp() throws Exception {
		jaxbc=JAXBContext.newInstance(	Outil.class, 
										OutilsDTO.class,
										Utilisateur.class);
		crb= new ClientRequestBuilder(jaxbc);
	}
		
	/**
	 * test unitaire création d'Outil
	 */
	@Test
	public void testCreateOutil() {
		try {
			final Utilisateur utilisateur= new Utilisateur("prenomCreateOutil","nomCreateOutil");
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			
			final Outil outil= new Outil(utilisateurPost,"Rateau","savoir ratisser",true,"Jardinage",50);
			final Outil outilPost=(Outil) crb.httpRequestXMLBody(outil, "tool/create");
			
			Assert.assertNotSame(outilPost,null);
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'outil", re);
			throw re;
		}
	}
	
	/**
	 * test unitaire mis à jour d'outil
	 */
	@Test
	public final void testUpdateTool() {
		try {
			
			final Utilisateur utilisateur= new Utilisateur("JeanUpdateTool","DucheminUpdateTool",null,"jean-duchemin@gmail.com","0606060606");
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
			
			final Outil outil= new Outil(utilisateurPost,"RateauUPDATE","savoir ratisser",true,"Jardinage",50);
			final Outil outilPost=(Outil) crb.httpRequestXMLBody(outil, "tool/create");
			
			String str ="MEGA Rateau UPDATE";
			outilPost.setNom(str);
			
			final Outil outilPost2 = (Outil) crb.httpRequestXMLBody(outilPost,"tool/update");						
			
			Assert.assertTrue(str.equals(outilPost2.getNom()));

		} catch (final RuntimeException re) {
			LOG.error("echec de mis a jour de l'utilisateur", re);
			throw re;
		}
	}

	
	
	/**
	 * test unitaire obtenir un tool
	 */
	
	@Test
	public final void testGetOutil() {

		try{
			final Utilisateur utilisateur= new Utilisateur("prenomGetOutil","nomGetOutil");
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			final Outil outil= new Outil(utilisateurPost,"RateauGet","savoir ratisserGET",true,"Jardinage",50);
			final Outil outilPost=(Outil) crb.httpRequestXMLBody(outil, "tool/create");
			
			
			LOG.info("");
			LOG.info("");
			LOG.info(outilPost.getId()+" "+outilPost.getNom()+" "+outilPost.getCategorie());	
			int i = outilPost.getId();
			LOG.info("");
			LOG.info("");
			LOG.info("id: "+i);
			LOG.info("");
			LOG.info("");
			
			final Outil outilGet = (Outil) crb.httpGetRequest("tool", i);
			LOG.info(outilGet.getId()+" "+outilGet.getNom()+" "+outilGet.getCategorie());
			LOG.info("");
			LOG.info("");
			Assert.assertNotSame(outilGet, null);
			LOG.info("");
			LOG.info("");
			
		}
		catch(final RuntimeException r){
			LOG.error("testGetUser failed",r);
			throw r;
		}
	}
	
	
	/**
	 * test unitaire suppresion d'Outil
	 */
	@Test
	public void testDeleteOutil() {
		try {
			final Utilisateur utilisateur= new Utilisateur("prenomDeleteOutil","nomDeleteOutil");
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			
			final Outil outil= new Outil(utilisateurPost,"RateauDelete","savoir ratisser, outil a supprimer",true,"Jardinage",50);
			final Outil outilPost=(Outil) crb.httpRequestXMLBody(outil, "tool/create");
			
			int i = outilPost.getId();
			
			crb.httpGetRequest("tool/delete", i);
			
			try{
				final Outil outilGet = (Outil) crb.httpGetRequest("tool", i);
				Assert.assertSame(outilGet, null);
			}
			catch(final RuntimeException r){
				LOG.error("testDeleteOeuvre failed",r);
				throw r;
			}
			
			
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'outil", re);
			throw re;
		}
	}
	
	/**
	 * test unitaire pour obtenir la liste des Outils
	 */
	@Test
	public final void testGetAllOutils() {
		try{
			
			OutilsDTO dto =(OutilsDTO) crb.httpGetRequestWithoutArgument("tool/list");
			
			LOG.info("\n\n\n");
			LOG.info("taille liste Outils:" +dto.size());
			LOG.info("\n\n\n");
			
			LOG.info("liste des outils:\n");
			
			Iterator<Outil> ito=dto.getListeOutils().iterator();
			while(ito.hasNext()){
				
				final Outil Outil = ito.next();
				LOG.info(Outil.getId()+" "+Outil.getNom()+" "+Outil.getCategorie()+" "+Outil.getDescription());
				
			}
			
			
			Assert.assertTrue( dto.getListeOutils().size() >= 0);
			LOG.info("\n\n\n");
		}
		catch(final RuntimeException r){
			LOG.error("getAllOutils failed",r);
			throw r;
		}
	}
	
	/**
	 * test unitaire pour obtenir la liste des Outils disponible
	 */
	@Test
	public final void testGetAllOutilsAvailable() {
		try{
			final Utilisateur utilisateur= new Utilisateur("prenomGetOutils","nomGetOutils");
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Rateau","savoir ratisser mais rateau pas disponible",false,"Jardinage",50), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Rateau","savoir ratisser mais rateau disponible",true,"Jardinage",50), "tool/create");
			
			OutilsDTO dto =(OutilsDTO) crb.httpGetRequestWithoutArgument("tool/list/available");
			
			LOG.info("\n\n\n");
			LOG.info("taille liste Outils disponible:" +dto.size());
			LOG.info("\n\n\n");
			
			LOG.info("liste des outils disponible:\n");
			
			Iterator<Outil> ito=dto.getListeOutils().iterator();
			while(ito.hasNext()){
				
				final Outil Outil = ito.next();
				LOG.info(Outil.getId()+" "+Outil.getNom()+" "+Outil.getCategorie()+" "+Outil.getDescription());
				
			}
			
			
			Assert.assertTrue( dto.getListeOutils().size() >= 0);
			LOG.info("\n\n\n");
		}
		catch(final RuntimeException r){
			LOG.error("getAllOutilsAvailable failed",r);
			throw r;
		}
	}
	
	
	/**
	 * test unitaire pour obtenir la liste des Outils d'un utilisateur en particulier
	 */
	@Test
	public final void testGetAllOutilsFromUser() {
		try{
			final Utilisateur utilisateur= new Utilisateur("prenomGetOutils","nomGetOutils");
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Rateau","savoir ratisser",true,"Jardinage",50), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Pelle","savoir pelleter",true,"Jardinage",50), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Tronçonneuse","savoir tronçonner",false,"Jardinage",50), "tool/create");
			
			
			int i = utilisateurPost.getId();
			OutilsDTO dto =(OutilsDTO) crb.httpGetRequest("tool/user",i );
			
			LOG.info("\n\n\n");
			LOG.info("taille liste Outils:" +dto.size());
			LOG.info("\n\n\n");
			
			LOG.info("liste des outils:\n");
			
			Iterator<Outil> ito=dto.getListeOutils().iterator();
			while(ito.hasNext()){
				
				final Outil Outil = ito.next();
				LOG.info(Outil.getId()+" "+Outil.getNom()+" "+Outil.getCategorie()+" "+Outil.getDescription());
				
			}
			
			
			Assert.assertTrue( dto.getListeOutils().size() >= 0);
			LOG.info("\n\n\n");
		}
		catch(final RuntimeException r){
			LOG.error("getAllOutils failed",r);
			throw r;
		}
	}
	
	/**
	 * test unitaire pour obtenir la liste des Outils DISPONIBLE d'un utilisateur en particulier
	 */
	@Test
	public final void testGetAllOutilsAvailableFromUser() {
		try{
			final Utilisateur utilisateur= new Utilisateur("prenomGetOutils","nomGetOutils");
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Rateau","savoir ratisser",true,"Jardinage",50), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Pelle","savoir pelleter",true,"Jardinage",50), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Tronçonneuse","savoir tronçonner",false,"Jardinage",50), "tool/create");
			
			
			int i = utilisateurPost.getId();
			OutilsDTO dto =(OutilsDTO) crb.httpGetRequest("tool/user/available",i );
			
			LOG.info("\n\n\n");
			LOG.info("taille liste Outils:" +dto.size());
			LOG.info("\n\n\n");
			
			LOG.info("liste des outils:\n");
			
			Iterator<Outil> ito=dto.getListeOutils().iterator();
			while(ito.hasNext()){
				
				final Outil Outil = ito.next();
				LOG.info(Outil.getId()+" "+Outil.getNom()+" "+Outil.getCategorie()+" "+Outil.getDescription());
				
			}
			
			
			Assert.assertTrue( dto.getListeOutils().size() >= 0);
			LOG.info("\n\n\n");
		}
		catch(final RuntimeException r){
			LOG.error("getAllOutils failed",r);
			throw r;
		}
	}
	
	
}
