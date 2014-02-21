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
		$('#file').click();
	});
	$('#file').change(function() {
		$('#showValue').val($('#file').val());
	});
	$('#uploadForm').on('submit',function(e) {
		e.preventDefault();
		var time = 0;
		if($('#showValue').val()=="" && $('#imgUploader').val()=="") {
			$('#noFile').fadeIn();
		} else {
			$('#bodyMain').hide();
			$('#sendFile').attr("disabled", "disabled");
			$('#sendFile').html("Envoi en cours...");
			$('#closeBtn').hide();
			$('#bodyLoading').show();
			alert($('input[name=fileUp]').val());
			var fd = new FormData();
			fd.append('file',$('input[name=fileUp]'));
			$.ajax({
			    url: "contents/uploadScript.jsp",
			    type: 'POST',
			    data: fd,
			    contentType: false,
			    processData: false,
			    success: function(data){
			    	var answer = data.split('@');
			    	if($.trim(answer[0])=="0") {
						$('#bodyMain').hide();
						$('#sendFile').hide();
						$('#closeBtn').show();
						$('#bodyLoading').hide();
						$('#bodyEndFail').show();
						$('#errorParse').html(answer[1]);
						$('#sendFile').removeAttr("disabled");
			    	} else {
						$('#bodyMain').hide();
						$('#sendFile').hide();
						$('#closeBtn').show();
						$('#bodyLoading').hide();
						$('#bodyEndSuccess').show();
						$('#sendFile').removeAttr("disabled");
			    	}
			    },
			    fail: function() {
			    }
			})
		}
	});
});
</script>

<div class="modal fade" id="uploadImg" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<form method="post" enctype="multipart/form-data" id="uploadForm">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="myModalLabel">Envoi d'image</h4>
				</div>
				<div class="modal-body" id="bodyMain">
					<input type="file" name="fileUp" id="fileUp"/>
					<div id="noFile" class="alert alert-warning perfectCenter" style="display:none;">
						Vous devez sp�cifier une image � envoyer.
					</div>
					<!-- <div class="row">
						<div class="col-md-6">
							<div class="input-group">
								<input style="cursor:pointer;" id="showValue" name="showValue" type="text" placeholder="Choisissez l'image � envoyer" class="form-control" readonly="readonly" required>
								<span class="input-group-btn">
									<button class="btn btn-default" type="button"><i class="glyphicon glyphicon-picture"></i></button>
								</span>
							</div>
						</div>
					</div> -->
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
				<div class="modal-body" id="bodyEndFail" style="display:none;">
					<div class="alert alert-danger perfectCenter">
						Erreur lors de l'envoi de l'image
					</div>
					<p>L'erreur suivante est survenue :<br />
					<pre id="errorParse"></pre></p>
				</div>
				<div class="modal-body" id="bodyEndSuccess" style="display:none;">
					<div class="alert alert-success perfectCenter">
						Envoi de l'image r�ussi.
					</div>
					<div class="input-group">
						<input type="text" name="imgLink" id="imgLink" class="form-control" readonly="readonly"/>
						<span class="input-group-btn">
							<button class="btn btn-default" type="button"><i class="glyphicon glyphicon-share"></i></button>
						</span>
					</div>
				</div>
				<div class="modal-footer">
					<button type="submit" id="sendFile" class="btn btn-info"><i class="glyphicon glyphicon-cloud-upload"></i> Envoyer</button>
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