<%@include file="../functions.jsp"%>
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

<%@ page import="com.ped.myneightool.model.Outil"%>
<%@ page import="com.ped.myneightool.dto.OutilsDTO"%>

<%@ page import="com.ped.myneightool.model.Emprunt"%>
<%@ page import="com.ped.myneightool.dto.EmpruntsDTO"%>

<%@ page import="com.ped.myneightool.model.Categorie"%>
<%@ page import="com.ped.myneightool.dto.CategoriesDTO"%>

<%@ page import="javax.xml.bind.DatatypeConverter"%>

<%
	//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
	final JAXBContext jaxbc=JAXBContext.newInstance(Outil.class, Utilisateur.class, OutilsDTO.class, CategoriesDTO.class, Categorie.class);
	
	// Le DTO des catégories permettant de récupérer la liste de catégories
	CategoriesDTO categoriesDto = new CategoriesDTO();
	Categorie categorieRes = new Categorie();
	
	// L'outil que l'on veut modifier
	Outil toolToUpdate = new Outil();
	
	String subInclude = "manageItemsList.jsp";
	String menuListActive = "active";
	String menuAddActive = "";
	String menuRequestOnMeActive = "";
	String menuMyRequestActive = "";
	boolean cautionCorrecte = true;
	
	if (request.getParameter("sub") != null) {
		String sub = (String) request.getParameter("sub");
		if (sub.equals("add")) {
			subInclude = "manageItemsAdd.jsp";
			menuListActive = "";
			menuAddActive = "active";
			menuRequestOnMeActive = "";
			menuMyRequestActive = "";
		}
		else if (sub.equals("requestsonme")) {
			subInclude = "manageItemsRequestsOnMe.jsp";
			menuListActive = "";
			menuAddActive = "";
			menuRequestOnMeActive = "active";
			menuMyRequestActive = "";
		
		}
		else if (sub.equals("myrequests")) {
			subInclude = "manageItemsMyRequests.jsp";
			menuListActive = "";
			menuAddActive = "";
			menuRequestOnMeActive = "";
			menuMyRequestActive = "active";
		}
		else if (sub.equals("edit")) {
			subInclude = "manageItemsEdit.jsp";
			menuListActive = "";
			menuAddActive = "";
			menuRequestOnMeActive = "";
			menuMyRequestActive = "";
		}
		
	}

	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";

	// Utilisateur
	Utilisateur userConnecte = new Utilisateur();
	
	// Le DTO des outils permettant de récupérer la liste d'outils
	OutilsDTO outilsDto = new OutilsDTO();

	// On récupère les données de session de l'utilisateur
	final String id = String.valueOf(session.getAttribute("ID"));
	final String userName = String.valueOf(session.getAttribute("userName"));

	// ici on envoit la requete permettant de récupérer les données complètes
	// sur l'utilisateur en ligne
	try {
		ClientRequest clientRequest;
		clientRequest = new ClientRequest(siteUrl+"rest/user/" + id);
		clientRequest.accept("application/xml");
		ClientResponse<String> response2 = clientRequest.get(String.class);
	
		if (response2.getStatus() == 200) {
	Unmarshaller un = jaxbc.createUnmarshaller();
	userConnecte = (Utilisateur) un.unmarshal(new StringReader(response2.getEntity()));
		}
	} catch (Exception e) {
		e.printStackTrace();
	}

	//ici on va récuperer la réponse de la requete
	try {
		ClientRequest requestTools;
		requestTools = new ClientRequest(siteUrl
				+ "rest/tool/user/available/" + userConnecte.getId());
		requestTools.accept("application/xml");
		ClientResponse<String> responseTools = requestTools
				.get(String.class);

		if (responseTools.getStatus() == 200) {
			Unmarshaller un2 = jaxbc.createUnmarshaller();
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

	// On récupère la liste des emprunts
	EmpruntsDTO listeEmprunt = new EmpruntsDTO();

	try {
		ClientRequest requestEmprunts;
		requestEmprunts = new ClientRequest(siteUrl
				+ "rest/emprunt/list");
		requestEmprunts.accept("application/xml");
		ClientResponse<String> responseEmprunts = requestEmprunts
				.get(String.class);

		if (responseEmprunts.getStatus() == 200) {
			Unmarshaller un2 = jaxbc.createUnmarshaller();
			listeEmprunt = (EmpruntsDTO) un2
					.unmarshal(new StringReader(responseEmprunts
							.getEntity()));

			// et ici on peut vérifier que c'est bien le bon objet
			messageValue = "La liste des emprunts a été récupérée.";
			messageType = "success";
		} else {
			messageValue = "Une erreur est survenue";
			messageType = "danger";
		}
	} catch (Exception e) {
		e.printStackTrace();
	}

	/* Traitement pour la mise à jour de l'objet */
	if (request.getParameter("itemId") != null) {
		// On récupère l'outil concerné par la modification
		try {
			ClientRequest requestTools;
			requestTools = new ClientRequest(siteUrl + "rest/tool/"
					+ escapeStr(request.getParameter("itemId")));
			requestTools.accept("application/xml");
			ClientResponse<String> responseTools = requestTools
					.get(String.class);

			if (responseTools.getStatus() == 200) {
				Unmarshaller un2 = jaxbc.createUnmarshaller();
				toolToUpdate = (Outil) un2.unmarshal(new StringReader(
						responseTools.getEntity()));

				// et ici on peut vérifier que c'est bien le bon objet
				messageValue = "Les détails de l'objet ont bien été récupérés.";
				messageType = "success";
			} else {
				messageValue = "Une erreur est survenue";
				messageType = "danger";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		if ((request.getParameter("itemName") != "")
				&& (request.getParameter("itemCategory") != "")
				&& (request.getParameter("itemDetails") != "")
				&& (request.getParameter("itemCaution") != null)
				&& (request.getParameter("start") != "")
				&& (request.getParameter("end") != "")) {

			actionValid = true;

			// Utilisateur
			Utilisateur user = new Utilisateur();

			cautionCorrecte = request.getParameter("itemCaution")
					.matches("[0-9]*");
			System.out.println("CAUTION CORRECTE " + cautionCorrecte);

			//ici on va créer l'outil avec les données rentrées dans le formulaire
			final String name = escapeStr(request
					.getParameter("itemName"));
			final String category = escapeStr(request
					.getParameter("itemCategory"));
			final String description = escapeStr(request
					.getParameter("itemDetails"));
			final int caution;
			if (cautionCorrecte) {
				caution = Integer.parseInt(request
						.getParameter("itemCaution"));
			} else {
				caution = 0;
			}

			// On parse l'ID de la catégorie
			final int category_id = Integer.parseInt(category);

			// On cherche la catégorie en fonction de son ID
			try {
				ClientRequest requestCategory;
				requestCategory = new ClientRequest(siteUrl
						+ "rest/categorie/" + category_id);
				requestCategory.accept("application/xml");
				ClientResponse<String> responseCategory = requestCategory
						.get(String.class);
				if (responseCategory.getStatus() == 200) {
					Unmarshaller un2 = jaxbc.createUnmarshaller();
					categorieRes = (Categorie) un2
							.unmarshal(new StringReader(
									responseCategory.getEntity()));

					// et ici on peut vérifier que c'est bien le bon objet
					messageValue = "La catégorie a bien été récupérée";
					messageType = "success";
				} else {
					messageValue = "Une erreur est survenue";
					messageType = "danger";
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			// On récupère l'image correspondante à l'objet créé
			final String cheminImage = escapeStr(request
					.getParameter("itemImg"));

			final String startDate = escapeStr(request
					.getParameter("start"));
			final String endDate = escapeStr(request
					.getParameter("end"));

			//Si la caution est correcte, on poursuit. Sinon on ne fait pas l'ajout en base de donnée
			if (cautionCorrecte) {
				SimpleDateFormat sdf = new SimpleDateFormat(
						"dd/MM/yyyy");
				Date parsedDateD = sdf.parse(startDate);
				System.out.println("test date debut : " + parsedDateD);

				Date parsedDateF = sdf.parse(endDate);
				System.out.println("test date fin : " + parsedDateF);

				//ici on récupère les données de l'utilisateur
				try {
					ClientRequest clientRequest;
					clientRequest = new ClientRequest(siteUrl
							+ "rest/user/" + id);
					clientRequest.accept("application/xml");
					ClientResponse<String> response2 = clientRequest
							.get(String.class);
					if (response2.getStatus() == 200) {
						Unmarshaller un = jaxbc.createUnmarshaller();
						user = (Utilisateur) un
								.unmarshal(new StringReader(response2
										.getEntity()));
					}
				} catch (Exception e) {
					e.printStackTrace();
				}

				//final Outil tool = new Outil(user, name, description, true, categorieRes, caution, parsedDateD, parsedDateF, cheminImage);
				//toolToUpdate = new Outil(user, name, description, true, categorieRes, caution, parsedDateD, parsedDateF, cheminImage);
				toolToUpdate.setNom(name);
				toolToUpdate.setCategorie(categorieRes);
				toolToUpdate.setDescription(description);
				toolToUpdate.setCaution(caution);
				toolToUpdate.setDateDebut(parsedDateD);
				toolToUpdate.setDateFin(parsedDateF);
				toolToUpdate.setCheminImage(cheminImage);

				try {
					final ClientRequest requestToolUpdate = new ClientRequest(
							siteUrl + "rest/tool/update");

					//ici il faut sérialiser l'outil
					final Marshaller marshaller2 = jaxbc
							.createMarshaller();
					marshaller2.setProperty(Marshaller.JAXB_ENCODING,
							"UTF-8");
					final java.io.StringWriter sw2 = new StringWriter();
					marshaller2.marshal(toolToUpdate, sw2);

					requestToolUpdate.body("application/xml",
							toolToUpdate);

					//CREDENTIALS		
					String username = user.getConnexion().getLogin();
					String password = user.getConnexion().getPassword();
					String base64encodedUsernameAndPassword = DatatypeConverter
							.printBase64Binary((username + ":" + password)
									.getBytes());
					requestToolUpdate.header("Authorization", "Basic "
							+ base64encodedUsernameAndPassword);
					///////////////////

					final ClientResponse<String> responseToolUpdate = requestToolUpdate
							.post(String.class);

					if (responseToolUpdate.getStatus() == 200) { // OK
						final Unmarshaller un = jaxbc
								.createUnmarshaller();
						final StringReader sr = new StringReader(
								responseToolUpdate.getEntity());
						final Object object = (Object) un.unmarshal(sr);
						toolToUpdate = (Outil) object;
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				messageType = "danger";
				messageValue = "Caution incorrecte";
			}
		} else {
			messageType = "danger";
			messageValue = "Tous les champs n'ont pas été remplis.";

		}
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
		<li class="<%=menuRequestOnMeActive%>"><a
			href="dashboard.jsp?page=manageItems&sub=requestsonme">Demandes sur mes objets<span
				class="badge pull-right"><%
				int cpt=0;
					for(Emprunt e : listeEmprunt.getListeEmprunts())
					{
						if(e.getOutil().getUtilisateur().getId() == Integer.parseInt(session.getAttribute("ID").toString()))
						{
							cpt++;
						}
					}
					out.print(cpt);
			%>
			</span></a></li>
		<li class="<%=menuMyRequestActive%>"><a
			href="dashboard.jsp?page=manageItems&sub=myrequests">Mes demandes aux voisins</a></li>
	</ul>
</div>

<div class="col-md-9">
	<jsp:include page="<%=subInclude%>" />
</div>