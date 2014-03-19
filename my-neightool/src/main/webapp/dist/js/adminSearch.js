$(function(){

	var field = $("#sSearch");
	var btnCancel = $("#sBtnCancel");
	var initialTab = $("#searchBody").html();
	var nbLetter = 0;
	
	function search() {
		if(nbLetter==0) {
			field.data('bs.tooltip').options.title = 'Veuillez taper votre recherche';
			field.tooltip('show');
			//btnCancel.click();
		} else {
			btnCancel.fadeIn();
			btnCancel.removeClass("disabled");
			var nbResult = 0;
			var foundInRow;
			var cellContent;
			var initTabArray = new Array();
			$("#searchBody").html(initialTab);
			$("#searchBody").find("tr").each(function() {
				foundInRow = false;
				$(this).find("td").each(function() {
					cellContent = $(this).html();
					if(cellContent.indexOf(field.val()) >= 0)
						foundInRow = true;
				});
				if(foundInRow) {
					initTabArray[nbResult] = "<tr class='toPaginate'>" + $(this).html() + "</tr>";
					nbResult++;
				}
			});
			if(nbResult == 0)
				$("#searchBody").html("<tr class='toPaginate'><td class='perfectCenter' colspan='7'>Aucun résultat à votre recherche</td></tr>");
			else {
				$("#searchBody").html("");
				for(var i = 0; i < nbResult; i++) {
					$("#searchBody").append(initTabArray[i]);
				}
			}


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
			
			recalculateNbPage();
		}
	}
	
	field.keyup(function(e) {
		if(e.keyCode==8 ||e.keyCode==46)
			nbLetter--;
		else
			nbLetter++;
		search();
	})
	
	btnCancel.click(function() {
		btnCancel.fadeOut('slow');
		btnCancel.addClass("disabled").tooltip('hide');
		field.val("");
		$("#searchBody").html(initialTab);
		nbLetter = 0;
		search();
	});
	
});