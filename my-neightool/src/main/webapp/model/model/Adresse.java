package model;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "adresse")
public class Adresse {
	
	private String rue;
	private String codePostale;
	private String ville;
	private String pays;
	private String adresseComplete;
		
	

	
	private float longitude;
		
	
	private float latitude;
	
	public Adresse(){
		
	}
	
	public Adresse(String rue, String codePostale, String ville, String pays,
			float longitude, float latitude) {
		super();
		this.rue = rue;
		this.codePostale = codePostale;
		this.ville = ville;
		this.pays = pays;
		this.longitude = longitude;
		this.latitude = latitude;
	}
	
	public Adresse(String adresseComplete,float longitude, float latitude){
		this.adresseComplete = adresseComplete;
		this.longitude = longitude;
		this.latitude = latitude;
	}
	
	public Adresse(String adresseComplete){
		this.adresseComplete = adresseComplete;
	}
	
	@XmlElement
	public String getadresseComplete() {
		return adresseComplete;
	}

	public void setadresseComplete(String adresseComplete) {
		this.adresseComplete = adresseComplete;
	}
	
	
	@XmlElement
	public String getRue() {
		return rue;
	}
	
	public void setRue(String rue) {
		this.rue = rue;
	}
	
	@XmlElement
	public String getcodePostale() {
		return codePostale;
	}
	
	public void setcodePostale(String codePostale) {
		this.codePostale = codePostale;
	}
	
	@XmlElement
	public String getVille() {
		return ville;
	}
	
	public void setVille(String ville) {
		this.ville = ville;
	}
	
	@XmlElement
	public String getPays() {
		return pays;
	}
	
	public void setPays(String pays) {
		this.pays = pays;
	}
	
	@XmlElement
	public float getLongitude() {
		return longitude;
	}
	
	public void setLongitude(float longitude) {
		this.longitude = longitude;
	}
	
	@XmlElement
	public float getLatitude() {
		return latitude;
	}
	
	public void setLatitude(float latitude) {
		this.latitude = latitude;
	}
	
	
	

}
