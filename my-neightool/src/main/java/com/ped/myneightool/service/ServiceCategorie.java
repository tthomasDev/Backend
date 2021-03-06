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

import com.ped.myneightool.dao.impl.CategorieDAOImpl;
import com.ped.myneightool.dao.itf.ItfCategorieDAO;
import com.ped.myneightool.dto.CategoriesDTO;
import com.ped.myneightool.model.Categorie;



@Path("/categorie")
public class ServiceCategorie {

	private static final Logger LOG = LoggerFactory
			.getLogger(ServiceCategorie.class);
	
	private static ItfCategorieDAO categorieDAO = new CategorieDAOImpl();

	public ServiceCategorie() {

	}

	@RolesAllowed("ADMIN")
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
	
	@RolesAllowed("ADMIN")
	@GET
	@Path("/delete/{id}")
	public void deleteCategorie(@PathParam("id") final int id) {
		final Categorie categorie = categorieDAO.findById(id);
		categorieDAO.deleteCategorie(categorie);
	}
	
	@RolesAllowed("ADMIN")
	@POST
	@Path("/update")
	@Consumes("application/xml")
	public Response updateCategorie(final Categorie c) {
		categorieDAO.updateCategorie(c);
		return Response.ok(c).build();
	}

	@PermitAll
	@GET
	@Path("/{id}")
	@Produces("application/xml")
	public Categorie getCategorie(@PathParam("id") final int id) {
		final Categorie c = categorieDAO.findById(id);
		return c;
	}
	
	@PermitAll
	@GET
	@Path("/name/{name}")
	@Produces("application/xml")
	public Categorie getCategorieByName(@PathParam("name") final String name) {
		final Categorie c = categorieDAO.findByName(name);
		return c;
	}
	
	@PermitAll
	@GET
	@Path("/list")
	@Produces("application/xml")
	public CategoriesDTO getAllCategories() {
		CategoriesDTO categories = new CategoriesDTO();
		
		try {
			categories = categorieDAO.findAll();
		} catch (Exception e) {
			LOG.error("erreur service /list");
			e.printStackTrace();
		}
		return categories;

	}
	
	@PermitAll
	@GET
	@Path("/listAsc")
	@Produces("application/xml")
	public CategoriesDTO getAllCategoriesByOrderAsc() {
		CategoriesDTO categories = new CategoriesDTO();
		
		try {
			categories = categorieDAO.findAllByOrderAsc();
		} catch (Exception e) {
			LOG.error("erreur service /list");
			e.printStackTrace();
		}
		return categories;

	}
	
}
