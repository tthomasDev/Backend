var showed = false;

function formatDate(str) {
	var tab = str.split("/");
	var day = tab[0];
	var month = tab[1];
	var year = tab[2];
	return new Date(month + "/" + day + "/" + year);
}

function reInit() {
	$('#dateDebut').data('bs.tooltip').options.title = '';
	$('#dateDebut').tooltip('hide');
	$('#dateChecked').fadeIn();
	$('#confirm').addClass("disabled");
	$('#resultAvailable').removeClass("alert-danger").removeClass("alert-success").html("").hide();
}

$('#showEmprunt').click(function(){
	if(showed) {
		$('#showEmprunt').html("Afficher");
	} else {
		$('#showEmprunt').html("Masquer");
	}
	showed = !showed;
});

$('#btnSignal').click(function(){
	$('#subjectOfMessage').val("Signalement de l'objet <%=itemName%>");
	$('#subjectOfMessage').prop('readonly', true);
	$('#reasonDiv').show();
	$('#contactModalLabel').html("Signaler un objet");
	$('#pMsg').html("Merci de remplir correctement les champs afin que nous prenions en compte le signalement.");
})

$('#contactLink').click(function(){
	$('#subjectOfMessage').val("");
	$('#subjectOfMessage').prop('readonly', false);
	$('#reasonDiv').hide();
	$('#contactModalLabel').html("Nous contacter");
	$('#pMsg').html("Un problème sur le site ? Une remarque ? N'hésitez pas à nous contacter !");
})