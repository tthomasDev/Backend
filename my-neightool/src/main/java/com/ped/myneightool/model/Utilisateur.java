package com.ped.myneightool.model;


import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;
import javax.persistence.OneToMany;



@SuppressWarnings("serial")
@Entity
@XmlAccessorType(XmlAccessType.NONE)
@XmlRootElement(name = "utilisateur")
public class Utilisateur implements Serializable{
	
		
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int id;
	
	private String nom;
	
	private String prenom;
	
	@Embedded
	private Connexion connexion;
	
	@Embedded
	private Adresse adresse;
	
	private String mail;
	
	private String telephone;
	
	private String dateDeNaissance;
	
	@OneToMany(mappedBy = "utilisateur",orphanRemoval=true)
	private Set<Outil> outils = new HashSet<Outil>();
	
	public Utilisateur(){
		
	}
	
	public Utilisateur(String prenom, String nom, Connexion connexion,
			String mail, String telephone) {
		this.prenom = prenom;
		this.nom = nom;
		this.connexion = connexion;
		this.mail = mail;
		this.telephone = telephone;
	}
	
	public Utilisateur(String prenom, String nom, Connexion connexion,
			String mail, String telephone, Adresse adresse) {
		this.prenom = prenom;
		this.nom = nom;
		this.connexion = connexion;
		this.mail = mail;
		this.telephone = telephone;
		this.adresse = adresse;
	}

	public Utilisateur(String prenom, String nom) {
		super();
		
		this.nom = nom;
		this.prenom = prenom;
		
	}
	
	public Utilisateur(String prenom, String nom, Connexion connexion,
			String mail, String telephone, Adresse adresse, String dateDeNaissance) {
		this.prenom = prenom;
		this.nom = nom;
		this.connexion = connexion;
		this.mail = mail;
		this.telephone = telephone;
		this.adresse = adresse;
		this.dateDeNaissance= dateDeNaissance;
	}
	
	@XmlTransient
	public Set<Outil> getOutils(){
		return outils;
	}
	
	public void setOutils(Set<Outil> outils){
		this.outils=outils;
	}
	
	// methode metier qui evitera d'avoir a faire :
	// utilisateur.getOutils().add(outils) et utilisateur.setOutils(outils)
	public void addOutil(Outil o) {
		this.outils.add(o);
	}
		
	public void removeOutil(Outil o) {
		this.outils.remove(o);
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
	
	@XmlElement
	public String getPrenom() {
		return prenom;
	}
	
	public void setPrenom(String prenom) {
		this.prenom = prenom;
	}

	@XmlElement
	public Connexion getConnexion() {
		return connexion;
	}

	public void setConnexion(Connexion connexion) {
		this.connexion = connexion;
	}

	@XmlElement
	public String getMail() {
		return mail;
	}

	public void setMail(String mail) {
		this.mail = mail;
	}

	@XmlElement
	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String toString(){
		return this.id+" "+this.nom +" "+this.prenom;
		
	}
	
	@XmlElement
	public Adresse getAdresse() {
		return adresse;
	}

	public void setAdresse(Adresse adresse) {
		this.adresse = adresse;
	}

	@XmlElement
	public String getDateDeNaissance() {
		return dateDeNaissance;
	}

	public void setDateDeNaissance(String dateDeNaissance) {
		this.dateDeNaissance = dateDeNaissance;
	}

	
	
}
