<%@page import="java.io.*,java.util.*, java.lang.Math"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>

<%@include file="../constantes.jsp"%>
<%@include file="../functions.jsp"%>
<%
	String finalPath = siteUrl + "uploads/img/";
	String finalName = "";
	int maxSize = Integer.parseInt(request.getParameter("size"));
	if(ServletFileUpload.isMultipartContent(request)){
	    try {
	        List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
	        int i = 0;
	        int err = 0;
	        for(FileItem item : multiparts) {
	            if(!item.isFormField()) {
	            	if(item.getSize() <= maxSize) {
	                	File f;
	                	int r;
		                do {
		                	r = 0 + (int)(Math.random()*1000); 
		                	f = new File("src/main/webapp/uploads/img/" + r + item.getName());
		                } while(f.exists());
		                f.createNewFile();
		                finalName = f.getName();
		                item.write(f);
	            	} else {
	            		err++;
	            	}
	            	i++;
	            }
	        }
	        if(i==0)
	        	out.print("0@No file uploaded");
	        else if(err>0) {
	        	double sizeInMo = Math.round(maxSize / 1024000);
	        	out.print("0@Fichier trop volumineux ("+ sizeInMo +" Mo maximum)");
	        } else
	        	out.print("1@"+finalPath+finalName);
	    } catch (Exception ex) {
	    	ex.printStackTrace();
	    	out.print("0@File Upload Failed due to " + ex);
	    }          
	 
	}else{
		out.print("0@Sorry this Servlet only handles file upload request");
	}
%>