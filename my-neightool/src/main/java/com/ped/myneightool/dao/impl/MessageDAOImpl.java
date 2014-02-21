package com.ped.myneightool.dao.impl;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;

import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.itf.ItfMessageDAO;
import com.ped.myneightool.dto.Messages;
import com.ped.myneightool.dto.MessagesDTO;
import com.ped.myneightool.model.Message;


public class MessageDAOImpl extends GenericDAOImpl implements ItfMessageDAO {

	
	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(MessageDAOImpl.class);

	
	@Override
	public void createMessage(Message message) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.persist(message);
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("create message failed", re);
			}
			LOG.error("create message failed", re);
			tx.rollback();

		}
		
	}

	@Override
	public void updateMessage(Message message) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.merge(message);
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("update message failed", re);
			}
			tx.rollback();
		}		
	}

	@Override
	public Message findById(int id) {
		final EntityManager em = createEntityManager();
		final Message message = em.find(Message.class, id);
		return message;
		
	}

	@Override
	public void deleteMessage(Message message) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.remove(em.merge(message));
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("delete message failed", re);
			}
			tx.rollback();
		}
		
	}

	@Override
	public MessagesDTO findMessagesSendOfUser(int utilisateurId) {
		LOG.info("find all messages send of user");
		List<Message> res = new ArrayList<Message>();
				
		final EntityManager em = createEntityManager();
		EntityTransaction tx=null;
		
		try{
			tx=em.getTransaction();
			tx.begin();
			final Query q = em.createQuery("SELECT m FROM Message m WHERE m.emetteur.id = :por ORDER BY m.date DESC");
			q.setParameter("por",utilisateurId);
			res = TypeSafetyChecking.castList(Message.class, q.getResultList());
			tx.commit();
			LOG.debug("recherche de tous les messages envoyés de l'utilisateur"+utilisateurId+" réussis, taille du résultat :"+res.size());
		}
		catch(final RuntimeException re){
			
		}
		
		Set<Message> set = new HashSet<Message>(res);
		MessagesDTO mdto= new MessagesDTO();
		mdto.setListeMessages(set);
		return mdto;
	}

	
	@Override
	public Messages findMessagesSendOfUserByList(int utilisateurId) {
		LOG.info("find all messages send of user");
		List<Message> res = new ArrayList<Message>();
				
		final EntityManager em = createEntityManager();
		EntityTransaction tx=null;
		
		try{
			tx=em.getTransaction();
			tx.begin();
			final Query q = em.createQuery("SELECT m FROM Message m WHERE m.emetteur.id = :por ORDER BY m.date DESC");
			q.setParameter("por",utilisateurId);
			res = TypeSafetyChecking.castList(Message.class, q.getResultList());
			tx.commit();
			LOG.debug("recherche de tous les messages envoyés de l'utilisateur"+utilisateurId+" réussis, taille du résultat :"+res.size());
		}
		catch(final RuntimeException re){
			
		}
		
		List<Message> set = new ArrayList<Message>(res);
		Messages mdto= new Messages();
		mdto.setListeMessages(set);
		return mdto;
	}
	
	
	@Override
	public MessagesDTO findMessagesReceiveOfUser(int utilisateurId) {
		
		LOG.info("find all messages receive of user");
		List<Message> res = new ArrayList<Message>();
				
		final EntityManager em = createEntityManager();
		EntityTransaction tx=null;
		
		try{
			tx=em.getTransaction();
			tx.begin();
			final Query q = em.createQuery("SELECT m FROM Message m WHERE m.destinataire.id = :por ORDER BY m.date DESC");
			q.setParameter("por",utilisateurId);
			res = TypeSafetyChecking.castList(Message.class, q.getResultList());
			tx.commit();
			LOG.debug("recherche de tous les messages reçus par l'utilisateur"+utilisateurId+" réussis, taille du résultat :"+res.size());
		}
		catch(final RuntimeException re){
			
		}
		
		Set<Message> set = new HashSet<Message>(res);
		MessagesDTO mdto= new MessagesDTO();
		mdto.setListeMessages(set);
		return mdto;
		}

	@Override
	public Messages findMessagesReceiveOfUserByList(int utilisateurId) {
		
		LOG.info("find all messages receive of user");
		List<Message> res = new ArrayList<Message>();
				
		final EntityManager em = createEntityManager();
		EntityTransaction tx=null;
		
		try{
			tx=em.getTransaction();
			tx.begin();
			final Query q = em.createQuery("SELECT m FROM Message m WHERE m.destinataire.id = :por ORDER BY m.date DESC");
			q.setParameter("por",utilisateurId);
			res = TypeSafetyChecking.castList(Message.class, q.getResultList());
			tx.commit();
			LOG.debug("recherche de tous les messages reçus par l'utilisateur"+utilisateurId+" réussis, taille du résultat :"+res.size());
		}
		catch(final RuntimeException re){
			
		}
		
		List<Message> set = new ArrayList<Message>(res);
		Messages mdto= new Messages();
		mdto.setListeMessages(set);
		return mdto;
		}

	

}
