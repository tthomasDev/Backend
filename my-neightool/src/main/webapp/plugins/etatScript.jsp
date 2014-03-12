<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.sql.Timestamp"%>

<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>

<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>

<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>

<%@ page import="model.Utilisateur"%>

<%@ page import="model.Message"%>
<%@ page import="dto.MessagesDTO"%>
<%@ page import="javax.xml.bind.DatatypeConverter"%>

<%@include file="../constantes.jsp"%>
<%@include file="../functions.jsp"%>

<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";

	actionValid = true;

	//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
	final JAXBContext jaxbc = JAXBContext.newInstance(MessagesDTO.class,Message.class);

	// Le DTO des messages
	Message messageGET = new Message();
	
	

	//ici on va récuperer la réponse de la requete
	try {
		

		Utilisateur myUser = new Utilisateur();
		
		try {
			ClientRequest clientRequest;
			clientRequest = new ClientRequest("http://localhost:8080/rest/user/" + request.getParameter("id"));
			clientRequest.accept("application/xml");
			ClientResponse<String> response2 = clientRequest.get(String.class);

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
		
		
		ClientRequest requestMessages;
		requestMessages = new ClientRequest(siteUrl + "rest/message/" + request.getParameter("id"));
		requestMessages.accept("application/xml");
		
		
		//CREDENTIALS		
		String username = myUser.getConnexion().getLogin();
		System.out.println("\n\n"+username+"\n\n");
		String password = myUser.getConnexion().getPassword();
		System.out.println("\n\n"+password+"\n\n");
		String base64encodedUsernameAndPassword = DatatypeConverter.printBase64Binary((username + ":" + password).getBytes());
		requestMessages.header("Authorization", "Basic " +base64encodedUsernameAndPassword );
		///////////////////
		
		ClientResponse<String> responseMessages = requestMessages
				.get(String.class);
		
		if (responseMessages.getStatus() == 200) {
			
			Unmarshaller un2 = jaxbc.createUnmarshaller();
			messageGET= (Message) un2.unmarshal(new StringReader(
					responseMessages.getEntity()));
			
			messageValue = "Le message a bien été récupérée";
			messageType = "success";
			
			
			if (Integer.parseInt(request.getParameter("page")) == 1)
			{	
				messageGET.setEtatDestinataire(Integer.parseInt(request.getParameter("etat")));
			}
			else if (Integer.parseInt(request.getParameter("page")) == 2)
			{
				messageGET.setEtatEmetteur(Integer.parseInt(request.getParameter("etat")));
			}
			
			ClientRequest clientRequest = new ClientRequest(siteUrl + "rest/message/update");
			clientRequest.body("application/xml", messageGET );
			//CREDENTIALS		
			String username2 = myUser.getConnexion().getLogin();
			System.out.println("\n\n"+username+"\n\n");
			String password2 = myUser.getConnexion().getPassword();
			System.out.println("\n\n"+password+"\n\n");
			String base64encodedUsernameAndPassword2 = DatatypeConverter.printBase64Binary((username2 + ":" + password2).getBytes());
			clientRequest.header("Authorization", "Basic " +base64encodedUsernameAndPassword2 );
			///////////////////

			//ici on va récuperer la réponse de la requete de mise à jour
			final ClientResponse<String> clientResponse = clientRequest.post(String.class);	
			
			
			//test affichage
			System.out.println("\n\n"+clientResponse.getEntity()+"\n\n");
			
			if (clientResponse.getStatus() == 200) { 
				final Unmarshaller un = jaxbc.createUnmarshaller();
				final Object object = (Object) un.unmarshal(new StringReader(clientResponse.getEntity()));
				// et ici on peut vérifier que c'est bien le bon objet
				messageValue = "Le message a bien été mis à jour";
				messageType = "success";
			} else {
				messageValue = "Une erreur est survenue";
				messageType = "danger";
			}		
			
			
		} else {
			messageValue = "Une erreur est survenue";
			messageType = "danger";
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
