package com.ped.myneightool.model;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@Embeddable
@XmlAccessorType(XmlAccessType.NONE)
@XmlRootElement(name = "adresse")
public class Adresse {
	
	
	
	@XmlElement
	private String adresse;
	
	@XmlElement
	private String codePostale;
	
	@XmlElement
	private String ville;
	
	@XmlElement
	private String pays;
	
	@XmlElement
	@Column(nullable = true)
	private float longitude;
	
	@XmlElement
	@Column(nullable = true)
	private float latitude;
	
	public Adresse(){
		
	}
	
	public Adresse(String adresse, String codePostale, String ville, String pays,
			float longitude, float latitude) {
		super();
		this.adresse = adresse;
		this.codePostale = codePostale;
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
	public String getcodePostale() {
		return codePostale;
	}
	public void setcodePostale(String codePostale) {
		this.codePostale = codePostale;
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
