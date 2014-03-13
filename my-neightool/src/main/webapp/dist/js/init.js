$(document).ready(function() {
	$(".ttipl").tooltip({placement: "left",container: 'body'});
	$(".ttipr").tooltip({placement: "right",container: 'body'});
	$(".ttipt").tooltip({placement: "top",container: 'body'});
	$(".ttipb").tooltip({placement: "bottom",container: 'body'});
	$(".popov").popover({html: true, placement: "bottom", trigger: "focus"});
	$(".createHide").click(function() {
		$.cookie('hideNewMessageModal','true');
	});
});