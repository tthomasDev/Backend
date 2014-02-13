package com.ped.myneightool.dto;

import java.util.HashSet;
import java.util.Set;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.ped.myneightool.model.Message;





@XmlRootElement(name = "messagesDTO")
public class MessagesDTO {
	
	protected Set<Message> message = new HashSet<Message>();
	
	public MessagesDTO(){
		
	}

	@XmlElement(name ="message")
	public Set<Message> getListeMessages() {
		return message;
	}

	public void setListeMessages(Set<Message> message) {
		this.message = message;
	}

	public int size() {
		return message.size();
		}
}
