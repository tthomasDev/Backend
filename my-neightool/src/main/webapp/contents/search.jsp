<%@page import="java.util.ArrayList"%>

<%@include file="../functions.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

String keywordsDisplay = "Aucun recherche effectuée.", keywords = "", adds = "";
int dMax = 20, cMax = 50;
boolean othersSubmitted = false;

ArrayList<Integer> categoriesIdSelected = new ArrayList<Integer>();

ArrayList<String> categories = new ArrayList<String>();
/* TODO */
/* Récupérer la vraie liste des catégories dans la base de données */
categories.add("Jardin");
categories.add("Maison");
categories.add("Voiture");
categories.add("Sport");

if(request.getParameter("category") != null) {
	int nbC = 0;
	String cats = "";
	for(String c:request.getParameterValues("category")) {
		categoriesIdSelected.add(Integer.parseInt(c));
		nbC++;
		cats+= " <strong>categorie " + c + "</strong>, "; 
	}
	othersSubmitted = true;
	if(nbC==1)
		adds += " dans la catégorie " + cats;
	if(nbC>1)
		adds += " dans les catégories " + cats;
}
if(request.getParameter("cMax") != null && request.getParameter("cMax") != "") {
	cMax = Integer.parseInt(escapeStr(request.getParameter("cMax")));
	adds += " pour <strong>" + cMax + "€</strong> maximum,";
}
if(request.getParameter("dMax") != null && request.getParameter("dMax")!="") {
	dMax = Integer.parseInt(escapeStr(request.getParameter("dMax")));
	adds += " dans un rayon de <strong>" + dMax + " km</strong> maximum";
}
if(request.getParameter("s") != null && request.getParameter("s") != "") {
	keywords = escapeStr(request.getParameter("s"));
	keywordsDisplay = "Résultats pour <strong>" + keywords + "</strong>" + adds;
}
if(request.getParameter("s") != null && request.getParameter("s") == "" && othersSubmitted) {
	keywordsDisplay = "Résultats pour les objets" + adds; 
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
						max : 100,
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
    					<div class="checkbox"><label id="enableDistanceLbl"><strong><input type="checkbox" checked="checked" name="enableDistance" id="enableDistance"/> Distance : <span id="amountDistance"></span></strong></label></div>
						<div id="sliderDistance"></div>
						<input type="hidden" id="dMax" name="dMax" value="" />
					</div>
					<div class="form-group">
    					<div class="checkbox"><label id="enableCautionLbl"><strong><input type="checkbox" checked="checked" name="enableCaution" id="enableCaution"/> Caution maximum : <span id="amountCaution"></span></strong></label></div>
						<div id="sliderCaution"></div>
						<input type="hidden" id="cMax" name="cMax" value="" />
					</div>
					<p class="perfectCenter"><button class="btn btn-info" type="submit"><i class="glyphicon glyphicon-search"></i> Rechercher</button></p>
				</form>
			</div> 
			<div class="col-md-9">
				<ul class="nav nav-tabs">
					<li class="active"><a href="#list" data-toggle="tab"><i class="glyphicon glyphicon-th-list"></i> Liste des objets</a></li>
					<li><a href="#map" data-toggle="tab"><i class="glyphicon glyphicon-map-marker"></i> Carte</a></li>
				</ul>
				<br />
				<ol class="breadcrumb">
					<li><%=keywordsDisplay%></li>
				</ol>
				
				
				<div class="tab-content">
  					<div class="tab-pane active" id="list">
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
					<div class="tab-pane" id="map">
						Google map here
					</div>
				</div>
			</div>