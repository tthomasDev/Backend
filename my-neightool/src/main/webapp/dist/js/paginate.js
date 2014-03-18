/* Utilisation du système de pagination :
 * Il faut ajouter sur chaque objet que l'on veut compter la classe "toPaginate"
 * Ensuite il faut mettre là où on veut les numéros de page 1,2,3....etc pour en change
 * dans une div : <div id="paginator"></div> qui créera automatiquement le système.
 * Il est nécessaire de charger l'intégralité des éléments à paginer.
 */

// Default values
var previousPage = 0;
var nbElements = $("#paginatorNbElements").val();

function changePage(index, nbElements) {
	var inc = 0;
	var min = index * nbElements;
	var max = index * nbElements + nbElements;
	$(".toPaginate").each(function() {
		inc++;
		if(inc<=max && inc>min) {
			$(this).show();
		} else {
			$(this).hide();
		}
	});
	$('#page'+previousPage).removeClass("active");
	$('#page'+index).addClass("active");
	previousPage = index;
}

function recalculateNbPage() {
	var nbElements = $("#paginatorNbElements").val();
	$(".toPaginate").hide();
	
	$("#paginator").html(function() {
		var count = 0;
		$(".toPaginate").each(function() {count++});
		var paginator = "";
		if(count>0) {
			count = count / nbElements;
			paginator = "<div class='row'>" +
				"<div class='col-md-12' style='text-align: center;'>" +
					"<ul class='pagination'>" + 
						"<li class='disabled'><a href='javascript:void(0);'>Page : </a></li>";
			for(var i = 0; i < count; i++)
				paginator += "<li id='page" + i + "'><a href='javascript:void(0);' onclick='changePage(" + i + ", "+ nbElements +");'>" + (i+1) + "</a></li>";
			paginator += "</ul>" +
				"</div>" +
			"</div>";
		}
		return paginator;
	});
	
	changePage(0, nbElements);
}

$(function() {
	var nbElements = $("#paginatorNbElements").val();
	$(".toPaginate").hide();
	
	$("#paginator").html(function() {
		var count = 0;
		$(".toPaginate").each(function() {count++});
		var paginator = "";
		if(count>0) {
			count = count / nbElements;
			paginator = "<div class='row'>" +
				"<div class='col-md-12' style='text-align: center;'>" +
					"<ul class='pagination'>" + 
						"<li class='disabled'><a href='javascript:void(0);'>Page : </a></li>";
			for(var i = 0; i < count; i++)
				paginator += "<li id='page" + i + "'><a href='javascript:void(0);' onclick='changePage(" + i + ", "+ nbElements +");'>" + (i+1) + "</a></li>";
			paginator += "</ul>" +
				"</div>" +
			"</div>";
		}
		return paginator;
	});
	
	changePage(0, nbElements);
});