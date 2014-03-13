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

<%@ page import="model.Outil"%>
<%@ page import="dto.OutilsDTO"%>
<%@ page import="javax.xml.bind.DatatypeConverter"%>

<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";

	actionValid = true;

	//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
	final JAXBContext jaxbc = JAXBContext.newInstance(Utilisateur.class);
	final JAXBContext jaxbc2 = JAXBContext.newInstance(OutilsDTO.class, Outil.class);

	// Utilisateur
	Utilisateur user = new Utilisateur();

	// Le DTO des outils permettant de récupérer la liste d'outils
	OutilsDTO outilsDto = new OutilsDTO();
	
	// L'outil que l'utilisateur veut supprimer
	Outil toolUpdated = new Outil();

	// On récupère les données de session de l'utilisateur
	final String id = String.valueOf(session.getAttribute("ID"));
	final String userName = String.valueOf(session
	.getAttribute("userName"));

	// ici on envoit la requete permettant de récupérer les données complètes
	// sur l'utilisateur en ligne
	try {
		ClientRequest clientRequest;
		clientRequest = new ClientRequest(siteUrl + "rest/user/" + id);
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
	
	// On fait appel au service permettant la recherche puis la suppression d'un outil spécifique
	if (request.getParameter("idTool")!=null) {
		try {
			ClientRequest requestSpecTool;
			requestSpecTool = new ClientRequest(siteUrl + "rest/tool/" + request.getParameter("idTool"));
			requestSpecTool.accept("application/xml");
			ClientResponse<String> responseSpecTool = requestSpecTool.get(String.class);
			if (responseSpecTool.getStatus() == 200) {	
				Unmarshaller un2 = jaxbc2.createUnmarshaller();
				toolUpdated = (Outil) un2.unmarshal(new StringReader(responseSpecTool.getEntity()));
				// et ici on peut vérifier que c'est bien le bon objet
				messageValue = "L'outil a bien été récupéré.";
				messageType = "success";
			} else {
				messageValue = "Une erreur est survenue";
				messageType = "danger";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// On rend désormais l'objet indisponible
		toolUpdated.setDisponible(false);
		
		try {
			final ClientRequest requestToolUpdate = new ClientRequest(siteUrl + "rest/tool/update");

			//ici il faut sérialiser l'outil
			final Marshaller marshaller2 = jaxbc2.createMarshaller();
			marshaller2.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
			final java.io.StringWriter sw2 = new StringWriter();
			marshaller2.marshal(toolUpdated, sw2);

			requestToolUpdate.body("application/xml", toolUpdated);
			
			
			//CREDENTIALS		
			String username = user.getConnexion().getLogin();
			String password = user.getConnexion().getPassword();
			String base64encodedUsernameAndPassword = DatatypeConverter.printBase64Binary((username + ":" + password).getBytes());
			requestToolUpdate.header("Authorization", "Basic " +base64encodedUsernameAndPassword );
			///////////////////
			
			
			final ClientResponse<String> responseToolUpdate = requestToolUpdate.post(String.class);
		
			if (responseToolUpdate.getStatus() == 200) { // OK
				final Unmarshaller un = jaxbc.createUnmarshaller();
				final StringReader sr = new StringReader(responseToolUpdate.getEntity());
				final Object object = (Object) un.unmarshal(sr);
				toolUpdated = (Outil) object;
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	//ici on va récuperer la réponse de la requete
	try {
		ClientRequest requestTools;
		requestTools = new ClientRequest(siteUrl + "rest/tool/user/available/" + user.getId());
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
<script>
$(function(){
	$(".deleteTool").click(function(){
		var tmp = ($(this).attr("id")).split("delete")[1];
		$("#confirm").attr("href","dashboard.jsp?page=manageItems&idTool="+tmp);
		$("#idToolConcern").html(tmp);
	});
});

</script>


<div class="row">
	<div class="col-md-12">
		<ol class="breadcrumb">
			<li><a href="#">Accueil</a></li>
			<li class="active">Liste de mes outils</li>
		</ol>
	
		<div class="table-responsive">
			<table class="table table-hover" id="toReorder">
				<thead>
					<tr>
						<th style="text-align: center;" width="140px">Photo</th>
						<th style="text-align: center;" width="80%">Description</th>
						<th style="text-align: center;" width="15%">Caution  <span class="reorderer" name="caution"></span></th>
						<th style="text-align: center;" width="25%">Actions</th>
					</tr>
				</thead>
				<tbody>
					<% for (Outil t : outilsDto.getListeOutils()) { %>
					<tr style="vertical-align: middle;" class="toPaginate">
						<td><img class="img-rounded" src="<%=t.getCheminImage() %>" width="140px" height="140px" /></td>
						<td style="vertical-align: middle;"><strong><a
								href="dashboard.jsp?page=itemDetails&id=<%=t.getId()%>"><%=t.getNom() %></a></strong><br />
							<p><%=t.getDescription() %></p></td>
						<td style="vertical-align: middle; text-align: center;"><%=t.getCaution() + " "%><i class="glyphicon glyphicon-euro"></i></td>
						<td style="vertical-align: middle;">
 							<a id="delete<%=t.getId()%>" data-toggle="modal" data-target="#confirmModal" 
							class="ttipt btn btn-default deleteTool" title="Retirer l'objet">
							<span class="glyphicon glyphicon-remove"></span>
							</a>							
						</td>
					</tr>
					<% } %>
				</tbody>
			</table>
		</div>
	</div>

	<div class="modal fade" id="confirmModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">Confirmer	suppression d'outil</h4>
				</div>
				<div class="modal-body">
					<strong>Objet concerné : <span id="idToolConcern"></span></strong><br />
					<div class="modal-footer">
						<a type="button" class="btn btn-default" data-dismiss="modal">
							<i class="glyphicon glyphicon-remove"></i> Annuler
						</a> <a id="confirm" href="" class="enabled btn btn-success"> <i
							class="glyphicon glyphicon-ok"> </i> Confirmer la suppression
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="paginator"></div>
	<input id="paginatorNbElements" type="hidden" value="5" readonly="readonly"/>
</div>