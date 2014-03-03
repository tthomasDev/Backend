<%@page import="java.io.*,java.util.*, java.lang.Math"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>

<%
	String finalPath = "http://localhost:8080/uploads/img/";
	String finalName = "";
	if(ServletFileUpload.isMultipartContent(request)){
	    try {
	        List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
	        int i = 0;
	        for(FileItem item : multiparts) {
	            if(!item.isFormField()) {
	                File f;
	                int r;
	                do {
	                	r = 0 + (int)(Math.random()*1000); 
	                	f = new File("src/main/webapp/uploads/img/" + r + item.getName());
	                } while(f.exists());
	                f.createNewFile();
	                finalName = f.getName();
	                item.write(f);
	                i++;
		        	System.out.println("1@"+finalPath+finalName);
	            }
	        }
	        if(i==0)
	        	out.print("0@No file uploaded");
	        else
	        	out.print("1@"+finalPath+finalName);
	    } catch (Exception ex) {
	    	ex.printStackTrace();
	    	out.print("0@File Upload Failed due to " + ex);
	    }          
	 
	}else{
		out.print("0@Sorry this Servlet only handles file upload request");
	}
%>