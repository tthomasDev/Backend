package com.ped.myneightool.dto;

import java.util.HashSet;
import java.util.Set;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.ped.myneightool.model.Outil;





@XmlRootElement(name = "outilsDTO")
public class OutilsDTO {
	
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
}
