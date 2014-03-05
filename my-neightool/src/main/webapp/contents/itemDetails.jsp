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
<%@ page import="dto.OutilsDTO"%>
<%
String itemName="", itemVendor="", itemDescription="", itemCategory="", itemDateStart="";
String itemDateEnd="", itemPrice="", itemDistance="", itemPath="";

boolean itemFound = false;
if(request.getParameter("id") != null) {
	itemFound = true;

	String messageType = "";
	String messageValue = "";
	
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

		// On récupère les données de session de l'utilisateur
		final String id = String.valueOf(session.getAttribute("ID"));
		final String userName = String.valueOf(session.getAttribute("userName"));

		// ici on envoit la requete permettant de récupérer les données complètes
		// sur l'utilisateur en ligne
		try {
			ClientRequest clientRequest;
			clientRequest = new ClientRequest(
			"http://localhost:8080/rest/user/" + id);
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

		//ici on va récuperer la réponse de la requete
		try {
			ClientRequest requestTools;
			requestTools = new ClientRequest(
			"http://localhost:8080/rest/tool/" + request.getParameter("id"));
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
		
		itemName = outil.getNom();
		itemVendor = user.getNom();;
		itemDescription = outil.getDescription();
		itemCategory = outil.getCategorie();
		itemPath = outil.getCheminImage();
		
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

			final ClientRequest clientRequestEmprunt = new ClientRequest("http://localhost:8080/rest/emprunt/create");
			
			if ((startDate.compareTo(outil.getDateDebut())) != -1
					&& startDate.compareTo(outil.getDateFin()) != 1
					&& endDate.compareTo(outil.getDateDebut()) != -1
					&& endDate.compareTo(outil.getDateFin()) != 1
					&& outil.isDisponible()) {
				final Emprunt emprunt = new Emprunt(outil, user, startDate, endDate);
				
				//ici il faut sérialiser l'emprunt
				final Marshaller marshaller = jaxbc.createMarshaller();
				marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
				final java.io.StringWriter sw = new StringWriter();
				marshaller.marshal(emprunt, sw);			
				
				//ici on envoit la requete au webservice createEmprunt
				clientRequestEmprunt.body("application/xml", emprunt);
				
				// On rend l'outil indisponible désormais
				outil.setDisponible(false);
				
				try {
					final ClientRequest requestToolUpdate = new ClientRequest("http://localhost:8080/rest/tool/update");

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
				}
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
				messageValue = "L'emprunt a bien été assigné";
				messageType = "success";
			} else {
				messageValue = "Une erreur est survenue";
				messageType = "danger";
			}
		}
	}
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
				<img width="100%" height="100%" class="img-rounded"
					src="<%=itemPath%>" />
			</div>
		</div>
	</div>
	<div class="col-md-8">
		<h4>
			<%=itemName%>
			<a class="btn btn-danger pull-right btn-xs"><i
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
				<td class="tableTmp">Catégorie :</td>
				<td><a href="#"><%=itemCategory%></a></td>
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
				<td class="tableTmp">Disponibilités :</td>
				<td>du <%=itemDateStart%> au <%=itemDateEnd%></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td class="tableTmp">Caution (<a href="#" class="ttipr" title="Montant que vous devrez verser lors de l'emprunt et qui vous sera restitué à la fin de celui-ci">?</a>) :
				</td>
				<td><%=itemPrice%> euros</td>
			</tr>
		</table>
		<hr />
		<a href="#" data-toggle="modal" data-target="#confirmBorrow"
			class="btn btn-success pull-right btn-lg"><i
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
								<span class="input-group-addon">du </span> <input type="text"
									data-provide="datepicker"
									class="datepicker input-sm form-control" name="start2" required />
								<span class="input-group-addon"> au </span> <input type="text"
									data-provide="datepicker"
									class="datepicker input-sm form-control" name="end2" required />
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">
							<i class="glyphicon glyphicon-remove"></i> Annuler
						</button>
						<button type="submit" class="btn btn-success">
							<i class="glyphicon glyphicon-ok"></i> Confirmer la demande
						</button>
					</div>
				</div>
			</form>
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