<%@page import="java.util.StringTokenizer"%>
<%@page import="java.io.*"%>

<%
	response.setContentType("text/html");
	response.setHeader("Cache-control", "no-cache");

	String contentType = request.getContentType();

	if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0)) {
		DataInputStream in = new DataInputStream(request.getInputStream());
		//get length of Content type data
		int formDataLength = request.getContentLength();
		byte dataBytes[] = new byte[formDataLength];
		int byteRead = 0;
		int totalBytesRead = 0;
		//convert the uploaded file into byte code
		while (totalBytesRead < formDataLength) {
			byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
			totalBytesRead += byteRead;
		}

		//decode byte array using default charset
		String file = new String(dataBytes);

		//Using StringTokenizer to extract genes list
		StringTokenizer st = new StringTokenizer(file, " ");

		int numtoken = st.countTokens();

		for (int i = 0; i < numtoken - 1; i++) {
			st.nextToken();
		}

		String a = st.nextToken();

		st = new StringTokenizer(a, " \n");
		numtoken = st.countTokens();

		String postlink = "";

		st.nextToken();
		st.nextToken();

		for (int i = 1; i < numtoken - 3; i++) {
			String temp = st.nextToken();
			char[] c = temp.toCharArray();
			temp = new String(c, 0, c.length - 1);
			if (!" ".equalsIgnoreCase(temp)) {
				postlink = postlink + temp + ",";
			}
		}

		String temp = st.nextToken();
		postlink = postlink + temp;

		out.println(postlink);
	} else if (contentType == null) {
		out.println("0@Not a valid file");
	}
%>