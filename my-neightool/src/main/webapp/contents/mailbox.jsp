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

<%@ page import="model.Message"%>
<%@ page import="model.Utilisateur"%>
<%@ page import="dto.MessagesDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String subInclude = "mailboxMain.jsp";
String menuMainActive = "active";
String menuSentActive = "";
boolean newMessageHidden = true;
String newMessageTo = "";

String messageType = "";
String messageValue = "";

//acces au messages envoyés
if(request.getParameter("sub") != null) {
	String sub = (String)request.getParameter("sub");
	if(sub.equals("sent")) {
	subInclude = "mailboxSent.jsp";
	menuMainActive = "";
	menuSentActive = "active";
	}
}

// réponse à un utilisateur
if(request.getParameter("userId") != null) {
	newMessageHidden = false;
	/** TODO **/
	/* Récupérer le nom d'utilisateur */
	newMessageTo = "Utilisateur 1";
}


//Nouveau message

    boolean actionValid = false;
if ((request.getParameter("posted") != null)
&& (request.getParameter("userTo") != null)
&& (request.getParameter("subjectTo") != null)
&& (request.getParameter("messageTo") != null))
{
	actionValid = true;
	System.out.println("ENVOI D'UN MESSAGE");
	
	//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
	final JAXBContext jaxbc=JAXBContext.newInstance(Message.class, Utilisateur.class);
	
	// Utilisateurs
	Utilisateur userSource = new Utilisateur();
	Utilisateur userTarget = new Utilisateur();
	
	
	String id = String.valueOf(session.getAttribute("ID"));
	String userPseudoTo = request.getParameter("userTo");	
	String subject = request.getParameter("subjectTo");
	String corps = request.getParameter("messageTo");

try {

	ClientRequest clientRequest ;
	clientRequest = new ClientRequest("http://localhost:8080/rest/user/" + id);
	clientRequest.accept("application/xml");
	ClientResponse<String> response2 = clientRequest.get(String.class);
	
	if (response2.getStatus() == 200)
	{
		Unmarshaller un = jaxbc.createUnmarshaller();
		userSource = (Utilisateur) un.unmarshal(new StringReader(response2.getEntity()));
	}
		
	ClientRequest clientRequest2 ;
	clientRequest2 = new ClientRequest("http://localhost:8080/rest/user/login/" + userPseudoTo);
	clientRequest2.accept("application/xml");
	ClientResponse<String> response3 = clientRequest2.get(String.class);
		
	if (response3.getStatus() == 200)
	{
		System.out.println("On est dans 200");
		Unmarshaller un = jaxbc.createUnmarshaller();
		userTarget = (Utilisateur) un.unmarshal(new StringReader(response3.getEntity()));
	}
	else
	{
	
	System.out.println("Pas 200");
	}


} catch (Exception e) {
	e.printStackTrace();
}


//création du message
final Message message = new Message(userSource,userTarget,subject,corps, new Date(),0,0);


final Marshaller marshaller = jaxbc.createMarshaller();
marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
final java.io.StringWriter sw = new StringWriter();
marshaller.marshal(message, sw);


//ici on envois la requete au webservice createUtilisateur
final ClientRequest clientRequest = new ClientRequest("http://localhost:8080/rest/message/create");
clientRequest.body("application/xml", message );


//ici on va récuperer la réponse de la requete
final ClientResponse<String> clientResponse = clientRequest.post(String.class);	


//test affichage
System.out.println("\n\n"+clientResponse.getEntity()+"\n\n");
if (clientResponse.getStatus() == 200) { // si la réponse est valide !
	// on désérialiser la réponse si on veut vérifier que l'objet retourner
	// est bien celui qu'on a voulu créer , pas obligatoire
	final Unmarshaller un = jaxbc.createUnmarshaller();
	final Object object = (Object) un.unmarshal(new StringReader(clientResponse.getEntity()));
	// et ici on peut vérifier que c'est bien le bonne objet
	messageValue = "Le message a bien été envoyé";
	messageType = "success";
} else {
	messageValue = "Une erreur est survenue";
	messageType = "danger";
}	


}

actionValid = false;
messageType = "";
messageValue = "";
boolean list=false;
int nbNewMessage=0;
actionValid = true;

//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
final JAXBContext jaxbc = JAXBContext.newInstance(MessagesDTO.class,Message.class);

// Le DTO des outils permettant de récupérer la liste d'outils
MessagesDTO messagesDto = new MessagesDTO();

//ici on va récuperer la réponse de la requete
try {
	ClientRequest requestMessages;
	requestMessages = new ClientRequest(
	"http://localhost:8080/rest/message/list/receiveListByOrder/" + session.getAttribute("ID"));
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
	
	for(Message m : messagesDto.getListeMessages()) {
		
		if(m.getEtatDestinataire() == 0)
			nbNewMessage++;
	}
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
%>
<%
	if(!newMessageHidden) {
%>
<script type="text/javascript">
	$(document).ready(function() {
		$('#newMessageModal').modal('show');
	});
</script>
<%
	}
%>

<%
	if (actionValid) {
		out.println("<div class='row'><div class='col-md-12' style='margin-top:-20px'>");
		out.println("<div class='alert alert-" + messageType + "'>"
				+ messageValue + "</div>");
		out.println("</div></div>");
	}
%>

<div class="col-md-3 well">
	<ul class="nav nav-pills nav-stacked">
		<li><a href="#" data-toggle="modal" id="newMsgModal"
			data-target="#newMessageModal"><span
				class="glyphicon glyphicon-envelope"></span> Nouveau message</a></li>
		<hr />
		<li class="<%=menuMainActive%>"><a
			href="dashboard.jsp?page=mailbox"><span
				class="glyphicon glyphicon-inbox"></span> Boite de réception <span
				class="badge pull-right"><%=nbNewMessage%></span></a></li>
		<li class="<%=menuSentActive%>"><a
			href="dashboard.jsp?page=mailbox&sub=sent">Messages envoyés</a></li>
	</ul>
</div>
<div class="col-md-9">
	<jsp:include page="<%=subInclude%>" />
</div>

<div class="modal fade" id="newMessageModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Composer un nouveau
					message</h4>
			</div>
			<form method="post" action="dashboard.jsp?page=mailbox"
				class="form-horizontal">
				<div class="modal-body">
					<div class="form-group">
						<label for="userTo" class="col-sm-3 control-label">Destinataire</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" name="userTo" id="userTo"
								placeholder="Nom d'utilisateur du destinataire"
								value="<%=newMessageTo%>" required />
						</div>
					</div>
					<div class="form-group">
						<label for="subjectTo" class="col-sm-3 control-label">Sujet</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" name="subjectTo"
								id="subjectTo" placeholder="Sujet du message" required />
						</div>
					</div>
					<div class="form-group">
						<label for="messageTo" class="col-sm-3 control-label">Message</label>
						<div class="col-sm-9">
							<textarea class="form-control" rows="10" name="messageTo"
								id="messageTo" placeholder="Entrez votre message" required></textarea>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<input type="hidden" name="idAnswer" id="idAnswer" value="" />
					<button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
					<button type="submit" class="btn btn-info">Envoyer</button>
					<input type="hidden" name="posted" id="posted">
				</div>
			</form>
		</div>
	</div>
</div>