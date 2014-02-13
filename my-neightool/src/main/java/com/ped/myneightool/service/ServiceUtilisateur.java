package com.ped.myneightool.service;

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

	@POST
	@Path("/update")
	@Consumes("application/xml")
	public Response updateOeuvre(final Utilisateur u) {
		utilisateurDAO.updateUtilisateur(u);
		return Response.ok(u).build();
	}
	
	@GET
	@Path("/delete/{id}")
	public void deleteUtilisateur(@PathParam("id") final int id) {
		final Utilisateur utilisateur = utilisateurDAO.findById(id);
		utilisateurDAO.deleteUtilisateur(utilisateur);
	}

	@GET
	@Path("/{id}")
	@Produces("application/xml")
	public Utilisateur getUtilisateur(@PathParam("id") final int id) {
		final Utilisateur a = utilisateurDAO.findById(id);
		return a;
	}

	
	@GET
	@Path("/list")
	@Produces("application/xml")
	public UtilisateursDTO getAllUtilisateurs() {
		UtilisateursDTO Utilisateurs = new UtilisateursDTO();
		try {
			Utilisateurs = utilisateurDAO.findAll();
		} catch (Exception e) {
			LOG.error("erreur service /list");
			e.printStackTrace();
		}
		return Utilisateurs;

	}
		
}
