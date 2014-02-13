package com.ped.myneightool.dao.impl;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;

import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.itf.ItfMessageDAO;
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

}
