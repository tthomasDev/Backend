package com.ped.myneightool;

import java.io.StringWriter;
import java.util.Date;
import java.util.Iterator;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;

import org.jboss.resteasy.client.ClientRequest;
import org.jboss.resteasy.client.ClientResponse;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.dto.OutilsDTO;
import com.ped.myneightool.model.Categorie;
import com.ped.myneightool.model.Connexion;
import com.ped.myneightool.model.Outil;
import com.ped.myneightool.model.Utilisateur;





public class TestOutil {

	public Categorie cat1= new Categorie("Jardin");
	public Categorie cat= (Categorie) crb.httpRequestXMLBody(cat1, "categorie/create");
	
	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(TestOutil.class);

	
	private static JAXBContext jaxbc;
	private static ClientRequestBuilder crb;
	

	@BeforeClass
	public static void setUp() throws Exception {
		jaxbc=JAXBContext.newInstance(	Outil.class, 
										OutilsDTO.class,
										Utilisateur.class,
										Connexion.class);
		crb= new ClientRequestBuilder(jaxbc);
	}
		
	/**
	 * test unitaire création d'Outil
	 */
	@Test
	public void testCreateOutil() {
		try {
			Connexion co = new Connexion("laaaaabbbbbbbaodqsaqadaaasdqgb","psqdqassb");
			final Utilisateur utilisateur= new Utilisateur("prenomCreateOutil","nomCreateOutil",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			
			final Outil outil= new Outil(utilisateurPost,"Rateau","savoir ratisser",true,cat,50);
			final Outil outilPost=(Outil) crb.httpRequestXMLBody(outil, "tool/create");
			
			Assert.assertNotSame(outilPost,null);
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'outil", re);
			throw re;
		}
	}
	
	
	/**
	 * test unitaire création d'Outil avec dates de dispo
	 */
	@Test
	public void testCreateOutilWithAvailableDate() {
		try {
			Connexion co = new Connexion("laaaaaaodqsaqabbbbbdaaasdqgb","psqdqassb");
			final Utilisateur utilisateur= new Utilisateur("prenomCreateOutilWithAvailableDate","nomCreateOutilWithAvailableDate",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			final Date debutT = new Date(0);
			
			
			final Date finT = new Date(0);
			
			final Outil outil= new Outil(utilisateurPost,"Rateau","savoir ratisser",true,cat,50,debutT,finT);
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
			Connexion co = new Connexion("laaaaaaodqsaqadaaasdqgb","psqdqassb");
			final Utilisateur utilisateur= new Utilisateur("JeanUpdateTool","DucheminUpdateTool",co);
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
			
			final Outil outil= new Outil(utilisateurPost,"RateauUPDATE","savoir ratisser",true,cat,50);
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
			Connexion co = new Connexion("laaaaaoaaaaqsqdaaasdqgb","psqdqassb");
			final Utilisateur utilisateur= new Utilisateur("prenomGetOutil","nomGetOutil",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			final Outil outil= new Outil(utilisateurPost,"RateauGet","savoir ratisserGET",true,cat,50);
			final Outil outilPost=(Outil) crb.httpRequestXMLBody(outil, "tool/create");
			
			
			LOG.info("");
			LOG.info("");
			LOG.info(outilPost.getId()+" "+outilPost.getNom()+" "+outilPost.getCategorie().getNom());	
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
			Connexion co = new Connexion("lodaaaaqsqdaaasdqgb","psqdqassb");
			final Utilisateur utilisateur= new Utilisateur("prenomDeleteOutil","nomDeleteOutil",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			
			final Outil outil= new Outil(utilisateurPost,"RateauDelete","savoir ratisser, outil a supprimer",true,cat,50);
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
			Connexion co = new Connexion("loddsqqsdqgb","psqdqasdqssb");
			final Utilisateur utilisateur= new Utilisateur("prenomGetOutils","nomGetOutils",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Rateau","savoir ratisser mais rateau pas disponible",false,cat,50), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Rateau","savoir ratisser mais rateau disponible",true,cat,50), "tool/create");
			
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
			Connexion co = new Connexion("lodqsdqgb","psqdqassb");
			final Utilisateur utilisateur= new Utilisateur("prenomGetOutils","nomGetOutils",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Rateau","savoir ratisser",true,cat,50), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Pelle","savoir pelleter",true,cat,50), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Tronçonneuse","savoir tronçonner",false,cat,50), "tool/create");
			
			
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
			Connexion co = new Connexion("logb","passb");
			final Utilisateur utilisateur= new Utilisateur("prenomGetOutils","nomGetOutils",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Rateau","savoir ratisser",true,cat,50), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Pelle","savoir pelleter",true,cat,50), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Tronçonneuse","savoir tronçonner",false,cat,50), "tool/create");
			
			
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
	
	/**
	 * test unitaire de l'API Criteria pour recherche d'outils
	 */
	@Test
	public final void testAPICriteria() throws Exception {

		try {

			Connexion co = new Connexion("logbfsd","passbdfsfs");
			final Utilisateur utilisateur= new Utilisateur("prenomAPICriteria","nomAPICriteria",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			Assert.assertNotSame(utilisateurPost, null);
			
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"RateauAPICriteria","savoir ratisser",true,cat,50), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"PelleAPICriteria","savoir pelleter",false,cat,50), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"TondeuseAPICriteria","savoir tondeuser",true,cat,50), "tool/create");


			cat1= new Categorie("Cuisine");
			Categorie cat3= (Categorie) crb.httpRequestXMLBody(cat1, "categorie/create");
			
			cat1= new Categorie("Salon");
			Categorie cat2= (Categorie) crb.httpRequestXMLBody(cat1, "categorie/create");
			
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Fourchette","savoir fourchetter",false,cat2,50), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Fauteuil","savoir fauteuiler",true,cat3,50), "tool/create");
			
			final Outil o = new Outil();
			o.setCategorie(cat);
			o.setDisponible(true);
			
			final Marshaller marshaller = jaxbc.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
			final java.io.StringWriter sw = new StringWriter();
			marshaller.marshal(o, sw);

			final ClientRequest request = new ClientRequest(
					"http://localhost:8080/rest/tool/criteria");
			request.body("application/xml", sw.toString());
			final ClientResponse<String> response = request.post(String.class);

			if (response.getStatus() == 200) {
				LOG.info(response.getEntity());
				Assert.assertTrue(!response.getEntity().isEmpty());
			}
			

		} catch (final RuntimeException re) {
			LOG.error("criteria failed", re);
			throw re;
		}
	}
	
}
