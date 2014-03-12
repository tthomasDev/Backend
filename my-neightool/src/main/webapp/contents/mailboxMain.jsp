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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%
	boolean list=false;

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
				"http://localhost:8080/rest/message/list/receiveListByOrder/" + myUser.getId());
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
		    data: {id: idMsg, etat: 3, page: 1},
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
	
	$('.answerBtn').click(function(e) {
		var strTmp = this.id.split("isanswerName");
		$("#userTo").val(strTmp[1]);
		$('#newMessageModal').modal('show');
		$("#idAnswer").val(strTmp[0]);
	});
	
	$("#newMsgModal").click(function(e) {
		$("#idAnswer").val("");
	});
	
	$('.msg').click(function(e) {
		var idMsg = $(this).attr("id").split("msg")[1];
		e.preventDefault();
		$.ajax({
		    url: "<%=pluginFolder%>etatScript.jsp",
		    type: 'POST',
		    data: {id: idMsg, etat: 1, page: 1},
		    success: function() {
		    	$(".unread"+idMsg).removeClass("unread");
		    }
		});
	});	
});
</script>
<style>
	.unread { font-weight: bold; }
	.unread td:first-child, .unread:hover td:first-child { background: #428BCA; }
	.answered td:first-child, .answered:hover td:first-child { background: #3C763D; }
</style>

<div class="row">

	<div class="col-md-12">
		<ol class="breadcrumb">
			<li><a href="dashboard.jsp">Accueil</a></li>
			<li class="active">Boite de réception (<span id="nbMessageInbox"><%=messagesDto.size()%></span>/<%=nbMaxMessagesAllowed%> messages)</li>
		</ol>
	</div>
	<% if(request.getParameter("mValue")!=null && request.getParameter("mValue")!="") { %>
		<div class='col-md-12'>
			<div class='perfectCenter alert alert-<%=request.getParameter("mType")%>'>
				<%=request.getParameter("mValue")%>
			</div>
		</div>
	<% } %>
	<div class="col-md-offset-8 col-md-4">
		<table class="table">
			<thead>
				<tr>
					<th width="15px"></th>
					<th>Légende</th>
				</tr>
			</thead>
			<tbody>
				<tr class="unread">
					<td></td>
					<td style="font-weight: normal">Message non lu</td>
				</tr>
				<tr class="answered">
					<td></td>
					<td>Message répondu</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div class="col-md-12">
		<div class="table-responsive">
			<table class="table table-hover" id="toReorder">
				<thead>
					<tr>
						<th style="text-align: center;" width="5px"></th>
						<th style="text-align: center;" width="20%">Expéditeur</th>
						<th style="text-align: center;" width="50%">Sujet</th>
						<th style="text-align: center;" width="15%">Date</th>
						<th style="text-align: center;" width="15%">Actions</th>
					</tr>
				</thead>
				<tbody id="accordion">
				
				
				<%
				if(list) {
					for (Message m : messagesDto.getListeMessages()) { %>
					<% if(m.getEtatDestinataire() == 0){ %>
					<tr style="vertical-align: middle;" class="toPaginate unread unread<%=m.getId()%>">
						<td></td>
						<td class="perfectCenter"><%=m.getEmetteur().getConnexion().getLogin()%></td>
						<td class="perfectCenter">
							<a data-toggle="collapse" data-parent="#accordion" href="#collapse<%=m.getId()%>" class="msg" id="msg<%=m.getId()%>">
								<%=m.getObjet()%>
							</a>
					<% } else if(m.getEtatDestinataire() == 1){ %>
					<tr style="vertical-align: middle;" class="toPaginate">
						<td></td>
						<td class="perfectCenter"><%=m.getEmetteur().getConnexion().getLogin()%></td>
						<td class="perfectCenter">
							<a data-toggle="collapse" data-parent="#accordion" href="#collapse<%=m.getId()%>" class="msg" id="msg<%=m.getId()%>">
								<%=m.getObjet()%>
							</a>
					<% } else if(m.getEtatDestinataire() == 2){ %>
					<tr style="vertical-align: middle;" class="toPaginate answered">
						<td></td>
						<td class="perfectCenter"><%=m.getEmetteur().getConnexion().getLogin()%></td>
						<td class="perfectCenter">
							<a data-toggle="collapse" data-parent="#accordion" href="#collapse<%=m.getId()%>">
								<%=m.getObjet()%>
							</a>
					<% } if(m.getEtatDestinataire() != 3) {	%>
							<div id="collapse<%=m.getId()%>" class="panel-collapse collapse">
								<hr />
								<div class="well" style="text-align: justify !important"><%=m.getCorps()%></div>
							</div></td>
						<td class="perfectCenter">
						<%
							String date = df.format(m.getDate());
							out.print(date);
						%>
						</td>
						<td class="perfectCenter">
							<div class="btn-group">
								<a id="<%=m.getId()%>isanswerName<%=m.getEmetteur().getConnexion().getLogin()%>" class="answerBtn ttipt btn btn-default" title="Répondre à l'expéditeur">
									<span class="glyphicon glyphicon-envelope"></span>
								</a>
								<a class="ttipt btn btn-default delMessage" id="delMsg<%=m.getId()%>" title="Supprimer le message">
									<span class="glyphicon glyphicon-remove"></span>
								</a>
							</div>
						</td>
					</tr>
			 	<%		}
					}
				} else {	
				%>
				 	<tr class="perfectCenter">
						<td colspan="4">Aucun message reçu</td>
					</tr>
				<% } %>			
				</tbody>
			</table>
		</div>
		
		<div id="paginator"></div>
		<input id="paginatorNbElements" type="hidden" value="10" readonly="readonly" />
	
	</div>
</div>