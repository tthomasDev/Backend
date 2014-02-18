<%
String subInclude = "mailboxMain.jsp";
String menuMainActive = "active";
String menuSentActive = "";
boolean newMessageHidden = true;
String newMessageTo = "";
if(request.getParameter("sub") != null) {
	String sub = (String)request.getParameter("sub");
	if(sub.equals("sent")) {
		subInclude = "mailboxSent.jsp";
		menuMainActive = "";
		menuSentActive = "active";
	}
}
if(request.getParameter("userId") != null) {
	newMessageHidden = false;
	/** TODO **/
	/* Récupérer le nom d'utilisateur */
	newMessageTo = "Utilisateur 1";
}
%>
		<% if(!newMessageHidden) { %>
		<script type="text/javascript">
		    $(document).ready(function () {
		        $('#newMessageModal').modal('show');
		    });
		</script>
		<% } %>
		
		<div class="col-md-3 well">
			<ul class="nav nav-pills nav-stacked">
				<li><a href="#" data-toggle="modal" data-target="#newMessageModal"><span class="glyphicon glyphicon-envelope"></span> Nouveau message</a></li>
				<hr />
				<li class="<%=menuMainActive%>"><a href="dashboard.jsp?page=mailbox"><span class="glyphicon glyphicon-inbox"></span> Boite de réception <span class="badge pull-right">0</span></a></li>
				<li class="<%=menuSentActive%>"><a href="dashboard.jsp?page=mailbox&sub=sent">Messages envoyés</a></li>
			</ul>
		</div> 
		<div class="col-md-9">
			<jsp:include page="<%=subInclude%>" />
		</div>

		<div class="modal fade" id="newMessageModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="myModalLabel">Composer un nouveau message</h4>
					</div>
					<form action="#" class="form-horizontal">
						<div class="modal-body">
							<div class="form-group">
								<label for="userTo" class="col-sm-3 control-label">Destinataire</label>
								<div class="col-sm-9">
									<input type="text" class="form-control" id="userTo" placeholder="Nom d'utilisateur du destinataire" value="<%=newMessageTo%>" required/>
								</div>
							</div>
							<div class="form-group">
								<label for="subjectTo" class="col-sm-3 control-label">Sujet</label>
								<div class="col-sm-9">
									<input type="text" class="form-control" id="subjectTo" placeholder="Sujet du message" required/>
								</div>
							</div>
							<div class="form-group">
								<label for="messageTo" class="col-sm-3 control-label">Message</label>
								<div class="col-sm-9">
									<textarea class="form-control" rows="10" id="messageTo" placeholder="Entrez votre message" required></textarea>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
							<button type="submit" class="btn btn-info">Envoyer</button>
						</div>
					</form>
				</div>
			</div>
		</div>