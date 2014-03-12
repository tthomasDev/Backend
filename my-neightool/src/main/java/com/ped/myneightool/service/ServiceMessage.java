package com.ped.myneightool.service;

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

import com.ped.myneightool.dao.impl.MessageDAOImpl;
import com.ped.myneightool.dao.itf.ItfMessageDAO;
import com.ped.myneightool.dto.MessagesDTO;
import com.ped.myneightool.model.Message;



@Path("/message")
public class ServiceMessage {

	private static final Logger LOG = LoggerFactory
			.getLogger(ServiceMessage.class);
	
	private static ItfMessageDAO messageDAO = new MessageDAOImpl();

	public ServiceMessage() {

	}

	@RolesAllowed({"USER","ADMIN"})
	@POST
	@Path("/create")
	@Consumes({"application/xml","application/json"})
	public Response createMessage(final Message u) {
		try{
			messageDAO.createMessage(u);
		} catch (Exception e) {
			LOG.error("erreur service /message/create");
			e.printStackTrace();
		}
		
		return Response.ok(u).build();
	}

	@RolesAllowed({"USER","ADMIN"})
	@POST
	@Path("/update")
	@Consumes("application/xml")
	public Response updateMessage(final Message u) {
		messageDAO.updateMessage(u);
		return Response.ok(u).build();
	}
	
	@RolesAllowed({"USER","ADMIN"})
	@GET
	@Path("/delete/{id}")
	public void deleteMessage(@PathParam("id") final int id) {
		final Message Message = messageDAO.findById(id);
		messageDAO.deleteMessage(Message);
	}

	@RolesAllowed({"USER","ADMIN"})
	@GET
	@Path("/{id}")
	@Produces("application/xml")
	public Message getMessage(@PathParam("id") final int id) {
		final Message a = messageDAO.findById(id);
		return a;
	}
	
	@RolesAllowed({"USER","ADMIN"})
	@GET
	@Path("/list/send/{id}")
	@Produces({ "application/xml", "application/json" })
	public MessagesDTO findMessagesSendOfUserByHashSet(@PathParam("id") final int UtilisateurId) {
		MessagesDTO messages = messageDAO.findMessagesSendOfUser(UtilisateurId);
		return messages;
	}
	
	@RolesAllowed({"USER","ADMIN"})
	@GET
	@Path("/list/sendListByOrder/{id}")
	@Produces({ "application/xml", "application/json" })
	public MessagesDTO findMessagesSendOfUserByList(@PathParam("id") final int UtilisateurId) {
		MessagesDTO messages = messageDAO.findMessagesSendOfUserByList(UtilisateurId);
		return messages;
	}
	
	@RolesAllowed({"USER","ADMIN"})
	@GET
	@Path("/list/receive/{id}")
	@Produces({ "application/xml", "application/json" })
	public MessagesDTO findMessagesReceiveOfUser(@PathParam("id") final int UtilisateurId) {
		MessagesDTO messages = messageDAO.findMessagesReceiveOfUser(UtilisateurId);
		return messages;
	}
	
	@RolesAllowed({"USER","ADMIN"})
	@GET
	@Path("/list/receiveListByOrder/{id}")
	@Produces({ "application/xml", "application/json" })
	public MessagesDTO findMessagesReceiveOfUserByList(@PathParam("id") final int UtilisateurId) {
		MessagesDTO messages = messageDAO.findMessagesReceiveOfUserByList(UtilisateurId);
		return messages;
	}
	
		
}
