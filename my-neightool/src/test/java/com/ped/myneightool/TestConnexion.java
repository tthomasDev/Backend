package com.ped.myneightool;

import java.io.StringWriter;

import javax.xml.bind.DatatypeConverter;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;

import org.jboss.resteasy.client.ClientRequest;
import org.jboss.resteasy.client.ClientResponse;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.model.Connexion;
import com.ped.myneightool.model.Utilisateur;






public class TestConnexion {

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(TestConnexion.class);

	
	private static JAXBContext jaxbc;
	private static ClientRequestBuilder crb;
	

	@BeforeClass
	public static void setUp() throws Exception {
		jaxbc=JAXBContext.newInstance(	Utilisateur.class, 
										Connexion.class
										);
		crb= new ClientRequestBuilder(jaxbc);
	}
		
	
	/**
	 * test unitaire pour une bonne connexion
	 */
	
	private static String base64Encode(String stringToEncode)
	{
		return DatatypeConverter.printBase64Binary(stringToEncode.getBytes());
	}
	
	@Test
	public final void testValidConnexion() {

		try {

			final Connexion connexion = new Connexion("loginTestValidConnexion","password");
			final Utilisateur utilisateur= new Utilisateur("JeanConnexion","DucheminConnexion",connexion);
			final Utilisateur utilisateurPost=(Utilisateur)crb.httpRequestXMLBody(utilisateur, "user/create");
						
			
			final Connexion connexionGet = utilisateurPost.getConnexion();
			
			final Marshaller marshaller = jaxbc.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
			final java.io.StringWriter sw = new StringWriter();
			marshaller.marshal(connexionGet, sw);

			final ClientRequest request = new ClientRequest("http://localhost:8080/rest/connection/try");
			request.body("application/xml", sw.toString());
			String username = connexionGet.getLogin();
			String password = connexionGet.getPassword();
			String base64encodedUsernameAndPassword = base64Encode(username + ":" + password);
			request.header("Authorization", "Basic " +base64encodedUsernameAndPassword );
			
			LOG.info(sw.toString());
			final ClientResponse<String> response = request.post(String.class);

			if (response.getStatus() == 200) {
				LOG.info("");
				LOG.info("");
				LOG.info(response.getEntity());
				LOG.info("");
				LOG.info("");
				Assert.assertTrue(!response.getEntity().isEmpty());
			}
		} catch (final Exception e) {
			e.printStackTrace();
			LOG.error("echec du test de connexion", e);
		}

	}
	
	/**
	 * test unitaire pour une mauvaise connexion
	 */
	@Test
	public final void testNotValidConnexion() {

		try {

			final Connexion connexion = new Connexion("badlogin","badpassword33");
			
			
			
			
			final Marshaller marshaller = jaxbc.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
			final java.io.StringWriter sw = new StringWriter();
			marshaller.marshal(connexion, sw);

			final ClientRequest request = new ClientRequest("http://localhost:8080/rest/connection/try");
			request.body("application/xml", sw.toString());
			LOG.info(sw.toString());
			final ClientResponse<String> response = request.post(String.class);

			if (response.getStatus() == 200) {
				LOG.info("");
				LOG.info("");
				LOG.info(response.getEntity());
				LOG.info("");
				LOG.info("");
				Assert.assertTrue(!response.getEntity().isEmpty());
			}
		} catch (final Exception e) {
			e.printStackTrace();
			LOG.error("echec du test de connexion", e);
		}

	}
	
}
