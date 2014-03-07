package com.ped.myneightool.service;

import javax.annotation.security.PermitAll;
import javax.annotation.security.RolesAllowed;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.impl.UtilisateurDAOImpl;
import com.ped.myneightool.dao.itf.ItfUtilisateurDAO;
import com.ped.myneightool.dto.UtilisateursDTO;
import com.ped.myneightool.model.Utilisateur;



@Path("/user")
public class ServiceUtilisateur {

	private static final Logger LOG = LoggerFactory
			.getLogger(ServiceUtilisateur.class);
	
	private static ItfUtilisateurDAO utilisateurDAO = new UtilisateurDAOImpl();

	public ServiceUtilisateur() {

	}

	@PermitAll
	@POST
	@Path("/create")
	@Consumes({"application/xml","application/json"})
	public Response createUtilisateur(final Utilisateur u) {
		try{
			utilisateurDAO.createUtilisateur(u);
		} catch (Exception e) {
			LOG.error("erreur service /user/create");
			e.printStackTrace();
		}
		
		return Response.ok(u).build();
	}

	@RolesAllowed({"USER","ADMIN"})
	@POST
	@Path("/update")
	@Consumes("application/xml")
	public Response updateUtilisateur(final Utilisateur u) {
		utilisateurDAO.updateUtilisateur(u);
		return Response.ok(u).build();
	}
	
	@PermitAll
	@GET
	@Path("/delete/{id}")
	public void deleteUtilisateur(@PathParam("id") final int id) {
		
		final Utilisateur utilisateur = utilisateurDAO.findById(id);
		utilisateurDAO.deleteUtilisateur(utilisateur);
	}

	@PermitAll
	@GET
	@Path("/{id}")
	@Produces("application/xml")
	public Utilisateur getUtilisateur(@PathParam("id") final int id) {
		final Utilisateur a = utilisateurDAO.findById(id);
		return a;
	}
	
	@PermitAll
	@GET
	@Path("/login/{login}")
	@Produces("application/xml")
	public Utilisateur getUtilisateurIdByLogin(@PathParam("login") final String login) {
		final Utilisateur a = utilisateurDAO.findByLogin(login);
		return a;
	}

	@PermitAll
	@GET
	@Path("/list")
	@Produces("application/xml")
	public UtilisateursDTO getAllUtilisateurs() {
		UtilisateursDTO utilisateurs = new UtilisateursDTO();
		try {
			utilisateurs = utilisateurDAO.findAll();
		} catch (Exception e) {
			LOG.error("erreur service /list");
			e.printStackTrace();
		}
		return utilisateurs;

	}
		
}
