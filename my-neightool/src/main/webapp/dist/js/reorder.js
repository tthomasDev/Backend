var nbRow = 0;
var store = new Array();

$(function() {
	$("#toReorder").find("tbody").find("tr").each(function() {
		$(this).attr('id', "row" + nbRow);
		store[nbRow] = [$(this)[0].outerHTML];
		nbRow++;
	});
	
	$(".reorderer").each(function() {
		var tmp = $(this).attr('name');
		$(this).html('<a href="javascript:void(0);" onclick="reorderBy(\'asc\',\'' + tmp + '\');"><span class="glyphicon glyphicon-chevron-up"></span></a><a href="javascript:void(0);" onclick="reorderBy(\'desc\',\''+ tmp +'\');"><span class="glyphicon glyphicon-chevron-down"></span></a>');
	});
});

function reorderBy(sens, col) {
	var order = new Array();
	var i = 0;
	var tmp;
	$("#toReorder").find("tbody").find("tr").each(function() {
		$(this).fadeOut("slow");
		tmp = $(this).attr('id');
		$(this).find('.reorderable').each(function() {
			order[i] = [parseInt(tmp.split("row")[1],10), splitCol(col,$(this).html())];
			i++;
		});
	});
	var nbCol = $("toReorder").find("tr:first td");
	$("#toReorder").find("tbody").fadeIn("slow", function() {
		$("#toReorder").find("tbody").html("<tr><td colspan='" + nbCol.length + "' class='perfectCenter'><img src='dist/img/ajax-loader.gif' alt='' /></td></tr>");
	});
	order = sorter(order,sens,col);
	$("#toReorder").find("tbody").html("");
	for(i = 0; i < order.length; i++) {
		$("#toReorder").find("tbody").append(store[order[i][0]]).fadeIn("slow");
	}
	if($("#paginatorNbElements").length>0) {
		changePage(0,$("#paginatorNbElements").val());
	}
}

function sorter(arrayToSort, sens, colName) {
	if(colName=="date") {
		if(sens=="asc")
			return arrayToSort.sort(function(a, b) { alert (new Date( a[1].text() ) < new Date( b[1].text() )) });
		else
			return arrayToSort.sort(function(a, b) { alert (new Date( a[1].text() ) > new Date( b[1].text() )) });
	}
	if(colName=="distance" || colName=="caution") {
		if(sens=="asc")
			return arrayToSort.sort(function(a, b) { return a[1]-b[1] });
		else
			return arrayToSort.sort(function(a, b) { return b[1]-a[1] });
	}	
}

function splitCol(colName, colContent) {
	if(colName=="distance")
		return spliter(colContent," km", 0);
	if(colName=="caution")
		return spliter(colContent," euros", 0);
	else
		return colContent;
}

function spliter(word, needle, element) {
	var ret = word.split(needle);
	return ret[element];
}