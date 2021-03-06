package com.ped.myneightool.dao.itf;

import com.ped.myneightool.dto.CategoriesDTO;
import com.ped.myneightool.model.Categorie;

public interface ItfCategorieDAO {

	public abstract void createCategorie(Categorie categorie);

	public abstract Categorie findById(int id);

	public abstract void deleteCategorie(Categorie categorie);

	public abstract CategoriesDTO findAll();

	public abstract CategoriesDTO findAllByOrderAsc();

	public abstract Categorie findByName(String name);

	public abstract void updateCategorie(Categorie c);

}