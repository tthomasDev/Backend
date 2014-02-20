package com.ped.myneightool.dto;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.OrderBy;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.ped.myneightool.model.Utilisateur;





@XmlRootElement(name = "utilisateursdto")
public class UtilisateursDTO {
	
	@OrderBy(value="id")
	protected Set<Utilisateur> utilisateur = new HashSet<Utilisateur>();
	
	public UtilisateursDTO(){
		
	}

	@OrderBy("id ASC")
	@XmlElement(name ="utilisateur")
	public Set<Utilisateur> getListeUtilisateurs() {
		return utilisateur;
	}

	public void setListeUtilisateurs(Set<Utilisateur> utilisateur) {
		this.utilisateur = utilisateur;
	}

	public int size() {
		return utilisateur.size();
		}
}
