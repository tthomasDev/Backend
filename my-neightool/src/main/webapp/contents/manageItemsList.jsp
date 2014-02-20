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

<%@ page import="model.Utilisateur"%>

<%@ page import="com.ped.myneightool.model.Outil"%>
<%@ page import="com.ped.myneightool.dto.OutilsDTO"%>

<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";

	actionValid = true;

	//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
	final JAXBContext jaxbc = JAXBContext.newInstance(Utilisateur.class);
	final JAXBContext jaxbc2 = JAXBContext.newInstance(OutilsDTO.class);

	// Utilisateur
	Utilisateur user = new Utilisateur();

	// Le DTO des outils permettant de récupérer la liste d'outils
	OutilsDTO outilsDto = new OutilsDTO();

	// On récupère les données de session de l'utilisateur
	final String id = String.valueOf(session.getAttribute("ID"));
	final String userName = String.valueOf(session
			.getAttribute("userName"));

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
				"http://localhost:8080/rest/tool/user/" + user.getId());
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

<div class="row">
	<div class="col-md-12">
		<ol class="breadcrumb">
			<li><a href="#">Accueil</a></li>
			<li class="active">Liste de mes outils</li>
		</ol>
	
		<div class="table-responsive">
			<table class="table table-hover">
				<thead>
					<tr>
						<th style="text-align: center;" width="140px">Photo</th>
						<th style="text-align: center;" width="80%">Description</th>
						<th style="text-align: center;" width="20%">Caution</th>
					</tr>
				</thead>
				<tbody>
					<% for (Outil t : outilsDto.getListeOutils()) { %>
					<tr style="vertical-align: middle;">
						<td><img class="img-rounded"
							src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAYAAACuwEE+AAADxElEQVR4nO3X3U7qeBSG8X3/l7KsEQQNWlQkGiuiGPCA+BWMiqC0t/DOEc1s997JvDPjR/U5+J1gm2VYT5s/P4qiEPBP/fjofwDVQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwslQrm5uZGWZap3W4rTVONRqPfXvfw8KA0TZWmqYbDYfn5YrFQv9/XxsaGGo2G9vf39fj4WJn5n0Glgul2u1pdXdXa2poiQr1e75dr8jzX1taWIkIRoSzLyr8dHBwoItRoNJSmqSJC9Xpd8/m8EvM/g0oFM5vNlOe5Dg8P/7iws7MzJUlSLmS5sKenJ62srCgiNJ1OVRRFudjBYKCrqytlWVa+NRaLhXq9nrIsK98Cbzn/o7/bLxnM0p8Wdn9/ryRJdHp6qqOjo58WNh6Pyyd6eX2WZYoI7e3t6fn5Wc1mUxGh6+tr9Xo9RYS63e67zP/o7/TbBZPnuVqtllqtlvI8/2Vho9FIEaFms1ne0+/3FRHa3t5WURSaTCZKkkS1Wk0rKytqNpt6eXl5t/lV8GWCubi4UERoNBrp9vZWnU5HEaH9/X3d3d2VT/j6+np5z/HxsSJCnU6n/Gz5Zlm+ad57/mf3ZYIZDAblol9rtVq6v79XRChJkvKtsVzqycmJiqLQfD5XvV4v79vZ2XnX+VVQqWDG47GyLNPm5ma5iCzLdHl5qbu7Ow2Hw9Ly0NlutzUej1UUhdrtdvlELw+nSZKUh9Dd3d3yELq89u8H0reeXwWVCmb5ZL/2u18rr88QRVFoOp3+9JO3VquVyzw/P1dEKE1T5Xmu2WymWq2mJEk0mUzefH5VVCqY/8tsNtPDw4PyPP+W8/+LbxkM/j2CgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKB5S+0wiW8EyQhYQAAAABJRU5ErkJggg==" /></td>
						<td style="vertical-align: middle;"><strong><a
								href="dashboard.jsp?page=itemDetails&id=<%=t.getId()%>"><%=t.getNom() %></a></strong><br />
							<p><%=t.getDescription() %></p></td>
						<td style="vertical-align: middle; text-align: center;"><%=t.getCaution() %></td>
					</tr>
					<% } %>
				</tbody>
			</table>
		</div>
	
		<div class="row">
			<div class="col-md-12" style="text-align: center;">
				<ul class="pagination">
					<li><a href="#">&laquo;</a></li>
					<li><a href="#">1</a></li>
					<li><a href="#">2</a></li>
					<li><a href="#">3</a></li>
					<li><a href="#">4</a></li>
					<li><a href="#">5</a></li>
					<li><a href="#">&raquo;</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>