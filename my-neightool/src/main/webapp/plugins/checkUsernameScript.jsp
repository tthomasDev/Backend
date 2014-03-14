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

<%@ page import="com.ped.myneightool.model.Utilisateur"%>
<%@ page import="com.ped.myneightool.dto.UtilisateursDTO" %>

<%@ page import="java.util.Iterator" %>

<%@ page import="java.lang.StringBuilder" %>

<%@include file="../constantes.jsp"%>
<%@include file="../functions.jsp"%>
<%
if(request.getParameter("name") != null) {
	String checkName = request.getParameter("name");
	UtilisateursDTO usersDto = new UtilisateursDTO();
	final JAXBContext jaxbc = JAXBContext.newInstance(UtilisateursDTO.class,Utilisateur.class);
	// On récupère la liste de tous les utilisateurs disponibles
	try {
		ClientRequest requestUsers;
		requestUsers = new ClientRequest(siteUrl + "rest/user/listAsc");
		requestUsers.accept("application/xml");
		ClientResponse<String> responseUsers = requestUsers
				.get(String.class);
		if (responseUsers.getStatus() == 200) {
			Unmarshaller un2 = jaxbc.createUnmarshaller();
			usersDto = (UtilisateursDTO) un2.unmarshal(new StringReader(
					responseUsers.getEntity()));
		} else {
	}
	} catch (Exception e) {
		e.printStackTrace();
	}
	Iterator<Utilisateur> ito=usersDto.getListeUtilisateurs().iterator();
	boolean found = false;
	while(ito.hasNext() && !found){
		final Utilisateur u = ito.next();
		if(checkName.equals(u.getConnexion().getLogin())) {
			found = true;
		}
	}
	out.clear();
	if(found)
		out.print("0");
	else
		out.print("1");
}
%>