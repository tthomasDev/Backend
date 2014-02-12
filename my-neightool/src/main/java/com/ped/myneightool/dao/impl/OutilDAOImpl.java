package com.ped.myneightool.dao.impl;


import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;

import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.itf.ItfOutilDAO;
import com.ped.myneightool.model.Outil;



public class OutilDAOImpl extends GenericDAOImpl implements ItfOutilDAO {

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(OutilDAOImpl.class);

	
	@Override
	public void createOutil(Outil o) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.persist(o);
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("create Outil failed", re);
			}
			LOG.error("create Outil failed", re);
			tx.rollback();

		}

	}

	@Override
	public void updateOutil(Outil o) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.merge(o);
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("update Outil failed", re);
			}
			tx.rollback();
		}
	}

	
	
	
	@Override
	public Outil findById(int id) {
		final EntityManager em = createEntityManager();
		final Outil o = em.find(Outil.class, id);
		return o;
	}

	
	@Override
	public void deleteOutil(Outil o) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.remove(em.merge(o));
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("delete Outil failed", re);
			}
			tx.rollback();
		}

	}

	
}
