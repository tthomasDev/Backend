package dto;

import java.util.HashSet;
import java.util.Set;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import model.Utilisateur;






@XmlRootElement(name = "utilisateursdto")
public class UtilisateursDTO {
	
	protected Set<Utilisateur> utilisateur = new HashSet<Utilisateur>();
	
	public UtilisateursDTO(){
		
	}

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
