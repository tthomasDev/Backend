<%@page import="javax.xml.stream.events.EndDocument"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../constantes.jsp"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.sql.Timestamp"%>

<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>

<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>

<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>

<%@ page import="model.Emprunt"%>
<%@ page import="model.Outil"%>
<%@ page import="model.Utilisateur"%>
<%@ page import="model.Emprunt"%>
<%@ page import="dto.OutilsDTO"%>
<%@ page import="dto.EmpruntsDTO"%>
<%@include file="../functions.jsp"%>

<%
String itemName="", itemVendor="", itemDescription="", itemCategory="", itemDateStart="";
String itemDateEnd="", itemPrice="", itemDistance="", itemPath="", userID="", itemCategoryID="";
int itemId = -1;

boolean itemFound = false;

boolean displayMessage = false;
String messageType = "";
String messageValue = "";

//On récupère les données de session de l'utilisateur
final String id = String.valueOf(session.getAttribute("ID"));
final String userName = String.valueOf(session.getAttribute("userName"));

//La liste des outils correspondant à une catégorie spécifique
OutilsDTO listeOutilsCat = new OutilsDTO();

if(request.getParameter("id") != null) {
	itemFound = true;
	
		//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
		final JAXBContext jaxbc = JAXBContext.newInstance(Emprunt.class, Outil.class,
				Utilisateur.class);
		final JAXBContext jaxbc2 = JAXBContext.newInstance(OutilsDTO.class);

		// Utilisateur
		Utilisateur user = new Utilisateur();

		// L'outil résultant de la requête souhaitée
		Outil outil = new Outil();
		
		// L'outil que l'on récupère après modification (isDisponible)
		Outil toolUpdated = new Outil();

		// ici on envoit la requete permettant de récupérer les données complètes
		// sur l'utilisateur en ligne
		try {
			ClientRequest clientRequest;
			clientRequest = new ClientRequest(
			siteUrl + "rest/user/" + id);
			clientRequest.accept("application/xml");
			ClientResponse<String> response2 = clientRequest.get(String.class);
			if (response2.getStatus() == 200) {
				Unmarshaller un = jaxbc.createUnmarshaller();
				user = (Utilisateur) un.unmarshal(new StringReader(
				response2.getEntity()));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// On récupère ensuite la liste des outils correspondants une catégorie spécifique
		try {
			ClientRequest requestTools;
			requestTools = new ClientRequest(siteUrl + "rest/tool/" + escapeStr(request.getParameter("id")));
			requestTools.accept("application/xml");
			ClientResponse<String> responseTools = requestTools
			.get(String.class);

			if (responseTools.getStatus() == 200) {
				Unmarshaller un2 = jaxbc2.createUnmarshaller();
				outil = (Outil) un2.unmarshal(new StringReader(
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
		
		// On récupère ensuite la liste des outils correspondants une catégorie spécifique
		try {
			ClientRequest requestTools;
			requestTools = new ClientRequest(siteUrl + "rest/tool/categorie/" + outil.getCategorie().getId());
			requestTools.accept("application/xml");
			ClientResponse<String> responseTools = requestTools.get(String.class);

			if (responseTools.getStatus() == 200) {
				Unmarshaller un2 = jaxbc2.createUnmarshaller();
				listeOutilsCat = (OutilsDTO) un2.unmarshal(new StringReader(
				responseTools.getEntity()));
				
				// et ici on peut vérifier que c'est bien le bon objet
				messageValue = "Les détails de la catégorie ont bien été récupérés.";
				messageType = "success";
			} else {
				messageValue = "Une erreur est survenue 1";
				messageType = "danger";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		itemId = outil.getId();
		itemName = outil.getNom();
		itemVendor = outil.getUtilisateur().getConnexion().getLogin();
		itemDescription = outil.getDescription();
		itemCategory = outil.getCategorie().getNom();
		itemCategoryID = String.valueOf(outil.getCategorie().getId());
		itemPath = outil.getCheminImage();
		
		// ID utilisateur
		userID = String.valueOf(user.getId());
		
		// Conversion des dates
		DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		itemDateStart = df.format(outil.getDateDebut());
		//System.out.println("Start date: " + itemDateStart);
	
		DateFormat df2 = new SimpleDateFormat("dd/MM/yyyy");
		itemDateEnd = df2.format(outil.getDateFin());
		//System.out.println("End date: " + itemDateEnd);
		
		itemPrice = String.valueOf(outil.getCaution());

		if (request.getParameter("start2") != ""
				&& request.getParameter("end2") != ""
				&& request.getParameter("start2") != null
				&& request.getParameter("end2") != null) {
				
			/*Contrôles sur les dates de demande d'emprunt */
			String dateStart2 = request.getParameter("start2");
			String dateEnd2 = request.getParameter("end2");
			Date startDate = new SimpleDateFormat("dd/MM/yyyy").parse(dateStart2);
			Date endDate = new SimpleDateFormat("dd/MM/yyyy").parse(dateEnd2);
		
			System.out.println("SD / deb : " + startDate.compareTo(outil.getDateDebut()));
			System.out.println("SD / fin : " + endDate.compareTo(outil.getDateFin()));

			final ClientRequest clientRequestEmprunt = new ClientRequest(siteUrl + "rest/emprunt/create");
			
			if ((startDate.compareTo(outil.getDateDebut())) != -1
					&& startDate.compareTo(outil.getDateFin()) != 1
					&& endDate.compareTo(outil.getDateDebut()) != -1
					&& endDate.compareTo(outil.getDateFin()) != 1
					&& outil.isDisponible()) {
				final Emprunt emprunt = new Emprunt(outil, user, startDate, endDate,1);
				
				//ici il faut sérialiser l'emprunt
				final Marshaller marshaller = jaxbc.createMarshaller();
				marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
				final java.io.StringWriter sw = new StringWriter();
				marshaller.marshal(emprunt, sw);			
				
				//ici on envoit la requete au webservice createEmprunt
				clientRequestEmprunt.body("application/xml", emprunt);
				
				// On rend l'outil indisponible désormais
/* 				outil.setDisponible(false);
				
				try {
					final ClientRequest requestToolUpdate = new ClientRequest(siteUrl + "rest/tool/update");

					//ici il faut sérialiser l'outil
					final Marshaller marshaller2 = jaxbc.createMarshaller();
					marshaller2.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
					final java.io.StringWriter sw2 = new StringWriter();
					marshaller2.marshal(outil, sw2);

					requestToolUpdate.body("application/xml", outil);
					final ClientResponse<String> responseToolUpdate = requestToolUpdate.post(String.class);
				
					if (responseToolUpdate.getStatus() == 200) { // OK
						final Unmarshaller un = jaxbc.createUnmarshaller();
						final StringReader sr = new StringReader(responseToolUpdate.getEntity());
						final Object object = (Object) un.unmarshal(sr);
						toolUpdated = (Outil) object;
					}
				}
				catch(Exception e) {
					e.printStackTrace();
				} */
			}
		
			//ici on va récuperer la réponse de la requete
			final ClientResponse<String> clientResponse = clientRequestEmprunt.post(String.class);
			
			//test affichage
			System.out.println("\n\n"+clientResponse.getEntity()+"\n\n");

			if (clientResponse.getStatus() == 200) { // si la réponse est valide !
				// on désérialiser la réponse si on veut vérifier que l'objet retourner
				// est bien celui qu'on a voulu créer , pas obligatoire
				final Unmarshaller un = jaxbc.createUnmarshaller();
				final Object object = (Object) un.unmarshal(new StringReader(clientResponse.getEntity()));
				// et ici on peut vérifier que c'est bien le bon objet
				displayMessage = true;
				
				messageValue = "L'emprunt a bien été assigné";
				messageType = "success";
			} else {
				
				displayMessage = true;
				
				messageValue = "Une erreur est survenue 2";
				messageType = "danger";
			}
		}
	}
	
	
	//on récupère tous les emprunts
	final JAXBContext jaxbc3 = JAXBContext.newInstance(EmpruntsDTO.class, Emprunt.class);
	EmpruntsDTO empruntdto = new EmpruntsDTO();

	try {
			ClientRequest requestMessages;
			requestMessages = new ClientRequest(siteUrl + "rest/emprunt/list");
			requestMessages.accept("application/xml");
			ClientResponse<String> responseMessages = requestMessages
					.get(String.class);
				
				if (responseMessages.getStatus() == 200) {
					Unmarshaller un2 = jaxbc3.createUnmarshaller();
					empruntdto = (EmpruntsDTO) un2.unmarshal(new StringReader(
							responseMessages.getEntity()));
				} else {
					messageValue = "Une erreur est survenue";
					messageType = "danger";
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	//Format affichage date
	DateFormat df = new SimpleDateFormat("dd/MM/yyyy");	
%>

<%
	if(itemFound) {
%>
<script src="./dist/js/bootstrap-datepicker.js" charset="UTF-8"></script>
<script src="./dist/js/bootstrap-datepicker.fr.js" charset="UTF-8"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$('.input-daterange').datepicker({
			format : "dd/mm/yyyy",
			language : "fr",
			todayBtn : "linked"
		});
		$('#btnSignal').click(function(){
			$('#subjectOfMessage').val("Signalement de l'objet <%=itemName%>") 
		})
		$('#contactLink').click(function(){
			$('#subjectOfMessage').val("") 
		})
	});
</script>

<script>
$(function(){
	$('.checkDispo').on('click',function() {
		$.ajax({
		    url: "<%=pluginFolder%>empruntScript.jsp",
		    type: 'POST',
		    data: {id: <%=itemId%>, dateDebut: $('#dateDebut').val(), dateFin: $('#dateFin').val() },
		    success: function(data) {
		    	if(data == "true")
		    	{
		    		alert("Emprunt possible")
		    		$('#confirm').removeClass("disabled")
		    	}
		    	else
		    	{
		    	    alert("L'emprunt n'est pas possible durant cette période ou il existe déjà un emprunt pour cet outil durant la période.");	
		    	    $('#confirm').addClass("disabled")
	    		}
		    }
		});
	});
});	
	
</script>
	
<link href="./dist/css/datepicker.css" rel="stylesheet">
<div class="row">
	<div class="col-md-12">
		<ol class="breadcrumb">
			<li><a href="javascript:history.go(-1)">&laquo; Retour</a></li>
			<li><a href="dashboard.jsp?idCat=<%=itemCategoryID%>"><%=itemCategory%></a></li>
			<li class="active"><%=itemName%></li>
		</ol>
	</div>
</div>

<%
if (displayMessage) {
out.println("<div class='row'><div class='col-md-12' style='margin-top:-20px'>");
out.println("<div class='alert alert-" + messageType + "'>"
		+ messageValue + "</div>");
out.println("</div></div>");
}
%>


<div class="row">
	<div class="col-md-4">
		<div class="row">
			<div class="col-md-12 perfectCenter">
				<img width="100%" height="100%" class="img-rounded"
					src="<%=itemPath%>" />
			</div>
		</div>
	</div>
	<div class="col-md-8">
		<h4>
			<%=itemName%>
			<a href="#" data-toggle="modal" data-target="#contact" class="btn btn-danger pull-right btn-xs" id="btnSignal"><i
				class="glyphicon glyphicon-warning-sign"></i> Signaler cet objet</a>
		</h4>
		<hr />
		<style>
			.tableTmp {
				padding-right: 3px;
				text-align: right;
				font-weight: bold;
				vertical-align: top
			}
			</style>
		<table width="100%">
			<tr>
				<td class="tableTmp" width="30%">Vendeur :</td>
				<td width="70%"><a href="#" data-toggle="modal"
					data-target="#userProfile"><%=itemVendor%></a></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td class="tableTmp" width="30%">Catégorie :</td>					
				<td width="70%"><a href="dashboard.jsp?idCat=<%=itemCategoryID%>" data-toggle="modal">
				<!-- data-target="#categoryProfile" --><%=itemCategory%></a></td>
					
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td class="tableTmp">Description :</td>
				<td style="text-align: justify"><%=itemDescription%></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td class="tableTmp">Caution (<a href="#" class="ttipr" title="Montant que vous devrez verser lors de l'emprunt et qui vous sera restitué à la fin de celui-ci">?</a>) :
				</td>
				<td><%=itemPrice%> euros</td>
			</tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td class="tableTmp">Disponibilités :</td>
				<td>du <%=itemDateStart%> au <%=itemDateEnd%></td>
			</tr>
			<tr>
			 <td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2">
					<table width="90%">
					<caption><strong>Réservations programmées de l'objet</strong></caption>

					<tr>
					<th width="10%">#</th>
					<th width="35%">Emprunteur</th>
					<th width="25%">Date début</th>
					<th width="25%">Date fin</th>
					</tr>
					<%
						int cpt=0;
						for (Emprunt e : empruntdto.getListeEmprunts()) {
						
							// Si un emprunt correspond à notre outil, que il n est pas refusé et que sa date de fin ne soit pas dejà passée
							if((itemId == e.getOutil().getId()) && ((e.getValide() == 1) || (e.getValide() == 2)) && (e.getDateFin().after(new Date())))
							{
								cpt++;
					%>
								<tr>
								<td><%=cpt%></td>
								<td><%=e.getEmprunteur().getConnexion().getLogin()%></td>
								<td><%=df.format(e.getDateDebut())%></td>
								<td><%=df.format(e.getDateFin())%></td>
								</tr>
					<%		}
						}
					%>					
					</table>				
				</td>
			</tr>
			<tr>
		</table>
		<hr />
		<a
			<%int diff = 100;
				if (Integer.parseInt(id) == Integer.parseInt(userID))
					diff = 0;
				else
					diff = 1;%>
			<%if (diff == 1) {%>
				href="#" data-toggle="modal" data-target="#confirmBorrow" class="btn btn-success pull-right btn-lg"
			<%} else { %>
				href="#" class="btn btn-default pull-right btn-lg ttipr" title="Vous ne pouvez pas emprunter vos propres objets" 
			<%}%>
			><i
			class="glyphicon glyphicon-shopping-cart"></i> Demander l'emprunt de
			l'objet</a>
	</div>
	<jsp:include page="profile.jsp">
		<jsp:param value="1" name="userId" />
	</jsp:include>
	<div class="modal fade" id="confirmBorrow" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<form action="#" method="POST">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="myModalLabel">Demande d'emprunt</h4>
					</div>
					<div class="modal-body">
						<strong>Objet concerné :</strong><br />
						<%=itemName%><br /> <br /> <strong>Période désirée :</strong><br />
						<div id="datepicker">
							<div class="input-daterange input-group" id="datepicker">
								<span class="input-group-addon">du </span> <input id="dateDebut" type="text"
									data-provide="datepicker"
									class="datepicker input-sm form-control" name="start2" required />
								<span class="input-group-addon"> au </span> <input id="dateFin" type="text"
									data-provide="datepicker"
									class="datepicker input-sm form-control" name="end2" required />
							</div>
						</div><br />
						<a class="btn btn-primary checkDispo" id="checkAvailable">Vérifier la disponibilité sur ces dates</a>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">
							<i class="glyphicon glyphicon-remove"></i> Annuler
						</button>
						<button type="submit" id="confirm" class="disabled btn btn-success">
							<i class="glyphicon glyphicon-ok"></i> Confirmer la demande
						</button>
					</div>
				</div>
			</form>
		</div>
	</div>
	<div class="modal fade" id="categoryProfile" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="myModalLabel">Catégorie : <%=itemCategory %></h4>
					</div>
					<div class="modal-body">
						<style>
.text-right {
	text-align: right;
	font-weight: bold;
	padding-right: 5px;
	vertical-align: top;
}
</style>
						<ul class="nav nav-tabs">
							<li class="active"><a href="#cat" data-toggle="tab">Objets
									correspondants</a></li>
						</ul>
						<br />
						<div class="tab-content">
							<div class="tab-pane active" id="cat">
								<% if (listeOutilsCat.getListeOutils().size() == 0) { %>
									<div class="alert alert-info perfectCenter"><i class="glyphicon glyphicon-warning-sign"></i> Aucun objet n'appartient actuellement à la catégorie <%=itemCategory%></div>
								<% } else {
								System.out.println("\n \n \n TAILLE !!! " + listeOutilsCat.getListeOutils().size());
								%>
								<div class="table-responsive">
									<table class="table table-hover">
										<thead>
											<tr>
												<th style="text-align: center;" width="25%">Nom</th>
												<th style="text-align: center;" width="15%">Caution</th>
												<th style="text-align: center;" width="20%">Disponible ?</th>
											</tr>
										</thead>
										<tbody>
											<% for (Outil t : listeOutilsCat.getListeOutils()) { %>
											<tr style="vertical-align: middle;" class="toPaginate">
												<td style="vertical-align: middle; text-align: center;"><strong>
													<a href="dashboard.jsp?page=itemDetails&id=<%=t.getId()%>"><%=t.getNom() %></a></strong><br />
												<td style="vertical-align: middle; text-align: center;"><%=t.getCaution() + " " %><i class="glyphicon glyphicon-euro"></i></td>
												<% if (t.isDisponible()) { %>
													<td style="vertical-align: middle; text-align: center;"><i class="glyphicon glyphicon-ok"></i></td>
												<% } else { %>
													<td style="vertical-align: middle; text-align: center;"><i class="glyphicon glyphicon-remove"></i></td>
												<% } %>
											</tr>
											<% } %>
										</tbody>
									</table>
								</div>
								<div id="paginator"></div>
								<input id="paginatorNbElements" type="hidden" value="5" readonly="readonly"/>
								<% } %>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
</div>

<%
	} else {
%>
<div class="row">
	<div class="col-md-12 alert alert-danger perfectCenter">L'objet
		que vous demandez n'existe pas ou plus.</div>
</div>
<% } %>
