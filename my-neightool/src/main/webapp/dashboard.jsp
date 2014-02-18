<%@include file="template/header.jsp" %>
<%@ page import="java.net.URI"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String fileName = "dashboard";
if(request.getParameter("page") != null) {
	fileName = request.getParameter("page");
}
String filePath = "contents/"+fileName+".jsp";
%>	

		<div class="container" style="margin-top:30px;">
			<jsp:include page="<%=filePath%>" />
		</div>
	
<%@include file="template/footer.jsp" %>	
