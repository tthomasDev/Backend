package com.ped.myneightool.dto;

import java.util.HashSet;
import java.util.Set;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.ped.myneightool.model.Utilisateur;





@XmlRootElement(name = "utilisateursdto")
public class UtilisateursDTO {
	
	protected Set<Utilisateur> listeUtilisateurs = new HashSet<Utilisateur>();
	
	public UtilisateursDTO(){
		
	}

	@XmlElement(name ="listeUtilisateurs")
	public Set<Utilisateur> getListeUtilisateurs() {
		return listeUtilisateurs;
	}

	public void setListeUtilisateurs(Set<Utilisateur> listeUtilisateurs) {
		this.listeUtilisateurs = listeUtilisateurs;
	}

	public int size() {
		return listeUtilisateurs.size();
		}
}
