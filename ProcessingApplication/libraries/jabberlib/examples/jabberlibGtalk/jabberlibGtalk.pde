/**
 * jabberlibGtalk by Gerald Kogler
 * example shows how to talk to gtalk XMPP server
 * jabberlib website at http://go.yuri.at/jabberlib/
 */
 
import jabberlib.*;

Jabber jabber;

void setup(){
  noLoop();
  jabber = new Jabber(this,"talk.google.com",5222,"gmail.com");
  jabber.login("myuser@gmail.com","password");
  Object[] users = jabber.getUsers();
  //println(users);
  jabber.createChat("otheruser@gmail.com");
}

/* every mousePressed sends a chat message */
void mousePressed(){
  jabber.sendMessage("hola mundo");
}

/* incoming chat message are forwarded to the chatEvent method */
void chatEvent(String message) {
  println("received message: "+message);
}