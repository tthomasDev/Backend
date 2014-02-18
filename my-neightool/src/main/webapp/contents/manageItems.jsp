<%
String subInclude = "manageItemsList.jsp";
String menuListActive = "active";
String menuAddActive = "";
if(request.getParameter("sub") !=null) {
	String sub = (String)request.getParameter("sub");
	if(sub.equals("add")) {
		subInclude = "manageItemsAdd.jsp";
		menuListActive = "";
		menuAddActive = "active";
	}
}
%>
			<div class="col-md-3 well">
				<ul class="nav nav-pills nav-stacked">
					<li class="<%=menuListActive%>"><a href="dashboard.jsp?page=manageItems"><span class="glyphicon glyphicon-list"></span> Mes objets disponibles <span class="badge pull-right">0</span></a></li>
					<li class="<%=menuAddActive%>"><a href="dashboard.jsp?page=manageItems&sub=add"><span class="glyphicon glyphicon-plus"></span> Ajouter un objet</a></li>
				</ul>
			</div>
			<div class="col-md-9">
				<jsp:include page="<%=subInclude%>" />
			</div>