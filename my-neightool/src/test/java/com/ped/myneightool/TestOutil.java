package com.ped.myneightool;

import javax.xml.bind.JAXBContext;

import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;
import org.slf4j.LoggerFactory;

import com.ped.myneightool.model.Outil;
import com.ped.myneightool.model.Utilisateur;





public class TestOutil {

	private static final org.slf4j.Logger LOG = LoggerFactory
			.getLogger(TestOutil.class);

	
	private static JAXBContext jaxbc;
	private static ClientRequestBuilder crb;
	

	@BeforeClass
	public static void setUp() throws Exception {
		jaxbc=JAXBContext.newInstance(	Utilisateur.class, 
										Outil.class);
		crb= new ClientRequestBuilder(jaxbc);
	}
		
	/**
	 * test unitaire création d'utilisateur
	 */
	@Test
	public void testCreateOutil() {
		try {
			final Utilisateur utilisateur= new Utilisateur("prenomCreateOutil","nomCreateOutil");
			final Utilisateur utilisateurPost= (Utilisateur) crb.httpRequestXMLBody(utilisateur, "user/create");
			
			
			final Outil outil= new Outil(utilisateurPost,"Rateau","savoir ratisser",true,"Jardinage",50);
			final Outil outilPost=(Outil) crb.httpRequestXMLBody(outil, "tool/create");
			
			Assert.assertNotSame(outilPost,null);
			
		} catch (final RuntimeException re) {
			LOG.error("echec de creation de l'outil", re);
			throw re;
		}
	}
	
	
	
	
	
}
