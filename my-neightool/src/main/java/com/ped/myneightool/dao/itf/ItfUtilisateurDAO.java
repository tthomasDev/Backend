package com.ped.myneightool.dao.itf;

import com.ped.myneightool.model.Utilisateur;

public interface ItfUtilisateurDAO {

	public abstract void createUtilisateur(Utilisateur utilisateur);

	public abstract void updateUtilisateur(Utilisateur utilisateur);

	public abstract Utilisateur findById(int id);

	public abstract void deleteUtilisateur(Utilisateur utilisateur);

}