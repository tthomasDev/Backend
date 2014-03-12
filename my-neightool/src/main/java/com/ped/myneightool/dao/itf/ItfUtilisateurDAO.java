package com.ped.myneightool.dao.itf;

import com.ped.myneightool.dto.UtilisateursDTO;
import com.ped.myneightool.model.Utilisateur;

public interface ItfUtilisateurDAO {

	public abstract void createUtilisateur(Utilisateur utilisateur);

	public abstract void updateUtilisateur(Utilisateur utilisateur);

	public abstract Utilisateur findById(int id);
	
	public abstract Utilisateur findByLogin(String login);
	
	public abstract Utilisateur findByEmail(String email);

	public abstract void deleteUtilisateur(Utilisateur utilisateur);

	public abstract UtilisateursDTO findAll();

}