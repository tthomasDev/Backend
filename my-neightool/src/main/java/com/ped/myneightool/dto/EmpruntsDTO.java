package com.ped.myneightool.dto;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import com.ped.myneightool.model.Emprunt;


@XmlRootElement(name = "empruntsDTO")
public class EmpruntsDTO {
	
	protected List<Emprunt> emprunt = new ArrayList<Emprunt>();
		
	public EmpruntsDTO(){
		
	}

	@XmlElement(name ="emprunt")
	public List<Emprunt> getListeEmprunts() {
		return emprunt;
	}

	public void setListeEmprunts(List<Emprunt> emprunt) {
		this.emprunt = emprunt;
	}

	public int size() {
		return emprunt.size();
	}
	
	/*
	protected Set<Emprunt> emprunt = new HashSet<Emprunt>();
		
	public EmpruntsDTO(){
		
	}

	@XmlElement(name ="emprunt")
	public Set<Emprunt> getListeEmprunts() {
		return emprunt;
	}

	public void setListeEmprunts(Set<Emprunt> emprunt) {
		this.emprunt = emprunt;
	}

	public int size() {
		return emprunt.size();
	}
	*/
}
