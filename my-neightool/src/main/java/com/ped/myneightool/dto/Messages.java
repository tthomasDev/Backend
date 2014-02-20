package com.ped.myneightool.dto;



import java.util.ArrayList;
import java.util.List;

import javax.persistence.OrderBy;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.ped.myneightool.model.Message;





@XmlRootElement(name = "messagesDTO")
public class Messages {
	
	@OrderBy(value="date")
	protected List<Message> message = new ArrayList<Message>();
	
	public Messages(){
		
	}

	@OrderBy("date ASC")
	@XmlElement(name ="message")
	public List<Message> getListeMessages() {
		return message;
	}

	public void setListeMessages(List<Message> message) {
		this.message = message;
	}

	public int size() {
		return message.size();
		}
}
