package com.ped.myneightool.dao.impl;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;

import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.itf.ItfConnexionDAO;
import com.ped.myneightool.model.Connexion;
import com.ped.myneightool.model.Utilisateur;



public class ConnexionDAOImpl extends GenericDAOImpl implements ItfConnexionDAO {

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(ConnexionDAOImpl.class);

	
	@Override
	public String isValidConnection(Connexion connexion) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			final Query q = em
					.createQuery("SELECT c FROM Utilisateur c where c.connexion.login =:lo and c.connexion.password =:pa");
			q.setParameter("lo", connexion.getLogin());
			q.setParameter("pa", connexion.getPassword());
			final Utilisateur utilisateur = (Utilisateur) q.getResultList()
					.get(0);
			tx.commit();

			if (utilisateur != null) {
				//renvois l'id utilisateur 
				return Integer.toString(utilisateur.getId());
			}
		} catch (final Exception re) {
			LOG.error("connexion DAO failed", re);
			tx.rollback();

		}
		String str = new String("Mauvaise connexion");
		return str;
	}

	
	

}
