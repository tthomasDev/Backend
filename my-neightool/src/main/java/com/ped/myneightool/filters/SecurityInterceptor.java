package com.ped.myneightool.filters;

import java.io.IOException;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;

import javax.annotation.security.DenyAll;
import javax.annotation.security.PermitAll;
import javax.annotation.security.RolesAllowed;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.ext.Provider;

import org.jboss.resteasy.annotations.interception.ServerInterceptor;
import org.jboss.resteasy.core.Headers;
import org.jboss.resteasy.core.ResourceMethod;
import org.jboss.resteasy.core.ServerResponse;
import org.jboss.resteasy.spi.Failure;
import org.jboss.resteasy.spi.HttpRequest;
import org.jboss.resteasy.spi.interception.PreProcessInterceptor;
import org.jboss.resteasy.util.Base64;

import com.ped.myneightool.dao.impl.ConnexionDAOImpl;
import com.ped.myneightool.dao.impl.UtilisateurDAOImpl;
import com.ped.myneightool.dao.itf.ItfConnexionDAO;
import com.ped.myneightool.dao.itf.ItfUtilisateurDAO;
import com.ped.myneightool.model.Connexion;
import com.ped.myneightool.model.Utilisateur;

/**
 * This interceptor verify the access permissions for a user 
 * based on username and passowrd provided in request
 * */
@Provider
@ServerInterceptor
public class SecurityInterceptor implements PreProcessInterceptor
{
	private static final String AUTHORIZATION_PROPERTY = "Authorization";
	private static final String AUTHENTICATION_SCHEME = "Basic";
	private static final ServerResponse ACCESS_DENIED = new ServerResponse("Access denied for this resource", 401, new Headers<Object>());;
	private static final ServerResponse ACCESS_FORBIDDEN = new ServerResponse("Nobody can access this resource", 403, new Headers<Object>());;
	private static final ServerResponse SERVER_ERROR = new ServerResponse("INTERNAL SERVER ERROR", 500, new Headers<Object>());;
	
	private static ItfConnexionDAO connexionDAOImpl = new ConnexionDAOImpl();
	private static ItfUtilisateurDAO utilisateurDAO = new UtilisateurDAOImpl();

	
	@Override
	public ServerResponse preProcess(HttpRequest request, ResourceMethod methodInvoked) throws Failure, WebApplicationException
	{
		Method method = methodInvoked.getMethod();
		
		//Access allowed for all 
		if(method.isAnnotationPresent(PermitAll.class))
		{
			return null;
		}
		//Access denied for all 
		if(method.isAnnotationPresent(DenyAll.class))
		{
			return ACCESS_FORBIDDEN;
		}
		
		//Get request headers
		final HttpHeaders headers = request.getHttpHeaders();
		
		
		//Fetch authorization header
	    final List<String> authorization = headers.getRequestHeader(AUTHORIZATION_PROPERTY);
	    
	    //If no authorization information present; block access
	    if(authorization == null || authorization.isEmpty())
	    {
	    	///A CHANGER POUR QUE CA MARCHE QUAND TOUTES LES REQUETES AURONT DES HEADERS ET TOUS LES WEBSERVICES AURONT LEUR ROLE
	    	return ACCESS_DENIED;
	    	//return null;
	    }
	    
	    //Get encoded username and password
	    final String encodedUserPassword = authorization.get(0).replaceFirst(AUTHENTICATION_SCHEME + " ", "");
	    
	    //Decode username and password
	    String usernameAndPassword;
		try {
			usernameAndPassword = new String(Base64.decode(encodedUserPassword));
		} catch (IOException e) {
			return SERVER_ERROR;
		}

		//Split username and password tokens
	    final StringTokenizer tokenizer = new StringTokenizer(usernameAndPassword, ":");
	    final String username = tokenizer.nextToken();
	    final String password = tokenizer.nextToken();
	    
	    //Verifying Username and password
	    System.out.println(username);
	    System.out.println(password);
	    
		
	    //Verify user access
		if(method.isAnnotationPresent(RolesAllowed.class))
		{
			RolesAllowed rolesAnnotation = method.getAnnotation(RolesAllowed.class);
			Set<String> rolesSet = new HashSet<String>(Arrays.asList(rolesAnnotation.value()));
			
			//Is user valid?
			if( ! isUserAllowed(username, password, rolesSet))
			{
				return ACCESS_DENIED;
			}
		}
		
		//Return null to continue request processing
		return null;
	}

	private boolean isUserAllowed(final String username, final String password,	final Set<String> rolesSet) 
	{
		boolean isAllowed = false;
		String userRole="";
				
		//on vérifie si la connexion est valide et on attribue le role correspondant
		Connexion c = new Connexion(username,password);
		if(connexionDAOImpl.isValidConnection(c) !=null){
			Utilisateur u = utilisateurDAO.findByLogin(username);
			System.out.println(u);
			userRole = u.getRole();
			
		}
			
		if(rolesSet.contains(userRole))
		{
			isAllowed = true;
		}
		return isAllowed;
	}
	
}