<%@ page import="org.apache.commons.lang3.*" %>
<%!

public String escapeStr(String s) {
	return StringEscapeUtils.escapeHtml4(s);
}

%>