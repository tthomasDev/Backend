<%@page import="java.util.ArrayList"%>

<%@include file="../functions.jsp"%>

<%@include file="../constantes.jsp"%>

<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>

<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>

<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>

<%@ page import="com.ped.myneightool.model.Categorie"%>
<%@ page import="com.ped.myneightool.dto.CategoriesDTO"%>

<%@ page import="com.ped.myneightool.model.Outil"%>
<%@ page import="com.ped.myneightool.dto.OutilsDTO"%>

<%@ page import="com.ped.myneightool.model.Utilisateur"%>
<%@ page import="com.ped.myneightool.dto.UtilisateursDTO"%>
<%@ page import="java.util.Iterator"%>

<%@ page import="java.text.DecimalFormat"%>


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String keywordsDisplay = "Aucun recherche effectuée.", keywords = "", adds = "";
int dMax = 20, cMax = 50;
boolean othersSubmitted = false;

ArrayList<Integer> categoriesIdSelected = new ArrayList<Integer>();

ArrayList<String> categories = new ArrayList<String>();

ArrayList<OutilsDTO> arrayListeOutilsCat = new ArrayList<OutilsDTO>();

boolean actionValid = false;
String messageType = "";
String messageValue = "";
boolean list=false;

actionValid = true;
	

//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
final JAXBContext jaxbc = JAXBContext.newInstance(CategoriesDTO.class);
final JAXBContext jaxbc2 = JAXBContext.newInstance(OutilsDTO.class, Outil.class);


////////////////////////////////
//Récupération des Outils
////////////////////////////////
// Le DTO des outils permettant de récupérer la liste complète des outils disponibles
OutilsDTO listeAllTools = new OutilsDTO();

//On récupère la liste de tous les objets disponibles
	try {
		ClientRequest requestTools;
		requestTools = new ClientRequest(siteUrl + "rest/tool/list/available");
		requestTools.accept("application/xml");
		ClientResponse<String> responseTools = requestTools.get(String.class);
		if (responseTools.getStatus() == 200) {
	Unmarshaller un2 = jaxbc2.createUnmarshaller();
	listeAllTools = (OutilsDTO) un2.unmarshal(new StringReader(
			responseTools.getEntity()));
			
	messageValue = "La liste a bien été récupérée";
	messageType = "success";
		} else {
	messageValue = "Une erreur est survenue";
	messageType = "danger";
		}
	} catch (Exception e) {
		e.printStackTrace();
	}

////////////////////////////////
//Récupération des Categories
////////////////////////////////
// Le DTO des catégories permettant de récupérer la liste des categories
CategoriesDTO categoriesDto = new CategoriesDTO();

// On récupère la liste de toutes les catégories
try {
	ClientRequest requestCategories;
	requestCategories = new ClientRequest(siteUrl + "rest/categorie/list/");
	requestCategories.accept("application/xml");
	ClientResponse<String> responseCategories = requestCategories
	.get(String.class);
	if (responseCategories.getStatus() == 200) {
		Unmarshaller un2 = jaxbc.createUnmarshaller();
		categoriesDto = (CategoriesDTO) un2.unmarshal(new StringReader(
		responseCategories.getEntity()));
		if(categoriesDto.size()>0)
		{
	list=true;
	System.out.println("LISTE TRUE");
		}
		else
		{
	list=false;	
	System.out.println("LISTE FALSE");
	
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

////////////////////////////////
//Récupération des Utilisateurs
////////////////////////////////
UtilisateursDTO usersDTO = new UtilisateursDTO();
final JAXBContext jaxbc3 = JAXBContext.newInstance(UtilisateursDTO.class);

try {
ClientRequest clientRequest;
clientRequest = new ClientRequest(
siteUrl+"rest/user/list");
clientRequest.accept("application/xml");
ClientResponse<String> response2 = clientRequest.get(String.class);
if (response2.getStatus() == 200) {
	Unmarshaller un = jaxbc3.createUnmarshaller();
	usersDTO = (UtilisateursDTO) un.unmarshal(new StringReader(
	response2.getEntity()));
}

} catch (Exception e) {
e.printStackTrace();
}


////////////////////////////////
//UTILISATEUR COURANT
////////////////////////////////

JAXBContext jaxbc4=JAXBContext.newInstance(Utilisateur.class);
Utilisateur currentUser = new Utilisateur();

try {
	ClientRequest clientRequest;
	clientRequest = new ClientRequest(siteUrl + "rest/user/" + session.getAttribute("ID"));
	clientRequest.accept("application/xml");
	ClientResponse<String> clientResponse = clientRequest.get(String.class);
	if (clientResponse.getStatus() == 200)
	{
		Unmarshaller un = jaxbc4.createUnmarshaller();
		currentUser = (Utilisateur) un.unmarshal(new StringReader(clientResponse.getEntity()));
		
	}
} catch (Exception e) {
	e.printStackTrace();
}


for (Categorie c : categoriesDto.getListeCategories()) {
	categories.add(c.getNom());
}


if(request.getParameter("category") != null) {
	int nbC = 0;
	String cats = "";
	for(String c:request.getParameterValues("category")) {
		categoriesIdSelected.add(Integer.parseInt(c));
		cats+= " <strong>" + categories.get(categories.size()-categoriesIdSelected.get(nbC)) + "</strong>, ";

		nbC++;
	}
	
	othersSubmitted = true;
	if(nbC==1)
		adds += " dans la catégorie " + cats;
	if(nbC>1)
		adds += " dans les catégories " + cats;

	//if(request.getParameter("cMax") == null && request.getParameter("dMax") == null)
	//{

		for (int i = 0; i < nbC; i++) {
			// On récupère la liste des outils correspondants une catégorie spécifique
			try {
				ClientRequest requestTools;
				requestTools = new ClientRequest(siteUrl
						+ "rest/tool/categorie/available/"
						+ (request.getParameterValues("category"))[i]);
				requestTools.accept("application/xml");
				ClientResponse<String> responseTools = requestTools
						.get(String.class);

				if (responseTools.getStatus() == 200) {
					Unmarshaller un2 = jaxbc2.createUnmarshaller();
					arrayListeOutilsCat.add((OutilsDTO) un2
							.unmarshal(new StringReader(responseTools
									.getEntity())));

					// et ici on peut vérifier que c'est bien le bon objet
					messageValue = "Les détails de la catégorie ont bien été récupérés.";
					messageType = "success";
				} else {
					messageValue = "Une erreur est survenue";
					messageType = "danger";
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
		

	//}
	if (request.getParameter("cMax") != null
			&& request.getParameter("cMax") != "") {
		cMax = Integer
				.parseInt(escapeStr(request.getParameter("cMax")));
		adds += " pour <strong>" + cMax + "€</strong> maximum,";

		
		//Si aucune categorie n'est selectionnée, on tri parmis la liste de tous les outils
		if (request.getParameter("category") == null)
		{
			//On enlève de la liste les outils qui n'ont pas le même nom que le nom demandé
			for(int i=0; i<listeAllTools.size();i++)
			{

				for (Iterator<Outil> it = listeAllTools.getListeOutils().iterator(); it.hasNext(); ) {
					Outil o = it.next();
					if (o.getCaution() > cMax)
					{
						System.out.println("CAUTION TROP CHER ! ");
						it.remove();
					}
					
					else
						System.out.println("CAUTION ACCEPTABLE ! " + request.getParameter("cMax") + " " + o.getCaution());
				}
			}
			
		}
		else
		{
			//On enlève de la liste les outils qui ont une caution trop elevee par rapport à la demande
			for(int i=0; i<arrayListeOutilsCat.size();i++)
			{
				for (Iterator<Outil> it = arrayListeOutilsCat.get(i).getListeOutils().iterator(); it.hasNext(); ) {
					Outil o = it.next();
					if (o.getCaution() > cMax)
					{
						System.out.println("CAUTION TROP CHER ! ");
						it.remove();
					}
					
					else
						System.out.println("CAUTION ACCEPTABLE ! " + request.getParameter("cMax") + " " + o.getCaution());
				}
			}
		}
		
	}
	if (request.getParameter("dMax") != null
			&& request.getParameter("dMax") != "") {
		dMax = Integer
				.parseInt(escapeStr(request.getParameter("dMax")));
		adds += " dans un rayon de <strong>" + dMax
				+ " km</strong> maximum";
		
		
		//Filtrer en fonction de la distance demandée par l'utilisateur
		
		
		float currentUserLat = currentUser.getAdresse().getLatitude();
		float currentUserLng = currentUser.getAdresse().getLongitude();
		
		if (request.getParameter("category") != null)
		{
			for(int i=0; i<arrayListeOutilsCat.size();i++)
			{
				for (Iterator<Outil> it = arrayListeOutilsCat.get(i).getListeOutils().iterator(); it.hasNext(); ) {
					Outil o = it.next();
					
					float userLat = o.getUtilisateur().getAdresse().getLatitude();
					float userLng = o.getUtilisateur().getAdresse().getLongitude();
					double distance = distFrom(currentUserLat, currentUserLng, userLat, userLng);
					if(distance>dMax)
					{
						System.out.println("TROP LOIN !");
						it.remove();
					}
					else
					{
						System.out.println("PAS TROP LOIN !");
					}
				}
			}
		}
		else
		{
			for (Iterator<Outil> it = listeAllTools.getListeOutils().iterator(); it.hasNext(); ) {
				Outil o = it.next();
				
				float userLat = o.getUtilisateur().getAdresse().getLatitude();
				float userLng = o.getUtilisateur().getAdresse().getLongitude();
				double distance = distFrom(currentUserLat, currentUserLng, userLat, userLng);
				if(distance>dMax)
				{
					System.out.println("TROP LOIN !");
					it.remove();
				}
				else
				{
					System.out.println("PAS TROP LOIN !");
				}
			}
		}
		
		
		
	}
	
	
	
	if (request.getParameter("s") != null
			&& request.getParameter("s") != "") {
		keywords = escapeStr(request.getParameter("s"));
		keywordsDisplay = "Résultats pour <strong>" + keywords
				+ "</strong>" + adds;
		
		//Si aucune categorie n'est selectionnée, on tri parmis la liste de tous les outils
		if (request.getParameter("category") == null)
		{
			//On enlève de la liste les outils qui n'ont pas le même nom que le nom demandé

			for (Iterator<Outil> it = listeAllTools.getListeOutils().iterator(); it.hasNext(); ) {
				Outil o = it.next();
				if (!like(o.getNom(),keywords))
				{
					System.out.println("CEST PAS LE MEME NOM ! ");
					it.remove();
				}
				
				else
					System.out.println("CEST LE MEME NOM ! " + request.getParameter("s") + " " + o.getNom());
			}
			arrayListeOutilsCat.add(listeAllTools);
		}
		//Sinon on tri parmis la liste des outils des catégories selectionnée
		else
		{
			//On enlève de la liste les outils qui n'ont pas le même nom que le nom demandé
			for(int i=0; i<arrayListeOutilsCat.size();i++)
			{
				for (Iterator<Outil> it = arrayListeOutilsCat.get(i).getListeOutils().iterator(); it.hasNext(); ) {
					Outil o = it.next();
					if (!like(o.getNom(),keywords))
					{
						System.out.println("CEST PAS LE MEME NOM ! ");
						it.remove();
					}
					
					else
						System.out.println("CEST LE MEME NOM ! " + request.getParameter("s") + " " + o.getNom());
				}
			}
		}
	}
	if (request.getParameter("s") != null
			&& request.getParameter("s") == "" && othersSubmitted) {
		keywordsDisplay = "Résultats pour les objets" + adds;
	}
	String cautionEnable = "", distanceEnable = "";
	if(request.getParameter("enableDistance")!=null && request.getParameter("enableDistance").equals("on")) {
		distanceEnable = "checked='checked'";
	}
	if(request.getParameter("enableCaution")!=null && request.getParameter("enableCaution").equals("on")) {
		cautionEnable = "checked='checked'";
	}
%>
<script>
				var activateDistance = false;
				var activateCaution = false;
				$(function() {
					$("#enableDistance").click(function() {
						if($("#enableDistance").is(':checked')) {
							$("#amountDistance").html($("#sliderDistance").slider("value") + " km maximum");
							$("#sliderDistance").show();
							$("#dMax").prop('disabled', false);
						} else {
							$("#amountDistance").html("Désactivée");
							$("#sliderDistance").hide();
							$("#dMax").prop('disabled', true);
						}
					});
					$("#enableCaution").click(function() {
						if($("#enableCaution").is(':checked')) {
							$("#amountCaution").html($("#sliderCaution").slider("value") + "€");
							$("#sliderCaution").show();
							$("#cMax").prop('disabled', false);
						} else {
							$("#amountCaution").html("Désactivée");
							$("#sliderCaution").hide();
							$("#cMax").prop('disabled', true);
						}
					});
					
					$("#sliderDistance").slider({
						range : "min",
						value: <%=dMax%>,
						min : 0,
						max : 200,
						step: 5,
						values : <%=dMax%>,
						slide : function(event, ui) {
							if(ui.value == 0)
								$("#amountDistance").html("< 1 km");
							else
								$("#amountDistance").html(ui.value + " km maximum");
							$("#dMax").val(ui.value);
						}
					});
					$("#sliderCaution").slider({
						range: "min",
						value: <%=cMax%>,
						min: 1,
						max: 500,
						slide: function(event, ui) {
							$("#amountCaution").html(ui.value + "€");
							$("#cMax").val(ui.value);
						}
					});
					$("#amountCaution").html($("#sliderCaution").slider("value") + "€");
					$("#cMax").val(<%=cMax%>);
					if($("#sliderDistance").slider("value")==0)
						$("#amountDistance").html("< 1 km");
					else
						$("#amountDistance").html($("#sliderDistance").slider("value") + " km maximum");
					$("#dMax").val($("#sliderDistance").slider("value"));
					<% if(distanceEnable.equals("")) { %>
						$("#amountDistance").html("Désactivée");
						$("#sliderDistance").hide();
						$("#dMax").prop('disabled', true);
					<% } %>
					<% if(cautionEnable.equals("")) { %>
						$("#amountCaution").html("Désactivée");
						$("#sliderCaution").hide();
						$("#cMax").prop('disabled', true);
					<% } %>
				});
			</script>
			
			
	<select style="display:none;" class="form-control" id="users" name="users">
		<% 	
			float currentUserLat = currentUser.getAdresse().getLatitude();
			float currentUserLng = currentUser.getAdresse().getLongitude();
			int num = 0;
			for(OutilsDTO outilDTO : arrayListeOutilsCat)
			{
				for(Outil o : outilDTO.getListeOutils())
				{

					float userLat = o.getUtilisateur().getAdresse().getLatitude();
					float userLng = o.getUtilisateur().getAdresse().getLongitude();
					
					double distance = distFrom(currentUserLat, currentUserLng, userLat, userLng);
					String distanceStr = new DecimalFormat("#").format(distance);
					
					out.println("<option value='" + num + "'>"
							+ o.getId() + "\\"
							+ o.getNom() + "\\"
							+ o.getDescription() + "\\"
							+ o.getCheminImage() + "\\"
							+ o.getCaution() + "\\"
							+ distanceStr + "\\"
							+ o.getUtilisateur().getNom() + "\\"
							+ o.getUtilisateur().getAdresse().getLatitude() + "\\"
							+ o.getUtilisateur().getAdresse().getLongitude()
							+ "</option>");
					num++;
				}
			}
		
		
		%>
	</select>
	<input type="hidden" value="<%=currentUserLat %>" name="lat" id="lat"> <input type="hidden" value="<%=currentUserLng %>" name="lng" id="lng">
	
	
<div class="col-md-3 well">
	<h4 class="perfectCenter">Critères de recherche</h4>
	<hr />
	<form action="dashboard.jsp" method="GET">
		<input type="hidden" name="page" value="search" />
		<div class="form-group">
			<label for="s">Nom</label> <input type="text"
				placeholder="Nom de l'outil" value="<%=keywords%>"
				class="form-control" name="s" />
		</div>
		<div class="form-group">
			<label for="category">Catégorie (<a
				href="javascript:void(0);" class="ttipr"
				title="Gardez la touche Ctrl appuyée pour sélectionner plusieurs catégories">?</a>)
			</label> <select name="category" class="form-control" multiple>
				<% 
				for(Categorie cat : categoriesDto.getListeCategories()) { 
					if(categoriesIdSelected.contains(cat.getId())) {
							%>
				<option value="<%=cat.getId()%>" selected><%=cat.getNom()%></option>
				<%  } else { %>
				<option value="<%=cat.getId()%>"><%=cat.getNom()%></option>
				<% }} %>
			</select>
		</div>
		<div class="form-group">
			<div class="checkbox">
				<label id="enableDistanceLbl"><strong><input
						type="checkbox" <%=distanceEnable%> name="enableDistance"
						id="enableDistance" /> Distance : <span id="amountDistance"></span></strong></label>
			</div>
			<div id="sliderDistance"></div>
			<input type="hidden" id="dMax" name="dMax" value="" />
		</div>
		<div class="form-group">
			<div class="checkbox">
				<label id="enableCautionLbl"><strong><input
						type="checkbox" <%=cautionEnable%> name="enableCaution"
						id="enableCaution" /> Caution maximum : <span id="amountCaution"></span></strong></label>
			</div>
			<div id="sliderCaution"></div>
			<input type="hidden" id="cMax" name="cMax" value="" />
		</div>
		<p class="perfectCenter">
			<button class="btn btn-info" type="submit">
				<i class="glyphicon glyphicon-search"></i> Rechercher
			</button>
		</p>
	</form>
</div>
<div class="col-md-9">
	<ul class="nav nav-tabs">
		<li class="active"><a href="#list" data-toggle="tab"><i
				class="glyphicon glyphicon-th-list"></i> Liste des objets</a></li>
		<li><a href="#map" data-toggle="tab" onclick="google.maps.event.trigger(map,'resize')"><i
				class="glyphicon glyphicon-map-marker"></i> Carte</a></li>
	</ul>
	<br />
	<ol class="breadcrumb">
		<li><%=keywordsDisplay%></li>
	</ol>


	<div class="tab-content">
		<div class="tab-pane active" id="list">
			<div class="table-responsive">
				<table class="table table-hover" id="toReorder" >
					<thead>
						<tr>
							<th class="perfectCenter" width="140px">Photo</th>
							<th class="perfectCenter" width="60%">Description</th>
							<th class="perfectCenter" width="20%">Caution</th>
							<th class="perfectCenter" width="20%">Distance <span class="reorderer" name="distance"></span></th> 
						</tr>
					</thead>
					<tbody>
							<% 
							if(request.getParameter("category")!=null || arrayListeOutilsCat.size()>0) {
							int nbOutils = 0;
							
							for (int i=0; i<arrayListeOutilsCat.size(); i++){
								for (Outil t : arrayListeOutilsCat.get(i).getListeOutils()) {
									nbOutils++;
									%>
									<tr class="toPaginate resize140">
										<td class="perfectCenter "><img class="img-rounded" src="<%=t.getCheminImage() %>" /></td>
										<td style="vertical-align: middle;"><strong><a
												href="dashboard.jsp?page=itemDetails&id=<%=t.getId()%>"><%=t.getNom() %></a></strong><br />
											<p><%=t.getDescription() %></p></td>
										<td class="perfectCenter "><%=t.getCaution() + " "%> euros</td>
										<td class="perfectCenter reorderable">
										<%							
								
										float userLat = t.getUtilisateur().getAdresse().getLatitude();
										float userLng = t.getUtilisateur().getAdresse().getLongitude();
										
										double distance = distFrom(currentUserLat, currentUserLng, userLat, userLng);
										String distanceStr = new DecimalFormat("#").format(distance);
										 %>
										<%= distanceStr + " km"%>
										</td>
									</tr>
								<% 
									}
							
								}

							if (nbOutils == 0){
								%>
								<tr class="perfectCenter">
								<td colspan="4">Aucuns résultats</td>
								</tr>
								<%
							}
							
							}else {%>
								<tr class="perfectCenter">
									<td colspan="4">Aucune recherche actuellement effectuée</td>
								</tr>
							<%} %>
					</tbody>
				</table>
			</div>
			<div id="paginator"></div>
			<input id="paginatorNbElements" type="hidden" value="5"
				readonly="readonly" />
		</div>
		<!-- <script type="text/javascript"
			src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAsO96nmOiM5A5mef1oNv4PZoETDWvfJ88&sensor=false"></script> -->
		<script src="./dist/js/mapsSearch.js"></script>
		<style>
#map-canvas {
	height: 600px !important;
}


#map-canvas img {
	max-width: none !important;
	box-shadow: none !important;
}

#map-canvas label {
	width: auto !important;
	display: inline !important;
}

.gmap-icons img {
	max-width: none
}
</style>
		<div class="tab-pane" id="map">
			<div class="img-rounded" id="map-canvas"
				style="background-color: #DDD;"></div>
		</div>
	</div>
</div>