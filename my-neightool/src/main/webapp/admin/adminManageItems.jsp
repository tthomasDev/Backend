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

<%@ page import="java.util.Iterator" %>

<%@ page import="java.lang.StringBuilder" %>
<%@ page import="javax.xml.bind.DatatypeConverter"%>

<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";
	
	actionValid = true;

	//Le DTO des catégories permettant de récupérer la liste des categories
	OutilsDTO outilsDto = new OutilsDTO();

	final JAXBContext jaxbc = JAXBContext
	.newInstance(OutilsDTO.class,Outil.class);
	
	// get des données administrateur
	String id = String.valueOf(session.getAttribute("ID"));
	Utilisateur admin = new Utilisateur();

	try {

		ClientRequest clientRequest;
		clientRequest = new ClientRequest(siteUrl + "rest/user/" + id);
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

	String currentLog = admin.getConnexion().getLogin();
	String currentPass = admin.getConnexion().getPassword();

	//supprimer un outil = passer son boolean à inactif
	if (request.getParameter("deleteId") != null) {

		int idDelete = Integer.parseInt(request
				.getParameter("deleteId"));

		// recuperation de l'outil
		Outil outilGet = new Outil();
		try {
			ClientRequest clientRequest;
			clientRequest = new ClientRequest(siteUrl + "rest/tool/"
					+ idDelete);
			clientRequest.accept("application/xml");
			ClientResponse<String> clientResponse = clientRequest
					.get(String.class);
			if (clientResponse.getStatus() == 200) {
				Unmarshaller un = jaxbc.createUnmarshaller();
				outilGet = (Outil) un.unmarshal(new StringReader(
						clientResponse.getEntity()));

			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		outilGet.setDisponible(false);

		try {
			//>> ON MET A JOUR LA DISPONIBILITE DANS L'OUTIL AVEC UN UPDATE
			final Marshaller marshaller = jaxbc.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
			final java.io.StringWriter sw = new StringWriter();
			marshaller.marshal(outilGet, sw);

			//ici on envois la requete au webservice createCategorie
			final ClientRequest clientRequest = new ClientRequest(
					siteUrl + "rest/tool/update");
			clientRequest.body("application/xml", outilGet);

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

	//On récupère la liste de tous les outils
	try {
		ClientRequest requestCategories;
		requestCategories = new ClientRequest(siteUrl
				+ "rest/tool/list");
		requestCategories.accept("application/xml");
		ClientResponse<String> responseCategories = requestCategories
				.get(String.class);
		if (responseCategories.getStatus() == 200) {
			Unmarshaller un2 = jaxbc.createUnmarshaller();
			outilsDto = (OutilsDTO) un2.unmarshal(new StringReader(
					responseCategories.getEntity()));

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
		$("#myModalLabel").html("Modifier un outil")
		var tmp = $(this).attr('id').split("edit")[1];
		$("#catName").val($("#nameCat"+tmp).html());
		$("#idCat").val(tmp);
		$("#categoryModal").modal('show');
	});
	
	
});
</script>

<h3>Liste des outils <span class="pull-right"></span></h3>
<hr />
<table class="table table-hover" id="toReorder">
	<thead>
		<tr>
			<th width="10%" class="perfectCenter"><span class="reorderer" name="idOrder"></span> Id</th>
			<th width="30px" class="perfectCenter">Photo</th>
			<th width="20%" class="perfectCenter">Nom de l'outil</th>
			<th width="5%" class="perfectCenter">Disponible</th>
			<th width="20%" class="perfectCenter">Propriétaire</th>
			<th width="15%" class="perfectCenter">Catégorie</th>
			<th width="10%" class="perfectCenter">Caution</th>
			<th width="15%" class="perfectCenter">Action</th>
		</tr>
	</thead>
	<tbody>
		<%
		
		Iterator<Outil> ito=outilsDto.getListeOutils().iterator();
		while(ito.hasNext()){
				
			final Outil outil = ito.next();
			
			if(outil.isDisponible()){
			
		%>
			<tr class="toPaginate">
			
			<td class="perfectCenter reorderable"><%=outil.getId() %></td>
			
			<td class="perfectCenter"><img class="img-rounded" src="<%=outil.getCheminImage()%>" width="35" height="35" /></td>
			
			<td id="nameCat<%=outil.getId()%>" class="perfectCenter"><%=outil.getNom() %></td>
			<%
			Boolean b=outil.isDisponible();
			String s=new String(""+b);
			if(b){
				s="Oui";
			}
			else{
				s="Non";
			}
			%>
			<td id="nameCat<%=outil.getId()%>" class="perfectCenter"><%=s %></td>
			<%
				String str2= outil.getUtilisateur().getConnexion().getLogin();
			%>
			<td id="nameCat<%=outil.getId()%>" class="perfectCenter"><%=str2 %></td>
			<% 
				String str= outil.getCategorie().getNom();
				if(str.equals(null)){
					str="Pas de catégorie";
				}
			%>
			<td id="nameCat<%=outil.getId()%>" class="perfectCenter"><%=str %></td>
			<td id="nameCat<%=outil.getId()%>" class="perfectCenter"><%=outil.getCaution() %></td>
			<td class="perfectCenter">
				<div class="btn-group">
					<a href="adminDashboard.jsp?page=adminManageItems&deleteId=<%=outil.getId()%>" class="ttipt btn btn-danger" title="Supprimer l'outil">
						<span class="glyphicon glyphicon-remove"></span>
					</a>
				</div>
			</td>
		</tr>
	
	
		<%
			}
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