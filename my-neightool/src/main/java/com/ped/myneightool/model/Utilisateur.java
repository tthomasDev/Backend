package com.ped.myneightool.model;


import java.io.Serializable;

import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;




@Entity
@XmlAccessorType(XmlAccessType.NONE)
@XmlRootElement(name = "utilisateur")
public class Utilisateur implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -7978946567530340990L;
	
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@XmlElement
	private int id;
	
	@XmlElement
	private String nom;
	
	@XmlElement
	private String prenom;
	
	@Embedded
	@XmlElement
	private Connection connexion;
	
	@XmlElement
	private String mail;
	
	@XmlElement
	private String telephone;
	
	public Utilisateur(){
		
	}
	
	public Utilisateur(int id, String nom, String prenom, Connection connexion,
			String mail, String telephone) {
		super();
		this.id = id;
		this.nom = nom;
		this.prenom = prenom;
		this.connexion = connexion;
		this.mail = mail;
		this.telephone = telephone;
	}

	public Utilisateur(String nom, String prenom) {
		super();
		
		this.nom = nom;
		this.prenom = prenom;
		
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
	
	
	public String getPrenom() {
		return prenom;
	}
	
	public void setPrenom(String prenom) {
		this.prenom = prenom;
	}

	
	public Connection getConnexion() {
		return connexion;
	}

	public void setConnexion(Connection connexion) {
		this.connexion = connexion;
	}

	
	public String getMail() {
		return mail;
	}

	public void setMail(String mail) {
		this.mail = mail;
	}

	
	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String toString(){
		return this.id+" "+this.nom +" "+this.prenom;
		
	}

}
