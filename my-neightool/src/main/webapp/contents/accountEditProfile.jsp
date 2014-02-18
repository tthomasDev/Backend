<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%
String firstname, lastname, address, city, postalCode, telephone, avatar, alertMessage, alertType;
int bYear, bMonth, bDay;
boolean showAlertMessage = false;
alertMessage = "";
alertType = "";
if(request.getParameter("firstname") != null) {
	showAlertMessage = true;
	alertMessage = "<i class='glyphicon glyphicon-ok'></i> Modifications enregistrées.";
	alertType = "success";
	/** TODO **/
	/* Récupérer les vraies infos apres modifications */
	/* Les infos suivantes sont mises à titre d'exemple */
	firstname = "Martin";
	lastname = "David";
	bDay = 25;
	bMonth = 3;
	bYear = 1991;
	address = "36 rue des Tests";
	city = "Bordeaux";
	postalCode = "33000";
	telephone = "05.66.84.32.17";
	avatar = "./dist/img/user_avatar_default.png";
} else {
	/** TODO **/
	/* Récupérer les vraies infos */
	/* Les infos suivantes sont mises à titre d'exemple */
	firstname = "Martin";
	lastname = "David";
	bDay = 25;
	bMonth = 3;
	bYear = 1991;
	address = "36 rue des Tests";
	city = "Bordeaux";
	postalCode = "33000";
	telephone = "0566843217";
	avatar = "./dist/img/user_avatar_default.png";
}

%>

<% if(showAlertMessage) { %>
<div class="row">
	<div class="col-md-12">
		<div class="alert alert-<%=alertType%>"><%=alertMessage%></div>
	</div>
</div>
<% } %>
<h4>Modifier vos informations personnelles</h4>
<hr />
<form action="dashboard.jsp?page=account&sub=editProfile" method="POST">
	<div class="row">
		<div class="col-md-4">
			Nom :<br />
			<input type="text" placeholder="Nom" value="<%=firstname%>" id="firstname" name="firstname" class="form-control" required="required" />
		</div>
		<div class="col-md-4">
			Prénom :<br />
			<input type="text" placeholder="Prénom" value="<%=lastname%>" id="lastname" name="lastname" class="form-control" required="required" />
		</div>
	</div>
	<div class="row">
		<div class="col-md-4">
			<br />Numéro de téléphone :
			<br /> <input type="tel" placeholder="Numéro de téléphone" value="<%=telephone%>" maxlength="10" id="telephone" name="telephone" class="form-control" required="required" /> 
			<br />
			Date de naissance :
		</div>
	</div>
	<div class="row">
		<div class="col-md-4">
			<select class="form-control" id="day" name="day">
				<%
				for (int i = 1; i <= 31; i++) {
					if(i == bDay)
						out.println("<option value='" + i + "' selected='selected'>" + i + "</option>");
					else
						out.println("<option value='" + i + "'>" + i + "</option>"); 
				}
				 %>
			</select>
		</div>
		<div class="col-md-4">
			<select class="form-control" id="month" name="month">
				<%
				String[] arrMois = {"Janvier", "Fevrier", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "Decembre"};
				int j = 0;
				for(String m:arrMois) {
					j++;
					if(j == bMonth)
						out.println("<option value='" + j + "' selected='selected'>" + m + "</option>");
					else
						out.println("<option value='" + j + "'>" + m + "</option>"); 
				} 
				 %>
			</select>
		</div>
		<div class="col-md-4">
			<select class="form-control" id="year" name="year">
				<%
				int yyyy = Calendar.getInstance().get(Calendar.YEAR);
				for(int i = 1900; i <= yyyy; i++) {
					if(i == bYear)
						out.println("<option value='" + i + "' selected='selected'>" + i + "</option>");
					else
						out.println("<option value='" + i + "'>" + i + "</option>"); 
				}
				%>
			</select><br /><br />
		</div>
		<div class="col-lg-12">
			<h4>Votre adresse</h4>
			<hr />
			<div class="input-group">
				<input type="text" placeholder="Adresse complète (Rue, Ville, Pays, Code Postal)" value="<% out.print(address + ", " + postalCode + " " + city); %>" id="location" name="location" class="form-control input-sm" required="required">
				<span class="input-group-btn">
					<button class="btn btn-default input-group-addon" type="button" data-toggle="tooltip" data-placement="top" title="Vérifier la carte" onclick="codeAddress()"><span class="glyphicon glyphicon-search"></span></button>
					<button class="btn btn-default input-group-addon" type="button" data-toggle="tooltip" data-placement="top" title="Me trouver sur la carte" onclick="codeLatLng(null)"><span class="glyphicon glyphicon-screenshot"></span></button>
					<button class="btn btn-default input-group-addon" type="button" data-toggle="tooltip" data-placement="top" title="Récupérer la position sur la carte"	onclick="getMyMarker()"><span class="glyphicon glyphicon-pushpin"></span></button>
				</span>
			</div>
		</div>
		<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAsO96nmOiM5A5mef1oNv4PZoETDWvfJ88&sensor=false"></script>
	    <script src="./dist/js/maps.js"></script>
	    <style>#map-canvas{height:300px !important;}</style>
		<div class="col-lg-12" onload="initialize()">
			<br />
	    	<div class="img-rounded" id="map-canvas" style="background-color:#DDD;"></div>
		</div>
		<div class="col-lg-12">
			<hr />
	    	<button type="submit" class="btn btn-success pull-right"><i class="glyphicon glyphicon-ok"></i> Enregistrer les modifications</button>
		</div>
	</div>
</form>