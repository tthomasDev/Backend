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
	boolean list=false;

	actionValid = true;

	//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
	final JAXBContext jaxbc = JAXBContext.newInstance(MessagesDTO.class,Message.class);

	// Le DTO des outils permettant de récupérer la liste d'outils
	MessagesDTO messagesDto = new MessagesDTO();


	//ici on va récuperer la réponse de la requete
	try {
		ClientRequest requestMessages;
		requestMessages = new ClientRequest(
				"http://localhost:8080/rest/message/list/sendListByOrder/" + session.getAttribute("ID"));
		requestMessages.accept("application/xml");
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


<ol class="breadcrumb">
	<li><a href="dashboard.jsp">Accueil</a></li>
	<li class="active">Boite d'envoi (les messages ne sont conservés que 30 jours)</li>
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
						<button type="button" class="btn btn-default ttipt" title="Supprimer ce message">
							<span class="glyphicon glyphicon-remove"></span>
						</button>
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