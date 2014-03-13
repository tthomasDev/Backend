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

<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";
	
	actionValid = true;

	//Le DTO des catégories permettant de récupérer la liste des categories
	CategoriesDTO categoriesDto = new CategoriesDTO();

	final JAXBContext jaxbc = JAXBContext
			.newInstance(CategoriesDTO.class);

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
		$("#myModalLabel").html("Ajoute une nouvelle catégorie")
		$("#catName").val("");
		$("#idCat").val("");
		$("#categoryModal").modal('show');
	});
	
});
</script>

<h3>Liste des catégories <span class="pull-right"><a class="btn btn-info" id="btnNewCat"><i class="glyphicon glyphicon-plus"></i> Ajouter une nouvelle catégorie</a></span></h3>
<hr />
<table class="table table-hover">
	<thead>
		<tr>
			<th width="10%" class="perfectCenter">Id</th>
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
			<td class="perfectCenter"><%=categorie.getId()%></td>
			<% 
			
			%>
			<td id="nameCat<%=categorie.getId()%>" class="perfectCenter"><%=categorie.getNom() %></td>
			<td class="perfectCenter">
				<div class="btn-group">
					<a id="edit<%=categorie.getId()%>" class="ttipt btn btn-default editBtn" title="Editer la catégorie">
						<span class="glyphicon glyphicon-pencil"></span>
					</a>
					<a href="adminDashboard.jsp?page=adminManageCategories&deleteId=<%=categorie.getId()%>" class="ttipt btn btn-default" title="Supprimer la catégorie">
						<span class="glyphicon glyphicon-remove"></span>
					</a>
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