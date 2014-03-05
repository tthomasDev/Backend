<%@page import="model.SendMailTLS"%>
<%
new SendMailTLS("myneightool@gmail.com", request.getParameter("subjectTo"),request.getParameter("messageTo"));
%>