package com.ped.myneightool.dao.impl;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Query;

import org.slf4j.LoggerFactory;

import com.ped.myneightool.dao.itf.ItfCategorieDAO;
import com.ped.myneightool.dto.CategoriesDTO;
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
	
	@Override
	public CategoriesDTO findAll() {
		LOG.info("find all categories");
		List<Categorie> res = new ArrayList<Categorie>();
				
		final EntityManager em = createEntityManager();
		EntityTransaction tx=null;
		
		try{
			tx=em.getTransaction();
			tx.begin();
			res = TypeSafetyChecking.castList(Categorie.class, em.createQuery("SELECT p FROM Categorie p ORDER BY p.id DESC").getResultList());
			tx.commit();
			LOG.debug("\n \n AFFICHAGE 2 !!!");
			LOG.debug("recherche de toutes les categories réussis, taille du résultat :"+res.size());
		}
		catch(final RuntimeException re){
			re.printStackTrace();
		}
		
		List<Categorie> set = new ArrayList<Categorie>(res);
		CategoriesDTO odto= new CategoriesDTO();
		odto.setListeCategories(set);
		return odto;
	}


	@Override
	public CategoriesDTO findAllByOrderAsc() {
		
		LOG.info("find all categories by order asc");
		List<Categorie> res = new ArrayList<Categorie>();
				
		final EntityManager em = createEntityManager();
		EntityTransaction tx=null;
		
		try{
			tx=em.getTransaction();
			tx.begin();
			res = TypeSafetyChecking.castList(Categorie.class, em.createQuery("SELECT p FROM Categorie p ORDER BY p.id ASC").getResultList());
			tx.commit();
			LOG.debug("\n \n AFFICHAGE 2 !!!");
			LOG.debug("recherche de toutes les categories réussis, taille du résultat :"+res.size());
		}
		catch(final RuntimeException re){
			re.printStackTrace();
		}
		
		List<Categorie> set = new ArrayList<Categorie>(res);
		CategoriesDTO odto= new CategoriesDTO();
		odto.setListeCategories(set);
		return odto;
	}


	@Override
	public Categorie findByName(String name) {
		final EntityManager em = createEntityManager();
		EntityTransaction tx=null;
		Categorie categorie = null;
		try{
			tx=em.getTransaction();
			tx.begin();
			final Query q = em.createQuery("SELECT c FROM Categorie c WHERE c.nom = :par");
			q.setParameter("par",name);
			categorie = (Categorie) q.getResultList().get(0);
			tx.commit();
			LOG.debug("categorie "+categorie.getId()+" trouvé");
			
		}
		catch(final RuntimeException re){
			LOG.error("findByName failed", re);
			tx.rollback();
		}
		return categorie;
	}		
	
}