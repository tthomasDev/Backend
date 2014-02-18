package com.ped.myneightool.dao.itf;

import com.ped.myneightool.model.Message;

public interface ItfMessageDAO {

	public abstract void createMessage(Message message);

	public abstract void updateMessage(Message message);

	public abstract Message findById(int id);

	public abstract void deleteMessage(Message message);
	

}