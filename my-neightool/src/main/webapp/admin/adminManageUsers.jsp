<%@include file="../constantes.jsp"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.Timestamp"%>

<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>

<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>

<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>

<%@ page import="com.ped.myneightool.model.Utilisateur"%>
<%@ page import="com.ped.myneightool.dto.UtilisateursDTO" %>

<%@ page import="java.util.Iterator" %>

<%@ page import="java.lang.StringBuilder" %>
<%@ page import="javax.xml.bind.DatatypeConverter"%>

<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";
	
	actionValid = true;
	final JAXBContext jaxbc = JAXBContext.newInstance(UtilisateursDTO.class,Utilisateur.class);
	
	
	//SUPPRESSION D'UN UTILISATEUR
	
	if (request.getParameter("deleteId") != null) {

		int idDelete = Integer.parseInt(request
				.getParameter("deleteId"));

		Utilisateur utilisateurGet = new Utilisateur();
		try {
			ClientRequest clientRequest;
			clientRequest = new ClientRequest(siteUrl + "rest/user/"
					+ idDelete);
			clientRequest.accept("application/xml");
			ClientResponse<String> clientResponse = clientRequest
					.get(String.class);
			if (clientResponse.getStatus() == 200) {
				Unmarshaller un = jaxbc.createUnmarshaller();
				utilisateurGet = (Utilisateur) un
						.unmarshal(new StringReader(clientResponse
								.getEntity()));

			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		String currentLog = utilisateurGet.getConnexion().getLogin();
		String currentPass = utilisateurGet.getConnexion().getPassword();

		utilisateurGet.getAdresse().setadresseComplete("Compte inactif");
		utilisateurGet.getAdresse().setcodePostale("Compte inactif");
		utilisateurGet.getAdresse().setLatitude(0);
		utilisateurGet.getAdresse().setLongitude(0);
		utilisateurGet.getAdresse().setPays("Compte inactif");
		utilisateurGet.getAdresse().setRue("Compte inactif");
		utilisateurGet.getAdresse().setVille("Compte inactif");
		utilisateurGet.setCheminImage("Compte inactif");
		
		//bug suppression de login > java nul exception
		//utilisateurGet.getConnexion().setLogin(null);
		
		utilisateurGet.getConnexion().setPassword(null);
		utilisateurGet.setDateDeNaissance(null);
		utilisateurGet.setMail(null);
		utilisateurGet.setNom("Compte inactif");
		utilisateurGet.setPrenom("Compte inactif");
		utilisateurGet.setTelephone("Compte inactif");

		try {

			// marshalling/serialisation pour l'envoyer avec une requete post
			final Marshaller marshaller = jaxbc.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
			final java.io.StringWriter sw = new StringWriter();
			marshaller.marshal(utilisateurGet, sw);

			final ClientRequest clientRequest = new ClientRequest(siteUrl + "rest/user/update/");
			clientRequest.body("application/xml", utilisateurGet);
			//CREDENTIALS		
			String username2 = currentLog;
			String password2 = currentPass;
			String base64encodedUsernameAndPassword = DatatypeConverter
					.printBase64Binary((username2 + ":" + password2).getBytes());
			clientRequest.header("Authorization", "Basic "+ base64encodedUsernameAndPassword);
			///////////////////

			final ClientResponse<String> clientResponse = clientRequest
					.post(String.class);

			System.out.println("\n\n" + clientResponse.getEntity()
					+ "\n\n");

			if (clientResponse.getStatus() == 200) { // ok !

			}
		} catch (final Exception e) {
			e.printStackTrace();
		}

	}

	// AFFICHAGE DES UTILISATEURS

	UtilisateursDTO usersDto = new UtilisateursDTO();
	// On récupère la liste de tous les utilisateurs disponibles
	try {
		ClientRequest requestUsers;
		requestUsers = new ClientRequest(siteUrl + "rest/user/list");
		requestUsers.accept("application/xml");
		ClientResponse<String> responseUsers = requestUsers
				.get(String.class);
		if (responseUsers.getStatus() == 200) {
			Unmarshaller un2 = jaxbc.createUnmarshaller();
			usersDto = (UtilisateursDTO) un2
					.unmarshal(new StringReader(responseUsers
							.getEntity()));

			messageValue = "La liste a bien été récupérée";
			messageType = "success";
		} else {
			messageValue = "Une erreur est survenue";
			messageType = "danger";
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
%>



<h3>Liste des utilisateurs <span class="pull-right"></span></h3>
<hr />
<table class="table table-hover">
	<thead>
		<tr>
			<th width="10%" class="perfectCenter"><span class="reorderer" name="idOrder"></span> Id</th>
			<th width="15%" class="perfectCenter">Login</th>
			<th width="15%" class="perfectCenter">Prénom</th>
			<th width="15%" class="perfectCenter">Nom</th>
			<th width="30%" class="perfectCenter">e-mail</th>
			<th width="15%" class="perfectCenter">Action</th>
		</tr>
	</thead>
	<tbody>
		<%
		
		Iterator<Utilisateur> ito=usersDto.getListeUtilisateurs().iterator();
		while(ito.hasNext()){
				
			Utilisateur u = ito.next();
							
			if((!u.getNom().equals("Compte inactif") && !u.getPrenom().equals("Compte inactif"))){
		%>
			<tr class="toPaginate">
			<td class="perfectCenter"><%=u.getId()%></td>
			<td id="nameCat<%=u.getId()%>" class="perfectCenter"><%=u.getConnexion().getLogin()%></td>
			<td id="nameCat<%=u.getId()%>" class="perfectCenter"><%=u.getPrenom() %></td>
			<td id="nameCat<%=u.getId()%>" class="perfectCenter"><%=u.getNom() %></td>
			<td id="nameCat<%=u.getId()%>" class="perfectCenter"><%=u.getMail() %></td>
			<td class="perfectCenter">
				<div class="btn-group">
					
					<a href="adminDashboard.jsp?page=adminManageUsers&deleteId=<%=u.getId()%>" class="ttipt btn btn-default" title="Supprimer l'utilisateur">
						<span class="glyphicon glyphicon-remove"></span>
					</a>
				</div>
			</td>
		</tr>
	
	
		<%
			}
			else{
				System.out.println("\n");
				System.out.println("\n");
				System.out.println("\n");
				System.out.println(u.getConnexion().getLogin());
				System.out.println("\n");
				System.out.println("\n");
				System.out.println("\n");
			}
		}
		%>
		
	</tbody>
</table>

<div id="paginator"></div>
<input id="paginatorNbElements" type="hidden" value="10" readonly="readonly" />

