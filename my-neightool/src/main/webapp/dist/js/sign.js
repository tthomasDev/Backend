$(document).ready(function() {
	$(".ttipl").tooltip({placement : "left",container : 'body'});
	$(".ttipr").tooltip({placement : "right",container : 'body'});
	$(".ttipt").tooltip({placement : "top",container : 'body'});
	$(".ttipb").tooltip({placement : "bottom",container : 'body'});

	$("#signUpBtn").click(function(){
		var name, lastname, username, mail, password, phone, day, month, year, city, tou;
		var now = new Date();
		var submitable = true;
		name = $("#firstname");
		lastname = $("#lastname");
		username = $("#username");
		mail = $("#email");
		password = $("#password");
		phone = $("#telephone");
		day = $("#day");
		month = $("#month");
		year = $("#year");
		city = $("#location");
		tou = $("#tou");
		if(name.val()=="") {
			name.parent().addClass("has-error");
			name.data('bs.tooltip').options.title = 'Veuillez renseigner votre nom';
			name.tooltip('show');
			submitable = false;
		}
		if(lastname.val()=="") {
			lastname.parent().addClass("has-error");
			lastname.data('bs.tooltip').options.title = 'Veuillez renseigner votre prénom';
			lastname.tooltip('show');
			submitable = false;
		}
		if(username.val()=="") {
			username.parent().addClass("has-error");
			username.data('bs.tooltip').options.title = 'Choisissez un nom d\'utilisateur valide (lettres et chiffres uniquement)';
			username.tooltip('show');
			submitable = false;
		}
		if(mail.val()=="") {
			mail.parent().addClass("has-error");
			mail.data('bs.tooltip').options.title = 'Veuillez rentrer une adresse email valide';
			mail.tooltip('show');
			submitable = false;
		}
		if(password.val()=="") {
			password.parent().addClass("has-error");
			password.data('bs.tooltip').options.title = 'Le mot de passe doit faire 6 chiffres/lettres/caractères spéciaux';
			password.tooltip('show');
			submitable = false;
		}
		if(phone.val()=="") {
			phone.parent().addClass("has-error");
			phone.data('bs.tooltip').options.title = 'Votre numéro de téléphone doit être composé de 10 chiffres';
			phone.tooltip('show');
			submitable = false;
		}
		if(city.val()=="") {
			city.parent().addClass("has-error");
			city.data('bs.tooltip').options.title = 'Veuillez rentrer le nom de votre ville';
			city.tooltip('show');
			submitable = false;
		}
		var age = now.getFullYear()-year.val();
		if(age < 18) {
			year.parent().addClass("has-error");
			year.data('bs.tooltip').options.title = 'Vous devez avoir au moins 18 ans pour vous inscrire';
			year.tooltip('show');
			submitable = false;
		}
		if(!tou.is(':checked')) {
			tou.parent().addClass("has-error");
			tou.data('bs.tooltip').options.title = 'Vous devez accepter les conditions générales d\'utilisation';
			tou.tooltip('show');
			submitable = false;
		}
		if(submitable)
			$("#formSignUp").submit();
	});
});