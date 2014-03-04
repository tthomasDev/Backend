package com.ped.myneightool.dao.itf;

import com.ped.myneightool.dto.EmpruntsDTO;
import com.ped.myneightool.model.Emprunt;

public interface ItfEmpruntDAO {

	public abstract void createEmprunt(Emprunt u);
	
	public abstract void updateEmprunt(Emprunt u);

	public abstract Emprunt findById(int id);

	public abstract void deleteEmprunt(Emprunt emprunt);

	public abstract EmpruntsDTO findAll();

	public abstract EmpruntsDTO findEmpruntsOfUser(int emprunteurId);
	
}
