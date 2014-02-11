package com.ped.myneightool.model;

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
@XmlRootElement(name = "adresse")
public class Adresse {
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@XmlElement
	private int id;
	
	@XmlElement
	private String adresse;
	
	@XmlElement
	private String cp;
	
	@XmlElement
	private String ville;
	
	@XmlElement
	private String pays;
	
	@XmlElement
	private float longitude;
	
	@XmlElement
	private float latitude;
	
	public Adresse(){
		
	}
	
	public Adresse(String adresse, String cp, String ville, String pays,
			float longitude, float latitude) {
		super();
		this.adresse = adresse;
		this.cp = cp;
		this.ville = ville;
		this.pays = pays;
		this.longitude = longitude;
		this.latitude = latitude;
	}
	
	public String getAdresse() {
		return adresse;
	}
	public void setAdresse(String adresse) {
		this.adresse = adresse;
	}
	public String getCp() {
		return cp;
	}
	public void setCp(String cp) {
		this.cp = cp;
	}
	public String getVille() {
		return ville;
	}
	public void setVille(String ville) {
		this.ville = ville;
	}
	public String getPays() {
		return pays;
	}
	public void setPays(String pays) {
		this.pays = pays;
	}
	public float getLongitude() {
		return longitude;
	}
	public void setLongitude(float longitude) {
		this.longitude = longitude;
	}
	public float getLatitude() {
		return latitude;
	}
	public void setLatitude(float latitude) {
		this.latitude = latitude;
	}
	
	
	

}
