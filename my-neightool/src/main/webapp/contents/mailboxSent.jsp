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
<%@ page import="javax.xml.bind.DatatypeConverter"%>



<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";
	boolean list=false;

	actionValid = true;

	//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
	final JAXBContext jaxbc = JAXBContext.newInstance(MessagesDTO.class,Message.class);

	// Le DTO des outils permettant de récupérer la liste d'outils
	MessagesDTO messagesDto = new MessagesDTO();


	//ici on va récuperer la réponse de la requete
	try {	
		

		Utilisateur myUser = new Utilisateur();
		
		try {
			ClientRequest clientRequest;
			clientRequest = new ClientRequest("http://localhost:8080/rest/user/" + session.getAttribute("ID"));
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
		requestMessages = new ClientRequest(
				"http://localhost:8080/rest/message/list/sendListByOrder/" + myUser.getId());
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
			messagesDto = (MessagesDTO) un2.unmarshal(new StringReader(
					responseMessages.getEntity()));
			if(messagesDto.size()>0)
			{
				list=true;
			}
			else
			{
				list=false;	
			}
			
			messageValue = "La liste a bien été récupérée";
			messageType = "success";
		} else {
			messageValue = "Une erreur est survenue";
			messageType = "danger";
		}
	} catch (Exception e) {
		e.printStackTrace();
	}

//Conversion des dates
DateFormat df = new SimpleDateFormat("MM/dd/yyyy");
		
%>

<script>
$(function(){
var nbMessages = <%=messagesDto.size()%>;


	$('.delMessage').click(function() {
		var idMsg = $(this).attr("id").split("delMsg")[1];
		var msg = $(this);
		$.ajax({
		    url: "<%=pluginFolder%>etatScript.jsp",
		    type: 'POST',
		    data: {id: idMsg, etat: 3, page: 2},
		    success: function() {
		    	msg.tooltip('hide');
		    	msg.closest('tr').fadeOut(400, function() {
					nbMessages--;
					$("#nbMessageInbox").html(nbMessages);
					$(this).removeClass("unread").html("<td colspan='5' class='perfectCenter alert-success'>Message supprimé avec succès</td>").fadeIn(400).delay(1000).fadeOut(400, function() {
						$(this).remove();
						if($("#paginatorNbElements").length>0) {
							changePage(previousPage,$("#paginatorNbElements").val());
							recalculateNbPage();
						}
					});
		    	});
			}
		});
	});
});
</script>

<ol class="breadcrumb">
	<li><a href="dashboard.jsp">Accueil</a></li>
	<li class="active">Boite d'envoi (<span id="nbMessageInbox"><%=messagesDto.size()%></span>/<%=nbMaxMessagesAllowed %> messages)</li>
</ol>

<div class="table-responsive">
	<table class="table table-hover">
		<thead>
			<tr>
				<th style="text-align: center;" width="20">Destinataire</th>
				<th style="text-align: center;" width="55%">Sujet</th>
				<th style="text-align: center;" width="15%">Date</th>
				<th style="text-align: center;" width="15%">Actions</th>
			</tr>
		</thead>
		<tbody id="accordion">		
		<% if(list)
			{
				for (Message m : messagesDto.getListeMessages()) { 
					if(m.getEtatEmetteur() == 0)
					{%>
					<tr style="vertical-align: middle;" class="toPaginate">
					<td class="perfectCenter"><%=m.getDestinataire().getConnexion().getLogin()%></td>
					<td class="perfectCenter"><strong><a
							data-toggle="collapse" data-parent="#accordion"
							href="#collapse<%=m.getId()%>"><%=m.getObjet()%></a></strong>
						<div id="collapse<%=m.getId()%>" class="panel-collapse collapse">
							<hr />
							<div style="text-align: justify !important"><%=m.getCorps()%></div>
						</div></td>
					<td class="perfectCenter">
					<% String date = df.format(m.getDate());
					out.print(date);
					%>				
					</td>
					<td class="perfectCenter">
						<div class="btn-group">
							<a class="ttipt btn btn-default delMessage" id="delMsg<%=m.getId()%>" title="Supprimer le message"><span class="glyphicon glyphicon-remove"></span></a>
						</div>
					</td>
				</tr>
	 	<%			}
				}
		
			}else{
			%>
		 	<tr class="perfectCenter">
					<td colspan="4">Aucun message envoyé</td>
			</tr>
			<% } %>
		</tbody>
	</table>
</div>

<div id="paginator"></div>
<input id="paginatorNbElements" type="hidden" value="10" readonly="readonly" />