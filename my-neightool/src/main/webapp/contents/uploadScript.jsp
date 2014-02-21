<%@page import="java.io.*,java.util.*, java.lang.Math"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>

<%
	if(ServletFileUpload.isMultipartContent(request)){
	    try {
	        List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
	        for(FileItem item : multiparts) {
	            if(item.isFormField()) {
	                String name = new File(item.getName()).getName();
	                File f;
	                double r;
	                do {
	                	r = Math.random();
	                	f = new File("../uploads/img/" + r + name);
	                } while(f.exists());
	                f.createNewFile();
	                item.write(f);
	            }
	        }
	        System.out.println("File Uploaded Successfully");
	    } catch (Exception ex) {
	    	System.out.println("File Upload Failed due to " + ex);
	    }          
	 
	}else{
		System.out.println("Sorry this Servlet only handles file upload request");
	}
%>