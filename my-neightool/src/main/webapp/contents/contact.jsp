<%@include file="../constantes.jsp"%>
<script type="text/javascript">
$(function() {
	$('#sendMessage').click(function(e) {
		e.preventDefault();
		$.ajax({
		    url: "<%=pluginFolder%>contactScript.jsp",
		    type: 'POST',
		    data: {subjectTo: $("#subjectOfMessage").val(), messageTo: $("#bodyOfMessage").val()},
		    success: function(data){
		    	$("#sendWait").hide();
		    	$("#sendSuccess").show();
		    	$("#sendMessage").hide();
		    }
		});
	});
});
</script>
<div class="modal fade" id="contact" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Nous contacter</h4>
			</div>
			<form method="POST"id="contactForm" name="contactForm" class="form-horizontal">
				<div id="sendSuccess" class="modal-body" style="display:none">
					<div class="alert alert-success perfectCenter">Message envoyé avec succès !</div>
				</div>
				<div id="sendWait" class="modal-body">
					<p>Un problème sur le site ? Une remarque ? N'hésitez pas à nous contacter !</p><br />
					<div class="form-group">
						<label for="subjectTo" class="col-sm-3 control-label">Sujet</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" value="" name="subjectTo" id="subjectOfMessage" placeholder="Sujet du message" required/>
						</div>
					</div>
					<div class="form-group">
						<label for="messageTo" class="col-sm-3 control-label">Message</label>
						<div class="col-sm-9">
							<textarea class="form-control" rows="10" name="messageTo" id="bodyOfMessage" placeholder="Entrez votre message" required></textarea>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
					<button type="button" id="sendMessage" class="btn btn-info"><i class="glyphicon glyphicon-envelope"></i> Envoyer</button>
				</div>
			</form>
		</div>
	</div>
</div>