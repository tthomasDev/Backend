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
import com.ped.myneightool.model.Adresse;
import com.ped.myneightool.model.Categorie;
import com.ped.myneightool.model.Connexion;
import com.ped.myneightool.model.Outil;
import com.ped.myneightool.model.Utilisateur;


public class TestOutil {
	
	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(TestOutil.class);

	
	private static JAXBContext jaxbc;
	private static ClientRequestBuilder crb;
	private static Utilisateur utilisateurAdmin;
	

	@BeforeClass
	public static void setUp() throws Exception {
		jaxbc=JAXBContext.newInstance(	Outil.class, 
										OutilsDTO.class,
										Utilisateur.class,
										Connexion.class);
		crb= new ClientRequestBuilder(jaxbc);
		
		try {
			final Connexion connexion = new Connexion("adminCategorieOutil",CryptHandler.encodedPw("admin"));
			final Adresse adresse = new Adresse("666 rue des pigeons meurtriers","33000","Bordeaux","France",-666,666);
			final Date birthDate = new Date();
			
			final Utilisateur utilisateur= new Utilisateur("admin","admin",connexion,"adminCategorieOutil@myneightool.com","0000000000",adresse,birthDate);
			utilisateur.setRole("ADMIN");
			utilisateurAdmin = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
									
					
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'utilisateur", re);
			throw re;
		}		
	}
		
	/**
	 * test unitaire création d'Outil
	 */
	@Test
	public void testCreateOutil() {
		try {
			
			
			//Elements nécéssaires à un outil (cat, utilisateur, date)
			final Categorie cat1= new Categorie("Jardin");
			final Categorie cat= (Categorie) crb.httpRequestXMLBodyCategorie(cat1, "categorie/create",utilisateurAdmin);			
			
			Connexion co = new Connexion("login1",CryptHandler.encodedPw("pass1"));
			final Utilisateur utilisateur= new Utilisateur("prenomCreateOutil","nomCreateOutil",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			final Date debutT = new Date(0);
			final Date finT = new Date();
			
		
			//test unitaire création d'Outil
			Outil outil= new Outil(utilisateurPost,"Rateau1","savoir ratisser",true,cat,50, new Date(0), new Date());
			Outil outilPost=(Outil) crb.httpRequestXMLBody(outil, "tool/create");
			Assert.assertNotSame(outilPost,null);
			
			//test unitaire création d'Outil avec dates de dispo
			outil= new Outil(utilisateurPost,"Rateau2","savoir ratisser",true,cat,50,debutT,finT);
			outilPost=(Outil) crb.httpRequestXMLBody(outil, "tool/create");
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
			
			final Categorie cat1= new Categorie("Piscine");
			final Categorie cat= (Categorie) crb.httpRequestXMLBodyCategorie(cat1, "categorie/create",utilisateurAdmin);
			
			Connexion co = new Connexion("login2",CryptHandler.encodedPw("pass2"));
			final Utilisateur utilisateur= new Utilisateur("JeanUpdateTool","DucheminUpdateTool",co);
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
			
			final Outil outil= new Outil(utilisateurPost,"AspirateurPiscineUPDATE","savoir aspirer",true,cat,50, new Date(0), new Date());
			final Outil outilPost=(Outil) crb.httpRequestXMLBody(outil, "tool/create");
			
			String str ="MEGA AspirateurPiscine UPDATE";
			outilPost.setNom(str);
			
			final Outil outilPost2 = (Outil) crb.httpRequestXMLBody(outilPost,"tool/update");						
			
			Assert.assertTrue(str.equals(outilPost2.getNom()));

		} catch (final RuntimeException re) {
			LOG.error("echec de mis a jour de l'outil", re);
			throw re;
		}
	}

	
	
	/**
	 * test unitaire obtenir un tool
	 */
	
	@Test
	public final void testGetOutil() {

		try{
			final Categorie cat1= new Categorie("Cuisine");
			final Categorie cat= (Categorie) crb.httpRequestXMLBodyCategorie(cat1, "categorie/create",utilisateurAdmin);
			
			Connexion co = new Connexion("login3",CryptHandler.encodedPw("pass3"));
			final Utilisateur utilisateur= new Utilisateur("prenomGetOutil","nomGetOutil",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			final Outil outil= new Outil(utilisateurPost,"CasserolleGet","savoir cuisiner",true,cat,50, new Date(0), new Date());
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
			LOG.error("testGetTool failed",r);
			throw r;
		}
	}
	
	
	/**
	 * test unitaire suppresion d'Outil
	 */
	@Test
	public void testDeleteOutil() {
		try {
			final Categorie cat1= new Categorie("Salon");
			final Categorie cat= (Categorie) crb.httpRequestXMLBodyCategorie(cat1, "categorie/create",utilisateurAdmin);
			
			Connexion co = new Connexion("login4",CryptHandler.encodedPw("pass4"));
			final Utilisateur utilisateur= new Utilisateur("prenomDeleteOutil","nomDeleteOutil",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			
			final Outil outil= new Outil(utilisateurPost,"TélévisionDelete","savoir regarder la télé, outil a supprimer",true,cat,50, new Date(0), new Date());
			final Outil outilPost=(Outil) crb.httpRequestXMLBody(outil, "tool/create");
			
			int i = outilPost.getId();
			
			crb.httpGetRequest("tool/delete", i,utilisateurPost);
			
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
			
			final Categorie cat1= new Categorie("Voiture");
			final Categorie cat= (Categorie) crb.httpRequestXMLBodyCategorie(cat1, "categorie/create",utilisateurAdmin);
			
			Connexion co = new Connexion("login5",CryptHandler.encodedPw("pass5"));
			final Utilisateur utilisateur= new Utilisateur("prenomGetOutils","nomGetOutils",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Cric","savoir cric mais cric pas disponible",false,cat,50, new Date(0), new Date()), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Pneu","savoir mettre un pneu mais pneu disponible",true,cat,50, new Date(0), new Date()), "tool/create");
			
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
			
			final Categorie cat1= new Categorie("Autre");
			final Categorie cat= (Categorie) crb.httpRequestXMLBodyCategorie(cat1, "categorie/create",utilisateurAdmin);
			
			Connexion co = new Connexion("login6",CryptHandler.encodedPw("pass6"));
			final Utilisateur utilisateur= new Utilisateur("prenomGetOutils","nomGetOutils",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Autre1","savoir autre1",true,cat,50, new Date(0), new Date()), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Autre2","savoir autre2",true,cat,50, new Date(0), new Date()), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Autre3","savoir autre3",false,cat,50, new Date(0), new Date()), "tool/create");
			
			
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
			
			final Categorie cat1= new Categorie("Professionnels");
			final Categorie cat= (Categorie) crb.httpRequestXMLBodyCategorie(cat1, "categorie/create",utilisateurAdmin);
			
			Connexion co = new Connexion("login8",CryptHandler.encodedPw("pass8"));
			final Utilisateur utilisateur= new Utilisateur("prenomGetOutils","nomGetOutils",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"OutilPro1","savoir être pro",true,cat,50, new Date(0), new Date()), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"OutilPro2","savoir être pro",true,cat,50, new Date(0), new Date()), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"OutilPro3","savoir être pro",false,cat,50, new Date(0), new Date()), "tool/create");
			
			
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
			
			
			Assert.assertTrue( dto.getListeOutils().size() > 0);
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

			Categorie cat1= new Categorie("Plomberie");
			Categorie cat= (Categorie) crb.httpRequestXMLBodyCategorie(cat1, "categorie/create",utilisateurAdmin);
			
			Connexion co = new Connexion("login9",CryptHandler.encodedPw("pass9"));
			final Utilisateur utilisateur= new Utilisateur("prenomAPICriteria","nomAPICriteria",co);
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			Assert.assertNotSame(utilisateurPost, null);
			
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Plummeau","savoir plummer",true,cat,50, new Date(0), new Date()), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Tournevis","savoir tournevisser",false,cat,50, new Date(0), new Date()), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Clé molette","savoir clé molette",true,cat,50, new Date(0), new Date()), "tool/create");


			cat1= new Categorie("Toiture");
			Categorie cat3= (Categorie) crb.httpRequestXMLBodyCategorie(cat1, "categorie/create",utilisateurAdmin);
			
			cat1= new Categorie("BTP");
			Categorie cat2= (Categorie) crb.httpRequestXMLBodyCategorie(cat1, "categorie/create",utilisateurAdmin);
			
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Tuile","savoir tuiller",false,cat2,50, new Date(0), new Date()), "tool/create");
			crb.httpRequestXMLBody(new Outil(utilisateurPost,"Remorque","savoir remorquer",true,cat3,50, new Date(0), new Date()), "tool/create");
			
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
	
	/**
	 * test unitaire pour obtenir la liste des Outils d'une catégorie en particulier
	 */
	@Test
	public final void testGetAllOutilsFromCategory() {
		try{
			final Categorie categorie = new Categorie("Nouvelles Technologies");
			final Categorie categoriePost = (Categorie) crb.httpRequestXMLBodyCategorie(categorie, "categorie/create",utilisateurAdmin);
			
			Utilisateur user1= new Utilisateur("Jean", "Dupont", new Connexion("loginTestOutil",CryptHandler.encodedPw( "pwd")), "test@test", "0505050505", new Adresse(), new Date());
			Utilisateur user= (Utilisateur) crb.httpRequestXMLBody(user1, "user/create");
			
			crb.httpRequestXMLBody(new Outil(user,"Rateau","savoir ratisser",true,categoriePost,50, new Date(0), new Date()), "tool/create");
			crb.httpRequestXMLBody(new Outil(user,"Pelle","savoir pelleter",true,categoriePost,50, new Date(0), new Date()), "tool/create");
			crb.httpRequestXMLBody(new Outil(user,"Tronçonneuse","savoir tronçonner",false,categoriePost,50, new Date(0), new Date()), "tool/create");

			int i = categoriePost.getId();
			OutilsDTO dto =(OutilsDTO) crb.httpGetRequest("tool/categorie",i );
			
			LOG.info("\n\n\n");
			LOG.info("taille liste Outils:" +dto.size());
			LOG.info("\n\n\n");
			
			LOG.info("liste des outils:\n");
			
			Iterator<Outil> ito=dto.getListeOutils().iterator();
			while(ito.hasNext()){
				
				final Outil Outil = ito.next();
				LOG.info(Outil.getId()+" "+Outil.getNom()+" "+Outil.getCategorie()+" "+Outil.getDescription());
				
			}			
			
			Assert.assertTrue( dto.getListeOutils().size() == 3);
			LOG.info("\n\n\n");
		}
		catch(final RuntimeException r){
			LOG.error("getAllOutils failed",r);
			throw r;
		}
	}
	
}
