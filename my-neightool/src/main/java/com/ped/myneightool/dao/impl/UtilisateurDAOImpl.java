package com.ped.myneightool.dao.impl;


import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;

import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.itf.ItfUtilisateurDAO;
import com.ped.myneightool.dto.UtilisateursDTO;
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

	@Override
	public void updateUtilisateur(Utilisateur utilisateur) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.merge(utilisateur);
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("update utilisateur failed", re);
			}
			tx.rollback();
		}
	}

	
	
	
	@Override
	public Utilisateur findById(int id) {
		final EntityManager em = createEntityManager();
		final Utilisateur utilisateur = em.find(Utilisateur.class, id);
		return utilisateur;
	}
	
	
	
	@Override
	public Utilisateur findByLogin(String login) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx=null;
		Utilisateur utilisateur = null;
		try{
			tx=em.getTransaction();
			tx.begin();
			final Query q = em.createQuery("SELECT u FROM Utilisateur u WHERE u.connexion.login = :par");
			q.setParameter("par",login);
			utilisateur = (Utilisateur) q.getResultList().get(0);
			tx.commit();
			LOG.debug("utilisateur"+utilisateur.getId()+" trouvé");
			
		}
		catch(final RuntimeException re){
			LOG.error("findByLogin failed", re);
			tx.rollback();
		}
		return utilisateur;
	}


	
	@Override
	public void deleteUtilisateur(Utilisateur utilisateur) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx = null;
		try {
			tx = em.getTransaction();
			tx.begin();
			em.remove(em.merge(utilisateur));
			tx.commit();

		} catch (final Exception re) {
			if (tx != null) {
				LOG.error("delete utilisateur failed", re);
			}
			tx.rollback();
		}

	}
	
	@Override
	public UtilisateursDTO findAll() {
		LOG.info("find all utilisateurs");
		List<Utilisateur> res = new ArrayList<Utilisateur>();
				
		final EntityManager em = createEntityManager();
		//EntityTransaction tx=null;
		
		try{
			//tx=em.getTransaction();
			//tx.begin();
			res = TypeSafetyChecking.castList(Utilisateur.class, em.createQuery("SELECT p FROM Utilisateur p ORDER BY p.id").getResultList());
			//tx.commit();
			LOG.debug("recherche de tous les utilisateurs réussis, taille du résultat :"+res.size());
		}
		catch(final RuntimeException re){
			
		}
		
		Set<Utilisateur> set = new HashSet<Utilisateur>(res);
		UtilisateursDTO odto= new UtilisateursDTO();
		odto.setListeUtilisateurs(set);
		return odto;
	}

	
	
}
