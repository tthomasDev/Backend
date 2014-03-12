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

import com.ped.myneightool.dao.impl.EmpruntDAOImpl;
import com.ped.myneightool.dao.itf.ItfEmpruntDAO;
import com.ped.myneightool.dto.EmpruntsDTO;
import com.ped.myneightool.model.Emprunt;



@Path("/emprunt")
public class ServiceEmprunt {

	private static final Logger LOG = LoggerFactory
			.getLogger(ServiceEmprunt.class);
	
	private static ItfEmpruntDAO empruntDAO = new EmpruntDAOImpl();

	public ServiceEmprunt() {

	}

	@RolesAllowed({"USER","ADMIN"})
	@POST
	@Path("/create")
	@Consumes({"application/xml","application/json"})
	public Response createEmprunt(final Emprunt u) {
		try{
			empruntDAO.createEmprunt(u);
		} catch (Exception e) {
			LOG.error("erreur service /emprunt/create");
			e.printStackTrace();
		}
		
		return Response.ok(u).build();
	}

	@RolesAllowed({"USER","ADMIN"})
	@POST
	@Path("/update")
	@Consumes("application/xml")
	public Response updateEmprunt(final Emprunt u) {
		empruntDAO.updateEmprunt(u);
		return Response.ok(u).build();
	}
	
	
	@RolesAllowed({"USER","ADMIN"})
	@GET
	@Path("/delete/{id}")
	public void deleteEmprunt(@PathParam("id") final int id) {
		final Emprunt emprunt = empruntDAO.findById(id);
		empruntDAO.deleteEmprunt(emprunt);
	}

	@PermitAll
	@GET
	@Path("/{id}")
	@Produces("application/xml")
	public Emprunt getEmprunt(@PathParam("id") final int id) {
		final Emprunt a = empruntDAO.findById(id);
		return a;
	}
	
	@PermitAll
	@GET
	@Path("/list")
	@Produces("application/xml")
	public EmpruntsDTO getAllUtilisateurs() {
		EmpruntsDTO emprunts = new EmpruntsDTO();
		try {
			emprunts = empruntDAO.findAll();
		} catch (Exception e) {
			LOG.error("erreur service /list");
			e.printStackTrace();
		}
		return emprunts;

	}
	
	@PermitAll
	@GET
	@Path("/user/{id}")
	@Produces({ "application/xml", "application/json" })
	public EmpruntsDTO findToolsOfUser(@PathParam("id") final int emprunteurId) {
		EmpruntsDTO emprunts = empruntDAO.findEmpruntsOfUser(emprunteurId);
		return emprunts;
	}
	
		
}
