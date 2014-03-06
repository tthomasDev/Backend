package com.ped.myneightool.dao.impl;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;

import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.itf.ItfCategorieDAO;
import com.ped.myneightool.model.Categorie;


public class CategorieDAOImpl extends GenericDAOImpl implements ItfCategorieDAO {

	
	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(CategorieDAOImpl.class);

	
	@Override
	public void createCategorie(Categorie categorie) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.persist(categorie);
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("create categorie failed", re);
			}
			LOG.error("create categorie failed", re);
			tx.rollback();

		}
		
	}


	@Override
	public Categorie findById(int id) {
		final EntityManager em = createEntityManager();
		final Categorie categorie = em.find(Categorie.class, id);
		return categorie;
		
	}

	@Override
	public void deleteCategorie(Categorie categorie) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.remove(em.merge(categorie));
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("delete categorie failed", re);
			}
			tx.rollback();
		}
		
	}
}