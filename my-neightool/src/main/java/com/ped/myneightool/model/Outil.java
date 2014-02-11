package com.ped.myneightool.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@Entity
@XmlRootElement(name = "outil")
public class Outil {
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@XmlElement
	private int id;
	
	@XmlElement
	private int idProprio;
	
	@XmlElement
	private String nom;
	
	@XmlElement
	private String description;
	
	@XmlElement
	private boolean disponible;
	
	@XmlElement
	private String categorie;
	
	@XmlElement
	private int caution;

	public Outil(){
		
	}
	
	public Outil(int id, int idProprio, String nom, String description,
			boolean disponible, String categorie, int caution) {
		super();
		this.id = id;
		this.idProprio = idProprio;
		this.nom = nom;
		this.description = description;
		this.disponible = disponible;
		this.categorie = categorie;
		this.caution = caution;
	}

	
	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	
	public String getNom() {
		return nom;
	}
	
	public void setNom(String nom) {
		this.nom = nom;
	}
	
	
	public boolean isDisponible() {
		return disponible;
	}

	public void setDisponible(boolean disponible) {
		this.disponible = disponible;
	}

	
	public String getDescription() {
		return description;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}

	
	public String getCategorie() {
		return categorie;
	}

	public void setCategorie(String categorie) {
		this.categorie = categorie;
	}

	
	public int getCaution() {
		return caution;
	}

	public void setCaution(int caution) {
		this.caution = caution;
	}

	
	public int getIdProprio() {
		return idProprio;
	}

	public void setIdProprio(int idProprio) {
		this.idProprio = idProprio;
	}

}
