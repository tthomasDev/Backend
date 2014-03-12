package com.ped.myneightool.dao.impl;


import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

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
			res = TypeSafetyChecking.castList(Outil.class, em.createQuery("SELECT p FROM Outil p ORDER BY p.id DESC").getResultList());
			tx.commit();
			LOG.debug("recherche de tous les outils réussis, taille du résultat :"+res.size());
		}
		catch(final RuntimeException re){
			
		}
		
		List<Outil> set = new ArrayList<Outil>(res);
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
			final Query q = em.createQuery("SELECT p FROM Outil p where p.disponible =:par ORDER BY p.id DESC");
			q.setParameter("par",true);
			res = TypeSafetyChecking.castList(Outil.class, q.getResultList());
			tx.commit();
			LOG.debug("recherche de tous les outils disponible réussis, taille du résultat :"+res.size());
		}
		catch(final RuntimeException re){
			
		}
		
		List<Outil> set = new ArrayList<Outil>(res);
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

		List<Outil> set = new ArrayList<Outil>(res);
		OutilsDTO odto= new OutilsDTO();
		odto.setListeOutils(set);
		return odto;
	}

	@Override
	public OutilsDTO findToolsOfUserAvailable(int utilisateurId) {
		LOG.info("find all available outils of user");
		List<Outil> res = new ArrayList<Outil>();
				
		final EntityManager em = createEntityManager();
		EntityTransaction tx=null;
		
		try{
			tx=em.getTransaction();
			tx.begin();
			final Query q = em.createQuery("SELECT p FROM Outil p WHERE p.disponible = :par AND p.utilisateur.id = :por ORDER BY p.id DESC");
			q.setParameter("par",true);
			q.setParameter("por",utilisateurId);
			res = TypeSafetyChecking.castList(Outil.class, q.getResultList());
			tx.commit();
			LOG.debug("recherche de tous les outils disponible de l'utilisateur"+utilisateurId+" réussis, taille du résultat :"+res.size());
		}
		catch(final RuntimeException re){
			
		}
		
		List<Outil> set = new ArrayList<Outil>(res);
		OutilsDTO odto= new OutilsDTO();
		odto.setListeOutils(set);
		return odto;
	}

	@Override
	public OutilsDTO findByCriteria(Outil o) {
		
		final List<Outil> Outils = new ArrayList<Outil>();

		final EntityManager em = createEntityManager();
		

		final CriteriaBuilder cb = em.getCriteriaBuilder();
		final CriteriaQuery<Outil> cq = cb.createQuery(Outil.class);
		final Root<Outil> root = cq.from(Outil.class); // FROM
		cq.select(root); // SELECT

		final List<Predicate> predicateList = new ArrayList<Predicate>();

		if (o.getCategorie() != null) {
			final Predicate categorie = cb.equal(root.get("categorie"), o.getCategorie());
			predicateList.add(categorie);
		}

		if (o.isDisponible() == true) {
			final Predicate disponible = cb.equal(root.get("disponible"), o.isDisponible());
			predicateList.add(disponible);
		}

		final Predicate[] predicates = new Predicate[predicateList.size()];
		predicateList.toArray(predicates);
		cq.where(predicates); // WHERE

		for (final Outil Outil : em.createQuery(cq).getResultList()) {
			Outils.add(Outil);
		}

		List<Outil> set = new ArrayList<Outil>(Outils);
		OutilsDTO odto= new OutilsDTO();
		odto.setListeOutils(set);
		return odto;
	}
	
	@Override
	public OutilsDTO findToolsOfCategory(int categorieId) {
		LOG.info("find all tools of a category");
		List<Outil> res = new ArrayList<Outil>();
				
		final EntityManager em = createEntityManager();
		EntityTransaction tx=null;
		
		try{
			tx=em.getTransaction();
			tx.begin();
			final Query q = em.createQuery("SELECT p FROM Outil p WHERE p.categorie.id = :cat ORDER BY p.id DESC");
			q.setParameter("cat",categorieId);
			res = TypeSafetyChecking.castList(Outil.class, q.getResultList());
			tx.commit();
			LOG.debug("recherche de tous les outils de la categorie " + categorieId + "réussie, taille du résultat : " + res.size());
		}
		catch(final RuntimeException re){
			LOG.error("findToolsOfCategory failed");
		}
		
		List<Outil> set = new ArrayList<Outil>(res);
		OutilsDTO odto= new OutilsDTO();
		odto.setListeOutils(set);
		return odto;
	}
}
