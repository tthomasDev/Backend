<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String itemName="", itemVendor="", itemDescription="", itemCategory="", itemDateStart="", itemDateEnd="", itemPrice="", itemDistance="";
boolean itemFound = false;
if(request.getParameter("id") != null) {
	itemFound = true;
	/** TODO **/
	/* Parser le résultat, valeur en dure mise en exemple */
	itemName = "Exemple objet 1";
	itemVendor = "Utilisateur";
	itemDescription = "Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.";
	itemCategory = "Categorie 1";
	/* Convertion de la date en string à réaliser */
	itemDateStart = "01/02/2014";
	itemDateEnd = "31/03/2014";
	itemPrice = "50€";
	itemDistance = "9,3km";
}
%>

<% if(itemFound) { %>
	<script src="./dist/js/bootstrap-datepicker.js" charset="UTF-8"></script>
	<script src="./dist/js/bootstrap-datepicker.fr.js" charset="UTF-8"></script>
	<script type="text/javascript">
	$(document).ready(function () {
		$('.input-daterange').datepicker({
			format: "dd/mm/yyyy",
			language: "fr",
			todayBtn: "linked"
		});
	});
	</script>
	<link href="./dist/css/datepicker.css" rel="stylesheet">
	<div class="row">
		<div class="col-md-12">
			<ol class="breadcrumb">
				<li><a href="javascript:history.go(-1)">&laquo; Retour</a></li>
				<li><a href="#"><%=itemCategory%></a></li>
				<li class="active"><%=itemName%></li>
			</ol>
		</div>
	</div>
	<div class="row">
		<div class="col-md-4">
			<div class="row">
				<div class="col-md-12 perfectCenter">
					<img width="100%" height="100%" class="img-rounded" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAYAAACuwEE+AAADxElEQVR4nO3X3U7qeBSG8X3/l7KsEQQNWlQkGiuiGPCA+BWMiqC0t/DOEc1s997JvDPjR/U5+J1gm2VYT5s/P4qiEPBP/fjofwDVQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwslQrm5uZGWZap3W4rTVONRqPfXvfw8KA0TZWmqYbDYfn5YrFQv9/XxsaGGo2G9vf39fj4WJn5n0Glgul2u1pdXdXa2poiQr1e75dr8jzX1taWIkIRoSzLyr8dHBwoItRoNJSmqSJC9Xpd8/m8EvM/g0oFM5vNlOe5Dg8P/7iws7MzJUlSLmS5sKenJ62srCgiNJ1OVRRFudjBYKCrqytlWVa+NRaLhXq9nrIsK98Cbzn/o7/bLxnM0p8Wdn9/ryRJdHp6qqOjo58WNh6Pyyd6eX2WZYoI7e3t6fn5Wc1mUxGh6+tr9Xo9RYS63e67zP/o7/TbBZPnuVqtllqtlvI8/2Vho9FIEaFms1ne0+/3FRHa3t5WURSaTCZKkkS1Wk0rKytqNpt6eXl5t/lV8GWCubi4UERoNBrp9vZWnU5HEaH9/X3d3d2VT/j6+np5z/HxsSJCnU6n/Gz5Zlm+ad57/mf3ZYIZDAblol9rtVq6v79XRChJkvKtsVzqycmJiqLQfD5XvV4v79vZ2XnX+VVQqWDG47GyLNPm5ma5iCzLdHl5qbu7Ow2Hw9Ly0NlutzUej1UUhdrtdvlELw+nSZKUh9Dd3d3yELq89u8H0reeXwWVCmb5ZL/2u18rr88QRVFoOp3+9JO3VquVyzw/P1dEKE1T5Xmu2WymWq2mJEk0mUzefH5VVCqY/8tsNtPDw4PyPP+W8/+LbxkM/j2CgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKB5S+0wiW8EyQhYQAAAABJRU5ErkJggg==" />
				</div>
			</div>
		</div>
		<div class="col-md-8">
			<h4>
				<%=itemName%>
				<a class="btn btn-danger pull-right btn-xs"><i class="glyphicon glyphicon-warning-sign"></i> Signaler cet objet</a>
			</h4>
			<hr />
			<style>
				.tableTmp{padding-right:3px; text-align:right; font-weight:bold;vertical-align:top}
			</style>
			<table width="100%">
				<tr>
					<td class="tableTmp" width="30%">Vendeur : </td>
					<td width="70%"><a href="#" data-toggle="modal" data-target="#userProfile"><%=itemVendor%></a></td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td class="tableTmp">Catégorie : </td>
					<td><a href="#"><%=itemCategory%></a></td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td class="tableTmp">Description : </td>
					<td style="text-align:justify"><%=itemDescription%></td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td class="tableTmp">Disponibilités : </td>
					<td>du <%=itemDateStart%> au <%=itemDateEnd%></td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td class="tableTmp">Caution (<a href="#">?</a>) : </td>
					<td><%=itemPrice%></td>
				</tr>
			</table>
			<hr />
			<a href="#" data-toggle="modal" data-target="#confirmBorrow" class="btn btn-success pull-right btn-lg"><i class="glyphicon glyphicon-shopping-cart"></i> Demander l'emprunt de l'objet</a>
		</div>
		<jsp:include page="profile.jsp">
			<jsp:param value="1" name="userId"/>
		</jsp:include>
		<div class="modal fade" id="confirmBorrow" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<form action="#" method="POST">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
							<h4 class="modal-title" id="myModalLabel">Demande d'emprunt</h4>
						</div>
						<div class="modal-body">
							<strong>Objet concerné :</strong><br /> 
							<%=itemName%><br /><br />
							<strong>Période désirée :</strong><br />
							<div id="datepicker">
								<div class="input-daterange input-group" id="datepicker">
									<span class="input-group-addon">du </span> <input type="text" data-provide="datepicker" class="datepicker input-sm form-control" name="start" required/> 
									<span class="input-group-addon"> au </span> <input type="text" data-provide="datepicker" class="datepicker input-sm form-control" name="end" required/>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal"><i class="glyphicon glyphicon-remove"></i> Annuler</button>
							<button type="submit" class="btn btn-success"><i class="glyphicon glyphicon-ok"></i> Confirmer la demande</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	
<% } else { %>
	<div class="row">
		<div class="col-md-12 alert alert-danger perfectCenter">
			L'objet que vous demandez n'existe pas ou plus.
		</div>
	</div>
<% } %>