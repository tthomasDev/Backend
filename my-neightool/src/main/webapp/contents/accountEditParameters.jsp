<%
String username, email, password, alertMessage, alertType;
boolean showAlertMessage = false;
alertMessage = "";
alertType = "";
if(request.getParameter("username") != null) {
	showAlertMessage = true;
	alertMessage = "<i class='glyphicon glyphicon-ok'></i> Modifications enregistrées.";
	alertType = "success";
	/** TODO **/
	/* Récupérer les vraies infos apres modifications */
	/* Les infos suivantes sont mises à titre d'exemple */
	username = "Utilisateur 1";
	email = "adresse@email.com";
	password = "********";
} else {
	/** TODO **/
	/* Récupérer les vraies infos */
	/* Les infos suivantes sont mises à titre d'exemple */
	username = "Utilisateur 1";
	email = "adresse@email.com";
	password = "********";
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
			<input type="text" placeholder="Nom d'utilisateur" value="<%=username%>" id="username" name="username" class="form-control" required="required" /><br />
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
			<input type="password" placeholder="Ancien mot de passe" value="<%=password%>" id="oldPassword" name="oldPassword" class="form-control" required="required" /><br />
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