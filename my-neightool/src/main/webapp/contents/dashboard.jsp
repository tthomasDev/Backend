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

<%@ page import="model.Utilisateur"%>

<%@ page import="com.ped.myneightool.model.Categorie"%>
<%@ page import="com.ped.myneightool.dto.CategoriesDTO"%>


<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";
	boolean list=false;

	actionValid = true;

	//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
	final JAXBContext jaxbc = JAXBContext.newInstance(CategoriesDTO.class);

	// Le DTO des outils permettant de récupérer la liste des categories
	CategoriesDTO categoriesDto = new CategoriesDTO();

	//ici on va récuperer la réponse de la requete
	try {
		ClientRequest requestCategories;
		requestCategories = new ClientRequest(
				"http://localhost:8080/rest/categorie/list/");
		requestCategories.accept("application/xml");
		ClientResponse<String> responseCategories = requestCategories
				.get(String.class);
		if (responseCategories.getStatus() == 200) {
			Unmarshaller un2 = jaxbc.createUnmarshaller();
			categoriesDto = (CategoriesDTO) un2.unmarshal(new StringReader(
					responseCategories.getEntity()));
			if(categoriesDto.size()>0)
			{
				list=true;
				System.out.println("LISTE TRUE");
			}
			else
			{
				list=false;	
				System.out.println("LISTE FALSE");
				
			}
			
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
		<div class="col-md-3 well">
				<ul class="nav nav-pills nav-stacked">
					<li class="active"><a href="#">Objets populaires dans ma région</a></li>
				</ul>
				<hr />
				<ul class="nav nav-pills nav-stacked">
				<% System.out.println("AFFICHAGE : ");
				if(list) {
					System.out.println("LISTE EXISTANTE");
					for (Categorie c : categoriesDto.getListeCategories()) { 
					System.out.println("UNE CAT !!");
					%>
					<li><a href="#"><%=c.getNom()%> <span class="badge pull-right">0</span></a></li>
					<%
					}
				}
				%>
				</ul>
			</div> 
			<div class="col-md-9">
				<ol class="breadcrumb">
					<li><a href="#">Accueil</a></li>
					<li class="active">Les plus regardés dans votre région (< 50km)</li>
				</ol>
				
				<div class="table-responsive">
					<table class="table table-hover" id="toReorder">
						<thead>
							<tr>
								<th style="text-align:center;" width="140px">Photo</th>
								<th style="text-align:center;" width="80%">Description</th>
								<th style="text-align:center;" width="20%">Distance <span class="reorderer" name="distance"></span></th>
							</tr>
						</thead>
						<tbody>
							<tr class="toPaginate">
								<td><img class="img-rounded" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAYAAACuwEE+AAADxElEQVR4nO3X3U7qeBSG8X3/l7KsEQQNWlQkGiuiGPCA+BWMiqC0t/DOEc1s997JvDPjR/U5+J1gm2VYT5s/P4qiEPBP/fjofwDVQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwslQrm5uZGWZap3W4rTVONRqPfXvfw8KA0TZWmqYbDYfn5YrFQv9/XxsaGGo2G9vf39fj4WJn5n0Glgul2u1pdXdXa2poiQr1e75dr8jzX1taWIkIRoSzLyr8dHBwoItRoNJSmqSJC9Xpd8/m8EvM/g0oFM5vNlOe5Dg8P/7iws7MzJUlSLmS5sKenJ62srCgiNJ1OVRRFudjBYKCrqytlWVa+NRaLhXq9nrIsK98Cbzn/o7/bLxnM0p8Wdn9/ryRJdHp6qqOjo58WNh6Pyyd6eX2WZYoI7e3t6fn5Wc1mUxGh6+tr9Xo9RYS63e67zP/o7/TbBZPnuVqtllqtlvI8/2Vho9FIEaFms1ne0+/3FRHa3t5WURSaTCZKkkS1Wk0rKytqNpt6eXl5t/lV8GWCubi4UERoNBrp9vZWnU5HEaH9/X3d3d2VT/j6+np5z/HxsSJCnU6n/Gz5Zlm+ad57/mf3ZYIZDAblol9rtVq6v79XRChJkvKtsVzqycmJiqLQfD5XvV4v79vZ2XnX+VVQqWDG47GyLNPm5ma5iCzLdHl5qbu7Ow2Hw9Ly0NlutzUej1UUhdrtdvlELw+nSZKUh9Dd3d3yELq89u8H0reeXwWVCmb5ZL/2u18rr88QRVFoOp3+9JO3VquVyzw/P1dEKE1T5Xmu2WymWq2mJEk0mUzefH5VVCqY/8tsNtPDw4PyPP+W8/+LbxkM/j2CgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKB5S+0wiW8EyQhYQAAAABJRU5ErkJggg==" /></td>
								<td style="vertical-align:middle;">
									<strong><a href="dashboard.jsp?page=itemDetails&id=1">Objet test numéro 1</a></strong><br />
									<p>Il s'agit d'un bien bel objet</p>
								</td>
								<td class="perfectCenter reorderable">9 km environ</td>
							</tr>
							<tr class="toPaginate">
								<td><img class="img-rounded" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAYAAACuwEE+AAADxElEQVR4nO3X3U7qeBSG8X3/l7KsEQQNWlQkGiuiGPCA+BWMiqC0t/DOEc1s997JvDPjR/U5+J1gm2VYT5s/P4qiEPBP/fjofwDVQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwslQrm5uZGWZap3W4rTVONRqPfXvfw8KA0TZWmqYbDYfn5YrFQv9/XxsaGGo2G9vf39fj4WJn5n0Glgul2u1pdXdXa2poiQr1e75dr8jzX1taWIkIRoSzLyr8dHBwoItRoNJSmqSJC9Xpd8/m8EvM/g0oFM5vNlOe5Dg8P/7iws7MzJUlSLmS5sKenJ62srCgiNJ1OVRRFudjBYKCrqytlWVa+NRaLhXq9nrIsK98Cbzn/o7/bLxnM0p8Wdn9/ryRJdHp6qqOjo58WNh6Pyyd6eX2WZYoI7e3t6fn5Wc1mUxGh6+tr9Xo9RYS63e67zP/o7/TbBZPnuVqtllqtlvI8/2Vho9FIEaFms1ne0+/3FRHa3t5WURSaTCZKkkS1Wk0rKytqNpt6eXl5t/lV8GWCubi4UERoNBrp9vZWnU5HEaH9/X3d3d2VT/j6+np5z/HxsSJCnU6n/Gz5Zlm+ad57/mf3ZYIZDAblol9rtVq6v79XRChJkvKtsVzqycmJiqLQfD5XvV4v79vZ2XnX+VVQqWDG47GyLNPm5ma5iCzLdHl5qbu7Ow2Hw9Ly0NlutzUej1UUhdrtdvlELw+nSZKUh9Dd3d3yELq89u8H0reeXwWVCmb5ZL/2u18rr88QRVFoOp3+9JO3VquVyzw/P1dEKE1T5Xmu2WymWq2mJEk0mUzefH5VVCqY/8tsNtPDw4PyPP+W8/+LbxkM/j2CgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKB5S+0wiW8EyQhYQAAAABJRU5ErkJggg==" /></td>
								<td style="vertical-align:middle;">
									<strong><a href="dashboard.jsp?page=itemDetails&id=1">Objet test numéro 2</a></strong><br />
									<p>Il s'agit d'un bien bel objet</p>
								</td>
								<td class="perfectCenter reorderable">5 km environ</td>
							</tr>
							<tr class="toPaginate">
								<td><img class="img-rounded" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAYAAACuwEE+AAADxElEQVR4nO3X3U7qeBSG8X3/l7KsEQQNWlQkGiuiGPCA+BWMiqC0t/DOEc1s997JvDPjR/U5+J1gm2VYT5s/P4qiEPBP/fjofwDVQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwslQrm5uZGWZap3W4rTVONRqPfXvfw8KA0TZWmqYbDYfn5YrFQv9/XxsaGGo2G9vf39fj4WJn5n0Glgul2u1pdXdXa2poiQr1e75dr8jzX1taWIkIRoSzLyr8dHBwoItRoNJSmqSJC9Xpd8/m8EvM/g0oFM5vNlOe5Dg8P/7iws7MzJUlSLmS5sKenJ62srCgiNJ1OVRRFudjBYKCrqytlWVa+NRaLhXq9nrIsK98Cbzn/o7/bLxnM0p8Wdn9/ryRJdHp6qqOjo58WNh6Pyyd6eX2WZYoI7e3t6fn5Wc1mUxGh6+tr9Xo9RYS63e67zP/o7/TbBZPnuVqtllqtlvI8/2Vho9FIEaFms1ne0+/3FRHa3t5WURSaTCZKkkS1Wk0rKytqNpt6eXl5t/lV8GWCubi4UERoNBrp9vZWnU5HEaH9/X3d3d2VT/j6+np5z/HxsSJCnU6n/Gz5Zlm+ad57/mf3ZYIZDAblol9rtVq6v79XRChJkvKtsVzqycmJiqLQfD5XvV4v79vZ2XnX+VVQqWDG47GyLNPm5ma5iCzLdHl5qbu7Ow2Hw9Ly0NlutzUej1UUhdrtdvlELw+nSZKUh9Dd3d3yELq89u8H0reeXwWVCmb5ZL/2u18rr88QRVFoOp3+9JO3VquVyzw/P1dEKE1T5Xmu2WymWq2mJEk0mUzefH5VVCqY/8tsNtPDw4PyPP+W8/+LbxkM/j2CgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKB5S+0wiW8EyQhYQAAAABJRU5ErkJggg==" /></td>
								<td style="vertical-align:middle;">
									<strong><a href="dashboard.jsp?page=itemDetails&id=1">Objet test numéro 3</a></strong><br />
									<p>Il s'agit d'un bien bel objet</p>
								</td>
								<td class="perfectCenter reorderable">1 km environ</td>
							</tr>
							<tr class="toPaginate">
								<td><img class="img-rounded" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAYAAACuwEE+AAADxElEQVR4nO3X3U7qeBSG8X3/l7KsEQQNWlQkGiuiGPCA+BWMiqC0t/DOEc1s997JvDPjR/U5+J1gm2VYT5s/P4qiEPBP/fjofwDVQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwslQrm5uZGWZap3W4rTVONRqPfXvfw8KA0TZWmqYbDYfn5YrFQv9/XxsaGGo2G9vf39fj4WJn5n0Glgul2u1pdXdXa2poiQr1e75dr8jzX1taWIkIRoSzLyr8dHBwoItRoNJSmqSJC9Xpd8/m8EvM/g0oFM5vNlOe5Dg8P/7iws7MzJUlSLmS5sKenJ62srCgiNJ1OVRRFudjBYKCrqytlWVa+NRaLhXq9nrIsK98Cbzn/o7/bLxnM0p8Wdn9/ryRJdHp6qqOjo58WNh6Pyyd6eX2WZYoI7e3t6fn5Wc1mUxGh6+tr9Xo9RYS63e67zP/o7/TbBZPnuVqtllqtlvI8/2Vho9FIEaFms1ne0+/3FRHa3t5WURSaTCZKkkS1Wk0rKytqNpt6eXl5t/lV8GWCubi4UERoNBrp9vZWnU5HEaH9/X3d3d2VT/j6+np5z/HxsSJCnU6n/Gz5Zlm+ad57/mf3ZYIZDAblol9rtVq6v79XRChJkvKtsVzqycmJiqLQfD5XvV4v79vZ2XnX+VVQqWDG47GyLNPm5ma5iCzLdHl5qbu7Ow2Hw9Ly0NlutzUej1UUhdrtdvlELw+nSZKUh9Dd3d3yELq89u8H0reeXwWVCmb5ZL/2u18rr88QRVFoOp3+9JO3VquVyzw/P1dEKE1T5Xmu2WymWq2mJEk0mUzefH5VVCqY/8tsNtPDw4PyPP+W8/+LbxkM/j2CgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKB5S+0wiW8EyQhYQAAAABJRU5ErkJggg==" /></td>
								<td style="vertical-align:middle;">
									<strong><a href="dashboard.jsp?page=itemDetails&id=1">Objet test numéro 4</a></strong><br />
									<p>Il s'agit d'un bien bel objet</p>
								</td>
								<td class="perfectCenter reorderable">11 km environ</td>
							</tr>
							<tr class="toPaginate">
								<td><img class="img-rounded" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAYAAACuwEE+AAADxElEQVR4nO3X3U7qeBSG8X3/l7KsEQQNWlQkGiuiGPCA+BWMiqC0t/DOEc1s997JvDPjR/U5+J1gm2VYT5s/P4qiEPBP/fjofwDVQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwslQrm5uZGWZap3W4rTVONRqPfXvfw8KA0TZWmqYbDYfn5YrFQv9/XxsaGGo2G9vf39fj4WJn5n0Glgul2u1pdXdXa2poiQr1e75dr8jzX1taWIkIRoSzLyr8dHBwoItRoNJSmqSJC9Xpd8/m8EvM/g0oFM5vNlOe5Dg8P/7iws7MzJUlSLmS5sKenJ62srCgiNJ1OVRRFudjBYKCrqytlWVa+NRaLhXq9nrIsK98Cbzn/o7/bLxnM0p8Wdn9/ryRJdHp6qqOjo58WNh6Pyyd6eX2WZYoI7e3t6fn5Wc1mUxGh6+tr9Xo9RYS63e67zP/o7/TbBZPnuVqtllqtlvI8/2Vho9FIEaFms1ne0+/3FRHa3t5WURSaTCZKkkS1Wk0rKytqNpt6eXl5t/lV8GWCubi4UERoNBrp9vZWnU5HEaH9/X3d3d2VT/j6+np5z/HxsSJCnU6n/Gz5Zlm+ad57/mf3ZYIZDAblol9rtVq6v79XRChJkvKtsVzqycmJiqLQfD5XvV4v79vZ2XnX+VVQqWDG47GyLNPm5ma5iCzLdHl5qbu7Ow2Hw9Ly0NlutzUej1UUhdrtdvlELw+nSZKUh9Dd3d3yELq89u8H0reeXwWVCmb5ZL/2u18rr88QRVFoOp3+9JO3VquVyzw/P1dEKE1T5Xmu2WymWq2mJEk0mUzefH5VVCqY/8tsNtPDw4PyPP+W8/+LbxkM/j2CgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKB5S+0wiW8EyQhYQAAAABJRU5ErkJggg==" /></td>
								<td style="vertical-align:middle;">
									<strong><a href="dashboard.jsp?page=itemDetails&id=1">Objet test numéro 5</a></strong><br />
									<p>Il s'agit d'un bien bel objet</p>
								</td>
								<td class="perfectCenter reorderable">19 km environ</td>
							</tr>
							<tr class="toPaginate">
								<td><img class="img-rounded" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAYAAACuwEE+AAADxElEQVR4nO3X3U7qeBSG8X3/l7KsEQQNWlQkGiuiGPCA+BWMiqC0t/DOEc1s997JvDPjR/U5+J1gm2VYT5s/P4qiEPBP/fjofwDVQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwsBAMLwcBCMLAQDCwEAwvBwEIwsBAMLAQDC8HAQjCwEAwslQrm5uZGWZap3W4rTVONRqPfXvfw8KA0TZWmqYbDYfn5YrFQv9/XxsaGGo2G9vf39fj4WJn5n0Glgul2u1pdXdXa2poiQr1e75dr8jzX1taWIkIRoSzLyr8dHBwoItRoNJSmqSJC9Xpd8/m8EvM/g0oFM5vNlOe5Dg8P/7iws7MzJUlSLmS5sKenJ62srCgiNJ1OVRRFudjBYKCrqytlWVa+NRaLhXq9nrIsK98Cbzn/o7/bLxnM0p8Wdn9/ryRJdHp6qqOjo58WNh6Pyyd6eX2WZYoI7e3t6fn5Wc1mUxGh6+tr9Xo9RYS63e67zP/o7/TbBZPnuVqtllqtlvI8/2Vho9FIEaFms1ne0+/3FRHa3t5WURSaTCZKkkS1Wk0rKytqNpt6eXl5t/lV8GWCubi4UERoNBrp9vZWnU5HEaH9/X3d3d2VT/j6+np5z/HxsSJCnU6n/Gz5Zlm+ad57/mf3ZYIZDAblol9rtVq6v79XRChJkvKtsVzqycmJiqLQfD5XvV4v79vZ2XnX+VVQqWDG47GyLNPm5ma5iCzLdHl5qbu7Ow2Hw9Ly0NlutzUej1UUhdrtdvlELw+nSZKUh9Dd3d3yELq89u8H0reeXwWVCmb5ZL/2u18rr88QRVFoOp3+9JO3VquVyzw/P1dEKE1T5Xmu2WymWq2mJEk0mUzefH5VVCqY/8tsNtPDw4PyPP+W8/+LbxkM/j2CgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKBhWBgIRhYCAYWgoGFYGAhGFgIBhaCgYVgYCEYWAgGFoKB5S+0wiW8EyQhYQAAAABJRU5ErkJggg==" /></td>
								<td style="vertical-align:middle;">
									<strong><a href="dashboard.jsp?page=itemDetails&id=1">Objet test numéro 5</a></strong><br />
									<p>Il s'agit d'un bien bel objet</p>
								</td>
								<td class="perfectCenter reorderable">20 km environ</td>
							</tr>
						</tbody>
					</table>
				</div>
			
				<div id="paginator"></div>
				<input id="paginatorNbElements" type="hidden" value="5" readonly="readonly" />
			</div>
