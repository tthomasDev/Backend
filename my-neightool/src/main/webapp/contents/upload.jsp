<%@ page import="java.lang.Math"%>

<%
if(request.getParameter("maxSize") != null && request.getParameter("maxHeight") != null && request.getParameter("maxWidth") != null) {
	int maxSize = Integer.parseInt(request.getParameter("maxSize"));
	int maxHeight = Integer.parseInt(request.getParameter("maxHeight"));
	int maxWidth = Integer.parseInt(request.getParameter("maxWidth"));
	double sizeInMo = Math.round(maxSize / 1024000); 
	
%>

<script type="text/javascript">
$(document).ready(function() {
	
	$('#showValue').click(function() {
		$('#imgUploader').click();
	});
	$('#imgUploader').change(function() {
		$('#showValue').val($('#imgUploader').val());
	});
	$('#sendFile').click(function(e) {
		var time = 0;
		if($('#showValue').val()=="" && $('#imgUploader').val()=="") {
			$('#noFile').fadeIn();
		} else {
			$('#bodyMain').hide();
			$('#sendFile').attr("disabled", "disabled");
			$('#sendFile').html("Envoi en cours...");
			$('#closeBtn').hide();
			$('#bodyLoading').show();
			e.preventDefault();
			var toUp = $('#imgUploader').val();
			$.ajax({
			    url: 'contents/uploadScript.jsp',
			    data: {fileUp:toUp},
			    cache: false,
			    contentType: false,
			    processData: false,
			    type: 'POST',
			    success: function(data){
			    	alert(data)
			    },
			    fail: function() {
			    	alert("Erreur");
			    }
			}).done(function() {
				$('#bodyMain').hide();
				$('#sendFile').hide();
				$('#closeBtn').show();
				$('#bodyLoading').hide();
				$('#bodyEnd').show();
			});
		}
	});
});
</script>

<div class="modal fade" id="uploadImg" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<form method="POST" id="uploadForm">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="myModalLabel">Envoi d'image</h4>
				</div>
				<div class="modal-body" id="bodyMain">
					<input type="file" name="imgUploader" id="imgUploader" style="display:none;"/>
					<div id="noFile" class="alert alert-warning perfectCenter" style="display:none;">
						Vous devez spécifier une image à envoyer.
					</div>
					<div class="row">
						<div class="col-md-6">
							<div class="input-group">
								<input style="cursor:pointer;" id="showValue" name="showValue" type="text" placeholder="Choisissez l'image à envoyer" class="form-control" readonly="readonly" required>
								<span class="input-group-btn">
									<button class="btn btn-default" type="button"><i class="glyphicon glyphicon-picture"></i></button>
								</span>
							</div>
						</div>
					</div>
					<br />
					<strong>Restrictions :</strong>
					<ul>
						<li>Taille maximum : <%=maxSize%> octets (soit <%=sizeInMo%> Mo)</li>
						<li>Dimensions maximums : <%=maxWidth%> par <%=maxHeight%> pixels</li>
					</ul>
				</div>
				<div class="modal-body" id="bodyLoading" style="display:none;">
					<div class="alert alert-info perfectCenter">
						<img src="./dist/img/ajax-loader.gif" />
						<br /><br />
						Envoi de votre fichier en cours...
					</div>
				</div>
				<div class="modal-body" id="bodyEnd" style="display:none;">
					<div class="alert alert-success perfectCenter">
						Envoi de l'image réussi.
					</div>
					<div class="input-group">
						<input type="text" name="imgLink" id="imgLink" class="form-control" readonly="readonly"/>
						<span class="input-group-btn">
							<button class="btn btn-default" type="button"><i class="glyphicon glyphicon-share"></i></button>
						</span>
					</div>
				</div>
				<div class="modal-footer">
					<a id="sendFile" class="btn btn-info"><i class="glyphicon glyphicon-cloud-upload"></i> Envoyer</a>
					<a id="closeBtn" class="btn btn-default" data-dismiss="modal">Fermer</a>
				</div>
			</div>
		</form>
	</div>
</div>

<% } else { %>

<div class="modal fade" id="uploadImg" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Envoi d'image</h4>
			</div>
			<div class="modal-body">
				<div class="alert alert-danger perfectCenter">
					Erreur lors du chargement du formulaire d'envoi d'image.
				</div>
			</div>
			<div class="modal-footer">
				<a href="#" class="btn btn-default" data-dismiss="modal">Fermer</a>
			</div>
		</div>
	</div>
</div>

<% } %>