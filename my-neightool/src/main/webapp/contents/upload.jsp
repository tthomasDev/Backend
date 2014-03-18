<%@include file="../constantes.jsp"%>
<%@ page import="java.lang.Math"%>

<%
if(request.getParameter("maxSize") != null && request.getParameter("maxHeight") != null && request.getParameter("maxWidth") != null) {
	int maxSize = Integer.parseInt(request.getParameter("maxSize"));
	int maxHeight = Integer.parseInt(request.getParameter("maxHeight"));
	int maxWidth = Integer.parseInt(request.getParameter("maxWidth"));
	double sizeInMo = Math.round(maxSize / 1024000);
	String imgFieldId = "", imgHiddenField = "", previousLink = "";
	boolean hiddenField = false, fieldId = false, prevLink = false;
	if(request.getParameter("imgFieldId") != null) {
		imgFieldId = "'#"+request.getParameter("imgFieldId")+"'";
		fieldId = true;
	}
	if(request.getParameter("imgHiddenField") != null) {
		imgHiddenField = "'#"+request.getParameter("imgHiddenField")+"'";
		hiddenField = true;	
	}
	if(request.getParameter("previousImg") != null) {
		String[] tmp = request.getParameter("previousImg").split("/");
		previousLink = tmp[tmp.length-1];
		prevLink = true;
	}
	
%>

<script type="text/javascript">
$(document).ready(function() {
	$('#showValueBtn').click(function() {
		$('#fileUp').click();
	});
	$('#showValue').click(function() {
		$('#fileUp').click();
	});
	$('#retryBtn').click(function() {
		$('#bodyMain').show();
		$('#sendFile').show();
		$('#closeBtn').show();
		$('#bodyEndFail').hide();
		$('#retryBtn').hide();
		$('#sendFile').html("Envoyer");
	});
	$('#fileUp').change(function() {
		$('#showValue').val($('#fileUp').val());
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
			var fd = new FormData();
			jQuery.each($('#fileUp')[0].files, function(i, file) {
				fd.append('file-'+i, file);
			});
			$.ajax({
			    url: "<%=pluginFolder%>uploadScript.jsp?size=<%=maxSize%>",
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
						$('#retryBtn').show();
						$('#sendFile').removeAttr("disabled");
			    	} else {
						$('#bodyMain').hide();
						$('#sendFile').hide();
						$('#closeBtn').show();
						$('#bodyLoading').hide();
						$('#bodyEndSuccess').show();
						$('#imgLink').val(answer[1]);
						<% if(fieldId) { %>
						$(<%=imgFieldId%>).attr("src", answer[1]);
						<% } %>
						<% if(hiddenField) { %>
						$(<%=imgHiddenField%>).val(answer[1]).trigger('change');
						<% } %>
						$('#sendFile').removeAttr("disabled");
						<% if(prevLink) { %>
						$.ajax({
							url: "<%=pluginFolder%>deleteScript.jsp",
							type: 'POST',
							data: {link: "<%=previousLink%>"},
							success: function() {}
						});
						<% } %>
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
		<form method="POST" enctype="multipart/form-data" id="uploadForm" name="uploadForm">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="myModalLabel">Envoi d'image</h4>
				</div>
				<div class="modal-body" id="bodyMain">
					<input type="file" name="fileUp" id="fileUp" style="display:none;"/>
					<div id="noFile" class="alert alert-warning perfectCenter" style="display:none;">
						Vous devez spécifier une image à envoyer.
					</div>
					<div class="row">
						<div class="col-md-6">
							<div class="input-group">
								<input style="cursor:pointer;" id="showValue" name="showValue" type="text" placeholder="Choisissez l'image à envoyer" class="form-control" readonly="readonly" required>
								<span class="input-group-btn">
									<button id="showValueBtn" class="btn btn-default" type="button"><i class="glyphicon glyphicon-picture"></i></button>
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
				<div class="modal-body" id="bodyEndFail" style="display:none;">
					<div class="alert alert-danger perfectCenter">
						Erreur lors de l'envoi de l'image
					</div>
					<p>L'erreur suivante est survenue :<br />
					<pre id="errorParse"></pre></p>
				</div>
				<div class="modal-body" id="bodyEndSuccess" style="display:none;">
					<div class="alert alert-success perfectCenter">
						Envoi de l'image réussi.
					</div>
					<input type="text" name="imgLink" id="imgLink" class="form-control" readonly="readonly"/>
				</div>
				<div class="modal-footer">
					<button type="submit" id="sendFile" class="btn btn-info"><i class="glyphicon glyphicon-cloud-upload"></i> Envoyer</button>
					<a id="retryBtn" class="btn btn-info" style="display:none;">Réessayer</a>
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