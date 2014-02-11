package com.ped.myneightool.dao.impl;

import javax.persistence.EntityManager;

import com.ped.myneightool.filters.JPAUtil;



public abstract class GenericDAOImpl {
	
	private EntityManager entityManager;
	
	public EntityManager createEntityManager() {
		entityManager = JPAUtil.getEntityManager();
		return entityManager;
		
	}

	public void closeEntityManager() {
		entityManager.close();
	}

	
}
