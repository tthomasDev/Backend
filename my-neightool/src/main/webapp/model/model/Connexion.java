package model;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "connexion")
public class Connexion {

	
	private String login;

	private String password;

	public Connexion() {

	}

	public Connexion(String login, String password) {
		super();
		this.login = login;
		this.password = password;
	}

	@XmlElement
	public String getLogin() {
		return login;
	}

	public void setLogin(String login) {
		this.login = login;
	}

	@XmlElement
	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

}
