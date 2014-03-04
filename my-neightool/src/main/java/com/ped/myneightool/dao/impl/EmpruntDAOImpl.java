package com.ped.myneightool.dao.impl;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;

import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.itf.ItfEmpruntDAO;
import com.ped.myneightool.dto.EmpruntsDTO;
import com.ped.myneightool.model.Emprunt;
import com.ped.myneightool.model.Utilisateur;

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

	@Override
	public EmpruntsDTO findAll() {
		LOG.info("find all Emprunts");
		List<Emprunt> res = new ArrayList<Emprunt>();
				
		final EntityManager em = createEntityManager();
		//EntityTransaction tx=null;
		
		try{
			//tx=em.getTransaction();
			//tx.begin();
			res = TypeSafetyChecking.castList(Emprunt.class, em.createQuery("SELECT p FROM Emprunt p ORDER BY p.id DESC").getResultList());
			//tx.commit();
			LOG.debug("recherche de tous les emprunts réussis, taille du résultat :"+res.size());
		}
		catch(final RuntimeException re){
			
		}
		
		List<Emprunt> set = new ArrayList<Emprunt>(res);
		EmpruntsDTO odto= new EmpruntsDTO();
		odto.setListeEmprunts(set);
		return odto;
	}

	@Override
	public EmpruntsDTO findEmpruntsOfUser(int emprunteurId) {
		LOG.info("find all emprunts from user ID : " + emprunteurId);
		Set<Emprunt> res = new HashSet<Emprunt>();
		final EntityManager em = createEntityManager();
		final Utilisateur u = em.getReference(Utilisateur.class, emprunteurId);
		res = u.getEmprunts();

		List<Emprunt> set = new ArrayList<Emprunt>(res);
		EmpruntsDTO odto= new EmpruntsDTO();
		odto.setListeEmprunts(set);
		return odto;
	}
	
}
