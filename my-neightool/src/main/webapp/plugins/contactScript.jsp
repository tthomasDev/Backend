<%@page import="model.SendMailTLS"%>
<%@include file="../constantes.jsp"%>
<%@include file="../functions.jsp"%>
<%
new SendMailTLS(contactMail, request.getParameter("subjectTo"),request.getParameter("messageTo"));
%>