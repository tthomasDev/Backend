<%@include file="../constantes.jsp"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.sql.Timestamp"%>

<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>

<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>

<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>

<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>

<%@ page import="model.Outil"%>
<%@ page import="model.Emprunt"%>

<%@ page import="dto.OutilsDTO"%>
<%@ page import="dto.EmpruntsDTO"%>

<%
	System.out.println("On vérifie la dispo de l'objet pour l'emprunt");
	
	String messageType = "";
	String messageValue = "";
	Boolean empruntBool = true;	
	
	String id = request.getParameter("id");
	String debut = request.getParameter("dateDebut");
	String fin = request.getParameter("dateFin");
	
	DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
	Date dateDebut = df.parse(debut);
	Date dateFin = df.parse(fin);
	
	System.out.println("Date debut : "+dateDebut.toString());
	System.out.println("Date fin : "+dateFin.toString());
	
	
	//on récupère l'outil a emprunter
	final JAXBContext jaxbc = JAXBContext.newInstance(OutilsDTO.class, Outil.class);
	Outil outil = new Outil();

	try {
			ClientRequest requestMessages;
			requestMessages = new ClientRequest(
					"http://localhost:8080/rest/tool/" + id);
			requestMessages.accept("application/xml");
			ClientResponse<String> responseMessages = requestMessages
					.get(String.class);
				
				if (responseMessages.getStatus() == 200) {
					Unmarshaller un2 = jaxbc.createUnmarshaller();
					outil = (Outil) un2.unmarshal(new StringReader(
							responseMessages.getEntity()));
				} else {
					messageValue = "Une erreur est survenue";
					messageType = "danger";
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
	
	
	//on récupère tous les emprunts
	final JAXBContext jaxbc2 = JAXBContext.newInstance(EmpruntsDTO.class, Emprunt.class);
	EmpruntsDTO empruntdto = new EmpruntsDTO();

	try {
			ClientRequest requestMessages;
			requestMessages = new ClientRequest(
					"http://localhost:8080/rest/emprunt/list");
			requestMessages.accept("application/xml");
			ClientResponse<String> responseMessages = requestMessages
					.get(String.class);
				
				if (responseMessages.getStatus() == 200) {
					Unmarshaller un2 = jaxbc2.createUnmarshaller();
					empruntdto = (EmpruntsDTO) un2.unmarshal(new StringReader(
							responseMessages.getEntity()));
				} else {
					messageValue = "Une erreur est survenue";
					messageType = "danger";
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
	
	
	//on garde dans une liste uniquement tous les emprunts liés à notre objet
	List<Emprunt> empruntsOutil = new ArrayList<Emprunt>();
	
	for (Emprunt e : empruntdto.getListeEmprunts()) {
		if(e.getOutil().getId() == outil.getId())
		{
			empruntsOutil.add(e);
		}
	}
	
	
	//On commence les vérifications
		// 1) Est ce que la demande d'emprunt est dans les disponinbilités données par le prêteur ?
		if( ((dateDebut.after(outil.getDateDebut())) || dateDebut.equals(outil.getDateDebut())) || (dateFin.after(outil.getDateFin())))
		{
			// OUI
			System.out.println("Date Preteur OK");	
			
			
			
			// 2) Est ce que quelqu'un l'a déjà demandé pour cette date et a été validé par le prêteur ?
			for (Emprunt e : empruntsOutil) {
				if(((dateDebut.before(e.getDateDebut())) && ((dateFin.after(e.getDateDebut()))) || dateFin.equals(e.getDateDebut()))||
				   (((dateDebut.after(e.getDateDebut())) || dateDebut.equals(e.getDateDebut())) && ((dateDebut.before(e.getDateFin())) || dateDebut.equals(e.getDateFin()))))
				{
					System.out.println("Deja un emprunt pendant cette periode");	
					empruntBool=false;	
				}	
			}
					

		}
		else
		{
			// NON
			System.out.println("Date Preteur PAS OK");
			empruntBool=false;
		}
	
	
	
	

%>