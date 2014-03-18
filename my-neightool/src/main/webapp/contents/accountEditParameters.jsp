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
<%@ page import="javax.xml.bind.DatatypeConverter"%>
<%@include file="../functions.jsp"%>
<%@include file="../constantes.jsp"%>
<%
String username, email, password, alertMessage, alertType;
boolean showAlertMessage = false;
alertMessage = "";
alertType = "";

/* Les vraies infos de l'utilisateur récupérés */
JAXBContext jaxbc=JAXBContext.newInstance(Utilisateur.class,Connexion.class,Adresse.class);


Utilisateur utilisateurGet = new Utilisateur();
try {
	ClientRequest clientRequest;
	clientRequest = new ClientRequest(siteUrl + "rest/user/" + session.getAttribute("ID"));
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



if(request.getParameter("username") != null) {
	
	showAlertMessage = true;
	alertMessage = "<i class='glyphicon glyphicon-ok'></i> Modifications enregistrées.";
	alertType = "success";
	
	String currentLogin= utilisateurGet.getConnexion().getLogin();
		
	utilisateurGet.getConnexion().setLogin(escapeStr(request.getParameter("username")));
	utilisateurGet.setMail(escapeStr(request.getParameter("email")));
			
	
	Utilisateur utilisateurGet2 = new Utilisateur();
	try {
		
		// marshalling/serialisation pour l'envoyer avec une requete post
		final Marshaller marshaller = jaxbc.createMarshaller();
		marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
		final java.io.StringWriter sw = new StringWriter();
		marshaller.marshal(utilisateurGet, sw);
					
		
		final ClientRequest clientRequest2 = new ClientRequest(siteUrl + "rest/user/update/");
		clientRequest2.body("application/xml", utilisateurGet );
		
		//CREDENTIALS		
		String username2 = currentLogin;
		String password2 = utilisateurGet.getConnexion().getPassword();
		String base64encodedUsernameAndPassword = DatatypeConverter.printBase64Binary((username2 + ":" + password2).getBytes());
		clientRequest2.header("Authorization", "Basic " +base64encodedUsernameAndPassword );
		///////////////////
		
		
		final ClientResponse<String> clientResponse2 = clientRequest2.post(String.class);
		
		System.out.println("\n\n"+clientResponse2.getEntity()+"\n\n");
		
		if (clientResponse2.getStatus() == 200) { // ok !
						
			final Unmarshaller un = jaxbc.createUnmarshaller();
			utilisateurGet2 = (Utilisateur) un.unmarshal(new StringReader(clientResponse2.getEntity()));
						
		}
	} catch (final Exception e) {
		e.printStackTrace();
	}
	
	
	username = utilisateurGet2.getConnexion().getLogin();
	email = utilisateurGet2.getMail();
	password = utilisateurGet2.getConnexion().getPassword();
	
} else {
	
	username = utilisateurGet.getConnexion().getLogin();
	email = utilisateurGet.getMail();
	password = utilisateurGet.getConnexion().getPassword();
}



if(request.getParameter("oldPassword") != null) {
	
	showAlertMessage = true;
	alertMessage = "<i class='glyphicon glyphicon-ok'></i> Modifications enregistrées.";
	alertType = "success";
		
	
	System.out.println("debut de boucle");
	String str=escapeStr(request.getParameter("oldPassword"));
	System.out.println(str);
	if(utilisateurGet.getConnexion().getPassword().equals(str)){
		System.out.println(utilisateurGet.getConnexion().getPassword());
		
		String newPass = escapeStr(request.getParameter("newPassword"));
		String confirmNewPass = escapeStr(request.getParameter("confirmNewPassword"));
		
		System.out.println(newPass);
		System.out.println(confirmNewPass);
			
		if(newPass.equals(confirmNewPass)){
			utilisateurGet.getConnexion().setPassword(encodedPw(confirmNewPass));
		}
		else
		{
			alertMessage = "<i class='glyphicon glyphicon-ok'></i> Vous n'avez pas confirmé votre nouveau mot de passe correctement.";
			alertType = "danger";
		}
	}
	
	
	Utilisateur utilisateurGet2 = new Utilisateur();
	try {
		
		// marshalling/serialisation pour l'envoyer avec une requete post
		final Marshaller marshaller = jaxbc.createMarshaller();
		marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
		final java.io.StringWriter sw = new StringWriter();
		marshaller.marshal(utilisateurGet, sw);
					
		
		final ClientRequest clientRequest2 = new ClientRequest(siteUrl + "rest/user/update/");
		clientRequest2.body("application/xml", utilisateurGet );
		
		//CREDENTIALS		
		String username2 = utilisateurGet.getConnexion().getLogin();
		String password2 = utilisateurGet.getConnexion().getPassword();
		String base64encodedUsernameAndPassword = DatatypeConverter.printBase64Binary((username2 + ":" + password2).getBytes());
		clientRequest2.header("Authorization", "Basic " +base64encodedUsernameAndPassword );
		///////////////////
		
		
		final ClientResponse<String> clientResponse2 = clientRequest2.post(String.class);
		
		System.out.println("\n\n"+clientResponse2.getEntity()+"\n\n");
		
		if (clientResponse2.getStatus() == 200) { // ok !
						
			final Unmarshaller un = jaxbc.createUnmarshaller();
			utilisateurGet2 = (Utilisateur) un.unmarshal(new StringReader(clientResponse2.getEntity()));
						
		}
	} catch (final Exception e) {
		e.printStackTrace();
	}
		
	username = utilisateurGet2.getConnexion().getLogin();
	email = utilisateurGet2.getMail();
	password = utilisateurGet2.getConnexion().getPassword();
	
} else {
	
	username = utilisateurGet.getConnexion().getLogin();
	email = utilisateurGet.getMail();
	password = utilisateurGet.getConnexion().getPassword();
}


// gérer la suppression du compte 

if(request.getParameter("deleteAccount") != null) {
	
	showAlertMessage = true;
	alertMessage = "<i class='glyphicon glyphicon-ok'></i> Modifications enregistrées.";
	alertType = "success";
		
	
	try {
		
		String currentLog= utilisateurGet.getConnexion().getLogin();
		String currentPass= utilisateurGet.getConnexion().getPassword();
		
		utilisateurGet.getAdresse().setadresseComplete("Compte inactif");
		utilisateurGet.getAdresse().setcodePostale("Compte inactif");
		utilisateurGet.getAdresse().setLatitude(0);
		utilisateurGet.getAdresse().setLongitude(0);
		utilisateurGet.getAdresse().setPays("Compte inactif");
		utilisateurGet.getAdresse().setRue("Compte inactif");
		utilisateurGet.getAdresse().setVille("Compte inactif");
		utilisateurGet.setCheminImage("Compte inactif");
		utilisateurGet.getConnexion().setLogin(null);
		utilisateurGet.getConnexion().setPassword(null);
		utilisateurGet.setDateDeNaissance(null);
		utilisateurGet.setMail(null);
		utilisateurGet.setNom("Compte inactif");
		utilisateurGet.setPrenom("Compte inactif");
		utilisateurGet.setTelephone("Compte inactif");
		
		
		
		try {
			
			// marshalling/serialisation pour l'envoyer avec une requete post
			final Marshaller marshaller = jaxbc.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
			final java.io.StringWriter sw = new StringWriter();
			marshaller.marshal(utilisateurGet, sw);
						
			
			final ClientRequest clientRequest = new ClientRequest(siteUrl + "rest/user/update/");
			clientRequest.body("application/xml", utilisateurGet );
			//CREDENTIALS		
			String username2 = currentLog;
			String password2 = currentPass;
			String base64encodedUsernameAndPassword = DatatypeConverter.printBase64Binary((username2 + ":" + password2).getBytes());
			clientRequest.header("Authorization", "Basic " +base64encodedUsernameAndPassword );
			///////////////////
			
			final ClientResponse<String> clientResponse = clientRequest.post(String.class);
			
			System.out.println("\n\n"+clientResponse.getEntity()+"\n\n");
			
			if (clientResponse.getStatus() == 200) { // ok !
				session.removeAttribute("ID");	
				session.removeAttribute("userName");
				RequestDispatcher rd =request.getRequestDispatcher("index.jsp");
				rd.forward(request, response);
				//response.sendRedirect("index.jsp");
			}
		} catch (final Exception e) {
			e.printStackTrace();
		}
		
		/*
		ClientRequest clientRequest;
		clientRequest = new ClientRequest("http://localhost:8080/rest/user/update/" + utilisateurGet.getId());
		*/
		//clientRequest = new ClientRequest("http://localhost:8080/rest/user/delete/" + utilisateurGet.getId());
		/*
		clientRequest.accept("application/xml");
		ClientResponse<String> clientResponse = clientRequest.get(String.class);
		if (clientResponse.getStatus() == 200)
		{
			*/
			//session.removeAttribute("ID");
			//session.removeAttribute("userName");
			/*
			RequestDispatcher rd =request.getRequestDispatcher("index.jsp?attemp=0");
			rd.forward(request, response);
			*/
			
			//response.sendRedirect("index.jsp?attemp=0");
			
		//}
	} catch (Exception e) {
		e.printStackTrace();
	}
		
	
} else {
	
}


%>

<% if(showAlertMessage) { %>
<div class="row">
	<div class="col-md-12">
		<div class="alert alert-<%=alertType%>"><%=alertMessage%></div>
	</div>
</div>
<% } %>
<h4>Modifier vos paramètres de compte</h4>
<hr />
<form action="dashboard.jsp?page=account&sub=editParameters" method="POST">
	<div class="row">
		<div class="col-md-6">
			Nom d'utilisateur :<br />
			<input type="text" placeholder="Nom d'utilisateur" value="<%=username%>" id="username" name="username" maxlength="20" class="form-control" required="required" /><br />
		</div>
	</div>
	<div class="row">
		<div class="col-md-6">
			Adresse email :<br />
			<input type="email" placeholder="Email" value="<%=email%>" id="email" name="email" class="form-control" required="required" />
		</div>
	</div>
	
	<div class="row">
		<div class="col-lg-12">
			<hr />
	    	<button type="submit" class="btn btn-success pull-right"><i class="glyphicon glyphicon-ok"></i> Enregistrer les modifications</button>
		</div>
	</div>
</form>
<br />
<h4>Modifier votre mot de passe</h4>
<hr />
<form action="dashboard.jsp?page=account&sub=editParameters" method="POST">
	<div class="row">
		<div class="col-md-6">
			Ancien mot de passe :<br />
			<input type="password" placeholder="Ancien mot de passe" id="oldPassword" name="oldPassword" class="form-control" required="required" /><br />
		</div>
	</div>
	<div class="row">
		<div class="col-md-6">
			Nouveau mot de passe :<br />
			<input type="password" placeholder="Nouveau mot de passe" id="newPassword" name="newPassword" class="form-control" required="required" /><br />
		</div>
	</div>
	<div class="row">
		<div class="col-md-6">
			Confirmez le nouveau mot de passe :<br />
			<input type="password" placeholder="Confirmez le nouveau mot de passe" id="confirmNewPassword" name="confirmNewPassword" class="form-control" required="required" /><br />
		</div>
	</div>
	
	<div class="row">
		<div class="col-lg-12">
			<hr />
	    	<button type="submit" class="btn btn-success pull-right"><i class="glyphicon glyphicon-ok"></i> Enregistrer le nouveau mot de passe</button>
		</div>
	</div>
</form>
<br /><br />
<h4>Supprimer votre compte</h4>
<hr />
<form action="dashboard.jsp?page=account&sub=editParameters" method="POST">
	<div class="row">
		<div class="col-md-12">
			<div class="alert alert-danger">
				<p><i class="glyphicon glyphicon-warning-sign"></i> Attention ! Cette action est irréversible. Votre compte ainsi que l'intégralité des données qui y sont liées seront supprimées définitivement de notre base de données.</p>
				<br />
				<label><input type="checkbox" name="deleteAccount" /> Je confirme vouloir supprimer mon compte.</label>
				<br />
	    		<button type="submit" class="btn btn-danger pull-right"><i class="glyphicon glyphicon-remove"></i> Supprimer votre compte</button>
	    		<br /><br />
	    	</div>
		</div>
	</div>
</form>