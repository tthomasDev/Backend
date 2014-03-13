<%@include file="../constantes.jsp"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="java.text.DateFormat"%>

<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>

<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>

<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>

<%@ page import="com.ped.myneightool.model.Emprunt"%>
<%@ page import="com.ped.myneightool.model.Utilisateur"%>

<%@include file="../functions.jsp"%>
<%@ page import="javax.xml.bind.DatatypeConverter"%>
<%
	String id = request.getParameter("id");
	String etat = request.getParameter("etat");


	//On l'emprunt avec l'id
	final JAXBContext jaxbc = JAXBContext.newInstance(Emprunt.class);

	Emprunt emprunt = new Emprunt();
	
	try {
		ClientRequest clientRequest;
		clientRequest = new ClientRequest(siteUrl+"rest/emprunt/"+id);
		clientRequest.accept("application/xml");
		ClientResponse<String> response1 = clientRequest.get(String.class);
		
		if (response1.getStatus() == 200) {
			Unmarshaller un = jaxbc.createUnmarshaller();
			emprunt = (Emprunt) un.unmarshal(new StringReader(response1.getEntity()));
		}
		
		System.out.println("ON MODIFIE");
		//On le modifie
		emprunt.setValide(Integer.parseInt(etat));
		
		Utilisateur myUser = new Utilisateur();
		
		try {
			ClientRequest clientRequest2;
			clientRequest2 = new ClientRequest(siteUrl + "rest/user/" + session.getAttribute("ID"));
			clientRequest2.accept("application/xml");
			ClientResponse<String> response2 = clientRequest2.get(String.class);

			if (response2.getStatus() == 200) {
				Unmarshaller un = jaxbc.createUnmarshaller();
				myUser = (Utilisateur) un
						.unmarshal(new StringReader(response2
								.getEntity()));
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}	
		
		// marshalling/serialisation pour l'envoyer avec une requete post
		final Marshaller marshaller = jaxbc.createMarshaller();
		marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
		final java.io.StringWriter sw = new StringWriter();
		marshaller.marshal(emprunt, sw);
		
		//on envoie la maj
		ClientRequest clientEmprunt = new ClientRequest(siteUrl + "rest/emprunt/update");
		clientEmprunt.body("application/xml", emprunt);
		
		//CREDENTIALS		
		String username = myUser.getConnexion().getLogin();
		System.out.println("\n\n"+username+"\n\n");
		String password = myUser.getConnexion().getPassword();
		System.out.println("\n\n"+password+"\n\n");
		String base64encodedUsernameAndPassword = DatatypeConverter.printBase64Binary((username + ":" + password).getBytes());
		clientEmprunt.header("Authorization", "Basic " +base64encodedUsernameAndPassword );
		///////////////////
		
		final ClientResponse<String> clientResponse3 = clientEmprunt.post(String.class);
		
		System.out.println("\n\n"+clientResponse3.getEntity()+"\n\n");

		out.clear();
		out.print("SUCCESS");
		
	} catch (Exception e) {
		e.printStackTrace();
	}
%>