package com.ped.myneightool.service;

import javax.annotation.security.PermitAll;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.impl.CategorieDAOImpl;
import com.ped.myneightool.dao.itf.ItfCategorieDAO;
import com.ped.myneightool.model.Categorie;


@PermitAll
@Path("/categorie")
public class ServiceCategorie {

	private static final Logger LOG = LoggerFactory
			.getLogger(ServiceCategorie.class);
	
	private static ItfCategorieDAO categorieDAO = new CategorieDAOImpl();

	public ServiceCategorie() {

	}

	@POST
	@Path("/create")
	@Consumes({"application/xml","application/json"})
	public Response createCategorie(final Categorie c) {
		try{
			categorieDAO.createCategorie(c);
		} catch (Exception e) {
			LOG.error("erreur service /categorie/create");
			e.printStackTrace();
		}
		
		return Response.ok(c).build();
	}
	
	@GET
	@Path("/delete/{id}")
	public void deleteCategorie(@PathParam("id") final int id) {
		final Categorie categorie = categorieDAO.findById(id);
		categorieDAO.deleteCategorie(categorie);
	}

	@GET
	@Path("/{id}")
	@Produces("application/xml")
	public Categorie getCategorie(@PathParam("id") final int id) {
		final Categorie c = categorieDAO.findById(id);
		return c;
	}
	
		
}
