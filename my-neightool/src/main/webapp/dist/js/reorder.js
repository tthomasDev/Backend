var nbRow = 0;
var store = new Array();

$(function() {
	$("#toReorder").find("tbody").find("tr").each(function() {
		$(this).attr('id', "row" + nbRow);
		store[nbRow] = [$(this)[0].outerHTML];
		nbRow++;
	});
});

function reorderBy(sens, col) {
	var order = new Array();
	var i = 0;
	var tmp;
	$("#toReorder").find("tbody").find("tr").each(function() {
		tmp = $(this).attr('id');
		$(this).find('.reorderable').each(function() {
			order[i] = [parseInt(tmp.split("row")[1],10), splitCol(col,$(this).html())];
			i++;
		});
	});
	if(sens=="asc")
		order = order.sort(function(a, b) { return a[1]-b[1] });
	if(sens=="desc")
		order = order.sort(function(a, b) { return b[1]-a[1] });
	$("#toReorder").find("tbody").html("");
	for(i = 0; i < order.length; i++) {
		$("#toReorder").find("tbody").append(store[order[i][0]]);
	}
}

function splitCol(colName, colContent) {
	if(colName=="distance")
		return spliter(colContent," km", 0);
}

function spliter(word, needle, element) {
	var ret = word.split(needle);
	return ret[element];
}