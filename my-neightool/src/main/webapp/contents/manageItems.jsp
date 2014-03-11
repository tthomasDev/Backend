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
	String subInclude = "manageItemsList.jsp";
	String menuListActive = "active";
	String menuAddActive = "";
	if (request.getParameter("sub") != null) {
		String sub = (String) request.getParameter("sub");
		if (sub.equals("add")) {
			subInclude = "manageItemsAdd.jsp";
			menuListActive = "";
			menuAddActive = "active";
		}
	}

	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";

	actionValid = true;

	//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
	final JAXBContext jaxbc = JAXBContext
			.newInstance(Utilisateur.class);
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
		ClientResponse<String> response2 = clientRequest
				.get(String.class);
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
<div class="col-md-3 well">
	<ul class="nav nav-pills nav-stacked">
		<li class="<%=menuListActive%>"><a
			href="dashboard.jsp?page=manageItems"><span
				class="glyphicon glyphicon-list"></span> Mes objets disponibles <span
				class="badge pull-right">
					<%=outilsDto.getListeOutils().size() %></span></a></li>
		<li class="<%=menuAddActive%>"><a
			href="dashboard.jsp?page=manageItems&sub=add"><span
				class="glyphicon glyphicon-plus"></span> Ajouter un objet</a></li>
	</ul>
</div>

<div class="col-md-9">
	<jsp:include page="<%=subInclude%>" />
</div>