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

<%@ page import="com.ped.myneightool.model.Utilisateur"%>
<%@ page import="com.ped.myneightool.dto.UtilisateursDTO" %>

<%@ page import="com.ped.myneightool.model.Outil"%>
<%@ page import="com.ped.myneightool.dto.OutilsDTO" %>

<%@ page import="java.util.Iterator" %>

<%@ page import="java.lang.StringBuilder" %>
<%@ page import="javax.xml.bind.DatatypeConverter"%>

<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";
	String errorMsg = "";
	boolean errorMsgB = false;
	
	actionValid = true;
	final JAXBContext jaxbc = JAXBContext.newInstance(UtilisateursDTO.class,Utilisateur.class,OutilsDTO.class,Outil.class);
	
	// get des données administrateur
	String id = String.valueOf(session.getAttribute("ID"));
	Utilisateur admin = new Utilisateur();

	try {

		ClientRequest clientRequest;
		clientRequest = new ClientRequest(siteUrl + "rest/user/"
				+ id);
		clientRequest.accept("application/xml");
		ClientResponse<String> response2 = clientRequest
				.get(String.class);

		if (response2.getStatus() == 200) {
			Unmarshaller un = jaxbc.createUnmarshaller();
			admin = (Utilisateur) un.unmarshal(new StringReader(
					response2.getEntity()));
		}

	} catch (Exception e) {
		e.printStackTrace();
	}
	
	
	
	//SUPPRESSION D'UN UTILISATEUR == UPDATE DE L'UTILISATEUR EN COMPTE INACTIF + PASSAGE DE SES OUTILS A INDISPONIBLE
	
	if (request.getParameter("deleteId") != null) {

		int idDelete = Integer.parseInt(request
		.getParameter("deleteId"));

		// recuperation de l'utilisateur
		Utilisateur utilisateurGet = new Utilisateur();
		try {
	ClientRequest clientRequest;
	clientRequest = new ClientRequest(siteUrl + "rest/user/"
			+ idDelete);
	clientRequest.accept("application/xml");
	ClientResponse<String> clientResponse = clientRequest
			.get(String.class);
	if (clientResponse.getStatus() == 200) {
		Unmarshaller un = jaxbc.createUnmarshaller();
		utilisateurGet = (Utilisateur) un
				.unmarshal(new StringReader(clientResponse
						.getEntity()));

	}
		} catch (Exception e) {
	e.printStackTrace();
		}

		if (!utilisateurGet.getRole().equals("ADMIN")) {
	
	
	String currentLog = admin.getConnexion()
			.getLogin();
	String currentPass = admin.getConnexion()
			.getPassword();

	
	
	OutilsDTO outilsDto=new OutilsDTO();
	
	//Recuperation de tous les outils de l'utilisateur
	try {
		ClientRequest requestTools;
		requestTools = new ClientRequest(siteUrl + "rest/tool/user/"+ utilisateurGet.getId());
		requestTools.accept("application/xml");
		ClientResponse<String> responseTools = requestTools
		.get(String.class);
		if (responseTools.getStatus() == 200) {
			Unmarshaller un2 = jaxbc.createUnmarshaller();
			outilsDto = (OutilsDTO) un2.unmarshal(new StringReader(responseTools.getEntity()));
		
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
	
	
		//Update des outils à indisponible
		Iterator<Outil> io=outilsDto.getListeOutils().iterator();
			while (io.hasNext()) {

				Outil o = io.next();
				o.setDisponible(false);
				try {
					//>> ON MET A JOUR LA DISPONIBILITE DANS L'OUTIL AVEC UN UPDATE
					final Marshaller marshaller = jaxbc
							.createMarshaller();
					marshaller.setProperty(Marshaller.JAXB_ENCODING,
							"UTF-8");
					final java.io.StringWriter sw = new StringWriter();
					marshaller.marshal(o, sw);

					//ici on envois la requete au webservice createCategorie
					final ClientRequest clientRequest = new ClientRequest(
							siteUrl + "rest/tool/update");
					clientRequest.body("application/xml", o);

					//CREDENTIALS		
					String username3 = currentLog;
					String password3 = currentPass;
					String base64encodedUsernameAndPassword3 = DatatypeConverter
							.printBase64Binary((username3 + ":" + password3)
									.getBytes());
					clientRequest.header("Authorization", "Basic "
							+ base64encodedUsernameAndPassword3);
					///////////////////

					//ici on va récuperer la réponse de la requete
					final ClientResponse<String> clientResponse = clientRequest
							.post(String.class);

					if (clientResponse.getStatus() == 200) {
						messageValue = "Outil UPDATE OK";
						messageType = "success";
					} else {
						messageValue = "Une erreur est survenue";
						messageType = "danger";
					}

				} catch (Exception e) {
					e.printStackTrace();
				}

			}

			utilisateurGet.getAdresse().setadresseComplete(
					"Compte inactif");
			utilisateurGet.getAdresse()
					.setcodePostale("Compte inactif");
			utilisateurGet.getAdresse().setLatitude(0);
			utilisateurGet.getAdresse().setLongitude(0);
			utilisateurGet.getAdresse().setPays("Compte inactif");
			utilisateurGet.getAdresse().setRue("Compte inactif");
			utilisateurGet.getAdresse().setVille("Compte inactif");
			utilisateurGet.setCheminImage("Compte inactif");

			//bug suppression de login > java nul exception
			//on garde donc le login avec une entete "Inactif:"
			String lo=utilisateurGet.getConnexion().getLogin();
			utilisateurGet.getConnexion().setLogin("Inactif:"+lo);

			utilisateurGet.getConnexion().setPassword(null);
			utilisateurGet.setDateDeNaissance(null);
			utilisateurGet.setMail(null);
			utilisateurGet.setNom("Compte inactif");
			utilisateurGet.setPrenom("Compte inactif");
			utilisateurGet.setTelephone("Compte inactif");

			// UPDATE de l'utilisateur en compte inactif
			try {

				// marshalling/serialisation pour l'envoyer avec une requete post
				final Marshaller marshaller = jaxbc.createMarshaller();
				marshaller.setProperty(Marshaller.JAXB_ENCODING,
						"UTF-8");
				final java.io.StringWriter sw = new StringWriter();
				marshaller.marshal(utilisateurGet, sw);

				final ClientRequest clientRequest = new ClientRequest(
						siteUrl + "rest/user/update/");
				clientRequest.body("application/xml", utilisateurGet);
				//CREDENTIALS		
				String username2 = currentLog;
				String password2 = currentPass;
				String base64encodedUsernameAndPassword = DatatypeConverter
						.printBase64Binary((username2 + ":" + password2)
								.getBytes());
				clientRequest.header("Authorization", "Basic "
						+ base64encodedUsernameAndPassword);
				///////////////////

				final ClientResponse<String> clientResponse = clientRequest
						.post(String.class);

				System.out.println("\n\n" + clientResponse.getEntity()
						+ "\n\n");

				if (clientResponse.getStatus() == 200) { // ok !

				}
			} catch (final Exception e) {
				e.printStackTrace();
			}
		} else {
			errorMsg = "Impossible de supprimer un compte administrateur";
			errorMsgB = true;
		}

	}

	// AFFICHAGE DES UTILISATEURS

	UtilisateursDTO usersDto = new UtilisateursDTO();
	// On récupère la liste de tous les utilisateurs disponibles
	try {
		ClientRequest requestUsers;
		requestUsers = new ClientRequest(siteUrl + "rest/user/list");
		requestUsers.accept("application/xml");
		ClientResponse<String> responseUsers = requestUsers
				.get(String.class);
		if (responseUsers.getStatus() == 200) {
			Unmarshaller un2 = jaxbc.createUnmarshaller();
			usersDto = (UtilisateursDTO) un2
					.unmarshal(new StringReader(responseUsers
							.getEntity()));

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

	var field = $("#sUser");
	var btnCancel = $("#sBtnCancel");
	var btnSearch = $("#sBtnSearch");
	var initialTab = $("#searchBody").html();
	
	btnSearch.click(function() {
		if(field.val()=="") {
			field.data('bs.tooltip').options.title = 'Veuillez taper un utilisateur (nom, email, ...) à rechercher';
			field.tooltip('show');
		} else {
			btnCancel.removeClass("disabled");
			var nbResult = 0;
			var foundInRow;
			var cellContent;
			var initTabArray = new Array();
			$("#searchBody").find("tr").each(function() {
				foundInRow = false;
				$(this).find("td").each(function() {
					cellContent = $(this).html();
					if(cellContent.indexOf(field.val()) >= 0)
						foundInRow = true;
				});
				if(foundInRow) {
					initTabArray[nbResult] = "<tr class='toPaginate'>" + $(this).html() + "</tr>";
					nbResult++;
				}
			});
			if(nbResult == 0)
				$("#searchBody").html("<tr class='toPaginate'><td class='perfectCenter' colspan='6'>Aucun résultat à votre recherche</td></tr>");
			else {
				$("#searchBody").html("");
				for(var i = 0; i < nbResult; i++) {
					$("#searchBody").append(initTabArray[i]);
				}	
			}


			var nbElements = $("#paginatorNbElements").val();
			$(".toPaginate").hide();
			
			$("#paginator").html(function() {
				var count = 0;
				$(".toPaginate").each(function() {count++});
				var paginator = "";
				if(count>0) {
					count = count / nbElements;
					paginator = "<div class='row'>" +
						"<div class='col-md-12' style='text-align: center;'>" +
							"<ul class='pagination'>" + 
								"<li class='disabled'><a href='javascript:void(0);'>Page : </a></li>";
					for(var i = 0; i < count; i++)
						paginator += "<li id='page" + i + "'><a href='javascript:void(0);' onclick='changePage(" + i + ", "+ nbElements +");'>" + (i+1) + "</a></li>";
					paginator += "</ul>" +
						"</div>" +
					"</div>";
				}
				return paginator;
			});
			
			recalculateNbPage();
		}
	});
	
	btnCancel.click(function() {
		btnCancel.addClass("disabled").tooltip('hide');
		field.val("");
		$("#searchBody").html(initialTab);
		
	});
	
});
</script>

<h3>Liste des utilisateurs 
	<span class="pull-right input-group col-md-4">
		<input type="text" id="sUser" placeholder="Chercher un utilisateur (login, email, ...)" class="form-control ttipl">
		<span class="input-group-btn">
			<button class="btn btn-default" id="sBtnSearch" type="button"><i class="glyphicon glyphicon-search"></i></button>
			<button class="btn btn-default disabled ttipt" title="Annuler la recherche" id="sBtnCancel" type="button"><i class="glyphicon glyphicon-remove"></i></button>
		</span>
	</span>
</h3>
<hr />
<% if(errorMsgB) { %>
<div class="alert alert-danger perfectCenter">
	<%=errorMsg%>
</div>
<br /><br />
<% } %>
<table class="table table-hover" id="toReorder">
	<thead>
		<tr>
			<th width="10%" class="perfectCenter">Id <span class="reorderer" name="idOrder"></span></th>
			<th width="30px" class="perfectCenter">Photo</th>
			<th width="15%" class="perfectCenter">Login</th>
			<th width="15%" class="perfectCenter">Prénom</th>
			<th width="15%" class="perfectCenter">Nom</th>
			<th width="30%" class="perfectCenter">Email</th>
			<th width="15%" class="perfectCenter">Action</th>
		</tr>
	</thead>
	<tbody id="searchBody">
		<%
		
		Iterator<Utilisateur> ito=usersDto.getListeUtilisateurs().iterator();
		while(ito.hasNext()){
				
			Utilisateur u = ito.next();
			
							
			if((!u.getNom().equals("Compte inactif") && !u.getPrenom().equals("Compte inactif"))){
		%>
			<tr class="toPaginate">
				<td class="perfectCenter reorderable"><%=u.getId()%></td>
				<% 
					String path = imgFolder + "user_avatar_default.png";
					if(u.getCheminImage()!=null){
						path = u.getCheminImage();
					}
				%>
				<td class="perfectCenter"><img class="img-rounded" src="<%=path%>" width="35" height="35" /></td>
				<td class="perfectCenter"><%=u.getConnexion().getLogin()%></td>
				<td class="perfectCenter"><%=u.getPrenom() %></td>
				<td class="perfectCenter"><%=u.getNom() %></td>
				<td class="perfectCenter"><%=u.getMail() %></td>
				<td class="perfectCenter">
					<% if(u.getRole().equals("USER")){ %>
					<a href="adminDashboard.jsp?page=adminManageUsers&deleteId=<%=u.getId()%>" class="ttipt btn btn-danger" title="Supprimer l'utilisateur">
						<span class="glyphicon glyphicon-remove"></span>
					</a>
					<%} else { %>
					<a href="javascript:void(0)" class="ttipt btn btn-default disabled" title="Impossible de supprimer l'utilisateur Admin">
						<span class="glyphicon glyphicon-remove"></span>
					</a>
					<% } %>
				</td>
			</tr>
	
	
		<%
			}
			else{
				System.out.println("\n");
				System.out.println("\n");
				System.out.println("\n");
				System.out.println(u.getConnexion().getLogin());
				System.out.println("\n");
				System.out.println("\n");
				System.out.println("\n");
			}
		}
		%>
		
	</tbody>
</table>

<div id="paginator"></div>
<input id="paginatorNbElements" type="hidden" value="10" readonly="readonly" />

