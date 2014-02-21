package dto;



import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import model.Message;







@XmlRootElement(name = "messagesDTO")
public class Messages {
	
	protected List<Message> message = new ArrayList<Message>();
	
	public Messages(){
		
	}

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
