<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
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
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%


String firstname="", lastname="", address="", telephone="", avatar="", alertMessage="", alertType="";
//String city,postalCode;
int bYear=1900, bMonth=1, bDay=1;
boolean showAlertMessage = false;
alertMessage = "";
alertType = "";

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




if(request.getParameter("firstname") != null) {
	showAlertMessage = true;
	alertMessage = "<i class='glyphicon glyphicon-ok'></i> Modifications enregistrées.";
	alertType = "success";
	
		
	utilisateurGet.setPrenom(request.getParameter("firstname"));
	utilisateurGet.setNom(request.getParameter("lastname"));
	//Formatage de la date
	String m = request.getParameter("month");
	String day = request.getParameter("day");
	String y = request.getParameter("year");
	String target = day + "-" + m + "-" + y;
	DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
	Date date2 = df.parse(target);
	utilisateurGet.setDateDeNaissance(date2);
	utilisateurGet.setTelephone(request.getParameter("telephone"));
	utilisateurGet.getAdresse().setadresseComplete(request.getParameter("location"));
	
	
	Utilisateur utilisateurGet2 = new Utilisateur();
	try {
		
		// marshalling/serialisation pour l'envoyer avec une requete post
		final Marshaller marshaller = jaxbc.createMarshaller();
		marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
		final java.io.StringWriter sw = new StringWriter();
		marshaller.marshal(utilisateurGet, sw);
					
		
		final ClientRequest clientRequest2 = new ClientRequest("http://localhost:8080/rest/user/update/");
		clientRequest2.body("application/xml", utilisateurGet );
		
		
		final ClientResponse<String> clientResponse2 = clientRequest2.post(String.class);
		
		System.out.println("\n\n"+clientResponse2.getEntity()+"\n\n");
		
		if (clientResponse2.getStatus() == 200) { // ok !
						
			final Unmarshaller un = jaxbc.createUnmarshaller();
			utilisateurGet2 = (Utilisateur) un.unmarshal(new StringReader(clientResponse2.getEntity()));
						
		}
	} catch (final Exception e) {
		e.printStackTrace();
	}
	
	
	firstname=utilisateurGet2.getPrenom();
	lastname = utilisateurGet2.getNom();
	Date d =		utilisateurGet2.getDateDeNaissance();
	Calendar c = Calendar.getInstance();
	c.setTime(d);
	bDay = c.get(Calendar.DAY_OF_MONTH);
	bMonth = c.get(Calendar.MONTH);
	bYear = c.get(Calendar.YEAR);
	address = 		utilisateurGet2.getAdresse().getadresseComplete();
	telephone = 	utilisateurGet2.getTelephone();
	avatar = 		"./dist/img/user_avatar_default.png"; //utilisateurGet.getCheminImage();
	
	
} else {
						
	firstname= 		utilisateurGet.getPrenom();
	lastname = 		utilisateurGet.getNom();
	Date d =		utilisateurGet.getDateDeNaissance();
	Calendar c = Calendar.getInstance();
	c.setTime(d);
	bDay = c.get(Calendar.DAY_OF_MONTH);
	bMonth = c.get(Calendar.MONTH);
	bYear = c.get(Calendar.YEAR);
	address = 		utilisateurGet.getAdresse().getadresseComplete();
	telephone = 	utilisateurGet.getTelephone();
	avatar = 		"./dist/img/user_avatar_default.png"; //utilisateurGet.getCheminImage();

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
					if(j == bMonth+1)
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
				<input type="text" placeholder="Adresse complète (Rue, Ville, Pays, Code Postal)" value="<% out.print(address /*+ ", " + postalCode + " " + city*/); %>" id="location" name="location" class="form-control input-sm" required="required">
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