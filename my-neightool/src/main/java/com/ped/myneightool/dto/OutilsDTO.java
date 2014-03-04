package com.ped.myneightool.dto;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import com.ped.myneightool.model.Outil;


@XmlRootElement(name = "outilsDTO")
public class OutilsDTO {
	
	protected List<Outil> outil = new ArrayList<Outil>();
		
	public OutilsDTO(){
		
	}

	@XmlElement(name ="outil")
	public List<Outil> getListeOutils() {
		return outil;
	}

	public void setListeOutils(List<Outil> outil) {
		this.outil = outil;
	}

	public int size() {
		return outil.size();
	}
	
	/*
	protected Set<Outil> outil = new HashSet<Outil>();
		
	public OutilsDTO(){
		
	}

	@XmlElement(name ="outil")
	public Set<Outil> getListeOutils() {
		return outil;
	}

	public void setListeOutils(Set<Outil> outil) {
		this.outil = outil;
	}

	public int size() {
		return outil.size();
	}
	*/
}
