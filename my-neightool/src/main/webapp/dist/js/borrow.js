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
