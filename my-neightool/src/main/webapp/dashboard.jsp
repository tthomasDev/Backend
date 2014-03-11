<%@include file="constantes.jsp"%>
<%@ page import="java.net.URI"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
	if(session.getAttribute("ID") == null) {
		RequestDispatcher rd =
		request.getRequestDispatcher("index.jsp");
		rd.forward(request, response);
	}

	int nbNewMessage = 0;
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
		

/* Service de gestion des nouveaux messages privés */
String tooltip = "";

if(nbNewMessage == 0)
	tooltip = "Aucun nouveau message";
else if(nbNewMessage == 1)
	tooltip = "1 nouveau message dans votre boite de réception. Cliquez pour le consulter.";
else if(nbNewMessage > 1)
	tooltip = nbNewMessage + " nouveaux messages dans votre boite de réception. Cliquez pour les consulter.";

String fileName = "dashboard";
if(request.getParameter("page") != null) {
	fileName = request.getParameter("page");
}
String filePath = contentFolder+fileName+".jsp";

%>

<!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8">
    	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    	<meta name="viewport" content="width=device-width, initial-scale=1">
    	<meta name="description" content="">
    	<meta name="author" content="">
		<link rel="icon" type="image/png" href="./dist/img/favicon.png" />
	
	    <title><% out.print(siteName); %></title>
	
	    <!-- Bootstrap core CSS -->
	    <link href="./dist/css/bootstrap.min.css" rel="stylesheet">
	    <link href="./dist/css/jumbotron.css" rel="stylesheet">
 		<link href="http://code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css" rel="stylesheet">
	
	    <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
 		<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
	    <script src="./dist/js/bootstrap.min.js"></script>
	    <script src="./dist/js/paginate.js"></script>
	    <script src="./dist/js/reorder.js"></script>
	    <script src="./dist/js/jquery.cookie.js"></script>
	    <script type="text/javascript">
			$(document).ready(function() {
		    	$(".ttipl").tooltip({placement: "left",container: 'body'});
		    	$(".ttipr").tooltip({placement: "right",container: 'body'});
		    	$(".ttipt").tooltip({placement: "top",container: 'body'});
		    	$(".ttipb").tooltip({placement: "bottom",container: 'body'});
		    	$(".popov").popover({html: true, placement: "bottom", trigger: "focus"});
		    	$(".createHide").click(function() {
		    		$.cookie('hideNewMessageModal','true');
		    	});
		    	<% if(nbNewMessage > 0) { %>
		    		var hide = $.cookie('hideNewMessageModal');
		    		if(!hide || hide!="true")
		    			$('#messageReceivedModal').modal('show');
		    	<% } %>
		    });
	    </script>
	
	    <!-- Just for debugging purposes. Don't actually copy this line! -->
	    <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
	    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
	    <!--[if lt IE 9]>
	      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	    <![endif]-->
		<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAsO96nmOiM5A5mef1oNv4PZoETDWvfJ88&sensor=false"></script>
	</head>
	
	<body>
		<div class="navbar navbar-default navbar-fixed-top">
			<div class="container">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse"
						data-target=".navbar-collapse">
						<span class="sr-only">Toggle navigation</span> <span
							class="icon-bar"></span> <span class="icon-bar"></span> <span
							class="icon-bar"></span>
					</button>
					<a class="navbar-brand" href="dashboard.jsp"><% out.print(siteName); %></a>
				</div>
				<div class="navbar-collapse collapse">
					<form class="navbar-form navbar-left" method="GET" action="dashboard.jsp">
						<input type="hidden" name="page" value="search" />
						<input type="text" id="searchField" name="s" class="form-control popov" data-content='<p style="text-align:justify">Appuyez sur la touche "Entrée" pour lancer la recherche.</p><p class="perfectCenter"><a class="btn btn-info" href="dashboard.jsp?page=search">Recherche avancée</a></p>' placeholder="Rechercher">
					</form>
					<ul class="nav navbar-nav navbar-right" style="margin-right:2px;">
	        			<li><a href="dashboard.jsp">Accueil</a></li>
	        			<li><a href="dashboard.jsp?page=manageItems">Mes objets</a></li>
	        			<li class="ttipb" title="<%=tooltip%>"><a href="dashboard.jsp?page=mailbox">Mes messages <span class="badge"><%=nbNewMessage%></span></a></li>
        				<li><a href="dashboard.jsp?page=account">Mon compte</a></li>
        				<li><a href="index.jsp?attemp=0">Déconnexion</a></li>
					</ul>
				</div>
			</div>
		</div>
		<% if(nbNewMessage > 0) { %>
		<div class="modal fade" id="messageReceivedModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="myModalLabel">Nouveau message</h4>
					</div>
					<div class="modal-body perfectCenter">
						<div class="alert alert-info">Vous avez reçu <%=nbNewMessage%> nouveau(x) message(s) privé(s) dans votre messagerie.</div>
					</div>
					<div class="modal-footer">
						<a class="btn btn-default createHide" data-dismiss="modal">Ne plus afficher cette fenêtre</a>
						<a class="btn btn-info createHide" href="dashboard.jsp?page=mailbox">Consulter</a>
					</div>
				</div>
			</div>
		</div>
		<% } %>
		<div class="container" style="margin-top:30px;">
			<jsp:include page="<%=filePath%>" />
		</div>	
		<div class="container">
			<hr />
			<footer>
				<p>Copyrights &copy; MyNeighTool 2014 | <span><a href="#" id="contactLink" data-toggle="modal" data-target="#contact">Nous contacter</a> &bull; <a href="#" data-toggle="modal" data-target="#terms">Conditions générales d'utilisation</a> &bull; <a href="#" data-toggle="modal" data-target="#faq">FAQ</a></span>
				</p>
			</footer>
		</div>
		<jsp:include page="<%=contentFolder+"terms.jsp"%>" />
		<jsp:include page="<%=contentFolder+"contact.jsp"%>" />
		<jsp:include page="<%=contentFolder+"faq.jsp"%>" />
	</body>
</html>