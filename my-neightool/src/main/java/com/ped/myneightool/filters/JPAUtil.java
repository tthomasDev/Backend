package com.ped.myneightool.filters;

import javax.persistence.EntityManager;

public class JPAUtil {
	public static final ThreadLocal<EntityManager> ENTITY_MANAGERS = new ThreadLocal<EntityManager>();

	/** Returns a fresh EntityManager */
	public static EntityManager getEntityManager() {
		return ENTITY_MANAGERS.get();
	}
}
