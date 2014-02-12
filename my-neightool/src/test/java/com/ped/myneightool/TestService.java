package com.ped.myneightool;

import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import org.jboss.resteasy.client.ClientRequest;
import org.jboss.resteasy.client.ClientResponse;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.model.Adresse;
import com.ped.myneightool.model.Connection;
import com.ped.myneightool.model.Utilisateur;





public class TestService {

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(TestService.class);

	private static JAXBContext jc;

	

	@BeforeClass
	public static void setUp() throws Exception {
		
		
		
		jc = JAXBContext.newInstance(Utilisateur.class, Connection.class,Adresse.class);
		
	}
		
	
	
	/**
	 * Requete POST XML
	 * @param o
	 * @param resourceURI
	 * @return
	 */
	public Object httpRequestXMLBody(Object o, String resourceURI) {
		try {

			
			// marshalling/serialisation pour l'envoyer avec une requete post
			final Marshaller marshaller = jc.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
			final java.io.StringWriter sw = new StringWriter();
			marshaller.marshal(o, sw);
						
			
			final ClientRequest request = new ClientRequest(
					"http://localhost:8080/rest/" + resourceURI);

			//request.accept("application/xml");
			request.body("application/xml", o );
			
			
			final ClientResponse<String> response = request.post(String.class);
			
			System.out.println("\n\n"+response.getEntity()+"\n\n");
			
			if (response.getStatus() == 200) { // ok !
				
				
				
				final Unmarshaller un = jc.createUnmarshaller();
				final Object object = (Object) un.unmarshal(new StringReader(response.getEntity()));
				return object;
				
				
			}
		} catch (final Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
		
	/**
	 * Requete POST JSON
	 * @param o
	 * @param resourceURI
	 * @return
	 */
	/*
	public Object httpRequestJSONBody(Object o, String resourceURI) {
		try {

			//System.out.println("\n\n"+o.toString()+"\n\n");
			
			Configuration config = new Configuration();
	        MappedNamespaceConvention con = new MappedNamespaceConvention(config);
	        Writer writer = new OutputStreamWriter(System.out);
	        XMLStreamWriter xmlStreamWriter = new MappedXMLStreamWriter(con, writer);
			
			
			// marshalling/serialisation pour l'envoyer avec une requete post
			final Marshaller marshaller = jc.createMarshaller();
			//marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
			//final java.io.StringWriter sw = new StringWriter();
			marshaller.marshal(o, xmlStreamWriter);
			
			
						
			
			
			
			final ClientRequest request = new ClientRequest(
					"http://localhost:8080/rest/" + resourceURI);

			request.accept("application/json");
			request.body("application/json", o );
			
			
			final ClientResponse<String> response = request.post(String.class);

			
			if (response.getStatus() == 200) { // ok !
				
				/*
				BufferedReader br=new BufferedReader(new InputStreamReader(new ByteArrayInputStream(response.getEntity().getBytes())));
				String output;
				while((output=br.readLine())!=null){
					System.out.println(output);
				}*/
				
				/*
				Unmarshaller u = jc.createUnmarshaller();
				StringBuffer xmlStr = new StringBuffer( response.getEntity() );
				Object object = u.unmarshal( new StreamSource( new StringReader( xmlStr.toString() ) ) );
				return object;
					*/
				/*
				StreamSource json=new StreamSource(response.getEntity());
				Object object1 = un.unmarshal(json,Object.class).getValue();
				
				return object1;
				  */
				
				/*
				JSONObject JSONObject = new JSONObject(response.getEntity());
				final Object object2=(Object) un.unmarshal(new MappedXMLStreamReader(JSONObject));
				*/
				
				//System.out.println("\n\n"+object.toString()+"\n\n");
				/*
				
				
			}
		} catch (final Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	*/
	
	
	/**
	 * Requete GET
	 * @param resourceURI
	 * @param id
	 * @return
	 * 
	 */
	public Object httpGetRequest(String resourceURI, int id){
		try {
			ClientRequest request;
			request = new ClientRequest("http://localhost:8080/rest/" + resourceURI + "/" + id);
			request.accept("application/xml");
			ClientResponse<String> response = request.get(String.class);
			if (response.getStatus() == 200)
			{
				Unmarshaller un = jc.createUnmarshaller();
				Object o = un.unmarshal(new StringReader(response.getEntity()));
				return o;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
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
	 * test unitaire création d'utilisateur
	 */
	@Test
	public void testCreateUserXMLWithAddress() {
		try {
			final Connection connexion = new Connection("loginCreate","passwordCreate");
			final Adresse adresse = new Adresse("666 rue des pigeons meurtriers","33000","Bordeaux","France",-666,666);
			
			//final Utilisateur utilisateur = new Utilisateur("test", "xml");
			final Utilisateur utilisateur2= new Utilisateur("JeanCreate","DucheminCreate",connexion,"jean-duchemin@gmail.com","0606060606",adresse);
			final Utilisateur utilisateurPost = (Utilisateur) httpRequestXMLBody(utilisateur2,"user/create");
			
						
			Assert.assertNotSame(utilisateurPost,null);
			
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'utilisateur", re);
			throw re;
		}
	}
	
	/**
	 * test unitaire création d'utilisateur
	 */
	@Test
	public void testCreateUserXML() {
		try {
			final Connection connexion = new Connection("loginCreate","passwordCreate");
			
			//final Utilisateur utilisateur = new Utilisateur("test", "xml");
			final Utilisateur utilisateur2= new Utilisateur("JeanCreate","DucheminCreate",connexion,"jean-duchemin@gmail.com","0606060606");
			final Utilisateur utilisateurPost = (Utilisateur) httpRequestXMLBody(utilisateur2,"user/create");
			
						
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
			final Connection connexion = new Connection("loginUpdate","passwordUpdate");
			final Utilisateur utilisateur= new Utilisateur("JeanUpdate","DucheminUpdate",connexion,"jean-duchemin@gmail.com","0606060606");
			final Utilisateur utilisateurPost = (Utilisateur) httpRequestXMLBody(utilisateur,"user/create");
			
			String str="1234567890";
			utilisateurPost.setTelephone(str);
			final Utilisateur utilisateurPost2 = (Utilisateur) httpRequestXMLBody(utilisateurPost,"user/update");						
			
			Assert.assertTrue(str.equals(utilisateurPost2.getTelephone()));

		} catch (final RuntimeException re) {
			LOG.error("echec de mis a jour de l'utilisateur", re);
			throw re;
		}
	}

	
	
	/**
	 * test unitaire obtenir un utilisateur
	 */
	
	@Test
	public final void testGetUser() {

		try{
			final Connection connexion = new Connection("loginGet","passwordGet");
			final Utilisateur utilisateur= new Utilisateur("JeanGet","DucheminGet",connexion,"jean-duchemin@gmail.com","0606060606");
			final Utilisateur utilisateurPost = (Utilisateur) httpRequestXMLBody(utilisateur,"user/create");
			
			LOG.info("");
			LOG.info("");
			LOG.info(utilisateurPost.getId()+" "+utilisateurPost.getPrenom()+" "+utilisateurPost.getNom()+" "+utilisateurPost.getTelephone());	
			int i = utilisateurPost.getId();
			LOG.info("");
			LOG.info("");
			LOG.info("id: "+i);
			LOG.info("");
			LOG.info("");
			
			final Utilisateur utilisateurGet = (Utilisateur) httpGetRequest("user", i);
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
			final Connection connexion = new Connection("loginDelete","passwordDelete");
			final Utilisateur utilisateur= new Utilisateur("JeanDelete","DucheminDelete",connexion,"jean-duchemin@gmail.com","0606060606");
			final Utilisateur utilisateurPost = (Utilisateur) httpRequestXMLBody(utilisateur,"user/create");
					
					
			int i = utilisateurPost.getId();
			LOG.info("n");
			LOG.info("");
			LOG.info("id: "+i);
			LOG.info("");
			LOG.info("");
					 
			httpGetRequest("user/delete", i);
					
			
			try{
				final Utilisateur utilisateurGet = (Utilisateur) httpGetRequest("user", i);
				Assert.assertSame(utilisateurGet, null);
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
	
}
