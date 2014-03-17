<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>
<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>
<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>

<%@ page import="com.ped.myneightool.model.Utilisateur"%>
<%@ page import="com.ped.myneightool.model.Connexion"%>
<%@ page import="com.ped.myneightool.model.Adresse"%>
<%@ page import="com.ped.myneightool.model.Outil"%>
<%@ page import="com.ped.myneightool.dto.OutilsDTO"%>

<%@ page import ="java.util.Date" %>
<%@ page import ="java.util.Calendar" %>
<%@include file="../constantes.jsp"%>
<%@include file="../functions.jsp"%>
<%

String multipleId = "";
Utilisateur utilisateurGet = new Utilisateur();


if(request.getParameter("multipleId") != null) {
	multipleId = request.getParameter("multipleId");
}


if(request.getParameter("userId") != null) {
	
	String login, avatar;
	int age, userId;
	
	userId = Integer.parseInt(request.getParameter("userId"));

	// Le DTO des outils permettant de récupérer la liste d'outils
	OutilsDTO outilsDto = new OutilsDTO();

	String messageType = "";
	String messageValue = "";
		
	/* Les vraies infos de l'utilisateur récupérés */
	JAXBContext jaxbc=JAXBContext.newInstance(Utilisateur.class,Connexion.class,Adresse.class);
	JAXBContext jaxbc2=JAXBContext.newInstance(OutilsDTO.class);

	try {
		ClientRequest clientRequest;
		clientRequest = new ClientRequest(siteUrl + "rest/user/" + userId);
		clientRequest.accept("application/xml");
		ClientResponse<String> clientResponse = clientRequest.get(String.class);
		if (clientResponse.getStatus() == 200)
		{
			Unmarshaller un = jaxbc.createUnmarshaller();
			utilisateurGet = (Utilisateur) un.unmarshal(new StringReader(clientResponse.getEntity()));
			
		}
	} catch (Exception e) {
		e.printStackTrace();
	}

	login = utilisateurGet.getConnexion().getLogin();
	Date date = utilisateurGet.getDateDeNaissance();
	
	int yeardiff;
	{
	  Calendar curr = Calendar.getInstance();
	  Calendar birth = Calendar.getInstance();
	  birth.setTime(date);
	  yeardiff = curr.get(Calendar.YEAR) - birth.get(Calendar.YEAR);
	  curr.add(Calendar.YEAR,-yeardiff);
	  if(birth.after(curr))
	  {
	    yeardiff = yeardiff - 1;
	  }
	}
	 
	age = yeardiff;
	avatar = 		imgFolder + "user_avatar_default.png";
	if(utilisateurGet.getCheminImage()!=null)
		avatar = 	utilisateurGet.getCheminImage();
	
	// Récupération de la liste des outils de l'utilisateur
	//ici on va récuperer la réponse de la requete
	try {
		ClientRequest requestTools;
		requestTools = new ClientRequest(siteUrl + "rest/tool/user/" + session.getAttribute("ID"));
		requestTools.accept("application/xml");
		ClientResponse<String> responseTools = requestTools
				.get(String.class);
		if (responseTools.getStatus() == 200) {
			Unmarshaller un2 = jaxbc2.createUnmarshaller();
			outilsDto = (OutilsDTO) un2.unmarshal(new StringReader(
					responseTools.getEntity()));

			// et ici on peut vérifier que c'est bien le bon objet
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

<div class="modal fade" id="userProfile<%=multipleId%>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Profil de <%=login%></h4>
			</div>
			<div class="modal-body">
				<style>.text-right {text-align: right;font-weight: bold;padding-right: 5px;vertical-align: top;}</style>
				<ul class="nav nav-tabs">
					<li class="active"><a href="#infos" data-toggle="tab">Informations</a></li>
					<li><a href="#list" data-toggle="tab">Objets à emprunter</a></li>
				</ul>
				<br />
				<div class="tab-content">
					<div class="tab-pane active" id="infos">
						<div class="row">
							<div class="col-md-8">
								<table width="100%">
									<tr>
										<td width="30%" class="text-right"><strong>Utilisateur :</strong></td>
										<td width="70%"><%=login%></td>
									</tr>
									<% 
									if(utilisateurGet.getAdresse().getadresseComplete() != null)
									{
									%>
									<tr>
										<td width="30%" class="text-right"><strong>Adresse :</strong></td>
										<td width="70%"><%=utilisateurGet.getAdresse().getadresseComplete()%></td>
									</tr>
									<% } %>
									<tr>
									
									<% 
									if(utilisateurGet.getTelephone() != null)
									{
									%>
									<tr>
										<td width="30%" class="text-right"><strong>Téléphone :</strong></td>
										<td width="70%"><%=utilisateurGet.getTelephone()%></td>
									</tr>
									<% } %>
									<tr>
									
										<td class="text-right"><strong>Age :</strong></td>
										<td>
											<% out.print(String.valueOf(age)); %> ans
										</td>
									</tr>
									
								</table>
							</div>
							<div class="col-md-4 perfectCenter">
								<img id="avatarP" width="80%" height="80%" class="img-rounded" src="<%=avatar%>" />
							</div>
						</div>
					</div>
					<div class="tab-pane" id="list">
						<% if (outilsDto.getListeOutils().size() == 0) { %>
							<div class="alert alert-info perfectCenter"><i class="glyphicon glyphicon-warning-sign"></i> Aucun objet n'est actuellement prêté par <%=login%></div>
						<% } else { %>
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
										<% for (Outil t : outilsDto.getListeOutils()) { %>
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
			<div class="modal-footer">
				<a href="dashboard.jsp?page=mailbox&userId=<% out.print(String.valueOf(userId)); %>" target="_blank" class="btn btn-info"><i class="glyphicon glyphicon-envelope"></i> Contacter</a>
				<a href="#" class="btn btn-default" data-dismiss="modal">Fermer</a>
			</div>
		</div>
	</div>
</div>

<%
} else {
%>

<div class="modal fade" id="userProfile" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Erreur</h4>
			</div>
			<div class="modal-body">
				<div class="alert alert-danger perfectCenter">Le profil que vous demandez n'existe pas ou plus.</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
			</div>
		</div>
	</div>
</div>

<% } %>