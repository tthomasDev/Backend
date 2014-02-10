package com.ped.myneightool.model;

public class Message {
	private int idSource;
	private int idDestinataire;
	private String objet;
	private String corps;
	
	public Message(int idSource, int idDestinataire, String objet, String corps) {
		super();
		this.idSource = idSource;
		this.idDestinataire = idDestinataire;
		this.objet = objet;
		this.corps = corps;
	}

	public int getIdSource() {
		return idSource;
	}

	public void setIdSource(int idSource) {
		this.idSource = idSource;
	}

	public int getIdDestinataire() {
		return idDestinataire;
	}

	public void setIdDestinataire(int idDestinataire) {
		this.idDestinataire = idDestinataire;
	}

	public String getObjet() {
		return objet;
	}

	public void setObjet(String objet) {
		this.objet = objet;
	}

	public String getCorps() {
		return corps;
	}

	public void setCorps(String corps) {
		this.corps = corps;
	}
	

}
