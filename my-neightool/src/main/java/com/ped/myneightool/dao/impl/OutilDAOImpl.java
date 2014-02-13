package com.ped.myneightool.dao.impl;


import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;

import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.itf.ItfOutilDAO;
import com.ped.myneightool.dto.OutilsDTO;
import com.ped.myneightool.model.Outil;
import com.ped.myneightool.model.Utilisateur;




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

	@Override
	public OutilsDTO findAll() {
		LOG.info("find all outils");
		List<Outil> res = new ArrayList<Outil>();
				
		final EntityManager em = createEntityManager();
		EntityTransaction tx=null;
		
		try{
			tx=em.getTransaction();
			tx.begin();
			res = TypeSafetyChecking.castList(Outil.class, em.createQuery("SELECT p FROM Outil p ORDER BY id ASC").getResultList());
			tx.commit();
			LOG.debug("recherche de tous les outils réussis, taille du résultat :"+res.size());
		}
		catch(final RuntimeException re){
			
		}
		
		Set<Outil> set = new HashSet<Outil>(res);
		OutilsDTO odto= new OutilsDTO();
		odto.setListeOutils(set);
		return odto;
	}

	
	@Override
	public OutilsDTO findAllAvailable() {
		LOG.info("find all outils");
		List<Outil> res = new ArrayList<Outil>();
				
		final EntityManager em = createEntityManager();
		EntityTransaction tx=null;
		
		try{
			tx=em.getTransaction();
			tx.begin();
			final Query q = em.createQuery("SELECT p FROM Outil p where p.disponible =:par");
			q.setParameter("par",true);
			res = TypeSafetyChecking.castList(Outil.class, q.getResultList());
			tx.commit();
			LOG.debug("recherche de tous les outils disponible réussis, taille du résultat :"+res.size());
		}
		catch(final RuntimeException re){
			
		}
		
		Set<Outil> set = new HashSet<Outil>(res);
		OutilsDTO odto= new OutilsDTO();
		odto.setListeOutils(set);
		return odto;
	}

	
	@Override
	public OutilsDTO findToolsOfUser(int utilisateurId) {
		LOG.info("find all outils from user ID : " + utilisateurId);
		Set<Outil> res = new HashSet<Outil>();
		final EntityManager em = createEntityManager();
		final Utilisateur u = em.getReference(Utilisateur.class, utilisateurId);
		res = u.getOutils();

		Set<Outil> set = new HashSet<Outil>(res);
		OutilsDTO odto= new OutilsDTO();
		odto.setListeOutils(set);
		return odto;
	}

	@Override
	public OutilsDTO findToolsOfUserAvailable(int utilisateurId) {
		// TODO Auto-generated method stub
		return null;
	}

}
