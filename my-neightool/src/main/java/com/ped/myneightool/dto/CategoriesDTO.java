package com.ped.myneightool.dto;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.ped.myneightool.model.Categorie;





@XmlRootElement(name = "categoriesDTO")
public class CategoriesDTO {
	
	protected List<Categorie> categorie = new ArrayList<Categorie>();
	
	public CategoriesDTO(){
		
	}

	@XmlElement(name ="categorie")
	public List<Categorie> getListeCategories() {
		return categorie;
	}

	public void setListeCategories(List<Categorie> categorie) {
		this.categorie = categorie;
	}

	public int size() {
		return categorie.size();
		}
}
