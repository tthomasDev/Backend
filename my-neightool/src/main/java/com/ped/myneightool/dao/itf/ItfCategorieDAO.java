package com.ped.myneightool.dao.itf;

import com.ped.myneightool.model.Categorie;

public interface ItfCategorieDAO {

	public abstract void createCategorie(Categorie categorie);

	public abstract Categorie findById(int id);

	public abstract void deleteCategorie(Categorie categorie);

}