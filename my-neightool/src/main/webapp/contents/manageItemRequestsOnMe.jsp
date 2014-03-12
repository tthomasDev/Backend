<%@include file="../constantes.jsp"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.Timestamp"%>

<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>

<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>

<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>

<%@ page import="model.Categorie"%>
<%@ page import="dto.CategoriesDTO"%>

<%@ page import="model.Outil"%>
<%@ page import="model.Utilisateur"%>

<%@include file="../functions.jsp"%>
<%@ page import="javax.xml.bind.DatatypeConverter"%>


<script src="./dist/js/bootstrap-datepicker.js" charset="UTF-8"></script>
<script src="./dist/js/bootstrap-datepicker.fr.js" charset="UTF-8"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$('.input-daterange').datepicker({
			format : "dd/mm/yyyy",
			language : "fr",
			todayBtn : "linked"
		});
	});
</script>

<link href="./dist/css/datepicker.css" rel="stylesheet">
<ol class="breadcrumb">
	<li><a href="dashboard.jsp">Accueil</a></li>
	<li class="active">Demande d'emprunts sur mes objets</li>
</ol>