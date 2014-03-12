<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>

<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>

<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>


<%@ page import="model.Utilisateur"%>
<%@ page import="model.Connexion"%>
<%@ page import="model.Adresse"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="javax.xml.bind.DatatypeConverter"%>
<%

JAXBContext jaxbc=JAXBContext.newInstance(Utilisateur.class,Connexion.class,Adresse.class);

Utilisateur utilisateurGet = new Utilisateur();
try {
	ClientRequest clientRequest;
	clientRequest = new ClientRequest("http://localhost:8080/rest/user/" + session.getAttribute("ID"));
	clientRequest.accept("application/xml");
	ClientResponse<String> clientResponse = clientRequest.get(String.class);
	if (clientResponse.getStatus() == 200)
	{
		Unmarshaller un = jaxbc.createUnmarshaller();
		utilisateurGet = (Utilisateur) un.unmarshal(new StringReader(clientResponse.getEntity()));
		
	}
} catch (Exception e) {
	e.printStackTrace();
}

if(request.getParameter("link") != null && request.getParameter("id")!=null) {
	
	utilisateurGet.setCheminImage(request.getParameter("link"));
	
	Utilisateur utilisateurGet2 = new Utilisateur();
	try {
		final Marshaller marshaller = jaxbc.createMarshaller();
		marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
		final java.io.StringWriter sw = new StringWriter();
		marshaller.marshal(utilisateurGet, sw);			
			
		final ClientRequest clientRequest2 = new ClientRequest("http://localhost:8080/rest/user/update/");
		clientRequest2.body("application/xml", utilisateurGet );
				
		String username = utilisateurGet.getConnexion().getLogin();
		String password = utilisateurGet.getConnexion().getPassword();
		String base64encodedUsernameAndPassword = DatatypeConverter.printBase64Binary((username + ":" + password).getBytes());
		clientRequest2.header("Authorization", "Basic " +base64encodedUsernameAndPassword );
		
		final ClientResponse<String> clientResponse2 = clientRequest2.post(String.class);
		
		if (clientResponse2.getStatus() == 200) {
			final Unmarshaller un = jaxbc.createUnmarshaller();
			utilisateurGet2 = (Utilisateur) un.unmarshal(new StringReader(clientResponse2.getEntity()));
			out.clear();
			out.print("success@Image modifiée avec succès");
		}
		
	} catch (final Exception e) {
		out.clear();
		out.print("danger@Erreur lors de la sauvegarde");
	}
}
%>