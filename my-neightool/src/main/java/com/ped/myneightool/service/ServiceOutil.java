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

import com.ped.myneightool.dao.impl.OutilDAOImpl;
import com.ped.myneightool.dao.itf.ItfOutilDAO;
import com.ped.myneightool.dto.OutilsDTO;
import com.ped.myneightool.model.Outil;



@Path("/tool")
public class ServiceOutil {

	private static final Logger LOG = LoggerFactory
			.getLogger(ServiceOutil.class);
	
	private static ItfOutilDAO outilDAO = new OutilDAOImpl();

	public ServiceOutil() {

	}

	@POST
	@Path("/create")
	@Consumes({"application/xml","application/json"})
	public Response createOutil(final Outil o) {
		try{
			outilDAO.createOutil(o);
		} catch (Exception e) {
			LOG.error("erreur service /user/create");
			e.printStackTrace();
		}
		
		return Response.ok(o).build();
	}

	@POST
	@Path("/update")
	@Consumes("application/xml")
	public Response updateOeuvre(final Outil o) {
		outilDAO.updateOutil(o);
		return Response.ok(o).build();
	}
	
	@GET
	@Path("/delete/{id}")
	public void deleteOutil(@PathParam("id") final int id) {
		final Outil o = outilDAO.findById(id);
		outilDAO.deleteOutil(o);
	}

	@GET
	@Path("/{id}")
	@Produces("application/xml")
	public Outil getOutil(@PathParam("id") final int id) {
		final Outil o = outilDAO.findById(id);
		return o;
	}

	@GET
	@Path("/list")
	@Produces("application/xml")
	public OutilsDTO getAllTools() {
		OutilsDTO outils = new OutilsDTO();
		try {
			outils = outilDAO.findAll();
		} catch (Exception e) {
			LOG.error("erreur service /list");
			e.printStackTrace();
		}
		return outils;

	}
	
	@GET
	@Path("/list/available")
	@Produces("application/xml")
	public OutilsDTO getAllToolsAvailable() {
		OutilsDTO outils = new OutilsDTO();
		try {
			outils = outilDAO.findAllAvailable();
		} catch (Exception e) {
			LOG.error("erreur service /list/available");
			e.printStackTrace();
		}
		return outils;

	}
	
	@GET
	@Path("/user/{id}")
	@Produces({ "application/xml", "application/json" })
	public OutilsDTO findToolsOfUser(@PathParam("id") final int UtilisateurId) {
		OutilsDTO outils = outilDAO.findToolsOfUser(UtilisateurId);
		return outils;
	}
	
	@GET
	@Path("/user/available/{id}")
	@Produces({ "application/xml", "application/json" })
	public OutilsDTO findToolsOfUserAvailable(@PathParam("id") final int UtilisateurId) {
		OutilsDTO outils = outilDAO.findToolsOfUserAvailable(UtilisateurId);
		return outils;
	}
		
}
