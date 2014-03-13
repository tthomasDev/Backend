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

<%@ page import="java.util.Iterator" %>

<%@ page import="java.lang.StringBuilder" %>

<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";
	
	actionValid = true;

	UtilisateursDTO usersDto = new UtilisateursDTO();
	final JAXBContext jaxbc = JAXBContext.newInstance(UtilisateursDTO.class,Utilisateur.class);
	// On récupère la liste de tous les utilisateurs disponibles
	try {
		ClientRequest requestUsers;
		requestUsers = new ClientRequest(siteUrl + "rest/user/listAsc");
		requestUsers.accept("application/xml");
		ClientResponse<String> responseUsers = requestUsers
				.get(String.class);
		if (responseUsers.getStatus() == 200) {
			Unmarshaller un2 = jaxbc.createUnmarshaller();
			usersDto = (UtilisateursDTO) un2.unmarshal(new StringReader(
					responseUsers.getEntity()));

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
		$("#myModalLabel").html("Modifier un utilisateur")
		var tmp = $(this).attr('id').split("edit")[1];
		$("#catName").val($("#nameCat"+tmp).html());
		$("#idCat").val(tmp);
		$("#categoryModal").modal('show');
	});
	
	
});
</script>

<h3>Liste des utilisateurs <span class="pull-right"></span></h3>
<hr />
<table class="table table-hover">
	<thead>
		<tr>
			<th width="10%" class="perfectCenter">Id</th>
			<th width="20%" class="perfectCenter">Prénom</th>
			<th width="20%" class="perfectCenter">Nom</th>
			<th width="35%" class="perfectCenter">e-mail</th>
			<th width="15%" class="perfectCenter">Action</th>
		</tr>
	</thead>
	<tbody>
		<%
		
		Iterator<Utilisateur> ito=usersDto.getListeUtilisateurs().iterator();
		while(ito.hasNext()){
				
			final Utilisateur u = ito.next();
			
				
			
		%>
			<tr class="toPaginate">
			<td class="perfectCenter"><%=u.getId()%></td>
			<% 
			
			%>
			<td id="nameCat<%=u.getId()%>" class="perfectCenter"><%=u.getPrenom() %></td>
			<td id="nameCat<%=u.getId()%>" class="perfectCenter"><%=u.getNom() %></td>
			<td id="nameCat<%=u.getId()%>" class="perfectCenter"><%=u.getMail() %></td>
			<td class="perfectCenter">
				<div class="btn-group">
					<a id="edit<%=u.getId()%>" class="ttipt btn btn-default editBtn" title="Editer la catégorie">
						<span class="glyphicon glyphicon-pencil"></span>
					</a>
					<a href="adminDashboard.jsp?page=adminManageCategories&deleteId=<%=u.getId()%>" class="ttipt btn btn-default" title="Supprimer la catégorie">
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