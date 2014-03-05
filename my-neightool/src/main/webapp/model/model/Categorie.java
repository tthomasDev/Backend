package model;

import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;



@XmlAccessorType(XmlAccessType.NONE)
@XmlRootElement(name = "categorie")
public class Categorie {
	
	
	private int id;
	
	
	private String name;
	
	public Categorie(){
		
	}
	
	public Categorie(String name) {
		super();
		this.name = name;
	}


	@XmlElement
	public String getName() {
		return name;
	}

	public void setname(String name) {
		this.name = name;
	}	

}
