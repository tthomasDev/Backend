package dto;

import java.util.HashSet;
import java.util.Set;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import model.Categorie;



@XmlRootElement(name = "categoriesDTO")
public class CategoriesDTO {
	
	protected Set<Categorie> categorie = new HashSet<Categorie>();
	
	public CategoriesDTO(){
		
	}

	@XmlElement(name ="categorie")
	public Set<Categorie> getListeCategories() {
		return categorie;
	}

	public void setListeCategories(Set<Categorie> categorie) {
		this.categorie = categorie;
	}

	public int size() {
		return categorie.size();
		}
}
