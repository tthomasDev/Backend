package com.ped.myneightool.filters;

import java.io.IOException;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JPAFilter implements Filter {

	private static final Logger LOG = LoggerFactory.getLogger(JPAFilter.class);
	private static EntityManagerFactory emf = null;

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		LOG.info("INTERCEPT REQUEST");
		EntityManager em = null;

		try {
			em = emf.createEntityManager();
			JPAUtil.ENTITY_MANAGERS.set(em);
			chain.doFilter(request, response);
			JPAUtil.ENTITY_MANAGERS.remove();
		} finally {
			try {
				if (em != null) {
					em.close();
				}
			} catch (final Throwable t) {
				LOG.error("While closing an EntityManager", t);
			}
		}
	}


	public void destroy() {
		if (emf != null) {
			emf.close();
		}
	}

	public void init(FilterConfig arg0) throws ServletException {
		destroy();
		emf = Persistence.createEntityManagerFactory("MyNeightool");

	}

}
