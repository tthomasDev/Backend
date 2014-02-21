<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>
<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>
<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>
<%@ page import="model.Utilisateur"%>
<%@ page import="model.Connexion"%>
<%@ page import="model.Adresse"%>
<%@ page import ="java.util.Date" %>
<%@ page import ="java.util.Calendar" %>
<%

/* Les vraies infos de l'utilisateur récupérés */
JAXBContext jaxbc=JAXBContext.newInstance(Utilisateur.class,Connexion.class,Adresse.class);


Utilisateur utilisateurGet = new Utilisateur();
try {
	ClientRequest clientRequest;
	clientRequest = new ClientRequest("http://localhost:8080/rest/user/" + session.getAttribute("ID"));
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



if(request.getParameter("userId") != null) {
	String login, avatar;
	int age, userId;
	
	userId = utilisateurGet.getId();
	login = utilisateurGet.getConnexion().getLogin();
	Date date = 	utilisateurGet.getDateDeNaissance();

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
	avatar = "./dist/img/user_avatar_default.png";
%>

<div class="modal fade" id="userProfile" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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
									<tr>
										<td class="text-right"><strong>Age :</strong></td>
										<td>
											<% out.print(String.valueOf(age)); %> ans
										</td>
									</tr>
									
								</table>
							</div>
							<div class="col-md-4 perfectCenter">
								<img width="80%" height="80%" src="<%=avatar%>" />
							</div>
						</div>
					</div>
					<div class="tab-pane" id="list">
						<div class="alert alert-info perfectCenter"><i class="glyphicon glyphicon-warning-sign"></i> Aucun objet n'est actuellement prêté par <%=login%></div>
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