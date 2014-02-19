package model;




import java.util.Date;

import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;



@XmlAccessorType(XmlAccessType.NONE)
@XmlRootElement(name = "emprunt")
public class Emprunt{
	
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int id;
	
	
	
	private Outil outil;
		
	
	private Utilisateur emprunteur;
	
	
	@XmlElement(name = "dateDebut",required =true) 
	@XmlJavaTypeAdapter(DateAdapter.class)
	private Date dateDebut;
	
	@XmlElement(name = "dateFin",required =true) 
	@XmlJavaTypeAdapter(DateAdapter.class)
	private Date dateFin;
	
	
	
	public Emprunt(){
		
	}
	
	public Emprunt(Outil outil,Utilisateur emprunteur){
		this.outil = outil;
		this.emprunteur = emprunteur;
	}
	
	public Emprunt(Outil outil, Utilisateur emprunteur, Date dateDebut,
			Date dateFin) {
		super();
		this.outil = outil;
		this.emprunteur = emprunteur;
		this.dateDebut = dateDebut;
		this.dateFin = dateFin;
	}
	
	@XmlElement
	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	@XmlElement
	public Outil getOutil() {
		return outil;
	}
	
	public void setOutil(Outil outil) {
		this.outil = outil;
	}
	
	
	@XmlElement
	public Utilisateur getEmprunteur() {
		return emprunteur;
	}

	public void setEmprunteur(Utilisateur emprunteur) {
		this.emprunteur = emprunteur;
	}

	
	public Date getDateDebut() {
		return dateDebut;
	}
	
	public void setDateDebut( Date dateDebut) {
		this.dateDebut = dateDebut;
	}
	
	
	public  Date getDateFin() {
		return dateFin;
	}
	
	public void setDateFin(Date dateFin) {
		this.dateFin = dateFin;
	}
	
	

}
