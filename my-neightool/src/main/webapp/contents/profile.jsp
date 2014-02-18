<%
if(request.getParameter("userId") != null) {
	String username, lastname, city, avatar;
	int age, userId;
	/** TODO **/
	/* Récupérer les vraies infos */
	/* Les infos suivantes sont mises à titre d'exemple */
	userId = 1;
	username = "Utilisateur 1";
	lastname = "David";
	age = 25;
	city = "Bordeaux";
	avatar = "./dist/img/user_avatar_default.png";
%>

<div class="modal fade" id="userProfile" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Profil de <%=username%></h4>
			</div>
			<div class="modal-body">
				<style>.text-right {text-align: right;font-weight: bold;padding-right: 5px;vertical-align: top;}</style>
				<ul class="nav nav-tabs">
					<li class="active"><a href="#infos" data-toggle="tab">Informations</a></li>
					<li><a href="#list" data-toggle="tab">Objets à emprunter</a></li>
				</ul>
				<br />
				<div class="tab-content">
					<div class="tab-pane active" id="infos">
						<div class="row">
							<div class="col-md-8">
								<table width="100%">
									<tr>
										<td width="30%" class="text-right"><strong>Prénom :</strong></td>
										<td width="70%"><%=lastname%></td>
									</tr>
									<tr>
										<td class="text-right"><strong>Age :</strong></td>
										<td>
											<% out.print(String.valueOf(age)); %> ans
										</td>
									</tr>
									<tr>
										<td class="text-right"><strong>Lieu :</strong></td>
										<td><%=city%></td>
									</tr>
								</table>
							</div>
							<div class="col-md-4 perfectCenter">
								<img width="80%" height="80%" src="<%=avatar%>" />
							</div>
						</div>
					</div>
					<div class="tab-pane" id="list">
						<div class="alert alert-info perfectCenter"><i class="glyphicon glyphicon-warning-sign"></i> Aucun objet n'est actuellement prêté par <%=username%></div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<a href="dashboard.jsp?page=mailbox&userId=<% out.print(String.valueOf(userId)); %>" target="_blank" class="btn btn-info"><i class="glyphicon glyphicon-envelope"></i> Contacter</a>
				<a href="#" class="btn btn-default" data-dismiss="modal">Fermer</a>
			</div>
		</div>
	</div>
</div>

<%
} else {
%>

<div class="modal fade" id="userProfile" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Erreur</h4>
			</div>
			<div class="modal-body">
				<div class="alert alert-danger perfectCenter">Le profil que vous demandez n'existe pas ou plus.</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
			</div>
		</div>
	</div>
</div>

<% } %>