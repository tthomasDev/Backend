<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

String keywordsDisplay = "Aucun recherche effectuée.", keywords = "";
int dMax = 80, dMin = 20, cMax = 50;
boolean isSearch = false;

ArrayList<Integer> categoriesIdSelected = new ArrayList<Integer>();

ArrayList<String> categories = new ArrayList<String>();
/* TODO */
/* Récupérer la vraie liste des catégories dans la base de données */
categories.add("Jardin");
categories.add("Maison");
categories.add("Voiture");
categories.add("Sport");

if(request.getParameter("s") != null && request.getParameter("s") != "") {
	keywords = request.getParameter("s");
	keywordsDisplay = "Résultats pour : " + keywords; 
	isSearch = true;
}
if(request.getParameter("category") != null) {
	for(String c:request.getParameterValues("category"))
		categoriesIdSelected.add(Integer.parseInt(c));
}
if(request.getParameter("cMax") != null && request.getParameter("cMax") != "") {
	cMax = Integer.parseInt(request.getParameter("cMax"));
}
if(request.getParameter("dMin") != null && request.getParameter("dMin")!="" && request.getParameter("dMax") != null && request.getParameter("dMax")!="") {
	dMin = Integer.parseInt(request.getParameter("dMin"));
	dMax = Integer.parseInt(request.getParameter("dMax"));
}
	
%>
			<script>
				$(function() {
					$("#sliderDistance").slider({
						range : true,
						min : 1,
						max : 100,
						values : [ <%=dMin%>, <%=dMax%> ],
						slide : function(event, ui) {
							$("#amountDistance").html(ui.values[0] + " km - " + ui.values[1] + " km");
							$("#dMin").val(ui.values[0]);
							$("#dMax").val(ui.values[1]);
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
					$("#amountDistance").html($("#sliderDistance").slider("values", 0) + " km - " + $("#sliderDistance").slider("values", 1) + " km");
					$("#dMin").val($("#sliderDistance").slider("values", 0));
					$("#dMax").val($("#sliderDistance").slider("values", 1));
				});
			</script>
			<div class="col-md-3 well">
				<h4 class="perfectCenter">Critères de recherche</h4>
				<hr />
				<form action="dashboard.jsp" method="GET">
					<input type="hidden" name="page" value="search" />
					<div class="form-group">
    					<label for="s">Nom</label>
						<input type="text" placeholder="Nom de l'outil" value="<%=keywords%>" class="form-control" name="s" />
					</div>
					<div class="form-group">
    					<label for="category">Catégorie (<a href="javascript:void(0);" class="ttipr" title="Gardez la touche Ctrl appuyée pour sélectionner plusieurs catégories">?</a>)</label>
						<select name="category" class="form-control" multiple>
							<% 
							for(String cat:categories) { 
								if(categoriesIdSelected.contains(categories.indexOf(cat))) {
							%>
							<option value="<%=categories.indexOf(cat)%>" selected><%=cat%></option>
							<%  } else { %>
							<option value="<%=categories.indexOf(cat)%>"><%=cat%></option>
							<% }} %>
						</select>
					</div>
					<div class="form-group">
    					<label for="distance">Distance : <span id="amountDistance"></span></label>
						<div id="sliderDistance"></div>
						<input type="hidden" id="dMin" name="dMin" value="" />
						<input type="hidden" id="dMax" name="dMax" value="" />
					</div>
					<div class="form-group">
    					<label for="caution">Caution maximum : <span id="amountCaution"></span></label>
						<div id="sliderCaution"></div>
						<input type="hidden" id="cMax" name="cMax" value="" />
					</div>
					<hr />
					<p class="perfectCenter"><button class="btn btn-info" type="submit"><i class="glyphicon glyphicon-search"></i> Rechercher</button></p>
				</form>
			</div> 
			<div class="col-md-9">
				<ol class="breadcrumb">
					<li><%=keywordsDisplay%></li>
				</ol>
				
				<div class="table-responsive">
					<table class="table table-hover">
						<thead>
							<tr>
								<th class="perfectCenter" width="140px">Photo</th>
								<th class="perfectCenter" width="80%">Description</th>
								<th class="perfectCenter" width="20%">Distance <a href="#"><span class="glyphicon glyphicon-chevron-up"></span></a><a href="#"><span class="glyphicon glyphicon-chevron-down"></span></a></th>
							</tr>
						</thead>
						<tbody>
							<tr class="perfectCenter">
								<td colspan="3">Aucune recherche actuellement effectuée</td>
							</tr>
						</tbody>
					</table>
				</div>
			
				<div class="row">
					<div class="col-md-12" style="text-align:center;">
						<ul class="pagination">
							<li><a href="#">&laquo;</a></li>
							<li><a href="#">1</a></li>
							<li><a href="#">&raquo;</a></li>
						</ul>
					</div>
				</div>
			</div>