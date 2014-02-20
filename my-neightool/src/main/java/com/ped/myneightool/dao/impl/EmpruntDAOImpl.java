package com.ped.myneightool.dao.impl;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;

import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.itf.ItfEmpruntDAO;
import com.ped.myneightool.model.Emprunt;

public class EmpruntDAOImpl extends GenericDAOImpl implements ItfEmpruntDAO {

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(EmpruntDAOImpl.class);

	
	@Override
	public void createEmprunt(Emprunt u) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.persist(u);
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("create emprunt failed", re);
			}
			LOG.error("create emprunt failed", re);
			tx.rollback();
		}
	}

	@Override
	public void updateEmprunt(Emprunt u) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.merge(u);
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("update emprunt failed", re);
			}
			tx.rollback();
		}		
		
	}

	@Override
	public Emprunt findById(int id) {
		final EntityManager em = createEntityManager();
		final Emprunt emprunt = em.find(Emprunt.class, id);
		return emprunt;
	}

	@Override
	public void deleteEmprunt(Emprunt emprunt) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.remove(em.merge(emprunt));
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("delete message failed", re);
			}
			tx.rollback();
		}
	}

}
