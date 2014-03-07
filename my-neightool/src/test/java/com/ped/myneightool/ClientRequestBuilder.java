package com.ped.myneightool;

import java.io.StringReader;
import java.io.StringWriter;

import javax.xml.bind.DatatypeConverter;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import org.jboss.resteasy.client.ClientRequest;
import org.jboss.resteasy.client.ClientResponse;

import com.ped.myneightool.model.Utilisateur;



public class ClientRequestBuilder {
	
	
	private JAXBContext jc;
	private Utilisateur u;
	
	
	public ClientRequestBuilder( JAXBContext jc){
		this.jc=jc;
	}
	
	
	
	public JAXBContext getJc() {
		return jc;
	}



	public void setJc(JAXBContext jc) {
		this.jc = jc;
	}

	private static String base64Encode(String stringToEncode)
	{
		return DatatypeConverter.printBase64Binary(stringToEncode.getBytes());
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
			final Marshaller marshaller = this.jc.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
			final java.io.StringWriter sw = new StringWriter();
			marshaller.marshal(o, sw);
			
									
			
			final ClientRequest request = new ClientRequest(
					"http://localhost:8080/rest/" + resourceURI);

			//request.accept("application/xml");
			request.body("application/xml", o );

			if(o instanceof Utilisateur){
				u = (Utilisateur) o;
				String username = u.getConnexion().getLogin();
				String password = u.getConnexion().getPassword();
				String base64encodedUsernameAndPassword = base64Encode(username + ":" + password);
				request.header("Authorization", "Basic " +base64encodedUsernameAndPassword );
			}
			
						
			
			final ClientResponse<String> response = request.post(String.class);
			
			System.out.println("\n\n"+response.getEntity()+"\n\n");
			
			if (response.getStatus() == 200) { // ok !
				
				
				
				final Unmarshaller un = this.jc.createUnmarshaller();
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
	 * Requete GET avec parametre INT
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
				Unmarshaller un = this.jc.createUnmarshaller();
				Object o = un.unmarshal(new StringReader(response.getEntity()));
				return o;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * Requete GET avec parametre INT et Utilisateur 
	 * @param resourceURI
	 * @param id
	 * @return
	 * 
	 */
	public Object httpGetRequest(String resourceURI, int id, Utilisateur ut){
		try {
			ClientRequest request;
			request = new ClientRequest("http://localhost:8080/rest/" + resourceURI + "/" + id);
			request.accept("application/xml");
			
			//CREDENTIALS
			String username = ut.getConnexion().getLogin();
			String password = ut.getConnexion().getPassword();
			String base64encodedUsernameAndPassword = base64Encode(username + ":" + password);
			request.header("Authorization", "Basic " +base64encodedUsernameAndPassword );
			///////////////////////////
			
			
			ClientResponse<String> response = request.get(String.class);
			if (response.getStatus() == 200)
			{
				Unmarshaller un = this.jc.createUnmarshaller();
				Object o = un.unmarshal(new StringReader(response.getEntity()));
				return o;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Requete GET avec parametre String
	 * @param resourceURI
	 * @param id
	 * @return
	 * 
	 */
	public Object httpGetRequest(String resourceURI,String id){
		try {
			ClientRequest request;
			request = new ClientRequest("http://localhost:8080/rest/" + resourceURI + "/" + id);
			request.accept("application/xml");
			ClientResponse<String> response = request.get(String.class);
			if (response.getStatus() == 200)
			{
				Unmarshaller un = this.jc.createUnmarshaller();
				Object o = un.unmarshal(new StringReader(response.getEntity()));
				return o;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	
	/**
	 * Requete GET sans parametre
	 * @param resourceURI
	 * @param id
	 * @return
	 * 
	 */

	public Object httpGetRequestWithoutArgument(String resourceURI) {
		try {
			ClientRequest request;
			request = new ClientRequest("http://localhost:8080/rest/" + resourceURI);
			request.accept("application/xml");
			ClientResponse<String> response = request.get(String.class);
			if (response.getStatus() == 200)
			{
				Unmarshaller un = this.jc.createUnmarshaller();
				Object o = un.unmarshal(new StringReader(response.getEntity()));
				return o;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}



	

}
