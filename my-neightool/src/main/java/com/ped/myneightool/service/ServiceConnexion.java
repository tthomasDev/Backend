package com.ped.myneightool.service;

import javax.annotation.security.RolesAllowed;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.impl.ConnexionDAOImpl;
import com.ped.myneightool.dao.itf.ItfConnexionDAO;
import com.ped.myneightool.model.Connexion;



@Path("/connection")
public class ServiceConnexion {

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(ServiceConnexion.class);

	private static ItfConnexionDAO connexionDAOImpl = new ConnexionDAOImpl();

	public ServiceConnexion() {

	}

	@RolesAllowed("USER")
	@POST
	@Path("/try")
	@Consumes("application/xml")
	@Produces("application/xml")
	public Response connexion(final Connexion connexion){
		
		LOG.info("login> " + connexion.getLogin() + " password> "+connexion.getPassword());
		
		final String status = connexionDAOImpl.isValidConnection(connexion);
		return Response.ok(status).build();

	}

	

}
