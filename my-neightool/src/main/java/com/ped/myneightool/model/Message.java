package com.ped.myneightool.model;




import java.util.Date;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;


@Entity
@XmlAccessorType(XmlAccessType.NONE)
@XmlRootElement(name = "message")
public class Message {
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int id;
	
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="utilisateur_id_emetteur")
	private Utilisateur emetteur;
	
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="utilisateur_id_destinataire")
	private Utilisateur destinataire;
	
	private String objet;
	
	@Lob @Basic(fetch=FetchType.LAZY, optional=false)
	private String corps;
	
	/*
	 * Permet de savoir dans quel Etat est le message chez l'émetteur
	 *  0 = non supprimé
	 *  1 = supprimé
	 */
	private int etatEmetteur;
	
	/*
	 * Permet de savoir dans quel Etat est le message chez le destinataire
	 *  0 = non lu
	 *  1 = lu
	 *  2 = répondu
	 *  3 = supprimé
	 */
	private int etatDestinataire;
	
	@XmlElement(name = "date",required =true) 
	@XmlJavaTypeAdapter(DateAdapter.class)
	private Date date;
	
	
	public Message(){
		
	}
	
	public Message(Utilisateur emetteur, Utilisateur destinataire, String objet, String corps,Date date, int etatEmetteur, int etatDestinataire) {
		super();
		this.emetteur = emetteur;
		this.destinataire = destinataire;
		this.objet = objet;
		this.corps = corps;
		this.date = date;
		this.etatEmetteur = etatEmetteur;
		this.etatDestinataire = etatDestinataire;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}
	
	@XmlElement
	public Utilisateur getEmetteur() {
		return emetteur;
	}

	public void setEmetteur(Utilisateur emetteur) {
		this.emetteur = emetteur;
	}

	@XmlElement
	public Utilisateur getDestinataire() {
		return destinataire;
	}

	public void setDestinataire(Utilisateur destinataire) {
		this.destinataire = destinataire;
	}

	@XmlElement
	public String getObjet() {
		return objet;
	}
	
	public void setObjet(String objet) {
		this.objet = objet;
	}

	@XmlElement
	@Column(name="DESC", columnDefinition="TEXT")
	public String getCorps() {
		return corps;
	}

	public void setCorps(String corps) {
		this.corps = corps;
	}

	@XmlElement
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	@XmlElement
	public int getEtatDestinataire() {
		return etatDestinataire;
	}

	public void setEtatDestinataire(int etatDestinataire) {
		this.etatDestinataire = etatDestinataire;
	}

	@XmlElement
	public int getEtatEmetteur() {
		return etatEmetteur;
	}

	public void setEtatEmetteur(int etatEmetteur) {
		this.etatEmetteur = etatEmetteur;
	}
	
	

}
