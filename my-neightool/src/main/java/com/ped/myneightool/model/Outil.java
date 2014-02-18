package com.ped.myneightool.model;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@XmlRootElement(name = "outil")
public class Outil {
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int id;
	
	private String nom;
	
	private String description;
	
	private boolean disponible = true;
	
	private String categorie;
	
	private int caution;
	
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="utilisateur_id")
	private Utilisateur utilisateur;

	public Outil(){
		
	}
	
	public Outil(Utilisateur utilisateur,String nom, String description,
			boolean disponible, String categorie, int caution) {
				
		this.utilisateur=utilisateur;
		this.utilisateur.addOutil(this);
				
		this.nom = nom;
		this.description = description;
		this.disponible = disponible;
		this.categorie = categorie;
		this.caution = caution;
	}
	
	@XmlElement
	public Utilisateur getUtilisateur(){
		return this.utilisateur;
	}
	
	public void setUtilisateur(Utilisateur utilisateur){
		this.utilisateur=utilisateur;
		utilisateur.addOutil(this);
	}

	@XmlElement
	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	@XmlElement
	public String getNom() {
		return nom;
	}
	
	public void setNom(String nom) {
		this.nom = nom;
	}
	
	@XmlElement(defaultValue="true")
	public boolean isDisponible() {
		return disponible;
	}

	public void setDisponible(boolean disponible) {
		this.disponible = disponible;
	}

	@XmlElement
	public String getDescription() {
		return description;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}

	@XmlElement
	public String getCategorie() {
		return categorie;
	}

	public void setCategorie(String categorie) {
		this.categorie = categorie;
	}

	@XmlElement
	public int getCaution() {
		return caution;
	}

	public void setCaution(int caution) {
		this.caution = caution;
	}

}
