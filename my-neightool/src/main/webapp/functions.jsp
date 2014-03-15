<%@page import="org.apache.commons.lang3.*"%>
<%@page import="java.io.*,java.util.*, java.lang.Math, java.security.*"%>
<%!
public String escapeStr(String s) {
	return StringEscapeUtils.escapeHtml4(s);
}

public boolean fileExists(String fileName) {
	fileName = "src/main/webapp/" + fileName;
	File f = new File(fileName);
	f = f.getAbsoluteFile();
	return f.exists();
}

public static String encodePassword(byte[] convertme, String encode) {
	MessageDigest md = null;
    try {
        md = MessageDigest.getInstance(encode);
    }
    catch(NoSuchAlgorithmException e) {
        e.printStackTrace();
    } 
    return byteArrayToHexString(md.digest(convertme));
}

public static String encodedPw(String pw) {
	String tmp = encodePassword(pw.getBytes(), "MD5");
	return encodePassword(tmp.getBytes(), "SHA-1");
}

public static String byteArrayToHexString(byte[] b) {
	String result = "";
	for (int i = 0; i < b.length; i++) {
		result += Integer.toString((b[i] & 0xff) + 0x100, 16).substring(1);
	}
	return result;
}

public static boolean like(final String str, final String expr)
{
	String a="",b="";
	a = str.toLowerCase();
	a = a.replace(" ", "");
	System.out.println(a);
	
	b = expr.toLowerCase();
	b = b.replace(" ", "");
	System.out.println(b);
	
 	return a.equals(b);
}

%>