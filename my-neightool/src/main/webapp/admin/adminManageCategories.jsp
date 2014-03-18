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

<%@ page import="com.ped.myneightool.model.Categorie"%>
<%@ page import="com.ped.myneightool.dto.CategoriesDTO"%>
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

	final JAXBContext jaxbc = JAXBContext
			.newInstance(CategoriesDTO.class,Categorie.class,Utilisateur.class,Outil.class,OutilsDTO.class);
	
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
	
	
%>


<%
	// AJOUT D'UNE CATEGORIE
	if (request.getParameter("idCat") != null
			&& request.getParameter("idCat") == "") {

		if (!request.getParameter("catName").equals("Autre")) {
			
			
			final Categorie categorie = new Categorie(
					request.getParameter("catName"));

			//on serialise la catégorie
			final Marshaller marshaller = jaxbc.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
			final java.io.StringWriter sw = new StringWriter();
			marshaller.marshal(categorie, sw);

			//ici on envois la requete au webservice createCategorie
			final ClientRequest clientRequest = new ClientRequest(
					siteUrl + "rest/categorie/create");
			clientRequest.body("application/xml", categorie);

			//CREDENTIALS		
			String username3 = admin.getConnexion().getLogin();
			String password3 = admin.getConnexion().getPassword();
			String base64encodedUsernameAndPassword3 = DatatypeConverter
					.printBase64Binary((username3 + ":" + password3)
							.getBytes());
			clientRequest.header("Authorization", "Basic "
					+ base64encodedUsernameAndPassword3);
			///////////////////

			//ici on va récuperer la réponse de la requete
			final ClientResponse<String> clientResponse = clientRequest
					.post(String.class);

			if (clientResponse.getStatus() == 200) { // si la réponse est valide !
				// on désérialiser la réponse si on veut vérifier que l'objet retourner
				// est bien celui qu'on a voulu créer , pas obligatoire
				final Unmarshaller un = jaxbc.createUnmarshaller();
				final Object object = (Object) un
						.unmarshal(new StringReader(clientResponse
								.getEntity()));
				// et ici on peut vérifier que c'est bien le bonne objet
				messageValue = "Categorie create OK";
				messageType = "success";
			} else {
				messageValue = "Une erreur est survenue";
				messageType = "danger";
			}
		} else {
			errorMsg = "Impossible de créer la catégorie \"Autre\" (catégorie unique non supprimable et non modifiable)";
			errorMsgB = true;
		}
	}
%>

<%	
	//SUPPRESSION D'UNE CATEGORIE
	if(request.getParameter("deleteId")!=null){
		
		System.out.println("\n");
		System.out.println("\n");
		System.out.println("\n");
		System.out.println(request.getParameter("deleteId"));
		System.out.println("\n");
		System.out.println("\n");
		System.out.println("\n");
		
		int idDelete = Integer.parseInt(request.getParameter("deleteId"));
		//UPDATE DE TOUS LES OUTILS DE CETTE CATEGORIE VERS LA CATEGORIE "AUTRE/DIVERS"
		//>>

		//on récupère la categorie que l'on veut supprimer)
		Categorie categorieGet = new Categorie();
		try {

			ClientRequest clientRequest;
			clientRequest = new ClientRequest(siteUrl + "rest/categorie/"
					+ idDelete);
			clientRequest.accept("application/xml");
			ClientResponse<String> response2 = clientRequest
					.get(String.class);

			if (response2.getStatus() == 200) {
				Unmarshaller un = jaxbc.createUnmarshaller();
				categorieGet = (Categorie) un.unmarshal(new StringReader(
						response2.getEntity()));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		System.out.println("\n");
		System.out.println("\n");
		System.out.println("\n");
		System.out.println(categorieGet.getNom());
		System.out.println("\n");
		System.out.println("\n");
		System.out.println("\n");
		
		if(!categorieGet.getNom().equals("Autre")){
			
			
			
			//on récupère la categorie "Autre" dans laquelle on "deplacera" 
			//les objets de la catégorie que l'on va supprimer
			Categorie categorieAutre = new Categorie();
			try {
	
				ClientRequest clientRequest;
				clientRequest = new ClientRequest(siteUrl + "rest/categorie/name/"+"autre");
				clientRequest.accept("application/xml");
				ClientResponse<String> response2 = clientRequest
						.get(String.class);
	
				if (response2.getStatus() == 200) {
					Unmarshaller un = jaxbc.createUnmarshaller();
					categorieAutre = (Categorie) un.unmarshal(new StringReader(
							response2.getEntity()));
				}
	
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			System.out.println("\n");
			System.out.println("\n");
			System.out.println("\n");
			System.out.println(categorieAutre.getNom());
			System.out.println("\n");
			System.out.println("\n");
			System.out.println("\n");
			
			
			//on récupère la liste des objets de la catégorie que l'on va supprimer
			OutilsDTO outilsDto= new OutilsDTO();
			try {
				ClientRequest requestTools;
				requestTools = new ClientRequest(
				siteUrl + "rest/tool/categorie/" + categorieGet.getId());
				requestTools.accept("application/xml");
				ClientResponse<String> responseTools = requestTools.get(String.class);
		
				if (responseTools.getStatus() == 200) {
					Unmarshaller un2 = jaxbc.createUnmarshaller();
					outilsDto = (OutilsDTO) un2.unmarshal(new StringReader(
					responseTools.getEntity()));
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			
			//parcours de la liste des objets de la catégorie que l'on va supprimer
			Iterator<Outil> io= outilsDto.getListeOutils().iterator();
			while(io.hasNext()){
				
				final Outil outil = io.next();
				outil.setCategorie(categorieAutre);
				try {
					//>> ON MET A JOUR LA CATEGORIE AVEC UN UPDATE
					//on serialise la catégorie
					final Marshaller marshaller = jaxbc.createMarshaller();
					marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
					final java.io.StringWriter sw = new StringWriter();
					marshaller.marshal(outil, sw);
		
					//ici on envois la requete au webservice createCategorie
					final ClientRequest clientRequest = new ClientRequest(siteUrl
							+ "rest/tool/update");
					clientRequest.body("application/xml", outil);
		
					//CREDENTIALS		
					String username3 = admin.getConnexion().getLogin();
					String password3 = admin.getConnexion().getPassword();
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
						messageValue = "Categorie create OK";
						messageType = "success";
					} else {
						messageValue = "Une erreur est survenue";
						messageType = "danger";
					}
				
					} catch (Exception e) {
						e.printStackTrace();
				}
			}
			
	
			//SUPPRESSION DE LA CATEGORIE
			//>>
			
			try{
				ClientRequest requestDelete;
				requestDelete = new ClientRequest(siteUrl+"rest/categorie/delete/"+categorieGet.getId());
				requestDelete.accept("application/xml");
				
				//CREDENTIALS
				String username = admin.getConnexion().getLogin();
				String password = admin.getConnexion().getPassword();
				String base64encodedUsernameAndPassword = DatatypeConverter.printBase64Binary((username + ":" + password)
						.getBytes());
				requestDelete.header("Authorization", "Basic " +base64encodedUsernameAndPassword );
				///////////////////////////
				
				ClientResponse<String> responseDelete = requestDelete.get(String.class);
				if (responseDelete.getStatus() == 200)
				{
					messageValue = "Categorie delete OK";
					messageType = "success";
					
				}else {
					messageValue = "Une erreur est survenue";
					messageType = "danger";
				}
				
			}
			catch(Exception e){
				e.printStackTrace();
			}
		
		} else {
			errorMsg = "Impossible de supprimer la catégorie \"Autre\" (non supprimable et non modifiable)";
			errorMsgB = true;
		}
	}
	

%>

<%
	//UPDATE D'UNE CATEGORIE
	if (request.getParameter("idCat") != null && request.getParameter("idCat")!="") {

		if (!request.getParameter("catName").equals("Autre")) {
			
		
		int idEdit = Integer.parseInt(request.getParameter("idCat"));

		//on récupère la categorie que l'on veut updater/editer
		Categorie categorieGet = new Categorie();
		try {

			ClientRequest clientRequestGet;
			clientRequestGet = new ClientRequest(siteUrl
					+ "rest/categorie/" + idEdit);
			clientRequestGet.accept("application/xml");
			ClientResponse<String> response2 = clientRequestGet
					.get(String.class);

			if (response2.getStatus() == 200) {
				Unmarshaller un = jaxbc.createUnmarshaller();
				categorieGet = (Categorie) un
						.unmarshal(new StringReader(response2
								.getEntity()));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		categorieGet.setNom(request.getParameter("catName"));

		try {
			//>> ON MET A JOUR LA CATEGORIE AVEC UN UPDATE
			//on serialise la catégorie
			final Marshaller marshaller = jaxbc.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
			final java.io.StringWriter sw = new StringWriter();
			marshaller.marshal(categorieGet, sw);

			//ici on envois la requete au webservice createCategorie
			final ClientRequest clientRequestUpdate = new ClientRequest(
					siteUrl + "rest/categorie/update");
			clientRequestUpdate.body("application/xml", categorieGet);

			//CREDENTIALS		
			String username3 = admin.getConnexion().getLogin();
			String password3 = admin.getConnexion().getPassword();
			String base64encodedUsernameAndPassword3 = DatatypeConverter
					.printBase64Binary((username3 + ":" + password3)
							.getBytes());
			clientRequestUpdate.header("Authorization", "Basic "
					+ base64encodedUsernameAndPassword3);
			///////////////////

			//ici on va récuperer la réponse de la requete
			final ClientResponse<String> clientResponse = clientRequestUpdate
					.post(String.class);

			if (clientResponse.getStatus() == 200) {
				messageValue = "Categorie update OK";
				messageType = "success";
			} else {
				messageValue = "Une erreur est survenue";
				messageType = "danger";
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		}
		else {
			errorMsg = "Impossible de donner le nom \"Autre\" à une catégorie (catégorie unique non supprimable et non modifiable)";
			errorMsgB = true;
		}

	}
%>


<%

	//AFFICHAGE DES CATEGORIES
	//Le DTO des catégories permettant de récupérer la liste des categories
	CategoriesDTO categoriesDto = new CategoriesDTO();
	

	//On récupère la liste de toutes les catégories
	try {
		ClientRequest requestCategories;
		requestCategories = new ClientRequest(siteUrl+"rest/categorie/list/");
		requestCategories.accept("application/xml");
		ClientResponse<String> responseCategories = requestCategories.get(String.class);
		if (responseCategories.getStatus() == 200) {
			Unmarshaller un2 = jaxbc.createUnmarshaller();
			categoriesDto = (CategoriesDTO) un2.unmarshal(new StringReader(responseCategories.getEntity()));
			
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
$(function() {
	$(".editBtn").click(function(){
		$("#myModalLabel").html("Modifier une catégorie")
		var tmp = $(this).attr('id').split("edit")[1];
		$("#catName").val($("#nameCat"+tmp).html());
		$("#idCat").val(tmp);
		$("#categoryModal").modal('show');
	});
	$("#btnNewCat").click(function(){
		$("#myModalLabel").html("Ajouter une nouvelle catégorie")
		$("#catName").val("");
		$("#idCat").val("");
		$("#categoryModal").modal('show');
	});
	
});
</script>

<h3>Liste des catégories <span class="pull-right"><a class="btn btn-info" id="btnNewCat"><i class="glyphicon glyphicon-plus"></i> Ajouter une nouvelle catégorie</a></span></h3>
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
			<th width="10%" class="perfectCenter"><span class="reorderer" name="idOrder"></span> Id</th>
			<th width="75%" class="perfectCenter">Nom de la catégorie</th>
			<th width="15%" class="perfectCenter">Action</th>
		</tr>
	</thead>
	<tbody>
		<%
		
		Iterator<Categorie> ito=categoriesDto.getListeCategories().iterator();
		while(ito.hasNext()){
				
			final Categorie categorie = ito.next();
			
				
			
		%>
			<tr class="toPaginate">
			<td class="perfectCenter reorderable"><%=categorie.getId()%></td>
			<% 
			
			%>
			<td id="nameCat<%=categorie.getId()%>" class="perfectCenter"><%=categorie.getNom() %></td>
			<td class="perfectCenter">
				<div class="btn-group">
					<%if(!categorie.getNom().equals("Autre")){%>
						
					
					<a id="edit<%=categorie.getId()%>" class="ttipt btn btn-default editBtn" title="Editer la catégorie">
						<span class="glyphicon glyphicon-pencil"></span>
					</a>
					
					<a href="adminDashboard.jsp?page=adminManageCategories&deleteId=<%=categorie.getId()%>" class="ttipt btn btn-default" title="Supprimer la catégorie">
						<span class="glyphicon glyphicon-remove"></span>
					</a>
					<%
					}%>
				</div>
			</td>
		</tr>
	
	
		<%
		}
		%>
		
	</tbody>
</table>



<div id="paginator"></div>
<input id="paginatorNbElements" type="hidden" value="10" readonly="readonly" />

<div class="modal fade" id="categoryModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel"></h4>
			</div>
			<form method="post" action="adminDashboard.jsp?page=adminManageCategories">
				<div class="modal-body">
					<label for="catName">Nom de la catégorie</label><br />
					<input type="text" class="form-control" name="catName" id="catName" placeholder="Nom de la catégorie" value="" required />
				</div>
								
				<div class="modal-footer">
					<input type="hidden" name="idCat" id="idCat" value="" />
					<button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
					<button type="submit" class="btn btn-info">Enregistrer</button>
				</div>
			</form>
		</div>
	</div>
</div>