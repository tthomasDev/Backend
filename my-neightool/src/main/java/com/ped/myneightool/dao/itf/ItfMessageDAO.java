package com.ped.myneightool.dao.itf;

import com.ped.myneightool.dto.Messages;
import com.ped.myneightool.dto.MessagesDTO;
import com.ped.myneightool.model.Message;

public interface ItfMessageDAO {

	public abstract void createMessage(Message message);

	public abstract void updateMessage(Message message);

	public abstract Message findById(int id);

	public abstract void deleteMessage(Message message);

	public abstract MessagesDTO findMessagesSendOfUser(int utilisateurId);

	public abstract MessagesDTO findMessagesReceiveOfUser(int utilisateurId);

	public abstract Messages findMessagesSendOfUserByList(int utilisateurId);
	

}