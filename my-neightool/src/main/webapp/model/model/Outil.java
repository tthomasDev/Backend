package model;

import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;



@XmlAccessorType(XmlAccessType.NONE)
@XmlRootElement(name = "outil")
public class Outil {
	
	
	private int id;
	
	private String nom;
	
	private String description;
	
	private boolean disponible = true;
	
	private Categorie categorie;
	
	private int caution;
	
	private Utilisateur utilisateur;
	
		
	@XmlElement(name = "dateDebut",required =true)
	@XmlJavaTypeAdapter(DateAdapter.class)
	private Date dateDebut;
	
	@XmlElement(name = "dateFin",required =true)
	@XmlJavaTypeAdapter(DateAdapter.class)
	private Date dateFin;
	
	private String cheminImage;
	

	public Outil(){
		
	}
	
	public Outil(Utilisateur utilisateur,String nom, String description,
			boolean disponible, Categorie categorie, int caution) {
				
		this.utilisateur=utilisateur;
		this.utilisateur.addOutil(this);
				
		this.nom = nom;
		this.description = description;
		this.disponible = disponible;
		this.categorie = categorie;
		this.caution = caution;
	}
	
	public Outil(Utilisateur utilisateur,String nom, String description,
			boolean disponible, Categorie categorie, int caution,
			Date dateDebut,Date dateFin) {
				
		this.utilisateur=utilisateur;
		this.utilisateur.addOutil(this);
				
		this.nom = nom;
		this.description = description;
		this.disponible = disponible;
		this.categorie = categorie;
		this.caution = caution;
		this.dateDebut=dateDebut;
		this.dateFin=dateFin;
	}
	
	public Outil(Utilisateur utilisateur,String nom, String description,
			boolean disponible, Categorie categorie, int caution,
			Date dateDebut,Date dateFin, String cheminImage) {
				
		this.utilisateur=utilisateur;
		this.utilisateur.addOutil(this);
				
		this.nom = nom;
		this.description = description;
		this.disponible = disponible;
		this.categorie = categorie;
		this.caution = caution;
		this.dateDebut=dateDebut;
		this.dateFin=dateFin;
		this.cheminImage=cheminImage;
	}
	
	
	
	@XmlElement
	public String getCheminImage() {
		return cheminImage;
	}

	public void setCheminImage(String cheminImage) {
		this.cheminImage = cheminImage;
	}

	public Date getDateDebut() {
		return dateDebut;
	}

	public void setDateDebut(Date dateDebut) {
		this.dateDebut = dateDebut;
	}

	
	public Date getDateFin() {
		return dateFin;
	}

	public void setDateFin(Date dateFin) {
		this.dateFin = dateFin;
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
	public Categorie getCategorie() {
		return categorie;
	}

	public void setCategorie(Categorie categorie) {
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
