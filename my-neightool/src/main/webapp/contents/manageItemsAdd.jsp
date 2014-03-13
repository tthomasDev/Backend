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

<%@ page import="com.ped.myneightool.model.Categorie"%>
<%@ page import="com.ped.myneightool.dto.CategoriesDTO"%>

<%@ page import="com.ped.myneightool.model.Outil"%>
<%@ page import="com.ped.myneightool.model.Utilisateur"%>

<%@include file="../functions.jsp"%>
<%@ page import="javax.xml.bind.DatatypeConverter"%>

<%
	boolean actionValid = false;
	boolean cautionCorrecte = true;
	String messageType = "";
	String messageValue = "";
	String itemImg = "data:image/png;base64,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";
	
	//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
	final JAXBContext jaxbc=JAXBContext.newInstance(Outil.class, Utilisateur.class);
	final JAXBContext jaxbc2=JAXBContext.newInstance(CategoriesDTO.class, Categorie.class);	
	
	// Le DTO des catégories permettant de récupérer la liste de catégories
	CategoriesDTO categoriesDto = new CategoriesDTO();
	Categorie categorieRes = new Categorie();
	
	// Le compteur pour la liste des catégories
	int cpt = 0;
	
	// On récupère la liste des catégories
	try {
		ClientRequest requestCategories;
		requestCategories = new ClientRequest(
				"http://localhost:8080/rest/categorie/list");
		requestCategories.accept("application/xml");
		ClientResponse<String> responseCategories = requestCategories.get(String.class);
		
		System.out.println("\n !!! responseCategories " + responseCategories.getStatus());
		if(responseCategories.getStatus() == 200) {
			Unmarshaller un2 = jaxbc2.createUnmarshaller();
			categoriesDto = (CategoriesDTO) un2.unmarshal(new StringReader(
					responseCategories.getEntity()));

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
	
	if ((request.getParameter("itemName") != "" )
	&& (request.getParameter("itemCategory") != "" )
	&& (request.getParameter("itemDetails") != "" )
	&& (request.getParameter("itemCaution") != null )
	&& (request.getParameter("start") != "" )
	&& (request.getParameter("end") != "" )
	&& (request.getParameter("termsofuse") != "" )) {

		actionValid = true;

	// Utilisateur
	Utilisateur user = new Utilisateur(); 
	
	cautionCorrecte = request.getParameter("itemCaution").matches("[0-9]*");
	System.out.println("CAUTION CORRECTE " + cautionCorrecte);
	
	//ici on va créer l'outil avec les données rentrées dans le formulaire
	final String name = escapeStr(request.getParameter("itemName"));
	final String category = escapeStr(request.getParameter("itemCategory"));
	final String description = escapeStr(request.getParameter("itemDetails"));
	final int caution;
	if ( cautionCorrecte ){
		caution = Integer.parseInt(request.getParameter("itemCaution"));
	}
	else {
		caution = 0;
	}
	
	
	// On parse l'ID de la catégorie
	final int category_id = Integer.parseInt(category);
	
	// On cherche la catégorie en fonction de son ID
	try {
		ClientRequest requestCategory;
		requestCategory = new ClientRequest(siteUrl + "rest/categorie/" + category_id);
		requestCategory.accept("application/xml");
		ClientResponse<String> responseCategory = requestCategory.get(String.class);
		if(responseCategory.getStatus() == 200) {
			Unmarshaller un2 = jaxbc2.createUnmarshaller();
			categorieRes = (Categorie) un2.unmarshal(new StringReader(
					responseCategory.getEntity()));

			// et ici on peut vérifier que c'est bien le bon objet
			messageValue = "La catégorie a bien été récupérée";
			messageType = "success";
		} else {
			messageValue = "Une erreur est survenue";
			messageType = "danger";
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	// On récupère l'image correspondante à l'objet créé
	final String cheminImage = escapeStr(request.getParameter("itemImg"));

	final String startDate = escapeStr(request.getParameter("start"));
	final String endDate = escapeStr(request.getParameter("end"));
	final String terms = request.getParameter("termsofuse");
	
	final String id = String.valueOf(session.getAttribute("ID"));
	final String userName = String.valueOf(session.getAttribute("userName"));
	
	//Si la caution est correcte, on poursuit. Sinon on ne fait pas l'ajout en base de donnée
	if ( cautionCorrecte )
	{
	
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		Date parsedDateD = sdf.parse(startDate);
		System.out.println("test date debut : " + parsedDateD);
		
		Date parsedDateF = sdf.parse(endDate);
		System.out.println("test date fin : " + parsedDateF);
		
		//ici on envoit la requete au webservice createTool
		try {
			ClientRequest clientRequest ;
			clientRequest = new ClientRequest(siteUrl + "rest/user/" + id);
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
		
		final Outil tool = new Outil(user, name, description, true, categorieRes, caution, parsedDateD, parsedDateF, cheminImage);
		//final Outil tool = new Outil();
	
		//ici il faut sérialiser l'outil
		final Marshaller marshaller = jaxbc.createMarshaller();
		marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
		final java.io.StringWriter sw = new StringWriter();
		marshaller.marshal(tool, sw);			
		
		//ici on envoit la requete au webservice createUtilisateur
		final ClientRequest clientRequest = new ClientRequest(siteUrl + "rest/tool/create");
		clientRequest.body("application/xml", tool);
		
		//CREDENTIALS		
		String username2 = user.getConnexion().getLogin();
		String password2 = user.getConnexion().getPassword();
		String base64encodedUsernameAndPassword = DatatypeConverter.printBase64Binary((username2 + ":" + password2).getBytes());
		clientRequest.header("Authorization", "Basic " +base64encodedUsernameAndPassword );
		///////////////////
		
		
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
		
	}
	else {
		messageType = "danger";
		messageValue = "Caution incorrecte";	
	}
	}
	
	else {
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

<%
	if (actionValid) {
		out.println("<div class='row'><div class='col-md-12' style='margin-top:-20px'>");
		out.println("<div class='alert alert-" + messageType + "'>"
				+ messageValue + "</div>");
		out.println("</div></div>");
	}
%>

<form action="dashboard.jsp?page=manageItems&sub=add"
	class="form-horizontal" role="form" method="POST">
	<div class="">
		<div class="form-group">
			<label for="itemName" class="col-sm-3 control-label">Nom de
				l'objet</label>
			<div class="col-sm-6">
				<input type="text" class="form-control" id="itemName"
					name="itemName" placeholder="Nom de l'objet" required />
			</div>
			<br />
		</div>
		<br />
		<div class="form-group">
			<label for="itemCategory" class="col-sm-3 control-label">Catégorie</label>
			<div class="col-sm-6">
				<select class="form-control" id="itemCategory" name="itemCategory"
					required>
					<!-- <option value="option1">Categorie 1</option>
					<option value="option2">Categorie 2</option>
					<option value="optioncol-md-6 3">Categorie 3</option>
					<option value="option4">Categorie 4</option> -->
					<% for (Categorie c : categoriesDto.getListeCategories()) {
						System.out.println("NOM de la CAT : "+c.getNom());
						cpt++;
					%>
					<option value="<%=c.getId()%>"><%=c.getNom()%></option>
					<% } %>
				</select> <br />
			</div>
		</div>
		<div class="form-group">
			<label for="itemDetails" class="col-sm-3 control-label">Description</label>
			<div class="col-sm-6">
				<textarea class="form-control" rows="5" id="itemDetails"
					name="itemDetails" placeholder="Description de l'objet" required></textarea>
			</div>
		</div>
		<div class="form-group">
			<label for="itemCaution" class="col-sm-3 control-label">Montant
				de la caution</label>
			<div class="col-sm-2">
				<input type="text" class="form-control" maxlength="7"
					id="itemCaution" name="itemCaution" placeholder="Prix" required />
			</div>
			<label for="itemCaution" class="col-sm-1 control-label">euros</label>
			<br />
		</div>
		<hr />
		<div class="form-group">
			<label for="itemDetails" class="col-sm-3 control-label">Disponibilité</label>
			<div class="col-sm-6" id="datepicker">
				<div class="input-daterange input-group" id="datepicker">
					<span class="input-group-addon">du </span> <input type="text"
						data-provide="datepicker" class="datepicker input-sm form-control"
						name="start" required /> <span class="input-group-addon">
						au </span> <input type="text" data-provide="datepicker"
						class="datepicker input-sm form-control" name="end" required />
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
				<div class="row">
					<div class="col-md-8">
						<center><img width="80%" height="80%" src="<%=itemImg%>" id="itemImg" /><input type="hidden" id="itemImgField" name="itemImg" value="" />
						<br /><br />
						<a href="#" class="btn-sm btn btn-info" data-toggle="modal" data-target="#uploadImg"><i class="glyphicon glyphicon-camera"></i> Mettre une image</a></center>
					</div>
				</div>
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
				<input type="checkbox" id="termsofuse" name="termsofuse" required />
				<label for="termsofuse">En mettant cet objet, je m'engage à
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
<jsp:include page="../contents/upload.jsp">
	<jsp:param value="1000" name="maxWidth"/>
	<jsp:param value="1000" name="maxHeight"/>
	<jsp:param value="1024000" name="maxSize"/>
	<jsp:param value="itemImg" name="imgFieldId"/>
	<jsp:param value="itemImgField" name="imgHiddenField"/>
</jsp:include>