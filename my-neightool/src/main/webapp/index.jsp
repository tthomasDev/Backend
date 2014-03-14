<%@include file="constantes.jsp"%>
<%@include file="functions.jsp"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.*"%>


<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>

<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>
<%@ page import="javax.xml.bind.DatatypeConverter"%>
<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>


<%@ page import="com.ped.myneightool.model.Utilisateur"%>
<%@ page import="com.ped.myneightool.model.Connexion"%>
<%@ page import="com.ped.myneightool.model.Adresse"%>
<%@ page import="com.ped.myneightool.model.SendMailTLS"%>

<%@ page import="com.ped.myneightool.dto.UtilisateursDTO"%>
<%@ page import="java.util.Iterator;"%>

<%
	UtilisateursDTO usersDTO = new UtilisateursDTO();
	try {
		final JAXBContext jaxbc = JAXBContext
		.newInstance(UtilisateursDTO.class);

		ClientRequest clientRequest;
		clientRequest = new ClientRequest(
		siteUrl+"/rest/user/list");
		clientRequest.accept("application/xml");
		ClientResponse<String> response2 = clientRequest
		.get(String.class);
		if (response2.getStatus() == 200) {
	Unmarshaller un = jaxbc.createUnmarshaller();
	usersDTO = (UtilisateursDTO) un.unmarshal(new StringReader(
	response2.getEntity()));
		}

	} catch (Exception e) {
		e.printStackTrace();
	}

	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";
	if (request.getParameter("attemp") != null) {
		if (request.getParameter("attemp").equals("0")) {
			session.removeAttribute("ID");
			session.removeAttribute("userName");
		} else if (request.getParameter("attemp").equals("1")) {
			actionValid = true;
			if (request.getParameter("signIn") != null) {
				System.out.println("CONNECTION EN COURS");
				/*Contexte*/
				JAXBContext jaxbc = JAXBContext
				.newInstance(Connexion.class);
		
				/*On créé une tentative de connexion avec les logins et mdp entrés*/
				final Connexion connexion = new Connexion(escapeStr(request.getParameter("login_username")),encodedPw(escapeStr(request.getParameter("login_password"))));
				/*On sérialise*/
				final Marshaller marshaller = jaxbc.createMarshaller();
				marshaller.setProperty(Marshaller.JAXB_ENCODING,"UTF-8");
				final java.io.StringWriter sw = new StringWriter();
				marshaller.marshal(connexion, sw);
		
				/*On envoie la requete au webservice*/
				final ClientRequest clientRequest = new ClientRequest(siteUrl + "rest/connection/try");
				clientRequest.body("application/xml", sw.toString());
		
				//CREDENTIALS
				String username = connexion.getLogin();
				String password = connexion.getPassword();
				String base64encodedUsernameAndPassword = DatatypeConverter.printBase64Binary((username + ":" + password).getBytes());
				clientRequest.header("Authorization", "Basic " + base64encodedUsernameAndPassword);
				///////////////////
		
				/*on récupère la réponse de la requete*/
				final ClientResponse<String> clientResponse = clientRequest.post(String.class);
				System.out.println("\n\n" + clientResponse.getEntity()+ "\n\n");
		
				if (clientResponse.getStatus() == 200) {
					//Si on récupère un ID
					try {
						Integer.parseInt(clientResponse.getEntity());
				
						messageType = "success";
						messageValue = "Connexion réussie";
				
						session.setAttribute("ID", clientResponse.getEntity());
						session.setAttribute("userName",escapeStr(request.getParameter("login_username")));
				
						//Sinon c'est que les identifiants sont mauvais
					} catch (NumberFormatException e) {
						messageValue = "Echec de la connexion, login ou mot de passe incorrect";
						messageType = "danger";
					}
				} else {
					messageValue = "Problème de connexion, ressayez plus tard";
					messageType = "danger";
				}
			} else if (request.getParameter("signUp") != null) {
		
				//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
				JAXBContext jaxbc = JAXBContext
				.newInstance(Utilisateur.class);
		
				System.out.println("LAT : " + request.getParameter("lat"));
		
				//ici on va créer l'utilisateur avec les données rentrés dans le formulaire
				boolean correctPW = escapeStr(request.getParameter("password")).matches("[a-zA-Z0-9#$%+=]*");
				//Formatage de la date
				String m = escapeStr(request.getParameter("month"));
				String day = escapeStr(request.getParameter("day"));
				String y = escapeStr(request.getParameter("year"));
		
				String target = day + "-" + m + "-" + y;
				DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
				Date d = df.parse(target);
		
				boolean dateCorrecte = false;
				DateFormat sdf = new SimpleDateFormat("d-M-yyyy");
				try {
					String dateFormatee = sdf.format(d);
					System.out.println("Date formatée : " + dateFormatee);
					if (dateFormatee.compareTo(target) != 0)
						dateCorrecte = false;
					else
						dateCorrecte = true;
				} catch (Exception e) {
					System.out.println("Exception");
				}
		
				//Verification numéro de tel
				String numTel = escapeStr(request.getParameter("telephone"));
				boolean correctTel = numTel.matches("[0-9]{10}");
				boolean correctLN = escapeStr(request.getParameter("lastname")).matches("[a-zA-Zéèï-]*");
				boolean correctFN = escapeStr(request.getParameter("firstname")).matches("[a-zA-Zéèï-]*");
		
				if (correctTel && dateCorrecte && correctLN	&& correctFN && correctPW) {
					final Adresse adresse = new Adresse(escapeStr(request.getParameter("location")),Float.valueOf(escapeStr(request.getParameter("lat"))),Float.valueOf(escapeStr(request.getParameter("long"))));
					final Connexion connexion = new Connexion(escapeStr(request.getParameter("username")),encodedPw(escapeStr(request.getParameter("password"))));
					final Utilisateur user = new Utilisateur(escapeStr(request.getParameter("lastname")), escapeStr(request.getParameter("firstname")),	connexion, escapeStr(request.getParameter("email")),numTel, adresse, d);

					//ici il faut sérialiser l'utilisateur
					final Marshaller marshaller = jaxbc.createMarshaller();
					marshaller.setProperty(Marshaller.JAXB_ENCODING,"UTF-8");
					final java.io.StringWriter sw = new StringWriter();
					marshaller.marshal(user, sw);
				
					//ici on envois la requete au webservice createUtilisateur
					final ClientRequest clientRequest = new ClientRequest(siteUrl + "rest/user/create");
					clientRequest.body("application/xml", user);
				
					//ici on va récuperer la réponse de la requete
					final ClientResponse<String> clientResponse = clientRequest.post(String.class);
					//test affichage
					System.out.println("\n\n" + clientResponse.getEntity() + "\n\n");
					if (clientResponse.getStatus() == 200) {
						// si la réponse est valide !
						// on désérialiser la réponse si on veut vérifier que l'objet retourner
						// est bien celui qu'on a voulu créer , pas obligatoire
						final Unmarshaller un = jaxbc
						.createUnmarshaller();
						final Object object = (Object) un
						.unmarshal(new StringReader(
						clientResponse.getEntity()));
						// et ici on peut vérifier que c'est bien le bonne objet
				
						/*A mettre lors de la mise en prod*/
						/*
						 new SendMailTLS(request.getParameter("email"),"Bonjour ! "
						 + "\n \n Bienvenue sur le site MyNeighTool. Pour rappel voici vos idnetifiants :"
						 + "\n \n - Login : "+ connexion.getLogin()
						 + "\n - Mot de passe "+ connexion.getPassword()
						 + "\n \n Cordialement, l'équipe de MyNeighTool");
						 System.out.println("Mail de confirmation envoyé");
						 */
						messageValue = "Vous avez bien été enregistré";
						messageType = "success";
				
					} else {
						messageValue = "Une erreur est survenue";
						messageType = "danger";
					}
				} else if (!correctTel) {
					messageValue = "Numero de téléphone incorrect. Format : 10 chiffres";
					messageType = "danger";
				} else if (!dateCorrecte) {
					messageValue = "La date de naissance est incorrecte";
					messageType = "danger";
				} else if (!correctFN) {
					messageValue = "Prénom incorrect";
					messageType = "danger";
				} else if (!correctLN) {
					messageValue = "Nom incorrect";
					messageType = "danger";
				} else if (!correctPW) {
					messageValue = "Mot de passe incorrect. Caractères autorisés : chiffres, lettres (majuscules et minuscules), caractères spéciaux (uniquement : #, +, =, $, %)";
					messageType = "danger";
				}
			} else {
				messageType = "danger";
				messageValue = "Il semble y avoir une erreur lors de votre connexion/inscription.";
			}
		}
	}

	//Si l'utilisateur est déjà connecté on redirige vers dashboard
	if (session.getAttribute("ID") != null) {
		RequestDispatcher rd = request
		.getRequestDispatcher("dashboard.jsp");
		rd.forward(request, response);
	}
%>
<!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta name="description" content="">
		<meta name="author" content="">
		<link rel="icon" type="image/png" href="./dist/img/favicon.png" />
		
		<title><% out.print(siteName); %></title>
		
		<link href="<%=cssFolder%>bootstrap.min.css" rel="stylesheet">
		<link href="<%=cssFolder%>jumbotron.css" rel="stylesheet">
		<link href="<%=cssFolder%>jquery-ui.css" rel="stylesheet">
		
		<script src="<%=jsFolder%>jquery.js"></script>
		<script src="<%=jsFolder%>jquery-ui.js"></script>
		<script src="<%=jsFolder%>bootstrap.min.js"></script>
		<script src="<%=jsFolder%>paginate.js"></script>
		<script src="<%=jsFolder%>reorder.js"></script>
		<script src="<%=jsFolder%>jquery.cookie.js"></script>
		<script src="<%=jsFolder%>init.js"></script>
		<script src="<%=jsFolder%>maps.js"></script>
		<script src="<%=jsFolder%>sign.js"></script>
		
		<!-- Just for debugging purposes. Don't actually copy this line! -->
		<!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
		
		<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
		<!--[if lt IE 9]>
		<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
		<script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
		<![endif]-->
		<script type="text/javascript"
			src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAsO96nmOiM5A5mef1oNv4PZoETDWvfJ88&sensor=false"></script>
		<style type="text/css">
		#map-canvas {
			height: 600px !important;
		}
		</style>
	</head>

	<body onload="initialize()">
		<div class="col-md-4">
			<select style="visibility: hidden;" class="form-control" id="users"
				name="users">
				<%
					Iterator<Utilisateur> it = usersDTO.getListeUtilisateurs()
							.iterator();
					int num = 0;
					while (it.hasNext()) {
	
						final Utilisateur utilisateur = it.next();
	
						try {
							if (utilisateur.getAdresse().getLatitude() > 0
									&& utilisateur.getAdresse().getLatitude() < 90
									&& utilisateur.getAdresse().getLongitude() > 0
									&& utilisateur.getAdresse().getLongitude() < 90) {
								out.println("<option value='" + num + "'>"
										+ utilisateur.getNom() + "/"
										+ utilisateur.getAdresse().getLatitude() + "/"
										+ utilisateur.getAdresse().getLongitude()
										+ "</option>");
							} else
								System.out.println("Longitude et Latitude invalides");
						} catch (Exception e) {
							System.out.println("Longitude et Latitude nulles");
						}
						num++;
					}
				%>
			</select>
		</div>
	
		<div class="navbar navbar-inverse navbar-fixed-top">
			<div class="container">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse"
						data-target=".navbar-collapse">
						<span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span>
					</button>
					<a class="navbar-brand" href="index.jsp"><img height="20px" src="<%=imgFolder%>favicon.png">&nbsp;&nbsp;&nbsp;<%=siteName%>
					</a>
				</div>
				<div class="navbar-collapse collapse">
					<form action="index.jsp?attemp=1" method="POST"
						class="navbar-form navbar-right">
						<div class="form-group">
							<input type="text" placeholder="Nom d'utilisateur"
								id="login_username" name="login_username" class="form-control"
								required>
						</div>
						<div class="form-group">
							<input type="password" placeholder="Mot de passe"
								id="login_password" name="login_password" class="form-control"
								required>
						</div>
						<input type="hidden" name="signIn" id="signIn">
						<button type="submit" class="btn btn-success">Connexion</button>
					</form>
				</div>
				<!--/.navbar-collapse -->
			</div>
		</div>
	
		<div class="jumbotron">
			<div class="container">
				<%
					if (actionValid) {
						out.println("<div class='row'><div class='col-md-12' style='margin-top:-20px'>");
						out.println("<div class='alert alert-" + messageType + "'>"
								+ messageValue + "</div>");
						out.println("</div></div>");
					}
				%>
				<div class="row">
					<div class="col-md-6 img-rounded" id="map-canvas"
						style="background-color: #DDD; margin-left: 20px;"></div>
					<div class="col-md-1"></div>
					<div class="col-md-5 img-rounded"
						style="background-color: #DDD !important; margin-left: 60px !important">
						<h3>Créez un compte gratuitement</h3>
						<h4>Echangez dès maintenant près de chez vous !</h4>
						<hr />
						<form id="formSignUp" action="index.jsp?attemp=1" method="POST">
							<div class="row">
								<div class="col-md-6 form-group">
									<input type="text" placeholder="Nom" id="firstname" name="firstname" class="form-control ttipt" required/>
								</div>
								<div class="col-md-6 form-group">
									<input type="text" placeholder="Prénom" id="lastname" name="lastname" class="form-control ttipt" required/>
								</div>
								<div class="col-md-12 form-group">
									<input type="text" placeholder="Nom d'utilisateur" id="username" name="username" class="form-control ttipr" required/>
								</div>
								<div class="col-md-12 form-group">
									<input type="email"	placeholder="Adresse email" id="email" name="email" class="form-control ttipr" required/>
								</div>
								<div class="col-md-12 form-group">
									<input type="password" placeholder="Mot de passe" id="password"	name="password" class="form-control ttipr" required/>
								</div>
								<div class="col-md-6 form-group">
									<input type="text" placeholder="Numéro de téléphone" id="telephone" name="telephone" maxlength="10" class="form-control ttipr" required/>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									Date de naissance :
								</div>
								<div class="col-md-4 form-group">
									<select class="form-control" id="day" name="day" required>
										<%
											for (int i = 1; i <= 31; i++) {
												out.println("<option value='" + i + "'>" + i + "</option>");
											}
										%>
									</select>
								</div>
								<div class="col-md-4 form-group">
									<select class="form-control" id="month" name="month" required>
										<%
											String[] arrMois = { "Janvier", "Fevrier", "Mars", "Avril", "Mai",
													"Juin", "Juillet", "Aout", "Septembre", "Octobre",
													"Novembre", "Decembre" };
											int mois = 0;
											for (String m : arrMois) {
												mois++;
												out.println("<option value='" + mois + "'>" + m + "</option>");
											}
										%>
									</select>
								</div>
								<div class="col-md-4 form-group">
									<select class="form-control ttipr" id="year" name="year" required>
										<%
											int yyyy = Calendar.getInstance().get(Calendar.YEAR);
											for (int i = yyyy; i >= 1900; i--) {
												out.println("<option value='" + i + "'>" + i + "</option>");
											}
										%>
									</select>
								</div>
								<div class="col-lg-12">
									<div class="input-group">
										<input type="text" placeholder="Votre ville" id="location" name="location" class="form-control ttipb" required/>
										<span class="input-group-btn">
											<button class="btn btn-default ttipb" type="button"	data-toggle="tooltip" title="Vérifier la carte"	onclick="codeAddress()">
												<span class="glyphicon glyphicon-search"></span>
											</button>
											<button class="btn btn-default ttipb" type="button"	data-toggle="tooltip" title="Me trouver sur la carte" onclick="codeLatLng(null)">
												<span class="glyphicon glyphicon-screenshot"></span>
											</button>
											<button class="btn btn-default ttipb" type="button"	data-toggle="tooltip" title="Récupérer la position sur la carte" onclick="getMyMarker()">
												<span class="glyphicon glyphicon-pushpin"></span>
											</button>
										</span>
									</div>
									<hr />
									<label class="checkbox">
										<input type="checkbox" id="tou" name="checkbox" class="ttipb" required> J'ai lu et j'accepte les <a href="#" data-toggle="modal" data-target="#terms">Conditions générales d'utilisation</a>
									</label>
									<br />
									<input type="hidden" name="signUp" id="signUp"> <input type="hidden" value="" name="lat" id="lat">
									<input type="hidden" value="" name="long" id="long">
									<a id="signUpBtn" class="pull-right btn btn-info btn-lg">Inscription</a>
									<br /> <br /> <br />
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<div class="container">
			<hr />
			<footer>
				<p>
					Copyrights &copy; MyNeighTool 2014 | <span><a href="#"
						id="contactLink" data-toggle="modal" data-target="#contact">Nous
							contacter</a> &bull; <a href="#" data-toggle="modal"
						data-target="#terms">Conditions générales d'utilisation</a> &bull;
						<a href="#" data-toggle="modal" data-target="#faq">FAQ</a></span>
				</p>
			</footer>
		</div>
		<jsp:include page="<%=contentFolder + "terms.jsp"%>" />
		<jsp:include page="<%=contentFolder + "contact.jsp"%>" />
		<jsp:include page="<%=contentFolder + "faq.jsp"%>" />
	</body>
</html>