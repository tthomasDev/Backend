package model;




import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;



@XmlAccessorType(XmlAccessType.NONE)
@XmlRootElement(name = "message")
public class Message {
	
	
	private int id;
	
	
	private Utilisateur emetteur;
	
	private Utilisateur destinataire;
	
	private String objet;
	
	private String corps;
	
	@XmlElement(name = "date",required =true) 
	@XmlJavaTypeAdapter(DateAdapter.class)
	private Date date;
	
	
	public Message(){
		
	}
	
	public Message(Utilisateur emetteur, Utilisateur destinataire, String objet, String corps,Date date) {
		super();
		this.emetteur = emetteur;
		this.destinataire = destinataire;
		this.objet = objet;
		this.corps = corps;
		this.date = date;
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
	

}
