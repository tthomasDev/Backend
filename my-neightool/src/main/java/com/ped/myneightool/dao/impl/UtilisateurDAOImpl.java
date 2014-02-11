package com.ped.myneightool.dao.impl;


import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;

import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.itf.ItfUtilisateurDAO;
import com.ped.myneightool.model.Utilisateur;



public class UtilisateurDAOImpl extends GenericDAOImpl implements ItfUtilisateurDAO {

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(UtilisateurDAOImpl.class);

	
	@Override
	public void createUtilisateur(Utilisateur utilisateur) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.persist(utilisateur);
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("create utilisateur failed", re);
			}
			LOG.error("create utilisateur failed", re);
			tx.rollback();

		}

	}

	
	
}
