<%@include file="../constantes.jsp"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.Timestamp"%>

<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>

<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>

<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>


<%@ page import="model.Outil"%>
<%@ page import="model.Utilisateur"%>

<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";
	if ((request.getParameter("itemName") != null)
	&& (request.getParameter("itemCategory") != null)
	&& (request.getParameter("itemDetails") != null)
	&& (request.getParameter("itemCaution") != null)
	&& (request.getParameter("start") != null)
	&& (request.getParameter("end") != null)
	&& (request.getParameter("termsofuse") != null)) {

		actionValid = true;
		
	
	//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
	final JAXBContext jaxbc=JAXBContext.newInstance(Outil.class, Utilisateur.class);
	
	// Utilisateur
	Utilisateur user = new Utilisateur(); 
	
	//ici on va créer l'outil avec les données rentrées dans le formulaire
	final String name = request.getParameter("itemName");
	final String category = request.getParameter("itemCategory");
	final String description = request.getParameter("itemDetails");
	final int caution = Integer.parseInt(request.getParameter("itemCaution"));
	final String startDate = request.getParameter("start");
	final String endDate = request.getParameter("end");
	final String terms = request.getParameter("termsofuse");
	
	final String id = String.valueOf(session.getAttribute("ID"));
	final String userName = String.valueOf(session.getAttribute("userName"));
	
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	Date parsedDateD = sdf.parse(startDate);
	System.out.println("test date debut : " + parsedDateD);
	
	Date parsedDateF = sdf.parse(endDate);
	System.out.println("test date fin : " + parsedDateF);
	
	//ici on envoit la requete au webservice createTool
	try {
		ClientRequest clientRequest ;
		clientRequest = new ClientRequest("http://localhost:8080/rest/user/" + id);
		clientRequest.accept("application/xml");
		ClientResponse<String> response2 = clientRequest.get(String.class);
		if (response2.getStatus() == 200)
		{
			Unmarshaller un = jaxbc.createUnmarshaller();
			user = (Utilisateur) un.unmarshal(new StringReader(response2.getEntity()));
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	final Outil tool = new Outil(user, name, description, true, category, caution,
			parsedDateD, parsedDateF);

	//ici il faut sérialiser l'outil
	final Marshaller marshaller = jaxbc.createMarshaller();
	marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
	final java.io.StringWriter sw = new StringWriter();
	marshaller.marshal(tool, sw);			
	
	//ici on envoit la requete au webservice createUtilisateur
	final ClientRequest clientRequest = new ClientRequest("http://localhost:8080/rest/tool/create");
	clientRequest.body("application/xml", tool);
	
	
	//ici on va récuperer la réponse de la requete
	final ClientResponse<String> clientResponse = clientRequest.post(String.class);
	//test affichage
	System.out.println("\n\n"+clientResponse.getEntity()+"\n\n");
	if (clientResponse.getStatus() == 200) { // si la réponse est valide !
		// on désérialiser la réponse si on veut vérifier que l'objet retourner
		// est bien celui qu'on a voulu créer , pas obligatoire
		final Unmarshaller un = jaxbc.createUnmarshaller();
		final Object object = (Object) un.unmarshal(new StringReader(clientResponse.getEntity()));
		// et ici on peut vérifier que c'est bien le bon objet
		messageValue = "L'outil a bien été assigné";
		messageType = "success";
	} else {
		messageValue = "Une erreur est survenue";
		messageType = "danger";
	}

		// on affiche ces messages qu'une fois la reponse de la requete valide

	} else {
		messageType = "danger";
		messageValue = "Tous les champs n'ont pas été remplis.";
	}
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
<ol class="breadcrumb">
	<li><a href="dashboard.jsp">Accueil</a></li>
	<li class="active">Ajout d'un nouvel objet à prêter</li>
</ol>

<form action="dashboard.jsp?page=manageItems&sub=add"
	class="form-horizontal" role="form" method="POST">
	<div class="">
		<div class="form-group">
			<label for="itemName" class="col-sm-3 control-label">Nom de
				l'objet</label>
			<div class="col-sm-6">
				<input type="text" class="form-control" id="itemName"
					name="itemName" placeholder="Nom de l'objet" />
			</div>
			<br />
		</div>
		<br />
		<div class="form-group">
			<label for="itemCategory" class="col-sm-3 control-label">Catégorie</label>
			<div class="col-sm-6">
				<select class="form-control" id="itemCategory" name="itemCategory">
					<option value="option1">Categorie 1</option>
					<option value="option2">Categorie 2</option>
					<option value="optioncol-md-6 3">Categorie 3</option>
					<option value="option4">Categorie 4</option>
				</select> <br />
			</div>
		</div>
		<div class="form-group">
			<label for="itemDetails" class="col-sm-3 control-label">Description</label>
			<div class="col-sm-6">
				<textarea class="form-control" rows="5" id="itemDetails"
					name="itemDetails" placeholder="Description de l'objet"></textarea>
			</div>
		</div>
		<div class="form-group">
			<label for="itemCaution" class="col-sm-3 control-label">Montant
				de la caution</label>
			<div class="col-sm-4">
				<input type="text" class="form-control" id="itemCaution"
					name="itemCaution" placeholder="Prix (euros)" />
			</div>
			<br />
		</div>
		<hr />
		<div class="form-group">
			<label for="itemDetails" class="col-sm-3 control-label">Disponibilité</label>
			<div class="col-sm-6" id="datepicker">
				<div class="input-daterange input-group" id="datepicker">
					<span class="input-group-addon">du </span> <input type="text"
						data-provide="datepicker" class="datepicker input-sm form-control"
						name="start" /> <span class="input-group-addon"> au </span> <input
						type="text" data-provide="datepicker"
						class="datepicker input-sm form-control" name="end" />
				</div>
			</div>
		</div>
		<hr />
		<div class="form-group">
			<label for="itemImage" class="col-sm-3 control-label"> Image
				<br /> <small style="color: #BBB; font-weight: normal"><em>Maximum
						1Mo et 1000x1000px</em></small>
			</label>
			<div class="col-sm-6" style="margin-top: 4px">
				<input type="file" name="itemImage" />
			</div>
		</div>
		<hr />
		<div id="accordion" class="form-group">
			<label for="itemImage" class="col-sm-3 control-label">Lieu
				enregistré</label>
			<div class="col-sm-6" style="margin-top: 5px">
				Talence (<a data-toggle="collapse" data-parent="#accordion"
					href="#collapseMap">modifier</a>)
				<div id="collapseMap" class="panel-collapse collapse">
					<br />
					<div class="col-md-12 img-rounded" id="map-canvas"
						style="background-color: #DDD;"></div>
				</div>
			</div>
		</div>
		<hr />
		<div class="form-group">
			<div class="col-sm-12">
				<!-- <input type="checkbox" id="termsofuse" name="termsofuse" /> <label
					for="terms">En mettant cet objet, je m'engage à respecter
					les <a href="#" data-toggle="modal" data-target="#terms">conditions
						générales d'utilisation</a>.
				</label> -->
				<input type="checkbox" id="termsofuse" name="termsofuse" /> <label
					for="termsofuse">En mettant cet objet, je m'engage à
					respecter les <a href="#" data-toggle="modal" data-target="#terms">conditions
						générales d'utilisation</a>
				</label>
			</div>
		</div>
		<div class="pull-right">
			<button type="submit" class="btn btn-info">Envoyer</button>
		</div>
	</div>
</form>