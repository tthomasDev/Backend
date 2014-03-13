<%@include file="../constantes.jsp"%>
<%@include file="../functions.jsp"%>
<%

String filePath = escapeStr(request.getParameter("link"));
filePath = "src/main/webapp/" + uploadFolder + "img/" + filePath;
File f = new File(filePath);
f = f.getAbsoluteFile();
f.delete();

%>