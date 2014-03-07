package model;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;



@XmlAccessorType(XmlAccessType.NONE)
@XmlRootElement(name = "categorie")
public class Categorie {
	
	
	private int id;
	
	
	private String nom;
	
	public Categorie(){
		
	}
	
	public Categorie(String nom) {
		this.nom = nom;
	}


	@XmlElement
	public String getNom() {
		return nom;
	}

	public void setNom(String nom) {
		this.nom = nom;
	}
	
	@XmlElement
	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id = id;
	}

}
