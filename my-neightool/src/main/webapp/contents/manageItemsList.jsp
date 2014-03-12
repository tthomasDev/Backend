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

	//ici on va récuperer la réponse de la requete
	try {
		ClientRequest requestTools;
		requestTools = new ClientRequest(siteUrl + "rest/tool/user/" + user.getId());
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
 							<a href="dashboard.jsp?page=manageItems"
							class="ttipt btn btn-default delMessage" title="Retirer l'objet">
							<span class="glyphicon glyphicon-remove"></span>
							</a>
							<% 
							// On fait appel au service permettant la suppression d'un outil spécifique
							try {
								ClientRequest requestTools;
								requestTools = new ClientRequest(
										"http://localhost:8080/rest/tool/delete/"+ t.getId());
								requestTools.accept("application/xml");
								ClientResponse<String> responseTools = requestTools
										.get(String.class);
						
								if (responseTools.getStatus() == 200) {						
									// et ici on peut vérifier que c'est bien le bon objet
									messageValue = "Les détails de la catégorie ont bien été récupérés.";
									messageType = "success";
								} else {
									messageValue = "Une erreur est survenue";
									messageType = "danger";
								}
							} catch (Exception e) {
								e.printStackTrace();
							}%>
							
							<%-- version qui ne fonctionne que la 2e fois --%>
							<%--  <% if (request.getParameter("idTool")!=null) { %>
								<a
							href="" data-toggle="modal" data-target="#deleteConfirm"
							class="ttipt btn btn-default delMessage" title="Retirer l'objet"></a>
							<% } else { %>
								<a
							href="dashboard.jsp?page=manageItems&idTool=<%=t.getId()%>"
							class="ttipt btn btn-default delMessage" title="Retirer l'objet"></a>
							<% } %> --%>
							
						</td>
					</tr>
					<% } %>
				</tbody>
			</table>
		</div>
	</div>
	
	<% if(request.getParameter("idTool")!=null) { %>
		<div class="modal fade" id="deleteConfirm" tabindex="-1" role="dialog"
			aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<form action="#" method="POST">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal"
								aria-hidden="true">&times;</button>
							<h4 class="modal-title" id="myModalLabel">Confirmer suppression d'outil</h4>
						</div>
						<div class="modal-body">
							<strong>Objet concerné : <%=request.getParameter("idTool") %></strong><br />
							<div class="modal-footer">
								<button type="button" class="btn btn-default" data-dismiss="modal">
									<i class="glyphicon glyphicon-remove"></i> Annuler
								</button>
								<button type="submit" id="confirm" class="enabled btn btn-success">
									<i class="glyphicon glyphicon-ok"></i> Confirmer la suppresion
								</button>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	<% } %>
</div>

<div id="paginator"></div>
<input id="paginatorNbElements" type="hidden" value="5" readonly="readonly"/>