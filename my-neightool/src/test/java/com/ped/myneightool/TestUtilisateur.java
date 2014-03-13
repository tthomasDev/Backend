package com.ped.myneightool;

import java.util.Date; 
import java.util.Iterator;

import javax.xml.bind.JAXBContext;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.dto.UtilisateursDTO;
import com.ped.myneightool.model.Adresse;
import com.ped.myneightool.model.Connexion;
import com.ped.myneightool.model.Utilisateur;


public class TestUtilisateur {
	
	

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(TestUtilisateur.class);

	
	private static JAXBContext jaxbc;
	private static ClientRequestBuilder crb;
	

	@BeforeClass
	public static void setUp() throws Exception {
		jaxbc=JAXBContext.newInstance(	Utilisateur.class,
										UtilisateursDTO.class,
										Connexion.class,
										Adresse.class,
										Adresse.class,
										Date.class);
		crb= new ClientRequestBuilder(jaxbc);
	}
		
	
	
	/*
	@Test
	public void testCreateUserJSON() {
		try {
			
			final Utilisateur utilisateur = new Utilisateur("test", "json");
			final Utilisateur utilisateurPost = (Utilisateur) httpRequestJSONBody(utilisateur,"user/create");
			
						
			Assert.assertNotSame(utilisateurPost,null);
			
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'utilisateur", re);
			throw re;
		}
	}
	*/
	
	
	/**
	 * test unitaire création d'utilisateur sans adresse
	 */
	@Test
	public void testCreateUser() {
		try {
			final Connexion connexion = new Connexion("loginCreate1",CryptHandler.encodedPw("passwordCreate"));
						
			final Utilisateur utilisateur= new Utilisateur("JeanCreate","DucheminCreate",connexion,"1jean-duchemin@gmail.com","0606060606");
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
					
			Assert.assertNotSame(utilisateurPost,null);
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'utilisateur", re);
			throw re;
		}
	}
	
	/**
	 * test unitaire création d'utilisateur fonctionnel pour le frontend
	 */
	@Test
	public void testCreateUserForFrontEnd() {
		try {
			final Connexion connexion = new Connexion("user",CryptHandler.encodedPw("user"));
			final Adresse adresse = new Adresse("666 rue des allées","33000","Bordeaux","France",-666,666);
			final Date birthDate = new Date();
			
			final Utilisateur utilisateur= new Utilisateur("user","user",connexion,"user@myneightool.com","0000000000",adresse,birthDate);
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
						
			Assert.assertNotSame(utilisateurPost,null);
			
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'utilisateur", re);
			throw re;
		}
	}
	
	
	/**
	 * test unitaire création d'un administrateur fonctionnel pour le frontend
	 */
	@Test
	public void testCreateAdminForFrontEnd() {
		try {
			final Connexion connexion = new Connexion("admin",CryptHandler.encodedPw("admin"));
			final Adresse adresse = new Adresse("666 rue des pigeons meurtriers","33000","Bordeaux","France",-666,666);
			final Date birthDate = new Date();
			
			final Utilisateur utilisateur= new Utilisateur("admin","admin",connexion,"admin@myneightool.com","0000000000",adresse,birthDate);
			utilisateur.setRole("ADMIN");
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
						
			Assert.assertNotSame(utilisateurPost,null);
			
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'utilisateur", re);
			throw re;
		}
	}
	
	
	/**
	 * test unitaire création d'utilisateur avec adresse et date
	 */
	@Test
	public void testCreateUserWithBirthDate() {
		try {
			final Connexion connexion = new Connexion("2loginCreate",CryptHandler.encodedPw("passwordCreate"));
			final Adresse adresse = new Adresse("666 rue des pigeons meurtriers","33000","Bordeaux","France",-666,666);
			final Date birthDate = new Date();
			final Utilisateur utilisateur= new Utilisateur("JeanCreate","DucheminCreate",connexion,"2jean-duchemin@gmail.com","0606060606",adresse,birthDate);
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
						
			Assert.assertNotSame(utilisateurPost,null);
			
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'utilisateur", re);
			throw re;
		}
	}
	
	
	/**
	 * test unitaire mis à jour d'utilisateur
	 */
	@Test
	public final void testUpdateUser() {
		try {
			final Connexion connexion = new Connexion("3loginUpdate",CryptHandler.encodedPw("passwordUpdate"));
			final Utilisateur utilisateur= new Utilisateur("JeanUpdate","DucheminUpdate",connexion,"3jean-duchemin@gmail.com","0606060606");
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
			String str="1234567890";
			utilisateurPost.setTelephone(str);
			final Utilisateur utilisateurPost2 = (Utilisateur) crb.httpRequestXMLBody(utilisateurPost,"user/update");						
			
			Assert.assertTrue(str.equals(utilisateurPost2.getTelephone()));

		} catch (final RuntimeException re) {
			LOG.error("echec de mis a jour de l'utilisateur", re);
			throw re;
		}
	}

	
	
	/**
	 * test unitaire obtenir un utilisateur par son id
	 */
	
	@Test
	public final void testGetUserById() {

		try{
			final Connexion connexion = new Connexion("4loginGet",CryptHandler.encodedPw("passwordGet"));
			final Utilisateur utilisateur= new Utilisateur("JeanGet","DucheminGet",connexion,"4jean-duchemin@gmail.com","0606060606");
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
			LOG.info("");
			LOG.info("");
			LOG.info(utilisateurPost.getId()+" "+utilisateurPost.getPrenom()+" "+utilisateurPost.getNom()+" "+utilisateurPost.getTelephone());	
			int i = utilisateurPost.getId();
			LOG.info("");
			LOG.info("");
			LOG.info("id: "+i);
			LOG.info("");
			LOG.info("");
			
			final Utilisateur utilisateurGet = (Utilisateur) crb.httpGetRequest("user", i);
			LOG.info(utilisateurGet.getId()+" "+utilisateurGet.getPrenom()+" "+utilisateurGet.getNom()+" "+utilisateurGet.getTelephone());
			LOG.info("");
			LOG.info("");
			Assert.assertNotSame(utilisateurGet, null);
			LOG.info("");
			LOG.info("");
			
		}
		catch(final RuntimeException r){
			LOG.error("testGetUser failed",r);
			throw r;
		}
	}
	
	
	/**
	 * test unitaire obtenir un utilisateur par son login
	 */
	
	@Test
	public final void testGetUserByLogin() {

		try{
			final Connexion connexion = new Connexion("loginGetUserByLogin",CryptHandler.encodedPw("fdkjfds"));
			final Utilisateur utilisateur= new Utilisateur("JeanGet","DucheminGet",connexion,"pommeDeTerre@gmail.com","0606060606");
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
			
			LOG.info("");
			LOG.info("");
			LOG.info(utilisateurPost.getId()+" "+utilisateurPost.getPrenom()+" "+utilisateurPost.getNom()+" "+utilisateurPost.getTelephone());	
			
			String i = utilisateurPost.getConnexion().getLogin();
			LOG.info("");
			LOG.info("");
			LOG.info("Login: "+i);
			LOG.info("");
			LOG.info("");
			
			final Utilisateur utilisateurGet = (Utilisateur) crb.httpGetRequest("user/login", i);
			LOG.info(utilisateurGet.getId()+" "+utilisateurGet.getPrenom()+" "+utilisateurGet.getNom()+" "+utilisateurGet.getTelephone());
			LOG.info("");
			LOG.info("");
			Assert.assertNotSame(utilisateurGet, null);
			LOG.info("");
			LOG.info("");
			
		}
		catch(final RuntimeException r){
			LOG.error("testGetUser failed",r);
			throw r;
		}
	}
	
	
	/**
	 * test unitaire supprimer un utilisateur
	 */
	
	@Test
	public final void testDeleteUser() {

		try{
			final Connexion connexion = new Connexion("admin1",CryptHandler.encodedPw("admin1"));
			final Utilisateur utilisateur= new Utilisateur("JeanDelete","DucheminDelete",connexion,"5jean-duchemin@gmail.com","0606060606");
			utilisateur.setRole("ADMIN");
			final Utilisateur utilisateurPost = (Utilisateur) crb.httpRequestXMLBody(utilisateur,"user/create");
					
					
			int i = utilisateurPost.getId();
			LOG.info("n");
			LOG.info("");
			LOG.info("id: "+i);
			LOG.info("");
			LOG.info("");
					 
			crb.httpGetRequest("user/delete", i,utilisateurPost);
					
			
			try{
				final Utilisateur utilisateurGet = (Utilisateur) crb.httpGetRequest("user", i);
				Assert.assertSame(utilisateurGet, null);
				Assert.assertTrue(true);
			}
			catch(final RuntimeException r){
				LOG.error("testDeleteOeuvre failed",r);
				throw r;
			}
					
			
			
		}
		catch(final RuntimeException r){
			LOG.error("testDeleteOeuvre failed",r);
			throw r;
		}
	}
	
	/**
	 * test unitaire pour obtenir la liste des utilisateurs
	 */
	@Test
	public final void testGetAllUsers() {
		try{
		
			UtilisateursDTO dto =(UtilisateursDTO) crb.httpGetRequestWithoutArgument("user/list");
			
			LOG.info("\n\n\n");
			LOG.info("taille liste utilisateurs:" +dto.size());
			LOG.info("\n\n\n");
			
			LOG.info("liste des artistes:\n");
			
			Iterator<Utilisateur> ito=dto.getListeUtilisateurs().iterator();
			while(ito.hasNext()){
				
				final Utilisateur utilisateur = ito.next();
				LOG.info(utilisateur.getId()+" "+utilisateur.getPrenom()+" "+utilisateur.getNom()+" "+utilisateur.getMail());
				
			}
			
			
			Assert.assertTrue( dto.getListeUtilisateurs().size() >= 0);
			LOG.info("\n\n\n");
		}
		catch(final RuntimeException r){
			LOG.error("getAllUtilisateurs failed",r);
			throw r;
		}
	}
	
}
