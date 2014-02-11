package com.ped.myneightool.model;

import java.sql.Timestamp;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.xml.bind.annotation.XmlRootElement;

@Entity
@XmlRootElement(name = "emprunt")
public class Emprunt {
	
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "outil_id")
	protected Outil outil;
	
	
	private int idEmprunteur;
	
	
	private Timestamp dateDebut;
	
	
	private Timestamp dateFin;
	
	public Emprunt(){
		
	}
	
	public Emprunt(int id, Outil tool, int idEmprunteur, Timestamp dateDebut,
			Timestamp dateFin) {
		super();
		this.id = id;
		this.outil = tool;
		this.idEmprunteur = idEmprunteur;
		this.dateDebut = dateDebut;
		this.dateFin = dateFin;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public Outil getTool() {
		return outil;
	}
	public void setTool(Outil tool) {
		this.outil = tool;
	}
	public int getIdEmprunteur() {
		return idEmprunteur;
	}
	public void setIdEmprunteur(int idEmprunteur) {
		this.idEmprunteur = idEmprunteur;
	}
	public Timestamp getDateDebut() {
		return dateDebut;
	}
	public void setDateDebut(Timestamp dateDebut) {
		this.dateDebut = dateDebut;
	}
	public Timestamp getDateFin() {
		return dateFin;
	}
	public void setDateFin(Timestamp dateFin) {
		this.dateFin = dateFin;
	}
	
	

}
