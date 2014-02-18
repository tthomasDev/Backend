<%

String username, email, firstname, lastname, address, city, postalCode, telephone, avatar;
int age;
/** TODO **/
/* Récupérer les vraies infos */
/* Les infos suivantes sont mises à titre d'exemple */
username = "Utilisateur 1";
firstname = "Martin";
lastname = "David";
age = 25;
address = "36 rue des Tests";
city = "Bordeaux";
postalCode = "33000";
telephone = "05.66.84.32.17";
email = "adresse@email.com";
avatar = "./dist/img/user_avatar_default.png";

%>
<style>
.text-right{text-align:right;font-weight:bold;padding-right:5px;vertical-align:top;}
</style>
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
				<td><%=address%><br /><%=postalCode%> <%=city%></td>
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
		<img width="80%" height="80%" src="<%=avatar%>" />
	</div>
</div>