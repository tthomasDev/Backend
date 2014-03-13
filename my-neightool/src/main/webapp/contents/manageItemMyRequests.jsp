<%@include file="../constantes.jsp"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="java.text.DateFormat"%>

<%@ page import="javax.xml.bind.JAXBContext"%>
<%@ page import="javax.xml.bind.Marshaller"%>
<%@ page import="javax.xml.bind.Unmarshaller"%>

<%@ page import="java.io.StringReader"%>
<%@ page import="java.io.StringWriter"%>

<%@ page import="org.jboss.resteasy.client.ClientRequest"%>
<%@ page import="org.jboss.resteasy.client.ClientResponse"%>

<%@ page import="model.Emprunt"%>
<%@ page import="dto.EmpruntsDTO"%>

<%@include file="../functions.jsp"%>
<%@ page import="javax.xml.bind.DatatypeConverter"%>

<%
	//On récupère les données de session de l'utilisateur
	final String idUser = String.valueOf(session.getAttribute("ID"));

	//On récupère tous les emprunts
	final JAXBContext jaxbc = JAXBContext.newInstance(EmpruntsDTO.class);

	EmpruntsDTO empruntsDto = new EmpruntsDTO();
	
	try {
		ClientRequest clientRequest;
		clientRequest = new ClientRequest(siteUrl+"rest/emprunt/list");
		clientRequest.accept("application/xml");
		ClientResponse<String> response2 = clientRequest.get(String.class);
		
		if (response2.getStatus() == 200) {
			Unmarshaller un = jaxbc.createUnmarshaller();
			empruntsDto = (EmpruntsDTO) un.unmarshal(new StringReader(response2.getEntity()));
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	//Format affichage date
	DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
%>

<ol class="breadcrumb">
	<li><a href="dashboard.jsp">Accueil</a></li>
	<li class="active">Mes demandes d'emprunt à mes voisins</a></li>
</ol>

<div class="table-responsive">
			<table class="table table-hover" id="toReorder">
				<thead>
					<tr>
						<th style="text-align: center;" width="20%">Objet</th>
						<th style="text-align: center;" width="20%">Propriétaire</th>
						<th style="text-align: center;" width="20%">Date début proposée</th>
						<th style="text-align: center;" width="20%">Date fin proposée</th>
						<th style="text-align: center;" width="20%">Accepté ?</th>
					</tr>
				</thead>
				<tbody>
					<%
						for (Emprunt e : empruntsDto.getListeEmprunts()) {
							if(Integer.parseInt(idUser) == e.getEmprunteur().getId())
							{
					%>
					<tr style="vertical-align: middle;">
						<td style="vertical-align: middle; text-align: center;"><%=e.getOutil().getNom()%></td>
						<td style="vertical-align: middle; text-align: center;"><%=e.getOutil().getUtilisateur().getConnexion().getLogin()%></td>
						<td style="vertical-align: middle; text-align: center;"><%=df.format(e.getDateDebut())%></td>
						<td style="vertical-align: middle; text-align: center;"><%=df.format(e.getDateFin())%></td>
						<td style="vertical-align: middle; text-align: center;"><%					
						if(e.getValide() == 0)
							out.print("Refusé");
						else if (e.getValide() == 1)
							out.print("En attente de validation");
						else if (e.getValide() == 2)
							out.print("Validé");
						%></td>
					</tr>
					<%
							}
						}
					%>
				</tbody>
			</table>
</div>
