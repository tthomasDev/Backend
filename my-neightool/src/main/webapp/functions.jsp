<%@page import="org.apache.commons.lang3.*" %>
<%@page import="java.io.*,java.util.*, java.lang.Math"%>
<%!

public String escapeStr(String s) {
	return StringEscapeUtils.escapeHtml4(s);
}

public boolean fileExists(String fileName){
	fileName = "src/main/webapp/" + fileName;
    File f = new File(fileName);
    f = f.getAbsoluteFile();
    return f.exists();
}

%>