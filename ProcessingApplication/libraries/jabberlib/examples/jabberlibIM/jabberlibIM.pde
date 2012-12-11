/**
 * jabberlibIM by Gerald Kogler
 * example shows how to talk to XMPP instant messaging server
 * jabberlib website at http://go.yuri.at/jabberlib/
 */
 
import jabberlib.*;

Jabber jabber;

void setup(){
  noLoop();
  jabber = new Jabber(this,"jabber.org",5222);
  jabber.login("geraldo@jabber.org","password");
  Object[] users = jabber.getUsers();
  println(users);
  jabber.createChat("user@jabber.org");
}

/* every mousePressed sends a chat message */
void mousePressed(){
  jabber.sendMessage("hola mundo");
}

/* incoming chat message are forwarded to the chatEvent method */
void chatEvent(String message) {
  println("received message: "+message);
}