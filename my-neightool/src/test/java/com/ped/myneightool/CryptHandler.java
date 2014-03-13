package com.ped.myneightool;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class CryptHandler {
	
	
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

}
