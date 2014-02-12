package com.ped.myneightool.service;

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

	@POST
	@Path("/try")
	@Consumes("application/xml")
	@Produces("application/xml")
	public Response connection(final Connexion connection) {
		LOG.info("login " + connection.getLogin() + " mdp "
				+ connection.getPassword());
		final String status = connexionDAOImpl.isValidConnection(connection);
		return Response.ok(status).build();

	}

	

}
