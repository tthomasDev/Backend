<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="constantes.jsp"%>
<%@include file="functions.jsp"%>
<%@ page import="java.net.URI"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>
<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>
<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>
<%@ page import="com.ped.myneightool.model.Utilisateur"%>
<%@ page import="com.ped.myneightool.model.Message"%>
<%@ page import="com.ped.myneightool.dto.MessagesDTO"%>
<%
String fileName = "adminDashboard";
if(request.getParameter("page") != null) {
	fileName = request.getParameter("page");
}
String filePath = adminFolder+fileName+".jsp";
if(!fileExists(filePath))
	filePath = adminFolder+"404.jsp";

final JAXBContext jaxbc = JAXBContext.newInstance(Utilisateur.class);
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
	    <link href="<%=cssFolder%>bootstrap.min.css" rel="stylesheet">
	    <link href="<%=cssFolder%>jumbotron.css" rel="stylesheet">
 		<link href="<%=cssFolder%>jquery-ui.css" rel="stylesheet">
	
	    <script src="<%=jsFolder%>jquery.js"></script>
 		<script src="<%=jsFolder%>jquery-ui.js"></script>
	    <script src="<%=jsFolder%>bootstrap.min.js"></script>
	    <script src="<%=jsFolder%>paginate.js"></script>
	    <script src="<%=jsFolder%>reorder.js"></script>
	    <script src="<%=jsFolder%>jquery.cookie.js"></script>
	    <script src="<%=jsFolder%>init.js"></script>
	   
	
	   
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
					<a class="navbar-brand" href="adminDashboard.jsp"><% out.print(siteName); %> - Administation</a>
				</div>
				<div class="navbar-collapse collapse">
					
					<ul class="nav navbar-nav navbar-right" style="margin-right:2px;">
	        			<li><a href="adminDashboard.jsp">Accueil de l'administration</a></li>
	        			<li><a href="adminDashboard.jsp?page=adminManageUsers">Gérer les utilisateurs</a></li>
	        			<li><a href="adminDashboard.jsp?page=adminManageItems">Gérer les outils</a></li>
	        			<li><a href="adminDashboard.jsp?page=adminManageCategories">Gérer les catégories</a></li>
        				<li><a href="index.jsp?attemp=0">Déconnexion</a></li>
					</ul>
				</div>
			</div>
		</div>
		
		<div class="container" style="margin-top:30px;">
			<jsp:include page="<%=filePath%>" />
		</div>	
		<div class="container">
			<hr />
			<footer>
				<p>Copyrights &copy; MyNeighTool 2014 | <span><a href="#" id="contactLink" data-toggle="modal" data-target="#contact">Nous contacter</a> &bull; <a href="#" data-toggle="modal" data-target="#terms">Conditions générales d'utilisation</a> &bull; <a href="#" data-toggle="modal" data-target="#faq">FAQ</a>
				<% 
								
				Utilisateur utilisateurGet = new Utilisateur();
				try {
					ClientRequest clientRequest;
					clientRequest = new ClientRequest(siteUrl + "rest/user/" + session.getAttribute("ID"));
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
				
				if(utilisateurGet.getRole().equals("ADMIN")){ %>
				&bull; 
				<a href="dashboard.jsp"> <FONT COLOR="#F75D59">Retour interface utilisateur</FONT></a>				
				<% } %>
				</span>
				</p>
			</footer>
		</div>
		<jsp:include page="<%=contentFolder+"terms.jsp"%>" />
		<jsp:include page="<%=contentFolder+"contact.jsp"%>" />
		<jsp:include page="<%=contentFolder+"faq.jsp"%>" />
	</body>
</html>