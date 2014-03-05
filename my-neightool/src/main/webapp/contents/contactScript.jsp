<%@page import="model.SendMailTLS"%>
<%
System.out.println("mail CONTACT");
new SendMailTLS("myneightool@gmail.com", request.getParameter("subjectTo"),request.getParameter("messageTo"));
%>