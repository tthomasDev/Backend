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

<%@ page import="com.ped.myneightool.model.Utilisateur"%>
<%@ page import="com.ped.myneightool.model.Outil"%>
<%@ page import="com.ped.myneightool.dto.OutilsDTO"%>

<%@ page import="com.ped.myneightool.model.Categorie"%>
<%@ page import="com.ped.myneightool.dto.CategoriesDTO"%>


<%
	boolean actionValid = false;
	String messageType = "";
	String messageValue = "";
	boolean list=false;

	actionValid = true;

	//on a besoin du contexte si on veut serialiser/désérialiser avec jaxb
	final JAXBContext jaxbc = JAXBContext.newInstance(CategoriesDTO.class);
	final JAXBContext jaxbc2 = JAXBContext.newInstance(OutilsDTO.class, Outil.class);

	// Le DTO des catégories permettant de récupérer la liste des categories
	CategoriesDTO categoriesDto = new CategoriesDTO();
	
	// Le DTO des outils permettant de récupérer la liste complète des outils disponibles
	OutilsDTO listeAllTools = new OutilsDTO();
		
	// Le DTO des outils permettant de récupérer la liste des outils par catégorie
	OutilsDTO listeOutilsCat = new OutilsDTO();
	OutilsDTO listeOutilsCatOthers = new OutilsDTO();

	// On récupère la liste de tous les objets disponibles
	try {
		ClientRequest requestTools;
		requestTools = new ClientRequest(siteUrl + "rest/tool/list/available");
		requestTools.accept("application/xml");
		ClientResponse<String> responseTools = requestTools.get(String.class);
		if (responseTools.getStatus() == 200) {
			Unmarshaller un2 = jaxbc2.createUnmarshaller();
			listeAllTools = (OutilsDTO) un2.unmarshal(new StringReader(
					responseTools.getEntity()));
					
			messageValue = "La liste a bien été récupérée";
			messageType = "success";
		} else {
			messageValue = "Une erreur est survenue";
			messageType = "danger";
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	// On récupère la liste de toutes les catégories
	try {
		ClientRequest requestCategories;
		requestCategories = new ClientRequest(siteUrl + "rest/categorie/list/");
		requestCategories.accept("application/xml");
		ClientResponse<String> responseCategories = requestCategories
				.get(String.class);
		if (responseCategories.getStatus() == 200) {
			Unmarshaller un2 = jaxbc.createUnmarshaller();
			categoriesDto = (CategoriesDTO) un2.unmarshal(new StringReader(
					responseCategories.getEntity()));
			if(categoriesDto.size()>0)
			{
				list=true;
				System.out.println("LISTE TRUE");
			}
			else
			{
				list=false;	
				System.out.println("LISTE FALSE");
				
			}
			
			messageValue = "La liste a bien été récupérée";
			messageType = "success";
		} else {
			messageValue = "Une erreur est survenue";
			messageType = "danger";
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	if (request.getParameter("idCat") != null) {
		// On récupère ensuite la liste des outils correspondants une catégorie spécifique
		try {
			ClientRequest requestTools;
			requestTools = new ClientRequest(siteUrl + "rest/tool/categorie/available/" + request.getParameter("idCat"));
			requestTools.accept("application/xml");
			ClientResponse<String> responseTools = requestTools.get(String.class);
	
				if (responseTools.getStatus() == 200) {
				Unmarshaller un2 = jaxbc2.createUnmarshaller();
				listeOutilsCat = (OutilsDTO) un2.unmarshal(new StringReader(
				responseTools.getEntity()));
				
				// et ici on peut vérifier que c'est bien le bon objet
				messageValue = "Les détails de la catégorie ont bien été récupérés.";
				messageType = "success";
			} else {
				messageValue = "Une erreur est survenue";
				messageType = "danger";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
%>
		<div class="col-md-3 well">
			<ul class="nav nav-pills nav-stacked">
				<li class="
				<% if((request.getParameter("idCat")!=null && request.getParameter("idCat").equals("0")) || request.getParameter("idCat")==null) { %>
					active
				<% } %>
				"><a href="dashboard.jsp?idCat=0">Objets dans ma région <span class="badge pull-right"><%=listeAllTools.size() %></span></a></li>
			</ul>
			<hr />
			<ul class="nav nav-pills nav-stacked">
				<% System.out.println("AFFICHAGE : ");
				if(list) {
					for (Categorie c : categoriesDto.getListeCategories()) { 
						if (request.getParameter("idCat")!=null) {
							if (c.getId() == Integer.parseInt(request.getParameter("idCat"))) { %>
								<li class="active"><a href=""><%=c.getNom()%> <span class="badge pull-right"><%=listeOutilsCat.size() %></span></a></li>
						 <% }
							else { %>
								<% try {
									ClientRequest requestTools;
									requestTools = new ClientRequest(
									siteUrl + "rest/tool/categorie/available/" + c.getId());
									requestTools.accept("application/xml");
									ClientResponse<String> responseTools = requestTools.get(String.class);
							
									if (responseTools.getStatus() == 200) {
										Unmarshaller un2 = jaxbc2.createUnmarshaller();
										listeOutilsCatOthers = (OutilsDTO) un2.unmarshal(new StringReader(
										responseTools.getEntity()));
										%> <li><a href="dashboard.jsp?idCat=<%=c.getId()%>"><%=c.getNom()%> <span class="badge pull-right"><%=listeOutilsCatOthers.size() %></span></a></li> <%
									}
								} catch (Exception e) {
									e.printStackTrace();
								}
							}
						}
						else { %>
							<li><a href="#"><%=c.getNom()%> <span class="badge pull-right">0</span></a></li>
						<% 
						}
					}
				}
				%>
				</ul>
			</div> 
			<div class="col-md-9">
				<ol class="breadcrumb">
					<li><a href="dashboard.jsp?idCat=0">Accueil</a></li>
					<% if (request.getParameter("idCat")!=null) {
						if (Integer.parseInt(request.getParameter("idCat"))!=0) {
							for (Categorie c : categoriesDto.getListeCategories()) {
								if (c.getId() == Integer.parseInt(request.getParameter("idCat"))) {%>
									<li class="active"><a href="#"><%=c.getNom()%></a></li>
								<% }
							}
						}
						else { %>
							<li class="active">Les plus regardés dans votre région (< 50km)</li>
						<% }
					}
					else { %>
						<li class="active">Les plus regardés dans votre région (< 50km)</li>
					<% } %>
				</ol>
				
				<div class="table-responsive" id="objectsList">
					<table class="table table-hover" id="toReorder">
						<thead>
							<tr>
								<th style="text-align:center;" width="140px">Photo</th>
								<th style="text-align:center;" width="80%">Description</th>
								<th style="text-align:center;" width="20%">Caution<span class="reorderer" name="distance"></span></th>
							</tr>
						</thead>
						<tbody>
							<% if(request.getParameter("idCat")!=null && request.getParameter("idCat").equals("0")) {
								for (Outil t : listeOutilsCat.getListeOutils()) { %>
									<tr style="vertical-align: middle;" class="toPaginate">
										<td><img class="img-rounded" src="<%=t.getCheminImage() %>" width="140px" height="140px" /></td>
										<td style="vertical-align: middle;"><strong><a
												href="dashboard.jsp?page=itemDetails&id=<%=t.getId()%>"><%=t.getNom() %></a></strong><br />
											<p><%=t.getDescription() %></p></td>
										<td style="vertical-align: middle; text-align: center;"><%=t.getCaution() + " "%><i class="glyphicon glyphicon-euro"></i></td>
									</tr>
								<% } 
								} else {
									for (Outil t : listeAllTools.getListeOutils()) { %>
									<tr style="vertical-align: middle;" class="toPaginate">
										<td><img class="img-rounded" src="<%=t.getCheminImage() %>" width="140px" height="140px" /></td>
										<td style="vertical-align: middle;"><strong><a
												href="dashboard.jsp?page=itemDetails&id=<%=t.getId()%>"><%=t.getNom() %></a></strong><br />
											<p><%=t.getDescription() %></p></td>
										<td style="vertical-align: middle; text-align: center;"><%=t.getCaution() + " "%><i class="glyphicon glyphicon-euro"></i></td>
									</tr>
								<% }
								} %>
						</tbody>
					</table>
				</div>
			
				<div id="paginator"></div>
				<input id="paginatorNbElements" type="hidden" value="5" readonly="readonly" />
			</div>
