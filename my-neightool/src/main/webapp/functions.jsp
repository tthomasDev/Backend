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
	a = a.replaceAll("[\\d]", "");
	a = a.replaceAll("[ιθ]", "e");
	
	b = expr.toLowerCase();
	b = b.replace(" ", "");
	b = b.replaceAll("[\\d]", "");
	b = b.replaceAll("[ιθ]", "e");
	
 	return a.equals(b) || a.contains(b);
}

public static double distFrom(double lat1, double lng1, double lat2, double lng2) {
    int earthRadius = 6371;
    double dLat = Math.toRadians(lat2-lat1);
    double dLng = Math.toRadians(lng2-lng1);
    double sindLat = Math.sin(dLat / 2);
    double sindLng = Math.sin(dLng / 2);
    double a = Math.pow(sindLat, 2) + Math.pow(sindLng, 2)
            * Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2));
    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    double dist = earthRadius * c;
    
    return dist;
    }

%>