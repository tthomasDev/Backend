<%@include file="../constantes.jsp"%>
<%@include file="../functions.jsp"%>
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
String username, email, firstname, lastname, address, telephone, avatar;
int age;
/** TODO **/
/* Récupérer les vraies infos */
JAXBContext jaxbc=JAXBContext.newInstance(Utilisateur.class);


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
			
username= 		utilisateurGet.getConnexion().getLogin();
firstname= 		utilisateurGet.getPrenom();
lastname = 		utilisateurGet.getNom();
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
 
age = 			yeardiff;
address = 		utilisateurGet.getAdresse().getadresseComplete();
telephone = 	utilisateurGet.getTelephone();
email = 		utilisateurGet.getMail();
avatar = 		imgFolder + "/user_avatar_default.png";
if(utilisateurGet.getCheminImage()!=null)
	avatar = 	utilisateurGet.getCheminImage();

%>
<style>
.text-right{text-align:right;font-weight:bold;padding-right:5px;vertical-align:top;}
</style>
<script type="text/javascript">
$(function() {
	$('#linkImg').on("change" , function() {
		var tmp = $(this).val();
        $.ajax({
		    url: "<%=pluginFolder%>imgProfilUpdateScript.jsp",
		    type: 'POST',
		    data: {id:<%=utilisateurGet.getId()%>, link:tmp},
		    success: function(data) {
		    	var tmpB = data.split("@");
		    	$('#uploadDone').addClass("alert-"+tmpB[0]).html(tmpB[1]).fadeIn().delay(4000).fadeOut();
		    	$('#avatarP').attr('src',tmp);
		    }
        });
    });
});
</script>

<div class="row">
	<div class="col-md-8">
		<h4>Paramètres de compte</h4>
		<hr />
		<table width="100%">
			<tr>
				<td width="30%" class="text-right"><strong>Nom d'utilisateur :</strong></td>
				<td width="70%"><%=username%></td>
			</tr>
			<tr>
				<td class="text-right"><strong>Adresse email :</strong></td>
				<td><%=email%></td>
			</tr>
			<tr>
				<td class="text-right"><strong>Mot de passe :</strong></td>
				<td>********</td>
			</tr>
		</table>
		<br /><br />
		<h4>Informations personnelles</h4>
		<hr />
		<table width="100%">
			<tr>
				<td width="30%" class="text-right"><strong>Nom* :</strong></td>
				<td width="70%"><%=firstname%></td>
			</tr>
			<tr>
				<td class="text-right"><strong>Prénom :</strong></td>
				<td><%=lastname%></td>
			</tr>
			<tr>
				<td class="text-right"><strong>Age :</strong></td>
				<td><% out.print(String.valueOf(age)); %> ans</td>
			</tr>
			<tr>
				<td class="text-right"><strong>Adresse* :</strong></td>
				<td><%=address%><br /></td>
			</tr>
			<tr>
				<td class="text-right"><strong>Téléphone* :</strong></td>
				<td><%=telephone%></td>
			</tr>
		</table>
		<br />
		<small style="color:#999;"><em>* Champs masqués au public par défaut</em></small>
	</div>
	<div class="col-md-4 perfectCenter">
		<img width="80%" height="80%" class="img-rounded" src="<%=avatar%>" id="avatar" />
		<input type="hidden" name="linkImg" value="" id="linkImg" />
		<br /><br />
		<a href="#" class="btn-sm btn btn-info" data-toggle="modal" data-target="#uploadImg"><i class="glyphicon glyphicon-camera"></i> Changer la photo de profil</a>
		<br /><br />
		<div class="alert perfectCenter" id="uploadDone" style="display:none">Image de profil modifiée avec succès</div>
	</div>
</div>
<jsp:include page="../contents/upload.jsp">
	<jsp:param value="1000" name="maxWidth"/>
	<jsp:param value="1000" name="maxHeight"/>
	<jsp:param value="1024000" name="maxSize"/>
	<jsp:param value="avatar" name="imgFieldId"/>
	<jsp:param value="linkImg" name="imgHiddenField"/>
	<jsp:param value="<%=avatar%>" name="previousImg"/>
</jsp:include>