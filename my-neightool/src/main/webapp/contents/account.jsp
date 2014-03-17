<%@include file="../constantes.jsp"%>
<%@include file="../functions.jsp"%>
<%
String subInclude = "accountMain.jsp";
String menuMainActive = "active";
String menuEditProfileActive = "";
String menuEditParamsActive = "";
if(request.getParameter("sub") !=null) {
	String sub = escapeStr((String)request.getParameter("sub"));
	if(sub.equals("editProfile")) {
		subInclude = "accountEditProfile.jsp";
		menuMainActive = "";
		menuEditProfileActive = "active";
		menuEditParamsActive = "";
	}
	if(sub.equals("editParameters")) {
		subInclude = "accountEditParameters.jsp";
		menuMainActive = "";
		menuEditProfileActive = "";
		menuEditParamsActive = "active";
	}
}
%>
			<div class="col-md-3 well">
				<ul class="nav nav-pills nav-stacked">
					<li><a href="#" data-toggle="modal" data-target="#userProfile"><span class="glyphicon glyphicon-eye-open"></span> Voir mon profil public</a></li>
					<hr />
					<li class="<%=menuMainActive%>"><a href="dashboard.jsp?page=account"><span class="glyphicon glyphicon-user"></span> Mon compte</a></li>
					<li class="<%=menuEditProfileActive%>"><a href="dashboard.jsp?page=account&sub=editProfile"><span class="glyphicon glyphicon-pencil"></span> Modifier mes informations</a></li>
					<li class="<%=menuEditParamsActive%>"><a href="dashboard.jsp?page=account&sub=editParameters"><span class="glyphicon glyphicon-cog"></span> Modifier mes paramètres</a></li>
				</ul>
			</div>
			<div class="col-md-9">
				<jsp:include page="<%=subInclude%>" />
			</div>
			<jsp:include page="profile.jsp">
				<jsp:param value="<%=session.getAttribute("ID")%>" name="userId"/>
			</jsp:include>