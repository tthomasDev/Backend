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

<%@ page import="model.Utilisateur"%>

<%@ page import="com.ped.myneightool.model.Outil"%>
<%@ page import="com.ped.myneightool.dto.OutilsDTO"%>

<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";

	actionValid = true;

	//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
	final JAXBContext jaxbc = JAXBContext.newInstance(Utilisateur.class);
	final JAXBContext jaxbc2 = JAXBContext.newInstance(OutilsDTO.class);

	// Utilisateur
	Utilisateur user = new Utilisateur();

	// Le DTO des outils permettant de récupérer la liste d'outils
	OutilsDTO outilsDto = new OutilsDTO();

	// On récupère les données de session de l'utilisateur
	final String id = String.valueOf(session.getAttribute("ID"));
	final String userName = String.valueOf(session
			.getAttribute("userName"));

	// ici on envoit la requete permettant de récupérer les données complètes
	// sur l'utilisateur en ligne
	try {
		ClientRequest clientRequest;
		clientRequest = new ClientRequest(
				"http://localhost:8080/rest/user/" + id);
		clientRequest.accept("application/xml");
		ClientResponse<String> response2 = clientRequest.get(String.class);
		if (response2.getStatus() == 200) {
			Unmarshaller un = jaxbc.createUnmarshaller();
			user = (Utilisateur) un.unmarshal(new StringReader(
					response2.getEntity()));
		}
	} catch (Exception e) {
		e.printStackTrace();
	}

	//ici on va récuperer la réponse de la requete
	try {
		ClientRequest requestTools;
		requestTools = new ClientRequest(
				"http://localhost:8080/rest/tool/user/" + user.getId());
		requestTools.accept("application/xml");
		ClientResponse<String> responseTools = requestTools
				.get(String.class);
		if (responseTools.getStatus() == 200) {
			Unmarshaller un2 = jaxbc2.createUnmarshaller();
			outilsDto = (OutilsDTO) un2.unmarshal(new StringReader(
					responseTools.getEntity()));

			// et ici on peut vérifier que c'est bien le bon objet
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

<div class="row">
	<div class="col-md-12">
		<ol class="breadcrumb">
			<li><a href="#">Accueil</a></li>
			<li class="active">Liste de mes outils</li>
		</ol>
	
		<div class="table-responsive">
			<table class="table table-hover">
				<thead>
					<tr>
						<th style="text-align: center;" width="140px">Photo</th>
						<th style="text-align: center;" width="80%">Description</th>
						<th style="text-align: center;" width="20%">Caution</th>
					</tr>
				</thead>
				<tbody>
					<% for (Outil t : outilsDto.getListeOutils()) { %>
					<tr style="vertical-align: middle;">
						<td><img class="img-rounded" src="<%=t.getCheminImage() %>" width="140px" height="140px" /></td>
						<td style="vertical-align: middle;"><strong><a
								href="dashboard.jsp?page=itemDetails&id=<%=t.getId()%>"><%=t.getNom() %></a></strong><br />
							<p><%=t.getDescription() %></p></td>
						<td style="vertical-align: middle; text-align: center;"><%=t.getCaution() %></td>
					</tr>
					<% } %>
				</tbody>
			</table>
		</div>
	
		<div class="row">
			<div class="col-md-12" style="text-align: center;">
				<ul class="pagination">
					<li><a href="#">&laquo;</a></li>
					<li><a href="#">1</a></li>
					<!-- <li><a href="#">2</a></li>
					<li><a href="#">3</a></li>
					<li><a href="#">4</a></li>
					<li><a href="#">5</a></li> -->
					<li><a href="#">&raquo;</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>