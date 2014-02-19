<%@include file="template/header.jsp" %>
<%@ page import="java.net.URI"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
//Si l'utilisateur n'est pas connecté on redirige vers l'index
if(session.getAttribute("ID") == null)
{
	RequestDispatcher rd =
	request.getRequestDispatcher("index.jsp");
	rd.forward(request, response);
}



String fileName = "dashboard";
if(request.getParameter("page") != null) {
	fileName = request.getParameter("page");
}
String filePath = "contents/"+fileName+".jsp";
%>	

		<div class="container" style="margin-top:30px;">
			<jsp:include page="<%=filePath%>" />
		</div>
	
<%
out.print(session.getAttribute("ID"));
out.print(session.getAttribute("userName"));

%>
	
<%@include file="template/footer.jsp" %>
