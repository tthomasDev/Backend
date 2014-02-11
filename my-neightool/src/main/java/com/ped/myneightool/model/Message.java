package com.ped.myneightool.model;




import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;





@XmlAccessorType(XmlAccessType.NONE)
@XmlRootElement(name = "message")
public class Message {
	
	@XmlElement
	private int idSource;
	
	@XmlElement
	private int idDestinataire;
	
	@XmlElement
	private String objet;
	
	@XmlElement
	private String corps;
	
	public Message(int idSource, int idDestinataire, String objet, String corps) {
		super();
		this.idSource = idSource;
		this.idDestinataire = idDestinataire;
		this.objet = objet;
		this.corps = corps;
	}

	public int getIdSource() {
		return idSource;
	}

	public void setIdSource(int idSource) {
		this.idSource = idSource;
	}

	public int getIdDestinataire() {
		return idDestinataire;
	}

	public void setIdDestinataire(int idDestinataire) {
		this.idDestinataire = idDestinataire;
	}

	public String getObjet() {
		return objet;
	}

	public void setObjet(String objet) {
		this.objet = objet;
	}

	public String getCorps() {
		return corps;
	}

	public void setCorps(String corps) {
		this.corps = corps;
	}
	

}
