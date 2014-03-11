<%@include file="../constantes.jsp"%>
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


<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";

	actionValid = true;

	//on a besoin du contexte si on veut serialiser/d�s�rialiser avec jaxb
	final JAXBContext jaxbc = JAXBContext.newInstance(MessagesDTO.class,Message.class);

	// Le DTO des messages
	Message messageGET = new Message();

	//ici on va r�cuperer la r�ponse de la requete
	try {
		ClientRequest requestMessages;
		requestMessages = new ClientRequest(
				"http://localhost:8080/rest/message/" + request.getParameter("id"));
		requestMessages.accept("application/xml");
		ClientResponse<String> responseMessages = requestMessages
				.get(String.class);
		
		if (responseMessages.getStatus() == 200) {
			
			Unmarshaller un2 = jaxbc.createUnmarshaller();
			messageGET= (Message) un2.unmarshal(new StringReader(
					responseMessages.getEntity()));
			
			messageValue = "Le message a bien �t� r�cup�r�e";
			messageType = "success";
			
			
			if (Integer.parseInt(request.getParameter("page")) == 1)
			{	
				messageGET.setEtatDestinataire(Integer.parseInt(request.getParameter("etat")));
			}
			else if (Integer.parseInt(request.getParameter("page")) == 2)
			{
				messageGET.setEtatEmetteur(Integer.parseInt(request.getParameter("etat")));
			}
			
			ClientRequest clientRequest = new ClientRequest("http://localhost:8080/rest/message/update");
			clientRequest.body("application/xml", messageGET );

			//ici on va r�cuperer la r�ponse de la requete de mise � jour
			final ClientResponse<String> clientResponse = clientRequest.post(String.class);	
			
			
			//test affichage
			System.out.println("\n\n"+clientResponse.getEntity()+"\n\n");
			
			if (clientResponse.getStatus() == 200) { 
				final Unmarshaller un = jaxbc.createUnmarshaller();
				final Object object = (Object) un.unmarshal(new StringReader(clientResponse.getEntity()));
				// et ici on peut v�rifier que c'est bien le bon objet
				messageValue = "Le message a bien �t� mis � jour";
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