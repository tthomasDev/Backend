package com.ped.myneightool.dao.itf;


import com.ped.myneightool.dto.OutilsDTO;
import com.ped.myneightool.model.Outil;

public interface ItfOutilDAO {

	public abstract void createOutil(Outil outil);

	public abstract void updateOutil(Outil outil);

	public abstract Outil findById(int id);

	public abstract void deleteOutil(Outil outil);

	public abstract OutilsDTO findAll();
	
	public abstract OutilsDTO findAllAvailable();

	public abstract OutilsDTO findToolsOfUser(int utilisateurId);

	public abstract OutilsDTO findToolsOfUserAvailable(int utilisateurId);
	
	public abstract OutilsDTO findByCriteria(Outil o);

	public abstract OutilsDTO findToolsOfCategory(int categoryId);
	
	public abstract OutilsDTO findToolsOfCategoryAvailable(int categoryId);
	
}